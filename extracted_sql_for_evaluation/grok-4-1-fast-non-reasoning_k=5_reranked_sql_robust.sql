SELECT count(*) FROM singer
SELECT count(*) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name ,  Song_release_year FROM singer WHERE Age  =  (SELECT MIN(Age) FROM singer)
SELECT Song_Name, Song_release_year FROM singer ORDER BY Age ASC LIMIT 1
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(*) FROM singer GROUP BY Country
SELECT Country,count(*) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT DISTINCT T2.Song_Name FROM singer AS T2 WHERE T2.Age  > (SELECT avg(T1.Age) FROM singer AS T1)
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT COUNT(*) FROM concert WHERE Year  =  2014 OR Year  =  2015
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT s.Name, count(c.concert_ID) FROM stadium s JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Stadium_ID, s.Name
SELECT T1.Stadium_ID, T1.Name, COUNT(T2.concert_ID) FROM stadium AS T1 LEFT JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID GROUP BY T1.Stadium_ID, T1.Name
SELECT stadium.Name, stadium.Capacity FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID WHERE concert.Year  >=  2014 GROUP BY stadium.Stadium_ID, stadium.Name, stadium.Capacity ORDER BY COUNT(concert.concert_ID) DESC LIMIT 1
SELECT stadium.Name, stadium.Capacity FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Stadium_ID, stadium.Name, stadium.Capacity HAVING COUNT(concert.concert_ID) = (SELECT MAX(c_count) FROM (SELECT COUNT(concert_ID) AS c_count FROM concert WHERE Year > 2013 GROUP BY Stadium_ID) AS counts)
SELECT Year FROM concert c1 GROUP BY Year HAVING count(*) = (SELECT max(c2_cnt) FROM (SELECT count(*) c2_cnt FROM concert c2 GROUP BY c2.Year))
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT DISTINCT s1.Country FROM singer s1 JOIN singer_in_concert sic1 ON s1.Singer_ID = sic1.Singer_ID WHERE s1.Age > 40 INTERSECT SELECT DISTINCT s2.Country FROM singer s2 JOIN singer_in_concert sic2 ON s2.Singer_ID = sic2.Singer_ID WHERE s2.Age < 30
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT c.concert_Name, c.Theme, COUNT(singer_in_concert.Singer_ID) FROM concert c LEFT JOIN singer_in_concert ON c.concert_ID  =  singer_in_concert.concert_ID GROUP BY c.concert_ID, c.concert_Name, c.Theme
SELECT C.concert_Name, C.Theme, COUNT(SIC.Singer_ID) FROM concert AS C INNER JOIN singer_in_concert AS SIC ON C.concert_ID  =  SIC.concert_ID GROUP BY C.concert_ID, C.concert_Name, C.Theme
SELECT s.Name ,  count(*) FROM singer s INNER JOIN singer_in_concert sic ON s.Singer_ID  =  sic.Singer_ID GROUP BY s.Singer_ID ,  s.Name
SELECT T2.Name ,  count(T1.concert_ID) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T2.Singer_ID ,  T2.Name
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year=2014))
SELECT s.Name FROM singer s JOIN singer_in_concert sc ON s.Singer_ID  =  sc.Singer_ID JOIN concert c ON sc.concert_ID  =  c.concert_ID WHERE c.Year  =  2014
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT DISTINCT T1.Name ,  T1.Location FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Year IN (2014,2015) GROUP BY T1.Stadium_ID ,  T1.Name ,  T1.Location HAVING COUNT(DISTINCT T2.Year)=2
SELECT DISTINCT s.Name, s.Location FROM stadium s JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID WHERE c.Year IN (2014, 2015) GROUP BY s.Stadium_ID, s.Name, s.Location HAVING COUNT(DISTINCT c.Year)  =  2
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT count(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Capacity  =  (SELECT max(Capacity) FROM stadium)
SELECT count(*) FROM Pets WHERE weight > 10
SELECT COUNT(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType  =  'dog' AND pet_age  =  (SELECT MIN(pet_age) FROM Pets WHERE PetType  =  'dog')
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1
SELECT PetType, max(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT count(*) FROM (SELECT DISTINCT PetID FROM Student S JOIN Has_Pet H ON S.StuID  =  H.StuID WHERE S.Age  >  20) T1
SELECT count(*) FROM Pets P WHERE P.PetID IN (SELECT PetID FROM Has_Pet HP WHERE HP.StuID IN (SELECT StuID FROM Student S WHERE S.Age > 20))
SELECT COUNT(*) FROM Pets P WHERE PetType = 'dog' AND PetID IN (SELECT PetID FROM Has_Pet H JOIN Student S ON H.StuID = S.StuID WHERE S.Sex = 'F')
SELECT COUNT(*) FROM Student S1 JOIN Has_Pet HP1 ON S1.StuID  =  HP1.StuID JOIN Pets P1 ON HP1.PetID  =  P1.PetID WHERE S1.Sex  =  'F' AND P1.PetType  =  'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT count(*) FROM (SELECT PetType FROM Pets) AS T1 GROUP BY PetType
SELECT Fname FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType IN ('cat','dog')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' OR PetType = 'dog')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat') AND StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')
SELECT DISTINCT T1.Fname FROM Student T1 JOIN Has_Pet T2 ON T1.StuID  =  T2.StuID JOIN Pets T3 ON T2.PetID  =  T3.PetID WHERE T3.PetType IN ('cat','dog') GROUP BY T1.StuID , T1.Fname HAVING COUNT(DISTINCT T3.PetType)  =  2
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID  =  P.PetID WHERE PetType  =  'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE PetType = 'cat')
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT DISTINCT Fname, Age FROM Student S JOIN Has_Pet H ON S.StuID  =  H.StuID JOIN Pets P ON H.PetID  =  P.PetID
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT PetID FROM Student JOIN Has_Pet ON Student.StuID  =  Has_Pet.StuID WHERE LName  =  'Smith'
SELECT PetID FROM Pets WHERE PetID IN (SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName  =  'Smith'))
SELECT T1.StuID, COUNT(T2.PetID) FROM Student T1 JOIN Has_Pet T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT StuID, COUNT(PetID) FROM Has_Pet GROUP BY StuID
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(*) FROM continents
SELECT count(*) FROM continents
SELECT DISTINCT continents.ContId, continents.Continent, count(countries.CountryId) OVER (PARTITION BY continents.ContId, continents.Continent) FROM continents JOIN countries ON continents.Continent  =  countries.Continent
SELECT ContId, Continent, (SELECT COUNT(*) FROM countries WHERE countries.Continent  =  continents.ContId) FROM continents
SELECT count(*) FROM countries
SELECT count(*) FROM countries
SELECT T1.FullName ,  T1.Id ,  count(T2.Model) FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Maker  =  T2.Maker GROUP BY T1.Id ,  T1.FullName
SELECT cm.Id, cm.FullName, COUNT(ml.ModelId) FROM car_makers cm JOIN model_list ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT Model FROM model_list M1 JOIN car_makers M2 ON M1.Maker  =  M2.Maker JOIN cars_data C ON M2.Country  =  C.Country WHERE Horsepower  =  (SELECT MIN(Horsepower) FROM cars_data)
SELECT T1.Model FROM model_list AS T1 WHERE T1.Maker IN (SELECT DISTINCT T2.Country FROM car_makers AS T2 JOIN countries AS T3 ON T2.Country  =  T3.CountryName) AND T1.ModelId = (SELECT Id FROM cars_data WHERE Horsepower = (SELECT MIN(Horsepower) FROM cars_data))
SELECT Model FROM model_list WHERE Maker IN (SELECT Maker FROM car_makers WHERE Country IN (SELECT Country FROM cars_data WHERE Weight < (SELECT avg(Weight) FROM cars_data)))
SELECT DISTINCT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT T2.Maker FROM cars_data AS T1 JOIN model_list AS T2 ON T1.Id  =  T2.ModelId WHERE T1.Year  =  1970
