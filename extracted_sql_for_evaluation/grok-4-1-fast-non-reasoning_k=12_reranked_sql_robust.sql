SELECT count(*) FROM singer
SELECT count(*) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name,Song_release_year FROM singer WHERE Age = (SELECT MIN(Age) FROM singer)
SELECT Song_Name, Song_release_year FROM singer WHERE Age  =  (SELECT MIN(Age) FROM singer)
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(*) FROM singer GROUP BY Country
SELECT Country, count(*) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT DISTINCT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT count(*) FROM concert WHERE Year  =  2014 OR Year  =  2015
SELECT count(*) FROM concert WHERE Year  =  2014 OR Year  =  2015
SELECT s.Name ,  count(c.concert_ID) FROM stadium s LEFT JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Stadium_ID ,  s.Name
SELECT s.Name, count(c.Stadium_ID) FROM stadium AS s, concert AS c WHERE s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Name
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = (SELECT Stadium_ID FROM concert WHERE Year >= 2014 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT s.Name ,  s.Capacity FROM stadium s WHERE s.Stadium_ID  =  (SELECT c.Stadium_ID FROM concert c WHERE c.Year  >  2013 GROUP BY c.Stadium_ID ORDER BY count(*) DESC LIMIT 1)
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT DISTINCT Country FROM singer WHERE Age > 40 INTERSECT SELECT DISTINCT Country FROM singer WHERE Age < 30
SELECT Name FROM stadium EXCEPT SELECT s.Name FROM stadium s JOIN concert c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = 2014
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name, Theme, COUNT(*) FROM concert C INNER JOIN singer_in_concert S ON C.concert_ID  =  S.concert_ID GROUP BY C.concert_ID, concert_Name, Theme
SELECT c.concert_Name, c.Theme, COUNT(sic.Singer_ID) FROM concert c JOIN singer_in_concert sic ON c.concert_ID  =  sic.concert_ID GROUP BY c.concert_ID, c.concert_Name, c.Theme
SELECT s.Name ,  count(c.concert_ID) FROM singer s ,  singer_in_concert sic ,  concert c WHERE s.Singer_ID  =  sic.Singer_ID AND sic.concert_ID  =  c.concert_ID GROUP BY s.Singer_ID ,  s.Name
SELECT s.Name ,  count(DISTINCT sic.concert_ID) FROM singer AS s JOIN singer_in_concert AS sic ON s.Singer_ID  =  sic.Singer_ID GROUP BY s.Singer_ID ,  s.Name
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year=2014))
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year = 2014))
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT DISTINCT stadium.Name, stadium.Location FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID WHERE concert.Year IN (2014,2015) GROUP BY stadium.Stadium_ID, stadium.Name, stadium.Location HAVING COUNT(DISTINCT concert.Year)=2
SELECT DISTINCT s.Name ,  s.Location FROM stadium s JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID WHERE c.Year IN (2014,2015) GROUP BY s.Stadium_ID ,  s.Name ,  s.Location HAVING COUNT(DISTINCT c.Year) = 2
SELECT COUNT(*) FROM concert WHERE Stadium_ID  =  (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT count(*) FROM Pets WHERE weight > 10
SELECT count(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT MIN(pet_age) FROM Pets WHERE PetType = 'dog')
SELECT weight FROM Pets WHERE PetType  =  'dog' ORDER BY pet_age ASC LIMIT 1
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT COUNT(*) FROM Pets P JOIN Has_Pet H ON P.PetID = H.PetID JOIN Student S ON H.StuID = S.StuID WHERE S.Age > 20
SELECT count(*) FROM Pets P JOIN Has_Pet HP ON P.PetID = HP.PetID JOIN Student S ON HP.StuID = S.StuID WHERE S.Age > 20
SELECT count(*) FROM Pets P JOIN Has_Pet H ON P.PetID = H.PetID JOIN Student S ON H.StuID = S.StuID WHERE P.PetType = 'dog' AND S.Sex = 'F'
SELECT count(*) FROM Pets P JOIN Has_Pet H ON P.PetID  =  H.PetID JOIN Student S ON H.StuID  =  S.StuID WHERE P.PetType  =  'dog' AND S.Sex  =  'F'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' OR PetType = 'dog'))
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' OR PetType = 'dog')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' INTERSECT SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' INTERSECT SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID=P.PetID WHERE P.PetType='cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT Fname ,  Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID  =  Pets.PetID WHERE PetType  =  'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID  =  Pets.PetID WHERE PetType  =  'cat')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT Fname ,  Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT PetID FROM Pets WHERE PetID IN (SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName = 'Smith'))
SELECT PetID FROM Pets WHERE PetID IN (SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName  =  'Smith'))
SELECT T1.StuID, count(T2.PetID) FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT StuID, count(PetID) FROM Has_Pet GROUP BY StuID
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING count(PetID) > 1)
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1)
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(*) FROM continents
SELECT count(*) FROM continents
SELECT continent.ContId, continent.Continent, count(*) FROM continents continent, countries country WHERE continent.Continent  =  country.Continent GROUP BY continent.ContId, continent.Continent
SELECT c.ContId, c.Continent, count(*) FROM continents c, countries co WHERE c.Continent  =  co.Continent GROUP BY c.ContId, c.Continent
SELECT count(*) FROM countries
SELECT count(*) FROM countries
SELECT cm.FullName ,  cm.Id ,  count(DISTINCT ml.Model) FROM car_makers AS cm JOIN model_list AS ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id ,  cm.FullName
SELECT cm.Id, cm.FullName, COUNT(ml.ModelId) FROM car_makers cm JOIN model_list ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT Model FROM car_names WHERE Make IN (SELECT Make FROM cars_data WHERE Horsepower=(SELECT MIN(Horsepower) FROM cars_data))
SELECT mo.Model FROM (SELECT MIN(Horsepower) AS min_power FROM cars_data) AS minp JOIN cars_data cd ON cd.Horsepower=minp.min_power JOIN car_makers cm ON cd.Id=cm.Id JOIN model_list mo ON mo.Maker=cm.Maker LIMIT 1
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight  < (SELECT AVG(Weight) FROM cars_data))
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT Maker FROM car_makers WHERE Country IN (SELECT Country FROM cars_data WHERE Year  =  1970)
