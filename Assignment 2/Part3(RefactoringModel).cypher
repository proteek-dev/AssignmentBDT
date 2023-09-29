// Suggest a modification to the base data model , 
// that would make it easier to answer questions such as 
// “Show me the top 5 users posting links from realestate.com.au”. 

// Current Query get the top 5 users posting links from realestate.com.au
MATCH (u:User)-[:POSTS]->(t:Tweet)-[:CONTAINS]->(l:Link)
WHERE l.expandedUrl CONTAINS "realestate.com.au"
WITH u, count(t) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

// Part A:
// Suggestions:
// we can create a new node label called Website to represent websites,
// and a new relationship type called POSTS_ON to connect users to websites.


// Part B
CREATE (:Website {name: 'Realestate'})

MATCH (t:Tweet)-[:CONTAINS]->(l:Link)
WHERE l.displayUrl STARTS WITH 'realestate.com.au' OR 
l.expandedUrl STARTS WITH 'http://realestate.com.au'
CREATE (t)-[:POSTS_ON]->(:Website {name: 'Realestate'})

// Testing Part B
// This would allow us to easily find the top 5 users posting links
// from realestate.com.au by using the following query:

MATCH (u:User)-[:POSTS]->(t:Tweet)-[:POSTS_ON]->(w:Website {name: 'Realestate'})
WITH u, COUNT(t) AS linkCount
ORDER BY linkCount DESC
LIMIT 5
RETURN u.UserDisplayName AS User, linkCount AS LinksPosted

// Part C

CREATE (:Website {name: 'LinkedIn'})

MATCH (t:Tweet)-[:CONTAINS]->(l:Link)
WHERE l.displayUrl STARTS WITH 'http://www.linkedin.com' OR 
l.expandedUrl STARTS WITH 'http://www.linkedin.com'
CREATE (t)-[:POSTS_ON]->(:Website {name: 'LinkedIn'})

// Testing Part C
MATCH (u:User)-[:POSTS]->(t:Tweet)-[:CONTAINS]->(l:Link)
WHERE l.expandedUrl STARTS WITH 'http://www.linkedin.com' OR 
l.expandedUrl STARTS WITH 'http://lnkd.in'
WITH u, COUNT(t) AS numPosts
ORDER BY numPosts DESC
LIMIT 1
RETURN COLLECT(u.UserDisplayName) AS user_names, numPosts AS num_posts


