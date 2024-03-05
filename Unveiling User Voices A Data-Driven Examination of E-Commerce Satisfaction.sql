use project1;

select* from ecommerce;

alter table ecommerce
drop Email_address;

select* from ecommerce

# # 1. DEMOGRAPHICS AND WEBSITE PREFERENCES

#Which age group uses the most e-commerce websites?

SELECT age, COUNT(*) AS website_users 
FROM ecommerce
WHERE website IS NOT NULL
GROUP BY age;

# Which city has the highest percentage of users who consider buying alternatives to current websites?

SELECT city_district, 
       COUNT(*) AS total_users,
       COUNT(CASE WHEN choosing_alternatives = 'Yes' THEN 1 END) AS considering_alternatives,
       ROUND((COUNT(CASE WHEN choosing_alternatives = 'Yes' THEN 1 END) / COUNT(*)) * 100, 2) AS percentage_considering
FROM ecommerce
GROUP BY city_district;

# #. Website Evaluation and Sentiment:

#	What is the average rating provided by users for each website?

SELECT website, AVG(rating) AS average_rating
FROM ecommerce
GROUP BY website;

#	Is there a correlation between age and overall happiness with e-commerce experiences?

SELECT age, AVG(overall_happiness) AS average_happiness
FROM ecommerce
GROUP BY age;


##. Exploring User Behavior:

#Which profession group exhibits the most frequent buying behavior?

SELECT profession, COUNT(*) AS frequent_buyers
FROM ecommerce
WHERE buying_behavior = 'Frequent'
GROUP BY profession;

#	Is there a relationship between choosing alternatives and the rating provided for the worst website?

SELECT choosing_alternatives, AVG(worst_rating) AS average_worst_rating
FROM ecommerce
GROUP BY choosing_alternatives;

## Analyzing Buying Behavior and Website Preferences:

#Which age group tends to spend the most on e-commerce websites?

SELECT age, AVG(CAST(REPLACE(worst_rating, '$', '') AS FLOAT)) AS average_spent
FROM ecommerce
GROUP BY age;

 # Are users who prefer specific professions more likely to choose alternatives?

SELECT profession, COUNT(*) AS total_users,
       COUNT(CASE WHEN choosing_alternatives = 'Yes' THEN 1 END) AS considering_alternatives
FROM ecommerce
GROUP BY profession;


##. Exploring User Satisfaction and Website Comparison:

#	Is there a significant difference in average rating between the best and worst websites?

SELECT 'Best Website', AVG(rating) AS average_best_rating,
       'Worst Website', AVG(worst_rating) AS average_worst_rating
FROM ecommerce;


# Do users with higher overall happiness tend to provide lower ratings for the worst website?

SELECT overall_happiness, AVG(worst_rating) AS average_worst_rating
FROM ecommerce
GROUP BY overall_happiness;


## Identifying Website Improvement Opportunities:

	 # Which website has the highest percentage of users with a "worst rating" below a certain threshold (e.g., 3 stars)?

SELECT website, COUNT(*) AS total_users,
       COUNT(CASE WHEN worst_rating < 3 THEN 1 END) AS low_rated
FROM ecommerce
GROUP BY website;

# Among users who consider alternatives, is there a specific website they seem to prefer switching to?

SELECT choosing_alternatives, COUNT(*) AS considering_alternatives,
       website AS preferred_alternative
FROM ecommerce
WHERE choosing_alternatives = 'Yes'
GROUP BY choosing_alternatives, website
ORDER BY considering_alternatives DESC;

##  Ranking with Window Functions:
#	Which users have the highest average rating for websites they use frequently?

SELECT name, 
       AVG(rating) OVER (PARTITION BY name ORDER BY buying_behavior DESC) AS avg_rating_frequent
FROM ecommerce
WHERE buying_behavior = 'Frequent';


##. Group by and Having Clause:
	
# Find the city districts with at least 10 users and an average overall happiness above 4.

SELECT city_district, 
       COUNT(*) AS total_users, 
       AVG(overall_happiness) AS avg_happiness
FROM ecommerce
GROUP BY city_district
HAVING COUNT(*) >= 10 AND AVG(overall_happiness) > 4;

##. Common Table Expressions (CTEs):

	#Identify the top 3 websites with the highest average rating, then find all users who rated them.

WITH top_websites AS (
  SELECT website, AVG(rating) AS avg_rating
  FROM ecommerce
  GROUP BY website
  ORDER BY avg_rating DESC
  LIMIT 3
)
SELECT users.name, top_websites.website, users.rating
FROM your_table AS users
INNER JOIN top_websites
ON users.website = top_websites.website;

## Subqueries:

#Find users whose overall happiness is higher than the average happiness for their age group.

SELECT *
FROM ecommerce AS users
WHERE overall_happiness > (
  SELECT AVG(overall_happiness)
  FROM ecommerce
  WHERE age = users.age
  GROUP BY age
);

## Self Joins:

#Find users who are considering alternatives and also have rated the worst website with a score below 3.

SELECT users.name, users.website AS user_website, worst_users.website AS worst_website, users.worst_rating
FROM ecommerce AS users
INNER JOIN ecommerce AS worst_users
ON users.name = worst_users.name
WHERE users.choosing_alternatives = 'Yes' AND worst_users.worst_rating < 3
AND users.website <> worst_users.website;

## CASE statements:

#Create a new column "satisfaction_level" based on the rating: "High" (4-5 stars), "Medium" (2-3 stars), "Low" (1 star).

SELECT *, 
       CASE WHEN rating >= 4 THEN 'High'
            WHEN rating BETWEEN 2 AND 3 THEN 'Medium'
            ELSE 'Low'
       END AS satisfaction_level
FROM ecommerce;

## Regular Expressions:

# Find users whose city district names start with the letter "S". (Note: Functionality for regular expressions might differ based on your database engine)

SELECT *
FROM ecommerce
WHERE city_district REGEXP '^[S].*';





 

