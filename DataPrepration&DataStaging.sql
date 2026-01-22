-- Data Cleaning SQL Script -- 

-- No.1  : -  Handling Foreign Characters --

-- No.2  : -  Remove Duplicates --
Select * from Netflix_raw
where concat(upper(title),type) in ( Select concat(upper(title),type)
				from netflix_raw 
				group by upper(title),type
				HAVING count(*) > 1)
Order by title;

WITH CTE as (
			Select *,
			ROW_NUMBER() OVER (partition by CONCAT(upper(title),type) order by show_id) as rn
			from Netflix_raw
)
Select * from CTE where rn = 1;

-- No.3  : -  New Table for Listed in , Director , Country , Cast1 --
CREATE TABLE netflix_directors AS
SELECT
    show_id,
    TRIM(director_name) AS director
FROM netflix_raw
CROSS JOIN LATERAL
UNNEST(string_to_array(director, ',')) AS director_name;

CREATE TABLE netflix_country AS
SELECT
    show_id,
    TRIM(country) AS Country
FROM netflix_raw
CROSS JOIN LATERAL
UNNEST(string_to_array(country, ',')) AS country_nme;

CREATE TABLE netflix_cast AS
SELECT
    show_id,
    TRIM(cast1) AS Cast_1
FROM netflix_raw
CROSS JOIN LATERAL
UNNEST(string_to_array(cast1, ',')) AS cast_nme;

select * from netflix_raw;

CREATE TABLE netflix_genre AS
SELECT
    show_id,
    TRIM(listed_in) AS genre
FROM netflix_raw
CROSS JOIN LATERAL
UNNEST(string_to_array(listed_in, ',')) AS genre;


select * from netflix_directors;
select * from netflix_country;
select * from netflix_genre;
select * from netflix_cast;


-- No.4  : -  Data Type converstion for date added --


--- Final Cleaned : Staged Arae ----
Create Table Netflix as 
with cte as(select * ,row_number() over(partition by title, type order by show_id) as rn
from netflix_raw
)
select show_id,
	   type,title,
	   cast(date_added as date) as date_added,
	   release_year,
	   rating,
	   case when duration is null
	   THEN rating else duration end as duration,
	   description
from cte where rn=1;


select * from netflix;
-- No.5  : -  Populate Missing values in Country, Duration Columns --

select 

-- No.6  : -  Populate rest of the "Null" as not_available --

insert into netflix_country
select show_id,m.country
from netflix_raw nr
inner join (select director,country 
			from netflix_country nc
			inner join netflix_directors nd on nc.show_id = nd.show_id
			group by director,country) m 
on nr.director = m.director
where nr.country is null;


select * from netflix_raw where duration is null;


-- No.6  : -  Drop Columns Director , Listed in , Country , Cast1 [ as we have created seperate tables for them in above steps ]--

