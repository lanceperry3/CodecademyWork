--1. Start by getting a feel for the hacker_news table! Let’s find the most popular Hacker News stories:

SELECT 
    title
    ,score
FROM 
    hacker_news
ORDER BY 
    score DESC
LIMIT 5
;
--What are the top five stories with the highest scores?
  --Penny Arcade – Surface Pro 3 update	517
  --Hacking The Status Game	309
  --Postgres CLI with autocompletion and syntax highlighting	304
  --Stephen Fry hits out at ‘infantile’ culture of trigger words and safe spaces	282
  --Reversal: Australian Govt picks ODF doc standard over Microsoft	191
;
--2.Recent studies have found that online forums tend to be dominated by a small percentage of their users (1-9-90 Rule). Is this true of Hacker News? Is a small percentage of Hacker News submitters taking the majority of the points?

--First, find the total score of all the stories.
SELECT 
    SUM(score)
FROM 
    hacker_news
;
--3. Next, we need to pinpoint the users who have accumulated a lot of points across their stories.

--Find the individual users who have gotten combined scores of more than 200, and their combined scores.

--GROUP BY and HAVING are needed!

SELECT 
    user
    ,SUM(score)
FROM 
    hacker_news
GROUP BY 
    user
HAVING 
    SUM(score) >200
;
--4. Then, we want to add these users’ scores together and divide by the total to get the percentage.

--Add their scores together and divide it by the total sum. Like so:
--SELECT (1.0 + 2.0 + 3.0) / 6.0;
--So, is Hacker News dominated by these users? 
  -- No they make up only ~22% of the total score   

SELECT 
    (309+304+282+517)/6366.0
;
--5. Oh no! While we are looking at the power users, some users are rickrolling — tricking readers into clicking on a link to a funny video and claiming that it links to information about coding.

--The url of the video is: https://www.youtube.com/watch?v=dQw4w9WgXcQ
--How many times has each offending user posted this link?
  --scorpiosister	1
  --sonnynomnom	2
SELECT 
    user
    ,COUNT(title)
FROM
    hacker_news
WHERE 
    url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
GROUP BY 
    user
;
--6. Hacker News stories are essentially links that take users to other websites.
--Which of these sites feed Hacker News the most: GitHub, Medium, or New York Times?
--First, we want to categorize each story based on their source.

--We can do this using a CASE statement:
SELECT  DISTINCT
    CASE WHEN url LIKE '%github.com%'  THEN 'GitHub'
         WHEN url LIKE '%Medium.com%'  THEN 'Medium'
         WHEN url LIKE '%nytimes.com%' THEN 'New York Times'
         ELSE 'Other'
         END 'Source' 
FROM 
    hacker_news
;
--7. Next, build on the previous query:
--Add a column for the number of stories from each URL using COUNT().Also, GROUP BY the CASE statement. Remember that you can refer to a column in GROUP BY using a number.
SELECT 
    CASE WHEN url LIKE '%github.com%'  THEN 'GitHub'
         WHEN url LIKE '%Medium.com%'  THEN 'Medium'
         WHEN url LIKE '%nytimes.com%' THEN 'New York Times'
         ELSE 'Other'
         END 'Source' 
    ,COUNT(*) AS 'Count'
FROM 
    hacker_news
GROUP BY 
    CASE WHEN url LIKE '%github.com%'       THEN 'GitHub'
         WHEN url LIKE '%Medium.com%'       THEN 'Medium'
         WHEN url LIKE '%nytimes.com%' THEN 'New York Times'
         ELSE 'Other'
         END
;
--8. Every submitter wants their story to get a high score so that the story makes it to the front page, but…

--What’s the best time of the day to post a story on Hacker News? Before we get started, let’s run this query and take a look at the timestamp column:

SELECT timestamp
FROM hacker_news
LIMIT 10;
--Notice that the values are formatted like: 2018-05-08T12:30:00Z If you ignore the T and Z, the format is: YYYY-MM-DD HH:MM:SS          
--9. SQLite comes with a strftime() function - a very powerful function that allows you to return a formatted date.

--It takes two arguments:
--strftime(format, column)
--Let’s test this function out:

SELECT timestamp,
   strftime('%H', timestamp)
FROM hacker_news
GROUP BY 1
LIMIT 20;
--What do you think this does? Open the hint if you’d like to learn more.
;
--10. Okay, now we understand how strftime() works. Let’s write a query that returns three columns:

--1. The hours of the timestamp
--2. The average score for each hour
--3. The count of stories for each hour
SELECT 
    STRFTIME('%H', timestamp) AS 'Hours'
    ,AVG(score)               AS 'Avg_Score'
    ,COUNT(*)                 AS 'Count_of_Stories'
FROM 
    hacker_news
GROUP BY 
    STRFTIME('%H', timestamp) 
ORDER BY 
    AVG(score) DESC
;    

SELECT 
    STRFTIME('%H', timestamp) AS 'Hours'
    ,ROUND(AVG(score),2)      AS 'Avg_Score'
    ,COUNT(*)                 AS 'Count_of_Stories'
FROM 
    hacker_news
WHERE 
    timestamp IS NOT NULL
GROUP BY 
    STRFTIME('%H', timestamp) 
ORDER BY 
    AVG(score) DESC








