    SELECT 
        tgr.tagger_id,
        tgr.name AS tagger_name,
        trn.activity, 
        trn.turn_day, 
        trn.status,
        trn.turn_start,
        trn.verified_time,
        COUNT(ts.id) AS total_tasks,
        ROUND(SUM(TIMESTAMPDIFF(SECOND, ts.start_date, ts.end_date)) / 3600.0, 2) AS total_task_duration_hours
    FROM tagadmin.taggers AS tgr
    INNER JOIN tagadmin.turn AS trn 
        ON tgr.tagger_id = trn.tagger_id
    LEFT JOIN tagadmin.tasks ts 
        ON ts.turn_id = trn.id AND ts.tagger_id = trn.tagger_id
        AND ts.start_date IS NOT NULL
        AND ts.end_date IS NOT NULL
        AND ts.visible = 1
    WHERE trn.facility_id = 475716
    AND trn.turn_day >= '{{ from_date }}'
    AND trn.turn_day <= '{{ to_date }}'
    GROUP BY trn.turn_day, tgr.tagger_id, tgr.name, trn.activity, trn.status, trn.turn_start, trn.verified_time
    ORDER BY trn.turn_day;
