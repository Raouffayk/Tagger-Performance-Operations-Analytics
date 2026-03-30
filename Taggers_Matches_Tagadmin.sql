SELECT DISTINCT
    t.match_id,
    m.match_name,
    m.competition,
    m.priority,
    qe.difficulty,
    t.tagger_id,
    tg.name AS tagger_name,
    t.team_id,
    vt.name AS team_name,
    trn.turn_day,
    t.start_date,
    t.end_date,
    ROUND(TIMESTAMPDIFF(SECOND, t.start_date, t.end_date) / 3600, 2) AS duration_hours,
    c.rating,
    c.creation_date,
    c.validity_date,
    c.notes
FROM tagadmin.turn AS trn
JOIN tagadmin.tasks AS t
    ON trn.id = t.turn_id
JOIN tagadmin.matches AS m
    ON t.match_id = m.id
LEFT JOIN tagadmin.quality_evaluation AS qe
    ON qe.match_id = t.match_id
LEFT JOIN tagadmin.taggers AS tg
    ON tg.tagger_id = t.tagger_id
   AND tg.facility_id = trn.facility_id
LEFT JOIN tagadmin.checks AS c
    ON c.match_id = t.match_id
   AND c.tagger_id = t.tagger_id
   AND c.team_id = t.team_id
   AND c.facility_id = trn.facility_id
LEFT JOIN tagadmin.views_teams AS vt
    ON vt.id = t.team_id
WHERE trn.turn_day >= '{{ from_date }}'
  AND trn.turn_day <= '{{ to_date }}'
  AND t.match_id IS NOT NULL
  AND trn.facility_id = 475716
  AND t.visible = 1;
