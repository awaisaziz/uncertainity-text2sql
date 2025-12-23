SELECT count(*) FROM singer
SELECT count(DISTINCT Singer_ID) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT AVG(Age), MIN(Age), MAX(Age) FROM singer WHERE Country = 'France'
SELECT AVG(Age), MIN(Age), MAX(Age) FROM singer WHERE Country = 'France'
SELECT Song_Name, Song_release_year FROM singer WHERE Age = (SELECT MIN(Age) FROM singer)
SELECT Song_Name, Song_release_year FROM singer WHERE Age = (SELECT MIN(Age) FROM singer)
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, COUNT(Singer_ID) FROM singer GROUP BY Country
SELECT Country, COUNT(Singer_ID) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age > (SELECT avg(Age) FROM singer)
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT MAX(Capacity), AVG(Capacity) FROM stadium
SELECT AVG(Capacity), MAX(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT count(*) FROM concert WHERE Year IN (2014, 2015)
SELECT T1.Name, COUNT(T2.concert_ID) FROM stadium AS T1 LEFT JOIN concert AS T2 ON T1.Stadium_ID = T2.Stadium_ID GROUP BY T1.Name
SELECT stadium.Stadium_ID, stadium.Name, stadium.Location, count(concert.concert_ID) FROM stadium AS stadium LEFT JOIN concert AS concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Stadium_ID, stadium.Name, stadium.Location;
SELECT S.Name, S.Capacity FROM stadium AS S WHERE (SELECT COUNT(*) FROM concert AS C WHERE C.Stadium_ID = S.Stadium_ID AND C.Year >= 2014) = (SELECT MAX((SELECT COUNT(*) FROM concert AS C2 WHERE C2.Stadium_ID = X.Stadium_ID AND C2.Year >= 2014)) FROM stadium AS X)
SELECT S.Name, S.Capacity FROM stadium AS S JOIN concert AS C ON S.Stadium_ID = C.Stadium_ID WHERE C.Year > 2013 GROUP BY S.Stadium_ID, S.Name, S.Capacity ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year HAVING count(*) >= ALL (SELECT count(*) FROM concert GROUP BY Year)
SELECT Year FROM concert GROUP BY Year HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM concert GROUP BY Year)
SELECT s.Name FROM stadium AS s LEFT JOIN concert AS c ON s.Stadium_ID = c.Stadium_ID WHERE c.Stadium_ID IS NULL
SELECT Name FROM stadium WHERE NOT EXISTS (SELECT 1 FROM concert WHERE concert.Stadium_ID = stadium.Stadium_ID)
SELECT DISTINCT s1.Country FROM singer AS s1 JOIN singer AS s2 ON s1.Country = s2.Country WHERE s1.Age > 40 AND s2.Age < 30
SELECT Name FROM stadium S WHERE NOT EXISTS (SELECT 1 FROM concert WHERE concert.Stadium_ID = S.Stadium_ID AND Year = 2014)
SELECT s.Name FROM stadium AS s LEFT JOIN concert AS c ON s.Stadium_ID = c.Stadium_ID AND c.Year = 2014 WHERE c.concert_ID IS NULL
SELECT concert.concert_Name, concert.Theme, COUNT(singer_in_concert.Singer_ID) FROM concert LEFT JOIN singer_in_concert ON concert.concert_ID = singer_in_concert.concert_ID GROUP BY concert.concert_ID, concert.concert_Name, concert.Theme
SELECT C.concert_Name, C.Theme, COUNT(SIC.Singer_ID) FROM concert AS C LEFT JOIN singer_in_concert AS SIC ON C.concert_ID = SIC.concert_ID GROUP BY C.concert_Name, C.Theme, C.concert_ID
SELECT S.Name, count(SIC.concert_ID) FROM singer AS S LEFT JOIN singer_in_concert AS SIC ON S.Singer_ID = SIC.Singer_ID GROUP BY S.Singer_ID, S.Name
SELECT singer.Name, COUNT(singer_in_concert.concert_ID) FROM singer LEFT JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID GROUP BY singer.Singer_ID, singer.Name
SELECT DISTINCT s.Name FROM singer AS s JOIN singer_in_concert AS sic ON s.Singer_ID = sic.Singer_ID JOIN concert AS c ON sic.concert_ID = c.concert_ID WHERE c.Year = 2014
SELECT DISTINCT T1.Name FROM singer AS T1 JOIN singer_in_concert AS T2 ON T1.Singer_ID = T2.Singer_ID JOIN concert AS T3 ON T2.concert_ID = T3.concert_ID WHERE T3.Year = 2014
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE LOWER(Song_Name) = 'hey' OR LOWER(Song_Name) LIKE 'hey %' OR LOWER(Song_Name) LIKE '% hey' OR LOWER(Song_Name) LIKE '% hey %'
SELECT S.Name, S.Location FROM stadium AS S JOIN concert AS C ON S.Stadium_ID = C.Stadium_ID GROUP BY S.Stadium_ID, S.Name, S.Location HAVING SUM(CASE WHEN C.Year = 2014 THEN 1 ELSE 0 END) > 0 AND SUM(CASE WHEN C.Year = 2015 THEN 1 ELSE 0 END) > 0
SELECT DISTINCT stadium.Name, stadium.Location FROM stadium JOIN concert AS c2014 ON stadium.Stadium_ID = c2014.Stadium_ID AND c2014.Year = 2014 JOIN concert AS c2015 ON stadium.Stadium_ID = c2015.Stadium_ID AND c2015.Year = 2015
SELECT count(*) FROM concert WHERE Stadium_ID IN (SELECT Stadium_ID FROM stadium WHERE Capacity = (SELECT MAX(Capacity) FROM stadium))
SELECT count(*) FROM concert AS c JOIN stadium AS s ON c.Stadium_ID  =  s.Stadium_ID WHERE s.Capacity  =  (SELECT max(Capacity) FROM stadium)
SELECT count(*) FROM Pets WHERE weight > 10
SELECT count(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT MIN(pet_age) FROM Pets WHERE PetType = 'dog')
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT MIN(pet_age) FROM Pets WHERE PetType = 'dog')
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT count(H.PetID) FROM Student AS S JOIN Has_Pet AS H ON S.StuID = H.StuID WHERE S.Age > 20
SELECT COUNT(*) FROM Has_Pet AS HP JOIN Student AS S ON HP.StuID = S.StuID WHERE S.Age > 20
SELECT COUNT(*) FROM Student AS S JOIN Has_Pet AS HP ON S.StuID = HP.StuID JOIN Pets AS P ON HP.PetID = P.PetID WHERE S.Sex = 'F' AND P.PetType = 'dog'
SELECT count(*) FROM Student AS S JOIN Has_Pet AS H ON S.StuID = H.StuID JOIN Pets AS P ON H.PetID = P.PetID WHERE P.PetType = 'dog' AND S.Sex IN ('F','Female')
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT DISTINCT Fname FROM Student AS S JOIN Has_Pet AS H ON S.StuID = H.StuID JOIN Pets AS P ON H.PetID = P.PetID WHERE P.PetType IN ('cat','dog')
SELECT DISTINCT Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType IN ('cat','dog')
SELECT Fname FROM Student WHERE EXISTS (SELECT 1 FROM Has_Pet JOIN Pets AS P ON Has_Pet.PetID = P.PetID WHERE Has_Pet.StuID = Student.StuID AND P.PetType = 'cat') AND EXISTS (SELECT 1 FROM Has_Pet JOIN Pets AS P2 ON Has_Pet.PetID = P2.PetID WHERE Has_Pet.StuID = Student.StuID AND P2.PetType = 'dog')
SELECT S.Fname FROM Student AS S JOIN Has_Pet AS H ON S.StuID = H.StuID JOIN Pets AS P ON H.PetID = P.PetID GROUP BY S.StuID, S.Fname HAVING SUM(CASE WHEN P.PetType = 'Cat' THEN 1 ELSE 0 END) > 0 AND SUM(CASE WHEN P.PetType = 'Dog' THEN 1 ELSE 0 END) > 0
SELECT Major, Age FROM Student AS S WHERE NOT EXISTS (SELECT 1 FROM Has_Pet AS HP JOIN Pets AS P ON HP.PetID = P.PetID WHERE HP.StuID = S.StuID AND P.PetType = 'cat')
SELECT Major, Age FROM Student AS S WHERE NOT EXISTS (SELECT 1 FROM Has_Pet AS HP JOIN Pets AS P ON HP.PetID = P.PetID WHERE HP.StuID = S.StuID AND P.PetType = 'cat')
SELECT StuID FROM Student WHERE NOT EXISTS (SELECT 1 FROM Has_Pet AS HP JOIN Pets AS P ON HP.PetID = P.PetID WHERE HP.StuID = Student.StuID AND P.PetType = 'cat')
SELECT Student.StuID FROM Student WHERE NOT EXISTS (SELECT 1 FROM Has_Pet AS HP JOIN Pets AS P ON HP.PetID = P.PetID WHERE HP.StuID = Student.StuID AND P.PetType = 'cat')
SELECT Student.Fname, Student.Age FROM Student JOIN Has_Pet AS HP ON Student.StuID = HP.StuID JOIN Pets AS P ON HP.PetID = P.PetID GROUP BY Student.StuID, Student.Fname, Student.Age HAVING SUM(CASE WHEN P.PetType = 'dog' THEN 1 ELSE 0 END) > 0 AND SUM(CASE WHEN P.PetType = 'cat' THEN 1 ELSE 0 END) = 0
SELECT Fname FROM Student AS S JOIN Has_Pet AS HP ON S.StuID = HP.StuID JOIN Pets AS P ON HP.PetID = P.PetID GROUP BY S.StuID, Fname HAVING SUM(CASE WHEN P.PetType = 'Dog' THEN 1 ELSE 0 END) > 0 AND SUM(CASE WHEN P.PetType = 'Cat' THEN 1 ELSE 0 END) = 0
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT DISTINCT T1.Fname, T1.Age FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID
SELECT T1.PetID FROM Pets AS T1 JOIN Has_Pet AS T2 ON T1.PetID = T2.PetID JOIN Student AS T3 ON T2.StuID = T3.StuID WHERE T3.LName = 'Smith'
SELECT T2.PetID FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID WHERE T1.LName = 'Smith'
SELECT T1.StuID, count(T2.PetID) FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID GROUP BY T1.StuID
SELECT Has_Pet.StuID, count(Has_Pet.PetID) FROM Has_Pet GROUP BY Has_Pet.StuID
SELECT T1.Fname, T1.Sex FROM Student AS T1 JOIN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING count(DISTINCT PetID) > 1) AS T2 ON T1.StuID = T2.StuID
SELECT S.Fname, S.Sex FROM Student AS S JOIN Has_Pet AS H ON S.StuID = H.StuID GROUP BY S.StuID, S.Fname, S.Sex HAVING count(H.PetID) > 1
SELECT DISTINCT S.LName FROM Student AS S JOIN Has_Pet AS H ON S.StuID = H.StuID JOIN Pets AS P ON H.PetID = P.PetID WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT S.LName FROM Student AS S JOIN Has_Pet AS HP ON S.StuID = HP.StuID JOIN Pets AS P ON HP.PetID = P.PetID WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT avg(Age) FROM Student AS T1 WHERE NOT EXISTS (SELECT 1 FROM Has_Pet AS T2 WHERE T2.StuID = T1.StuID)
SELECT AVG(Age) FROM Student WHERE NOT EXISTS (SELECT 1 FROM Has_Pet WHERE Has_Pet.StuID = Student.StuID)
SELECT count(*) FROM continents
SELECT count(*) FROM continents
SELECT c.ContId, c.Continent, count(co.CountryId) FROM continents AS c JOIN countries AS co ON c.ContId = co.Continent GROUP BY c.ContId, c.Continent
SELECT T1.ContId, T1.Continent, count(T2.CountryId) FROM continents AS T1 LEFT JOIN countries AS T2 ON T2.Continent = T1.ContId GROUP BY T1.ContId, T1.Continent
SELECT count(*) FROM countries
SELECT count(*) FROM countries
SELECT T1.FullName, T1.Id, COUNT(DISTINCT T2.Model) FROM car_makers AS T1 LEFT JOIN car_names AS T2 ON T1.Id = T2.MakeId GROUP BY T1.FullName, T1.Id
SELECT T1.FullName, T1.Id, count(DISTINCT T2.Model) FROM car_makers AS T1 LEFT JOIN car_names AS T2 ON T1.Id = T2.MakeId GROUP BY T1.FullName, T1.Id
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.ModelId = T2.MakeId JOIN cars_data AS T3 ON T2.MakeId = T3.Id WHERE T3.Horsepower = (SELECT MIN(Horsepower) FROM cars_data)
SELECT T2.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id = T2.MakeId WHERE T1.Horsepower = (SELECT MIN(Horsepower) FROM cars_data)
SELECT T2.Model FROM cars_data AS T1 JOIN car_names AS T2 ON T1.Id  =  T2.MakeId WHERE T1.Weight < (SELECT avg(Weight) FROM cars_data)
SELECT T2.Model FROM cars_data AS T1 JOIN model_list AS T2 ON T1.Id = T2.ModelId WHERE T1.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT DISTINCT T1.Maker FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker JOIN cars_data AS T3 ON T2.ModelId = T3.Id WHERE T3.Year = 1970
