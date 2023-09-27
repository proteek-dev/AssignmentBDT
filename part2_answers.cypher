// Answer 1

MATCH (t:Tweet)-[:USING]->(s:Source)
WITH s, COUNT(t) AS post_count, COUNT(DISTINCT t.username) AS user_count
RETURN s.sourceName, post_count, user_count
ORDER BY post_count DESC
LIMIT 5

// Answer 2