SELECT *
FROM technicalsupportdata;

-- For data cleaning purposes I will duplicate this table
CREATE TABLE technicalsupport2
LIKE technicalsupportdata;

INSERT INTO technicalsupport2
SELECT *
FROM technicalsupportdata;

SELECT *
FROM technicalsupport2;

-- DATA CLEANING
SELECT *
FROM technicalsupport2
WHERE `Close time` = '';

-- Populating the blank values in the Survey Results column 
SELECT t1.`Survey results`, t2.`Survey results`
FROM technicalsupport2 t1
JOIN technicalsupport2 t2 
	ON t1.Topic = t2.Topic AND t1.`SLA For first response`= t2.`SLA For first response`
    AND t1.`SLA For Resolution` = t2.`SLA For Resolution`
WHERE t1.`Survey results` = '' AND  t2.`Survey results` != '';

UPDATE technicalsupport2 t1
JOIN technicalsupport2 t2
	ON t1.Topic = t2.Topic AND t1.`SLA For first response`= t2.`SLA For first response`
AND t1.`SLA For Resolution` = t2.`SLA For Resolution`
SET t1.`Survey results` = t2.`Survey results` 
WHERE t1.`Survey results` = '' AND  t2.`Survey results` != '';

SELECT *
FROM technicalsupport2;

SELECT *, ROW_NUMBER()OVER(PARTITION BY `Ticket ID`) AS row_num
FROM technicalsupport2;

-- there are no duplicates
with duplicates as (
	SELECT *, ROW_NUMBER()OVER(PARTITION BY `Ticket ID`) AS row_num
	FROM technicalsupport2
)
select *
from duplicates 
where row_num >1;

-- drop the columns resolution time and Close Time - they have null values
ALTER TABLE technicalsupport2
DROP COLUMN `Resolution time`;

ALTER TABLE technicalsupport2
DROP COLUMN `Close time`;

SELECT *
FROM technicalsupport2;

SELECT `Created time`, STR_TO_DATE(`Created time`, '%d/%m/%Y %H:%i:%s') as time2
FROM technicalsupport2;

UPDATE technicalsupport2
SET `Created time` = STR_TO_DATE(`Created time`, '%d/%m/%Y %H:%i:%s');

-- separate the date from the time 
SELECT `Created time`, RIGHT(`Created time`,8) as created_time2
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN created_time2 TIME;

UPDATE technicalsupport2
SET created_time2 = RIGHT(`Created time`,8);

SELECT `Created time`, LEFT(`Created time`,10) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN created_date DATE;

UPDATE technicalsupport2
SET created_date = LEFT(`Created time`,10);

SELECT *
FROM technicalsupport2;

ALTER TABLE technicalsupport2
DROP COLUMN `Created time`;

ALTER TABLE technicalsupport2
RENAME COLUMN created_time2 TO created_time;

SELECT `Created time`, RIGHT(`Created time`,8) as created_time2
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN created_time2 TIME;

UPDATE technicalsupport2
SET created_time2 = RIGHT(`Created time`,8);

SELECT `Expected SLA to resolve`, STR_TO_DATE(`Expected SLA to resolve`, '%d/%m/%Y %H:%i:%s') as time2
FROM technicalsupport2;

UPDATE technicalsupport2
SET `Expected SLA to resolve` = STR_TO_DATE(`Expected SLA to resolve`, '%d/%m/%Y %H:%i:%s');

SELECT `Expected SLA to resolve`, LEFT(`Expected SLA to resolve`,10) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN Expected_SLA_to_resolve_date DATE;

UPDATE technicalsupport2
SET Expected_SLA_to_resolve_date = LEFT(`Expected SLA to resolve`,10);

SELECT `Expected SLA to resolve`, RIGHT(`Expected SLA to resolve`,8) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN Expected_SLA_to_resolve_time TIME;

UPDATE technicalsupport2
SET Expected_SLA_to_resolve_time = RIGHT(`Expected SLA to resolve`,8);

SELECT `Expected SLA to first response`, STR_TO_DATE(`Expected SLA to first response`, '%d/%m/%Y %H:%i:%s') as time2
FROM technicalsupport2;

UPDATE technicalsupport2
SET `Expected SLA to first response` = STR_TO_DATE(`Expected SLA to first response`, '%d/%m/%Y %H:%i:%s');

SELECT `Expected SLA to first response`, LEFT(`Expected SLA to first response`,10) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN Expected_SLA_to_first_response_date DATE;

UPDATE technicalsupport2
SET Expected_SLA_to_first_response_date = LEFT(`Expected SLA to first response`,10);

SELECT `Expected SLA to first response`, RIGHT(`Expected SLA to first response`,8) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN Expected_SLA_to_first_response_time TIME;

UPDATE technicalsupport2
SET Expected_SLA_to_first_response_time = RIGHT(`Expected SLA to resolve`,8);

SELECT `Expected SLA to resolve`, STR_TO_DATE(`Expected SLA to resolve`, '%d/%m/%Y %H:%i:%s') as time2
FROM technicalsupport2;

UPDATE technicalsupport2
SET `Expected SLA to resolve` = STR_TO_DATE(`Expected SLA to resolve`, '%d/%m/%Y %H:%i:%s');

