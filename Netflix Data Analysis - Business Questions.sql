

----------------------------------------------------------------------------------
--------------- Netflix Data Analysis - Business Questions -----------------------
----------------------------------------------------------------------------------

--- NO 1. For each director count the no. of movies and tv shows created by them in seperate column
-- for directors who have created tv shows and movie both.

select nd.director,
	   Count(distinct CASE when n.type='Movie' then n.show_id end) as no_of_movies,
       Count(distinct CASE when n.type='TV Show' then n.show_id end) as no_of_tvshow
from netflix n
inner join netflix_directors nd on n.show_id = nd.show_id
group by nd.director
HAVING count(distinct n.type) > 1;



--- NO 2. Which country has the highest number of comedy movies.
select ng.genre, nc.country,count(distinct ng.show_id) as no_of_comedy_movies
from netflix_genre ng
inner join netflix_country nc on ng.show_id = nc.show_id
inner join netflix n on ng.show_id = n.show_id
where ng.genre = 'Comedies' and n.type='Movie'
group by nc.country,ng.genre
order by no_of_comedy_movies DESC
Limit 1;


Select nc.country,count(distinct ng.show_id) as no_of_movies
from netflix_genre ng
inner join netflix_country nc on ng.show_id=nc.show_id
inner join netflix n on ng.show_id=nc.show_id
where ng.genre = 'Comedies' and n.type='Movie'
group by nc.country
order by no_of_movies;

Select * from netflix;


--- NO 3. For each year (as per date added to netflix), which directors has max. number of movies realsed;


with cte as (
select EXTRACT(YEAR FROM date_added) as date_year,nd.director,count(distinct n.show_id) as no_of_movies
from netflix n
inner join netflix_directors nd on n.show_id=nd.show_id
where type='Movie'
group by nd.director , date_year
order by no_of_movies DESC
),
cte2 as(
select * , ROW_NUMBER () over(partition by date_year order by no_of_movies desc , Director)as rn
from cte
--order by date_year,no_of_movies desc
)

select * from cte2 where rn = 1;




--- NO 4. What is the average duration of the movies in each genre.

select * from netflix;

Select * from Netflix_genre;


select ROUND(AVG(REPLACE(duration,'min','')::INT),2) as Average_Duration,
	   ng.genre
from netflix n
inner join netflix_genre ng on n.show_id=ng.show_id
where n.type='Movie'
group by ng.genre;


--- NO 5. Find the list of directors who have created horror and comedy movies both.
--- Display director names along with the number of comedy and horror movies directed by them.

select nd.director
	, count(distinct case when ng.genre='Comedies' then n.show_id end ) as no_of_comedy
	, count(distinct case when ng.genre='Horror Movies' then n.show_id end ) as no_of_horror
from Netflix n
inner join netflix_genre ng on n.show_id=ng.show_id
inner join netflix_directors nd on n.show_id=nd.show_id
where type='Movie' and ng.genre in('Comedies','Horror Movies')
group by nd.director
HAVING COunt(Distinct ng.genre) = 2 ;




