//Tweet Node
CALL apoc.periodic.iterate(
    'CALL apoc.load.json("https://raw.githubusercontent.com/proteek-dev/Big_Data_Technologies/main/Assignment%202/formatted_10000_tweets.json") YIELD value',
    'WITH value.id AS id,
    datetime({ 
        epochMillis: apoc.date.parse( 
            value.postedTime,
            "ms",
            "yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'"
            )
        }) AS postedTimestamp,
    value.text AS text,
    value.twitter_lang AS language,
    value.retweetCount AS retweetCount,
    value.favoritesCount AS favoritesCount,
    value.verb AS retweets,
    value.actor.displayName AS username
    MERGE (t:Tweet{id:id})
    ON CREATE SET
    t.postedTimestamp = postedTimestamp,
    t.text = text,
    t.language = language,
    t.retweetCount = retweetCount,
    t.favoritesCount = favoritesCount,
    t.retweetStatus = retweets,
    t.username = username',
    {batchSize:500}
    )
YIELD * ;

// Source Node and USING relationship
CALL apoc.periodic.iterate(
    'CALL apoc.load.json("https://raw.githubusercontent.com/proteek-dev/Big_Data_Technologies/main/Assignment%202/formatted_10000_tweets.json") YIELD value',
    'WITH value
    MATCH (t:Tweet{id:value.id})
    WITH t, value
    UNWIND value.generator AS source
    MERGE (s:Source {sourceName:source.displayName})
    ON CREATE SET
    s.sourceLink = source.link,
    s.sourceDisplayName = source.displayName
    MERGE (t)-[:USING]->(s)',
    {batchSize:500}
    )
YIELD * ;

// User Node and POSTS relationship
CALL apoc.periodic.iterate(
    'CALL apoc.load.json("https://raw.githubusercontent.com/proteek-dev/Big_Data_Technologies/main/Assignment%202/formatted_10000_tweets.json") YIELD value',
    'WITH value
    MATCH (t:Tweet{id:value.id})
    WITH t, value
    UNWIND value.actor AS user
    MERGE (u:User{id:user.id})
    ON CREATE SET
    u.UserDisplayName = user.displayName,
    u.twitterName = user.preferredUsername,
    u.userLink = user.url
    MERGE (u)-[:POSTS]->(t)',
    {batchSize:500}
    )
YIELD * ;

// Hashtag Node and TAGS relationship
CALL apoc.periodic.iterate(
    'CALL apoc.load.json("https://raw.githubusercontent.com/proteek-dev/Big_Data_Technologies/main/Assignment%202/formatted_10000_tweets.json") YIELD value',
    'WITH value
    MATCH (t:Tweet{id:value.id})
    WITH t, value
    UNWIND value.twitter_entities AS level1
    FOREACH (
        tag in level1.hashtags | MERGE (h:Hashtag {hashtag:tag.text}
        )
    MERGE (t)-[:TAGS]->(h))',
    {batchSize:500}
    )
YIELD * ;

// Retweet Node and RETWEET and TAGS relationship
CALL apoc.periodic.iterate(
    'CALL apoc.load.json("https://raw.githubusercontent.com/proteek-dev/Big_Data_Technologies/main/Assignment%202/formatted_10000_tweets.json") YIELD value',
    'WITH value
    MATCH (t:Tweet{id:value.id})
    WHERE t.retweetStatus = "share"
    WITH t, value
    UNWIND value.object AS retweet
    MERGE (rt:Tweet {id:retweet.id})
    ON CREATE SET
    rt.retweetStatus = retweet.verb,
    rt.postedTime = datetime({ 
        epochMillis: apoc.date.parse( 
            retweet.postedTime,
            "ms",
            "yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'"
            )
        }),
    rt.link = retweet.link,
    rt.text = retweet.text,
    rt.favoritesCount = retweet.favoritesCount
    MERGE (t)-[:RETWEETS]->(rt)
    WITH rt, value, retweet
    UNWIND retweet.twitter_entities AS level2
    FOREACH (
        tag in level2.hashtags | MERGE (h:Hashtag {hashtag:tag.text}
        )
    )',
    {batchSize:500}
    )
YIELD * ;

// Link Node and CONTAINS relationship
CALL apoc.periodic.iterate(
    'CALL apoc.load.json("https://raw.githubusercontent.com/proteek-dev/Big_Data_Technologies/main/Assignment%202/formatted_10000_tweets.json") YIELD value',
    'WITH value
    MATCH (t:Tweet{id:value.id})
    UNWIND value.twitter_entities AS level1
    FOREACH(
        userurl in level1.urls |
        MERGE (l:Link{link:userurl.url})
        ON CREATE SET
        l.expandedUrl = userurl.expanded_url,
        l.displayUrl = userurl.display_url
        MERGE (t)-[:CONTAINS]->(l)
    )',
    {batchSize:500}
    )
YIELD * ;

// Mentioned User Node and MENTIONS relationship
CALL apoc.periodic.iterate(
    'CALL apoc.load.json("https://raw.githubusercontent.com/proteek-dev/Big_Data_Technologies/main/Assignment%202/formatted_10000_tweets.json") YIELD value',
    'WITH value
    MATCH (t:Tweet{id:value.id})
    WITH t, value
    UNWIND value.twitter_entities AS level1
    FOREACH (
        user in level1.user_mentions | 
        MERGE (u:User {name:user.name})
        ON CREATE SET
        u.twitterName = user.screen_name,
        u.id = user.id
        MERGE (t)-[:MENTIONS]->(u)
    )',
    {batchSize:500}
    )
YIELD * ;

