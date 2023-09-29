// Answer 1
// The top five most used sources (app or site) to post or 
// share a tweet. For each source return the number of posts and 
// the number of users that created tweets from that source.

MATCH (s:Source)<-[:USING]-(t:Tweet)
WITH s, count(t) AS posts, collect(t.username) AS users
RETURN s.sourceName AS Source, posts AS Posts, size(users) AS Users
ORDER BY posts DESC
LIMIT 5

// Answer 2
// Top 3 users that have the highest number of tweets with a 
// retweetCount greater than 50. For each of these users show 
// the number of popular tweets they have and the top 2 hashtags 
// present in all their tweets in order of occurrence.

MATCH (u:User)-[:POSTS]->(t:Tweet)
WHERE t.retweetCount > 50
WITH u, count(t) AS popularTweets
ORDER BY popularTweets DESC
LIMIT 3
MATCH (u)-[:POSTS]->(t:Tweet)-[:TAGS]->(h:Hashtag)
WITH u, popularTweets, h, count(h) AS hashtagCount
ORDER BY hashtagCount DESC
LIMIT 2
RETURN u.UserDisplayName AS User, popularTweets AS PopularTweets, 
collect(h.hashtag) AS TopHashtags

// Answer 3
// The shortest path connecting the User ‘luckyinsivan’ and
// the hashtag ‘imsosick’ using any relationship type except 
// :USING. Submit a picture of the path from neo4j browser graph 
// view and the length of this path 

// Getting Graph in Neo4j Browser
MATCH (u1:User{twitterName:"luckyinsivan"}),
(h:Hashtag{hashtag:"imsosick"})
MATCH p = shortestPath((u1)-[*]-(h))
WHERE ALL (r IN relationships(p) WHERE type(r) <> "USING")
RETURN p, length(p)

// Getting Example result row: path_length 13
MATCH (u1:User{twitterName:"luckyinsivan"}),
(h:Hashtag{hashtag:"imsosick"})
MATCH p = shortestPath((u1)-[*]-(h))
WHERE ALL (r IN relationships(p) WHERE type(r) <> "USING")
RETURN length(p) AS path_length
