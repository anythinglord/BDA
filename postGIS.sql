-- Creamos una nueva base de datos
CREATE DATABASE sea_tower; 

CREATE TABLE Regions (
	id 		SERIAL PRIMARY KEY,
	name 	        VARCHAR(20) NOT NULL,
	area		GEOMETRY NOT NULL,
	settled_family  VARCHAR(20)
);
 
CREATE TABLE Dolphins (
	id 		SERIAL PRIMARY KEY,
	family_name	VARCHAR(20) NOT NULL,
	last_position	GEOMETRY NOT NULL,
	movement 	GEOMETRY NOT NULL 
);

-- Inicializar las tablas
INSERT INTO Regions (name, area, settled_family) VALUES 
('Alpha',  'POLYGON((2 17, 7 22, 13 22, 13 15, 7 15, 2 17))', 'Javadelphis'), 
('Bravo',  'POLYGON((13 22, 22 22, 22 15, 13 15, 13 22))', null),
('Charlie',  'POLYGON((2 10, 2 17, 7 15, 13 15, 11 10, 2 10))', 'Lagenonaut'),
('Delta',  'POLYGON((11 10, 13 15, 22 15, 23 10, 19 4, 11 10))', null),
('Echo',  'POLYGON((2 10, 11 10, 7 1, 3 1, 2 10))', null),
('Foxtrot',  'POLYGON((11 10, 19 4, 17 1, 7 1, 11 10))', 'Delphinuspring');

INSERT INTO Dolphins (family_name, last_position, movement) VALUES 
('Javadelphis', 'POINT(7 18)', 'LINESTRING(6 18, 7 18)'),
('Javadelphis', 'POINT(11 20)', 'LINESTRING(12 18, 16 18, 16 20, 11 20)'),
('Javadelphis', 'POINT(10 17)', 'LINESTRING(10 17, 9 18, 11 18, 10 17)'),
('Javadelphis', 'POINT(14 19)', 'LINESTRING(9 17, 10 13, 16 13, 20 17, 20 21, 14 19)'),
('Javadelphis', 'POINT(25 25)', 'LINESTRING(8 18, 10 20, 10 24, 17 21, 25 25)'),
('Lagenonaut', 'POINT(7 12)', 'LINESTRING(4 15, 7 12)'),
('Lagenonaut', 'POINT(8 13)', 'LINESTRING(12 14, 10 12, 9 12, 8 13)'),
('Lagenonaut', 'POINT(11 14)', 'LINESTRING(9 14, 9 16, 11 16, 11 14)'),
('Lagenonaut', 'POINT(22 12)', 'LINESTRING(9 11, 15 10, 22 12)'),
('Delphinuspring', 'POINT(12 5)', 'LINESTRING(12 3, 13 4, 12 5)'),
('Delphinuspring', 'POINT(14 5)', 'LINESTRING(16 2, 14 3, 14 5)'),
('Delphinuspring', 'POINT(5 12)', 'LINESTRING(10 3, 10 4, 5 11, 5 12)');


-- Indica el numero de delfines en una region :3
SELECT r.id AS region_id, r.name AS region_name, COUNT(d.id) AS number_of_dolphins
FROM Regions r
LEFT JOIN Dolphins d 
ON ST_Within(d.last_position, r.area) 
GROUP BY r.id;

-- Muestra para cada familia :
-- El número de delfines que la componen y cuál es la región en la que está asentada
-- La distancia media entre los delfines de una misma familia :3
SELECT families.family_name, number_of_dolphins, region_name, average_distance
FROM 
	(SELECT family_name, COUNT(*) AS number_of_dolphins FROM Dolphins GROUP by family_name) AS families
	JOIN (SELECT settled_family, name AS region_name from Regions) AS regions ON families.family_name = regions.settled_family
	JOIN (
		SELECT family_name, avg(distance) AS average_distance
		FROM (
			SELECT ST_Distance(a.last_position, b.last_position) AS distance, a.family_name AS family_name
			FROM Dolphins a JOIN Dolphins b
			ON a.family_name = b.family_name AND a.id < b.id
		) AS familiar_dolphins
		GROUP BY family_name
	) AS average_distances ON  families.family_name = average_distances.family_name
ORDER BY average_distance DESC;


-- Devuelve la ultima posicion antes que los delfines abandonen cualquier area conocida
SELECT id, family_name, ST_AsText(last_position) as last_position
FROM Dolphins
WHERE NOT ST_Within(last_position, (SELECT ST_Union(area) FROM Regions));


-- Devuelve la ultima posicion de los delfines que estan mas lejos de sus familias 
SELECT a.id, a.family_name AS family_name, ST_AsText(a.last_position) AS last_position
FROM Dolphins a
LEFT JOIN Dolphins b
ON a.id != b.id AND ST_Within(b.last_position, ST_Buffer(a.last_position, 9))
WHERE b.id IS NULL;

-- Cálculo de la distancia mínima entre el primer delfin y los demas
SELECT first_id, min(distance)
FROM (
	SELECT a.id AS first_id, b.id, ST_Distance(a.last_position, b.last_position) AS distance
	FROM Dolphins a JOIN Dolphins b
	ON a.id != b.id) AS distances
GROUP BY first_id;

