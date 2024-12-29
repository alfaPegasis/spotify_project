-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
select * from spotify
Select count(*) from spotify
select count(distinct artist) from spotify
select distinct album_type from spotify
select min(duration_min) from spotify

select * from spotify where duration_min = 0
delete from spotify
where duration_min = 0


select distinct most_played_on from spotify
------ Data Analysis----------
-- 1) Names of all tracks with more than 1 billion streams
select track, stream from spotify where stream > 1000000000
order by stream desc

-- 2) List of all albums with their respective artists
select album, artist from spotify

-- 3) Total number of comments for tracks where licensed= true
select sum(comments) from spotify
where licensed is true

-- 4) Count of total number of tracks by each artist
select artist, count(*) as total_no_of_songs
from spotify
group by artist
order by 2 asc

-- 5) All tracks that belong to album single
select * from spotify
where album_type = 'single'


-- 6) Average danceability tracks  in each album
select album, avg(danceability) from spotify
group by 1


-- 7) Find the top 5 tracks with the highest energy values
select track, energy from spotify
order by 2 desc
limit 5


-- 8) List all tracks along with their views and likes where official_video = TRUE.
select track, sum(views) as total_views, sum(likes) as total_likes from spotify 
where official_video is true
group by 1
order by 2 desc
-- 9) For each album, calculate the total views of all associated tracks.
select album, track, sum(views) as total_views from spotify
group by 1, 2
order by 3 desc
-- 10) Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from
(select 
	track, 
	Coalesce(Sum(case when most_played_on = 'Youtube' then stream end), 0) as s_yt, 
	Coalesce(Sum(case when most_played_on = 'Spotify' then stream end), 0) as s_spo
from spotify
group by 1) as t1
where s_spo > s_yt and s_yt <> 0

-- 11) Find the top 3 most-viewed tracks for each artist using window functions.
with ranking_artist
as (
select 
	artist,
	track,
	sum(views),
	dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1, 2
order by 1, 3 desc)
select * from ranking_artist
where rank <= 3

-- 12) Write a query to find tracks where the liveness score is above the average.
select * from spotify where liveness > (select avg(liveness) from spotify)

-- 13) Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with cte
as (
	select 
		album, 
		min(energy) as lowest_energy, 
		max(energy) as highest_energy
	from spotify
	group by 1
)
select album, highest_energy - lowest_energy as energy_difference
from cte
order by 2 desc
-- 14) Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT 
    track,
    energy / liveness AS ratio_e_l
FROM 
    spotify
WHERE 
    liveness > 0 AND energy / liveness > 1.2;

select track, ratio_e_l
from
(	select 
		track,
		energy/liveness as ratio_e_l
	from spotify
	where liveness > 0) 
where
	ratio_e_l >1.2


-- 15) Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
select 
	track, views, likes, sum(likes) over (order by views) as cumulative_likes
from spotify
order by views desc









