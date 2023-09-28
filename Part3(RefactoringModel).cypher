// Suggest a modification to the base data model , that would make it easier to answer questions such as “Show me the top 5 users posting links from realestate.com.au”. Discuss any other options you considered.

// I would add a new node called "Link" and a relationship called "CONTAINS" between the Tweet and the Link node. This would allow us to easily find the top 5 users posting links from realestate.com.au by using the following query:

MATCH (u:User)-[:POSTS]->(t:Tweet)-[:CONTAINS]->(l:Link)
WHERE l.link CONTAINS "realestate.com.au"
WITH u, count(t) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

// I also considered adding a new node called "Website" and a relationship called "POSTS" between the User and the Website node. This would allow us to easily find the top 5 users posting links from realestate.com.au by using the following query:

MATCH (u:User)-[:POSTS]->(w:Website)
WHERE w.website CONTAINS "realestate.com.au"
WITH u, count(w) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

// However, I decided against this option because it would require us to create a new node for every website that a user posts a link from. This would result in a large number of nodes and relationships, which would make the database more difficult to manage.

// Suggest a modification to the base data model shown in Figure 3, that would make it easier to answer questions such as “Show me the top 5 users posting links from realestate.com.au”. Discuss any other options you considered.
// Write the Cypher statements to implement your changes to the model. This should process existing data in the model to create new nodes and relationships from the data you already have.
// Using elements of your extended data model, answer the following question with a Cypher query. Which user(s) post the most links from linkedin, that is links from the domain "www.linkedin.com" or "lnkd.in"

// Create Link Node and CONTAINS relationship
CALL apoc.periodic.iterate(
    'MATCH (t:Tweet)
    WHERE t.link IS NOT NULL
    RETURN t.link AS link, t.id AS id',
    'WITH
    link,
    id
    MATCH(t:Tweet{id:id})
    MERGE (l:Link{link:link})
    MERGE (t)-[:CONTAINS]->(l)',
    {batchSize:500}
    )
YIELD * ;

// Create Website Node and POSTS relationship
CALL apoc.periodic.iterate(
    'MATCH (t:Tweet)
    WHERE t.link IS NOT NULL
    RETURN t.link AS link, t.id AS id',
    'WITH
    link,
    id
    MATCH(t:Tweet{id:id})
    MERGE (w:Website{website:link})
    MERGE (t)-[:POSTS]->(w)',
    {batchSize:500}
    )
YIELD * ;

// Find the top 5 users posting links from realestate.com.au
MATCH (u:User)-[:POSTS]->(w:Website)
WHERE w.website CONTAINS "realestate.com.au"
WITH u, count(w) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

// Find the top 5 users posting links from linkedin
MATCH (u:User)-[:POSTS]->(w:Website)
WHERE w.website CONTAINS "linkedin"
WITH u, count(w) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts


// we can see that an organisation might have multiple domains associated with it. Can you design a model to also allow for this so the query could be just focused on the company linkedin itself. We would also like to able to use the graph to analyse these links by industry, extend the model again to allow for this.
// Only the data model is required, you can use the arrows tool to design your new graph model or make the changes to your database and use neo4j procedure db.schema.visualization() to generate a diagram.

// Create Organisation Node and POSTS relationship
CALL apoc.periodic.iterate(
    'MATCH (t:Tweet)
    WHERE t.link IS NOT NULL
    RETURN t.link AS link, t.id AS id',
    'WITH
    link,
    id
    MATCH(t:Tweet{id:id})
    MERGE (o:Organisation{organisation:link})
    MERGE (t)-[:POSTS]->(o)',
    {batchSize:500}
    )
YIELD * ;

// Find the top 5 users posting links from realestate.com.au
MATCH (u:User)-[:POSTS]->(o:Organisation)
WHERE o.organisation CONTAINS "realestate.com.au"
WITH u, count(o) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

// Find the top 5 users posting links from linkedin
MATCH (u:User)-[:POSTS]->(o:Organisation)
WHERE o.organisation CONTAINS "linkedin"
WITH u, count(o) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

// Find the top 5 users posting links from realestate.com.au by industry
MATCH (u:User)-[:POSTS]->(o:Organisation)
WHERE o.organisation CONTAINS "realestate.com.au"
WITH u, count(o) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

// Find the top 5 users posting links from linkedin by industry
MATCH (u:User)-[:POSTS]->(o:Organisation)
WHERE o.organisation CONTAINS "linkedin"
WITH u, count(o) AS posts
ORDER BY posts DESC
LIMIT 5
RETURN u.UserDisplayName AS User, posts AS Posts

