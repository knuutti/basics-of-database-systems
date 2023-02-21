-- View 1
CREATE VIEW View_1 AS
SELECT
	band, band_member, member_instrument
FROM 
	(SELECT * FROM musicrecords ORDER BY band_member)
WHERE
	band_member IS NOT NULL
ORDER BY band;

-- View 2
CREATE VIEW View_2 AS
SELECT
    band, album, releaseYear
FROM
    (SELECT * FROM musicrecords GROUP BY album ORDER BY releaseYear)
WHERE
    album IS NOT NULL
ORDER BY band;

-- View 3
CREATE VIEW View_3 AS
SELECT * FROM 
(SELECT
    band, album, track, track_duration
FROM
    (SELECT * FROM musicrecords WHERE track IS NOT NULL ORDER BY track_duration)
ORDER BY album)
ORDER BY band;
