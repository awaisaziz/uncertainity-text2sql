SELECT count(*) FROM singer
SELECT COUNT(*) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name, Song_release_year FROM singer WHERE Age = (SELECT MIN(Age) FROM singer)
SELECT Song_Name, Song_release_year FROM singer WHERE Age  =  (SELECT MIN(Age) FROM singer)
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(Singer_ID) FROM singer GROUP BY Country
SELECT Country, count(Singer_ID) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT DISTINCT T2.Song_Name FROM singer AS T2 WHERE T2.Age > (SELECT avg(T1.Age) FROM singer AS T1)
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average  =  (SELECT MAX(Average) FROM stadium)
SELECT count(*) FROM concert WHERE Year IN (2014, 2015)
SELECT count(*) FROM concert WHERE Year IN (2014, 2015)
SELECT T1.Name ,  count(T2.concert_ID) FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID GROUP BY T1.Stadium_ID ,  T1.Name
SELECT T1.Stadium_ID, T1.Name, count(T2.concert_ID) FROM stadium AS T1 LEFT JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID GROUP BY T1.Stadium_ID, T1.Name
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = (SELECT Stadium_ID FROM concert WHERE Year >= 2014 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT Name, Capacity FROM stadium WHERE Stadium_ID =(SELECT Stadium_ID FROM concert WHERE Year >2013 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT DISTINCT T2.Country FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.Singer_ID  =  T2.Singer_ID WHERE T2.Age  >  40 INTERSECT SELECT DISTINCT T3.Country FROM singer_in_concert AS T4 JOIN singer AS T3 ON T4.Singer_ID  =  T3.Singer_ID WHERE T3.Age  <  30
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT T1.Stadium_ID FROM concert AS T1 WHERE T1.Year  =  2014)
SELECT concert_Name, Theme, COUNT(Singer_ID) FROM concert JOIN singer_in_concert ON concert.concert_ID  =  singer_in_concert.concert_ID GROUP BY concert.concert_ID, concert_Name, Theme
SELECT T1.concert_Name, T1.Theme, COUNT(T2.Singer_ID) FROM concert AS T1 JOIN singer_in_concert AS T2 ON T1.concert_ID  =  T2.concert_ID GROUP BY T1.concert_ID, T1.concert_Name, T1.Theme
SELECT T2.Name ,  count(T1.concert_ID) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T2.Singer_ID ,  T2.Name
SELECT T2.Name, count(T1.concert_ID) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T2.Singer_ID, T2.Name
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year = 2014))
SELECT T2.Name FROM concert AS T1 JOIN singer_in_concert AS T2 ON T1.concert_ID  =  T2.concert_ID JOIN singer AS T3 ON T2.Singer_ID  =  T3.Singer_ID WHERE T1.Year  =  2014
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT T1.Name ,  T1.Location FROM stadium AS T1 WHERE T1.Stadium_ID IN (SELECT T3.Stadium_ID FROM concert AS T3 WHERE T3.Year  =  2014 INTERSECT SELECT T3.Stadium_ID FROM concert AS T3 WHERE T3.Year  =  2015)
SELECT T1.Name, T1.Location FROM stadium AS T1 WHERE T1.Stadium_ID IN (SELECT T2.Stadium_ID FROM concert AS T2 WHERE T2.Year = 2014 INTERSECT SELECT T3.Stadium_ID FROM concert AS T3 WHERE T3.Year = 2015)
SELECT count(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Capacity  =  (SELECT max(Capacity) FROM stadium)
SELECT count(*) FROM concert WHERE Stadium_ID  =  (SELECT Stadium_ID  FROM stadium ORDER BY Capacity  DESC LIMIT 1)
SELECT count(*) FROM Pets WHERE weight > 10
SELECT count(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT MIN(pet_age) FROM Pets WHERE PetType = 'dog')
SELECT weight FROM Pets WHERE PetType  =  'dog' ORDER BY pet_age ASC LIMIT 1
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT count(*) FROM Pets P WHERE P.PetID IN (SELECT PetID FROM Has_Pet H JOIN Student S ON H.StuID  =  S.StuID WHERE S.Age  >  20)
SELECT COUNT(*) FROM Pets P WHERE P.PetID IN (SELECT PetID FROM Has_Pet H WHERE H.StuID IN (SELECT StuID FROM Student S WHERE S.Age > 20))
SELECT count(*) FROM Pets P JOIN Has_Pet H ON P.PetID  =  H.PetID JOIN Student S ON H.StuID  =  S.StuID WHERE P.PetType  =  'dog' AND S.Sex  =  'F'
SELECT COUNT(*) FROM Student S1 JOIN Has_Pet HP1 ON S1.StuID = HP1.StuID JOIN Pets P1 ON HP1.PetID = P1.PetID WHERE S1.Sex = 'F' AND P1.PetType = 'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType IN ('cat', 'dog'))
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType IN ('cat', 'dog'))
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' INTERSECT SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')}
SELECT DISTINCT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID  =  P.PetID WHERE PetType  =  'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE PetType = 'cat')
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID  =  P.PetID WHERE P.PetType  =  'dog' GROUP BY StuID HAVING SUM(CASE WHEN P.PetType  =  'cat' THEN 1 ELSE 0 END)  =  0)
SELECT PetType, weight FROM Pets WHERE pet_age  =  (SELECT MIN(pet_age ) FROM Pets)
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT PetType ,  avg(weight) FROM Pets GROUP BY PetType
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets))
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT PetID FROM Pets WHERE PetID IN (SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName  =  'Smith'))
SELECT PetID FROM Pets WHERE PetID IN (SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName  =  'Smith'))
SELECT T1.StuID, COUNT(T2.PetID) FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID GROUP BY T1.StuID
SELECT T1.StuID, count(T2.PetID) FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType  =  'cat' AND pet_age  =  3))
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType  =  'cat' AND pet_age  =  3))
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet WHERE StuID IS NOT NULL)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(*) FROM continents
SELECT count(DISTINCT Continent) FROM countries
SELECT c.ContId, c.Continent, COUNT(*) FROM continents c JOIN countries cn ON c.Continent  =  cn.Continent GROUP BY c.ContId, c.Continent
SELECT ContId, Continent, COUNT(CountryId) FROM continents LEFT JOIN countries ON continents.ContId  =  countries.Continent GROUP BY ContId, Continent
SELECT COUNT(DISTINCT CountryName) FROM countries
SELECT count(DISTINCT CountryId) FROM countries
SELECT cm.FullName, cm.Id, COUNT(DISTINCT ml.Model) FROM car_makers AS cm JOIN model_list AS ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT car_makers.Id, car_makers.FullName, COUNT(model_list.Model) FROM car_makers JOIN model_list ON car_makers.Maker  =  model_list.Maker GROUP BY car_makers.Id, car_makers.FullName
SELECT Model FROM model_list WHERE Maker IN (SELECT DISTINCT Maker FROM car_makers) AND Model IN (SELECT Model FROM car_names) ORDER BY (SELECT MIN(Horsepower) FROM cars_data WHERE Id IN (SELECT Id FROM cars_data)) LIMIT 1
SELECT T2.Model FROM cars_data AS T1 JOIN model_list AS T2 ON T1.Id  =  T2.ModelId WHERE T1.Horsepower  =  (SELECT MIN(Horsepower) FROM cars_data)
SELECT Model FROM model_list WHERE Maker IN (SELECT DISTINCT Maker FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT AVG(Weight) FROM cars_data))) LIMIT 1
SELECT T2.Model FROM cars_data AS T1 CROSS JOIN model_list AS T2 WHERE T1.Weight < (SELECT avg(Weight) FROM cars_data) AND T1.Id  =  T2.ModelId
SELECT DISTINCT Maker FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Maker  =  T2.Maker JOIN cars_data AS T3 ON T2.ModelId  =  T3.Id WHERE T3.Year  =  1970
