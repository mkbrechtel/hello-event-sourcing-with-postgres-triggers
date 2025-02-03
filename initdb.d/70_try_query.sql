-- Query both views to compare
SELECT 'Regular View' as source, * FROM pets_view
UNION ALL
SELECT 'Snapshot' as source, * FROM pets_snapshot;
