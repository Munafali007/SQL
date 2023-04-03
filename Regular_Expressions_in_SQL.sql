
-- In this task, I will create a new database
-- and retrieve data from the tables in the database
---------------------------------------------------------------------------

-- Task 1.1: Create the customers table
CREATE TABLE customers
(
    CustomerId SERIAL PRIMARY KEY,
    FirstName VARCHAR(255),
	LastName VARCHAR(255),
    Address text,
	City VARCHAR(255),
	Country VARCHAR(255),
    PostalCode VARCHAR(12),
	Phone VARCHAR(20),
	Email text,
	SupportRepId INT
);

-- Task 1.2: Create the twitter table
CREATE TABLE twitter
(
    tweetid INT,
    tweets text
);

-- Task 1.3: Retrieve all the data from the tables in regrex-db database
SELECT * FROM customers;
SELECt * FROM twitter;
--------------------------------------------------------------------------------
-- Task Two: LIKE/NOT LIKE
-- In this task, I will retrieve data from tables 
-- in the regex-db database, using the LIKE and
-- NOT LIKE operators together with the WHERE clause


-- Task 2.1: Extracting a list of all customers whose first name starts with 'He'
SELECT *
FROM customers
WHERE firstname LIKE('He%');

-- Task 2.2: Extracting a list of all customers whose last name ends with 's'
SELECT *
FROM customers
WHERE lastname LIKE('%s');

-- Task 2.3: Extracting a list of all customers whose firstname has ar in it?
SELECT *
FROM customers
WHERE firstname LIKE('%ar%');

-- Task 2.4: Extracting a list of all customers whose firstname starts with Mar?
SELECT *
FROM customers
WHERE firstname LIKE ('Mar_');
    
-- 2.1: Extract all individuals from the customers table whose first name 
-- does not contain 'Mar'
SELECT *
FROM customers
WHERE firstname LIKE ('%Mar%');

-- Solution to Exercise 2.1
SELECT *
FROM customers
WHERE firstname NOT LIKE ('%Mar%');

-------------------------------------------------------------------------------
-- Task Three: Using Regular Expressions - Part One
-- In this task, I retrieve data from the customers table 
-- using regular expressions wildcard characters
-------------------------------------------------------------------------------
-- Task 3.1: Retrieve a list of all customers 
-- whose first name starts with a
SELECT *
FROM customers
WHERE firstname ~* '^a+[a-z]+$';

-- Task 3.2: Retrieve a list of all customers 
-- whose city starts with s
SELECT *
FROM customers
WHERE city ~* '^s+[a-z\s]+$' ;

-- Task 3.3: Retrieve a list of all customers 
-- whose city starts with a, b, c, or d
SELECT * FROM customers
WHERE city ~* '^(a|b|c)+[a-z/s]+$';

-- Task 3.4: Retrieve a list of all customers 
-- whose city starts with s 
SELECT * FROM customers
WHERE city ~* '^s+[a-z]{2}\s[a-z]{5}$';


------------------------------------------------------------------------------
-- Task Four: Regular Expressions 
-- In this task, I will continue to retrieve data from the
-- customers table using regular expressions
-------------------------------------------------------------------------------

-- 4.1: Retrieve the first name, last name, phone number and email
-- of all customers with a gmail account
SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ 'gmail';
-- 4.2: Retrieve the first name, last name, phone number and email
-- of all customers whose email starts with t
SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ '^t';

-- 4.3: Retrieve the first name, last name, phone number and email
-- of all customers whose email ends with com
SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ 'com$';

-- 4.4: Retrieve the first name, last name, phone number and email
-- of all customers whose email starts with a, b, or t
SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ '^[abt]';

-- 2nd way to do the same thing.

SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ '^(a|b|t)';

-- 4.5: Retrieve the first name, last name, phone number and email
-- of all customers whose email contain a number
SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ '[0-9]';

-- 4.6: Retrieve the first name, last name, phone number and email
-- of all customers whose email contain two-digit numbers
SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ '[0-9]{2}';

-- another way to do the same thing
SELECT firstname, lastname, phone, email
FROM customers
WHERE email ~ '[0-9][0-9]';

-----------------------------------------------------------------------------------
-- Task Five: Using Regular Expressions - Part Two
-- In this task, I will continue to retrieve data from the
-- customers table using regular expressions wildcard characters
-----------------------------------------------------------------------------------

-- Retrieve all the data in the customers table
SELECT * FROM customers;

-- Task 5.1: Retrieve the city, country, postalcode 
-- and original digits of the postal codes for Brazil
SELECT city, country, postalcode,
SUBSTRING(postalcode FOR 5) AS old_postalcode
FROM customers
WHERE country = 'Brazil';

-- Task 5.2: Retrieve the first name, last name, city, country, postalcode 
-- and the new digits of the postal codes for Brazil
SELECT firstname, lastname, city, country, postalcode,
SUBSTRING(postalcode FROM 7 FOR 3) AS new_postalcode
FROM customers
WHERE country = 'Brazil';

-- Task 5.3: Retrieve the numbers in the email addresses of customers
SELECT email FROM customers;
SELECT SUBSTRING(email FROM '[0-9]+')
FROM customers
WHERE email ~ '[0-9]';
-- Task 5.4: Retrieve the domain names in the email addresses of customers
SELECT SUBSTRING(email FROM '.+@(.*)$')
FROM customers

-- 5.1: Retrieve the distinct domain names in the email addresses of customers
SELECT DISTINCT SUBSTRING(email FROM '.+@(.*)$')
FROM customers;

-- Task 5.5: Retrieve the domain names and count of the domain names
-- in the email addresses of customers
SELECT SUBSTRING(email FROM '.+@(.*)$') AS domainname, 
COUNT(SUBSTRING(email FROM '.+@(.*)$')) domain_names_count
FROM customers
GROUP BY domainname
ORDER BY domain_names_count DESC;

-- 5.2: Retrieve the first name, last name, country and emails
-- of all customers whose email domain name is gmail.com
SELECT firstname, lastname, email  
FROM customers
WHERE SUBSTRING(email FROM '.+@(.*)$')  = 'gmail.com'

---------------------------------------------------------------------------------------
-- Task Six: Using the regex_matches() function
-- In this task, I will use the regex_matches() 
-- function to retrieve hashtags from tweets
---------------------------------------------------------------------------------------

-- Task 6.1: Retrieve all tweets and tweetid with the word #COVID
SELECT * FROM twitter;
SELECT tweetid, tweets
FROM twitter
WHERE tweets ~* '#COVID';
-- Task 6.2: Retrieve all tweets and tweetid with the word #COVID19
SELECT tweetid, tweets
FROM twitter
WHERE tweets ~* '#COVID19';

-- Task 6.3: Retrieve all tweetid and all hashtags
SELECT tweetid, regexp_matches(tweets, '#[A-Za-z0-9_]+', 'g')
FROM twitter


-- 6.1: Retrieve all tweetid and all COVID19 hashtags using regexp_matches()
SELECT tweetid, regexp_matches(tweets, '#(COVID19)', 'g')
FROM twitter;


-- Task 6.4: Retrieve all tweetid and all distinct hashtags
SELECT DISTINCT
regexp_matches(tweets, '#([A-Za-z0-9_]+)', 'g')
FROM twitter

-- Task 6.5: Retrieve all distinct hashtags and the count of the hashtags
SELECT regexp_matches(tweets, '#([A-Za-z0-9_]+)', 'g') hashtags, COUNT(*)
FROM twitter
GROUP BY hashtags
ORDER BY COUNT(*) DESC;

