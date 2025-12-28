SELECT count(*) FROM singer
SELECT count(*) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name,Song_release_year FROM singer WHERE Age = (SELECT MIN(Age) FROM singer)
SELECT Song_Name, Song_release_year FROM singer WHERE Age  =  (SELECT min(Age) FROM singer)
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(*) FROM singer GROUP BY Country
SELECT Country, count(Singer_ID) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age > (SELECT avg(Age) FROM singer)
SELECT Song_Name FROM singer WHERE Age > (SELECT avg(Age) FROM singer)
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity) ,  Average FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average  =  (SELECT max(Average) FROM stadium)
SELECT COUNT(*) FROM concert WHERE Year IN (2014,2015)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT Name, count(concert_ID) FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID GROUP BY T1.Stadium_ID, T1.Name
SELECT Location, count(T2.concert_ID) FROM stadium AS T1 LEFT JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID GROUP BY Location
SELECT T1.Name, T1.Capacity FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Year  >=  2014 GROUP BY T1.Stadium_ID, T1.Name, T1.Capacity ORDER BY count(*) DESC LIMIT 1
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = (SELECT Stadium_ID FROM concert WHERE Year > 2013 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT T1.Country FROM singer AS T1 JOIN singer AS T2 ON T1.Country  =  T2.Country WHERE T1.Age > 40 AND T2.Age < 30
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name ,  Theme ,  count(sic.Singer_ID) FROM concert c JOIN singer_in_concert sic ON c.concert_ID  =  sic.concert_ID GROUP BY c.concert_ID ,  concert_Name ,  Theme
SELECT concert_Name, Theme, (SELECT COUNT(*) FROM singer_in_concert AS sic WHERE sic.concert_ID  =  concert.concert_ID) FROM concert
SELECT T2.Name ,  count(T1.concert_ID) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T2.Singer_ID ,  T2.Name
SELECT s.Name, COUNT(c.concert_ID) FROM singer AS s JOIN singer_in_concert AS sic ON s.Singer_ID  =  sic.Singer_ID JOIN concert AS c ON sic.concert_ID  =  c.concert_ID GROUP BY s.Singer_ID, s.Name
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year = 2014))
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year  =  2014))
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT DISTINCT T1.Name, T1.Location FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Year IN (2014,2015) GROUP BY T1.Stadium_ID, T1.Name, T1.Location HAVING SUM(CASE WHEN T2.Year = 2014 THEN 1 ELSE 0 END) > 0 AND SUM(CASE WHEN T2.Year = 2015 THEN 1 ELSE 0 END) > 0
SELECT DISTINCT s.Name, s.Location FROM stadium s JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID WHERE c.Year IN (2014, 2015) GROUP BY s.Stadium_ID, s.Name, s.Location HAVING COUNT(DISTINCT c.Year)  =  2
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT COUNT(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Capacity  =  (SELECT MAX(Capacity) FROM stadium)
SELECT count(*) FROM Pets WHERE weight > 10
SELECT COUNT(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT MIN(pet_age) FROM Pets WHERE PetType = 'dog')
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1
SELECT PetType, max(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT COUNT(*) FROM Pets P WHERE PetID IN (SELECT PetID FROM Has_Pet H WHERE StuID IN (SELECT StuID FROM Student WHERE Age > 20))
SELECT COUNT(*) FROM Pets P JOIN Has_Pet H ON P.PetID = H.PetID JOIN Student S ON H.StuID = S.StuID WHERE S.Age > 20
SELECT count(*) FROM Pets P JOIN Has_Pet H ON P.PetID  =  H.PetID JOIN Student S ON H.StuID  =  S.StuID WHERE P.PetType  =  'dog' AND S.Sex  =  'F'
SELECT count(*) FROM Student S JOIN Has_Pet HP ON S.StuID = HP.StuID JOIN Pets P ON HP.PetID = P.PetID WHERE S.Sex = 'F' AND P.PetType = 'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT Fname FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat' OR P.PetType = 'dog'
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' OR PetType = 'dog')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat') AND StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')
SELECT DISTINCT Fname FROM Student S WHERE EXISTS (SELECT 1 FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE H.StuID = S.StuID AND P.PetType = 'cat') AND EXISTS (SELECT 1 FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE H.StuID = S.StuID AND P.PetType = 'dog')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet H1 JOIN Pets P1 ON H1.PetID = P1.PetID WHERE P1.PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet H2 JOIN Pets P2 ON H2.PetID = P2.PetID WHERE P2.PetType = 'cat')
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, avg(pet_age), max(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT DISTINCT Student.Fname, Student.Age FROM Student JOIN Has_Pet ON Student.StuID  =  Has_Pet.StuID JOIN Pets ON Has_Pet.PetID  =  Pets.PetID
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT PetID FROM Student JOIN Has_Pet ON Student.StuID  =  Has_Pet.StuID WHERE LName  =  'Smith'
SELECT PetID FROM Pets WHERE PetID IN (SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName  =  'Smith'))
SELECT T1.StuID, count(T2.PetID) FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT H.StuID, count(H.PetID) FROM Has_Pet AS H JOIN Student AS S ON H.StuID  =  S.StuID GROUP BY H.StuID
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1)
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING count(PetID) > 1)
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(*) FROM continents
SELECT count(*) FROM continents
SELECT c1.ContId, c1.Continent, count(c2.CountryId) FROM continents AS c1 JOIN countries AS c2 ON c1.Continent  =  c2.Continent GROUP BY c1.ContId, c1.Continent
SELECT c.ContId, c.Continent, count(co.CountryId) FROM continents c JOIN countries co ON c.Continent  =  co.Continent GROUP BY c.ContId, c.Continent
SELECT count(*) FROM countries
SELECT count(*) FROM countries
SELECT cm.FullName ,  cm.Id ,  count(ml.Model) FROM car_makers AS cm JOIN model_list AS ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id ,  cm.FullName
SELECT cm.Id, cm.FullName, COUNT(*) FROM car_makers cm JOIN model_list ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT Model FROM model_list m1 JOIN cars_data c ON m1.Maker  =  (SELECT Maker FROM car_makers WHERE Country  =  (SELECT Country FROM car_names WHERE Model  =  m1.Model LIMIT 1)) WHERE Horsepower  =  (SELECT MIN(Horsepower) FROM cars_data)
SELECT cn.Model FROM cars_data c JOIN car_names cn ON c.Id = cn.MakeId ORDER BY c.Horsepower LIMIT 1
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight  <  (SELECT avg(Weight) FROM cars_data))
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT Maker FROM car_makers WHERE Id IN (SELECT DISTINCT Maker FROM model_list WHERE ModelId IN (SELECT Id FROM cars_data WHERE Year  =  1970))