SELECT `Expected SLA to resolve`, LEFT(`Expected SLA to resolve`,10) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN Expected_SLA_to_resolve_date DATE;

UPDATE technicalsupport2
SET Expected_SLA_to_resolve_date = LEFT(`Expected SLA to resolve`,10);

SELECT `Expected SLA to resolve`, RIGHT(`Expected SLA to resolve`,8) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN Expected_SLA_to_resolve_time TIME;

UPDATE technicalsupport2
SET Expected_SLA_to_resolve_time = RIGHT(`Expected SLA to resolve`,8);

SELECT `First response time`, STR_TO_DATE(`First response time`, '%d/%m/%Y %H:%i:%s') as time2
FROM technicalsupport2;

UPDATE technicalsupport2
SET `First response time` = STR_TO_DATE(`First response time`, '%d/%m/%Y %H:%i:%s');

SELECT `First response time`, LEFT(`First response time`,10) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN First_response_date DATE;

UPDATE technicalsupport2
SET First_response_date = LEFT(`First response time`,10);

SELECT `First response time`, RIGHT(`First response time`,8) as created_date
FROM technicalsupport2;

ALTER TABLE technicalsupport2
ADD COLUMN First_response_time TIME;

UPDATE technicalsupport2
SET First_response_time = RIGHT(`First response time`,8);

SELECT *
FROM technicalsupport2;

                      -- Ticket Volume Trends:
-- 1. Analyze daily, weekly and monthly volumes
-- Daily
SELECT day(created_date) as days, COUNT(`Ticket ID`) as ticket_count
FROM technicalsupport2
GROUP BY days
ORDER BY 2 DESC;

-- weekly
SELECT week(created_date) as weeks, COUNT(`Ticket ID`) as ticket_count
FROM technicalsupport2
GROUP BY week(created_date)
ORDER BY 2 DESC;

-- monthly 
SELECT MONTHNAME(created_date)as month, COUNT(`Ticket ID`) as ticket_count
FROM technicalsupport2
GROUP BY month
ORDER BY 2 DESC;

-- Compare volumes between workdays and weekends
-- workdays 
SELECT dayname(created_date) AS workday_name, COUNT(`Ticket ID`) as ticket_count
FROM technicalsupport2
WHERE  dayname(created_date) != 'Saturday' AND dayname(created_date) != 'Sunday'
GROUP BY dayname(created_date)
ORDER BY 2 DESC;

-- weekends 
SELECT dayname(created_date) AS weekend_name, COUNT(`Ticket ID`) as ticket_count
FROM technicalsupport2
WHERE  dayname(created_date) = 'Saturday' OR dayname(created_date) = 'Sunday'
GROUP BY dayname(created_date)
ORDER BY 2 DESC;

-- Examine ticket distribution during standard work hours versus after hours.
      -- standard work hours run from 9AM to 5PM
SELECT Count(*) as count_std_hours
FROM technicalsupport2
WHERE created_time between '9:00:00' and '17:00:00';

      -- after hours between 6PM and 8AM.
SELECT Count(*) as count_after_hours
FROM technicalsupport2
WHERE created_time >='18:00:00' or created_time >= '8:00:00';

-- Recognize peak ticket creation times
SELECT Count(*) as ticket_count,
		HOUR(created_time) as hour_of_day
FROM technicalsupport2
GROUP BY HOUR(created_time)
ORDER BY ticket_count DESC;

                      -- Ticket Content and Resolution:
-- Identify trends in ticket topics
SELECT Topic, Count(*) as ticket_count
FROM technicalsupport2
GROUP BY Topic
ORDER BY ticket_count DESC;

-- Compare support channels (chat, phone, email)
SELECT `Source`, Count(*) as ticket_count
FROM technicalsupport2
GROUP BY `Source`
ORDER BY ticket_count DESC;

-- Analyze ticket geography for trends in submissions or product issues.
SELECT Country, Count(*) as ticket_count,
	round(avg(Latitude),5) as average_latitude,
    round(avg(Longitude),5) as avg_longitude
FROM technicalsupport2
GROUP BY Country
ORDER BY ticket_count DESC;

                        -- Performance Metrics:
-- Evaluate agent SLA adherence for first responses and resolutions.
SELECT ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_time,First_response_time)),0) AS average_first_response_time,
		ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_time,Expected_SLA_to_resolve_time)),0) AS average_expected_SLA_to_resolve,
        ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_time,Expected_SLA_to_first_response_time)),0) AS average_expected_SLA_to_first_response
FROM technicalsupport2;

-- Explore customer satisfaction rates across agents, topics and other categories
				-- agents
SELECT `Agent Name`, ROUND(AVG(`Survey results`),1) as average_survey_results
FROM technicalsupport2
GROUP BY  `Agent Name`
ORDER BY AVG(`Survey r esults`) DESC;

                  -- Topics
SELECT Topic, ROUND(AVG(`Survey results`),1) as average_survey_results
FROM technicalsupport2
GROUP BY Topic
ORDER BY AVG(`Survey results`) DESC;

-- Check how quickly tickets move through the resolution process.
SELECT ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_time,First_response_time)),0) AS average_first_response_time
FROM technicalsupport2;

SELECT COUNT(`Ticket ID`) As ticketcount
FROM technicalsupport2;

SELECT *
FROM technicalsupport2;