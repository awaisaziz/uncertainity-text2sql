SELECT count(*) FROM singer
SELECT count(*) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name,Song_release_year FROM singer WHERE Age IN (SELECT MIN(Age) FROM singer)
WITH youngest AS (SELECT MIN(Age) AS min_age FROM singer) SELECT Song_Name, Song_release_year FROM singer, youngest WHERE singer.Age  =  youngest.min_age
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country ,  count(*) FROM singer GROUP BY Country
SELECT Country, count(Singer_ID) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location,Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity) ,  avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name ,  Capacity FROM stadium WHERE Average  =  (SELECT MAX(Average ) FROM stadium)
SELECT Name ,  Capacity FROM stadium WHERE Average  =  (SELECT max(Average) FROM stadium)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT Name, count(concert_ID) FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID GROUP BY stadium.Stadium_ID , Name
SELECT Location, COUNT(concert_ID) FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID GROUP BY Location
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = (SELECT Stadium_ID FROM concert WHERE Year >= 2014 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = (SELECT Stadium_ID FROM concert WHERE Year > 2013 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
WITH cnts AS (SELECT Year,count(*) cnt FROM concert GROUP BY Year) SELECT Year FROM cnts WHERE cnt  =  (SELECT max(cnt) FROM cnts)
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT DISTINCT s1.Country FROM singer AS s1 JOIN singer AS s2 ON s1.Country  =  s2.Country WHERE s1.Age > 40 AND s2.Age < 30
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name, Theme, (SELECT COUNT(*) FROM singer_in_concert sic2 WHERE sic2.concert_ID  =  c.concert_ID) FROM concert c
SELECT T1.concert_Name , T1.Theme , COUNT(T2.Singer_ID) FROM concert AS T1 JOIN singer_in_concert AS T2 ON T1.concert_ID  =  T2.concert_ID GROUP BY T1.concert_ID , T1.concert_Name , T1.Theme
SELECT T2.Name ,  count(T1.concert_ID) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T2.Singer_ID ,  T2.Name
SELECT Name, count(concert_ID) FROM singer JOIN singer_in_concert ON singer.Singer_ID  =  singer_in_concert.Singer_ID GROUP BY Name
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year=2014))
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year = 2014))
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name ,  Country FROM singer WHERE Song_Name  LIKE '%Hey%'
SELECT DISTINCT stadium.Name, stadium.Location FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID WHERE concert.Year IN (2014, 2015) GROUP BY stadium.Stadium_ID, stadium.Name, stadium.Location HAVING SUM(CASE WHEN concert.Year = 2014 THEN 1 ELSE 0 END) > 0 AND SUM(CASE WHEN concert.Year = 2015 THEN 1 ELSE 0 END) > 0
SELECT stadium.Name ,  stadium.Location FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID WHERE concert.Year IN (2014,2015) GROUP BY stadium.Stadium_ID ,  stadium.Name ,  stadium.Location HAVING COUNT(DISTINCT concert.Year) = 2
SELECT COUNT(*) FROM concert WHERE Stadium_ID  =  (SELECT Stadium_ID  FROM stadium ORDER BY Capacity  DESC LIMIT 1)
SELECT count(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Capacity  =  (SELECT max(Capacity) FROM stadium)
SELECT COUNT(*) FROM Pets WHERE weight > 10
SELECT COUNT(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType  =  'dog' AND pet_age  =  (SELECT MIN(pet_age) FROM Pets WHERE PetType  =  'dog')
SELECT weight FROM Pets WHERE PetType='dog' ORDER BY pet_age ASC LIMIT 1
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT COUNT(*) FROM (SELECT PetID FROM Has_Pet H JOIN Student S ON H.StuID = S.StuID WHERE S.Age > 20) AS subquery
SELECT count(*) FROM Pets P JOIN Has_Pet H ON P.PetID  =  H.PetID JOIN Student S ON S.StuID  =  H.StuID WHERE S.Age  >  20
SELECT count(*) FROM Pets P JOIN Has_Pet H ON P.PetID = H.PetID JOIN Student S ON H.StuID = S.StuID WHERE P.PetType = 'dog' AND S.Sex = 'F'
SELECT count(*) FROM Student S1 JOIN Has_Pet H1 ON S1.StuID  =  H1.StuID JOIN Pets P1 ON H1.PetID  =  P1.PetID WHERE S1.Sex  =  'F' AND P1.PetType  =  'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' OR PetType = 'dog'))
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' OR PetType = 'dog'))
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat') AND StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')
SELECT DISTINCT Fname FROM Student S1 WHERE EXISTS (SELECT 1 FROM Has_Pet H1 JOIN Pets P1 ON H1.PetID=P1.PetID WHERE H1.StuID=S1.StuID AND P1.PetType='cat') AND EXISTS (SELECT 1 FROM Has_Pet H2 JOIN Pets P2 ON H2.PetID=P2.PetID WHERE H2.StuID=S1.StuID AND P2.PetType='dog')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID  =  P.PetID WHERE P.PetType  =  'cat')
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT PetID FROM Student JOIN Has_Pet ON Student.StuID  =  Has_Pet.StuID WHERE LName  =  'Smith'
SELECT DISTINCT P.PetID FROM Pets P, Has_Pet H, Student S WHERE P.PetID = H.PetID AND H.StuID = S.StuID AND S.LName = 'Smith'
SELECT Student.StuID, COUNT(Has_Pet.PetID) FROM Student JOIN Has_Pet ON Student.StuID  =  Has_Pet.StuID GROUP BY Student.StuID
SELECT StuID ,  count(PetID) FROM Has_Pet GROUP BY StuID
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(*) FROM continents
SELECT count(*) FROM continents
SELECT c.ContId, c.Continent, count(co.CountryId) FROM continents c JOIN countries co ON c.Continent  =  co.Continent GROUP BY c.ContId, c.Continent
SELECT ContId, Continent, (SELECT count(CountryId) FROM countries c2 WHERE c2.Continent  =  continents.ContId GROUP BY c2.Continent) FROM continents
SELECT count(*) FROM countries
SELECT count(*) FROM countries
SELECT FullName, Id, (SELECT COUNT(DISTINCT Model) FROM model_list WHERE Maker  =  car_makers.Maker) FROM car_makers
SELECT Id, FullName, (SELECT COUNT(Model) FROM model_list WHERE Maker  =  car_makers.Maker) FROM car_makers
WITH min_hp AS (SELECT MIN(Horsepower) AS min_power FROM cars_data) SELECT cn.Model FROM car_names cn JOIN cars_data cd ON cn.MakeId  =  cd.Id JOIN min_hp mh ON cd.Horsepower  =  mh.min_power
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Horsepower  =  (SELECT MIN(Horsepower) FROM cars_data))
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT avg(Weight) FROM cars_data))
SELECT Model FROM car_names WHERE EXISTS (SELECT 1 FROM cars_data WHERE Id  =  MakeId AND Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT Maker FROM model_list JOIN cars_data ON model_list.ModelId  =  cars_data.Id WHERE cars_data.Year  =  1970
