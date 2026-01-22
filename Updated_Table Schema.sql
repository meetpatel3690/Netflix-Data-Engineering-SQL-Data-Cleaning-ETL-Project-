Drop table netflix_raw;

Create TABLE netflix_raw (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(10),
    title VARCHAR(200),
    director VARCHAR(250),
    cast1 VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(20),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(10),
    listed_in VARCHAR(100),
    description VARCHAR(500)
);

Select * from netflix_raw
where show_id = 's5304' and show_id='s5096';