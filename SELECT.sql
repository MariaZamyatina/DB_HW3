--1 количество исполнителей в каждом жанре
SELECT g.name ganre_name, COUNT(artist_id) FROM artistsganres ag
JOIN ganres g ON ag.ganre_id = g.id
GROUP BY g.name;

--2 количество треков, вошедших в альбомы 2019-2020 годов
SELECT a.name album, COUNT(t.id) tracks_count, a.release_year FROM tracks t
JOIN albums a ON a.id = t.album_id
WHERE a.release_year >= 2019 AND a.release_year <=2020
GROUP BY a.name, a.release_year;

--3 средняя продолжительность треков по каждому альбому
SELECT round(AVG(duration),0) average_duration, a.name album FROM tracks t 
JOIN albums a ON t.album_id  = a.id 
GROUP BY a.name;


--4 все исполнители, которые не выпустили альбомы в 2020 году
SELECT a.name artist, al.name album, al.release_year FROM albums al 
JOIN artistsalbums aa ON aa.album_id = al.id
JOIN artists a ON a.id = aa.artist_id
WHERE al.release_year != 2020;

--5 названия сборников, в которых присутствует конкретный исполнитель (выберите сами)
SELECT a.name artist, c.name collection, c.release_year relaese_year FROM collections c
JOIN trackscollections tc ON c.id  = tc.coll_id 
JOIN tracks t ON t.id  = tc.track_id 
JOIN artistsalbums aa ON aa.album_id = t.album_id 
JOIN artists a ON a.id = aa.artist_id 
WHERE a.name = 'Frank Sinatra'
GROUP BY collection, artist, release_year;

--6 название альбомов, в которых присутствуют исполнители более 1 жанра
SELECT alb.name album ,a.name artist FROM artists a 
JOIN artistsganres ag ON a.id = ag.artist_id
JOIN artistsalbums aa ON aa.artist_id  = a.id 
JOIN albums alb ON alb.id = aa.album_id 
group BY a.name, alb.name
HAVING count(a.id) > 1;

--7 наименование треков, которые не входят в сборники
SELECT t.name track, t.id  FROM tracks t 
left JOIN trackscollections tc ON tc.track_id = t.id 
WHERE tc.coll_id IS NULL
GROUP BY t.name, t.id;

--8 исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)
SELECT a.name artist, t.name track, t.duration  FROM tracks t
JOIN artistsalbums aa ON aa.album_id = t.album_id 
JOIN artists a ON a.id = aa.artist_id 
WHERE t.duration <= (SELECT MIN(duration) FROM tracks);

--9 название альбомов, содержащих наименьшее количество треков
SELECT a.name album, count(t.id) tracks_count FROM albums a
JOIN tracks t ON a.id = t.album_id
GROUP BY a.name
HAVING count(t.id) <= (
	SELECT count(tracks.id) FROM tracks
	GROUP BY tracks.album_id
	ORDER BY count(tracks.id) ASC
	LIMIT 1);
	

	