SELECT count(*) FROM singer
SELECT count(*) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name, Song_release_year FROM singer ORDER BY Age ASC LIMIT 1
WITH youngest AS (SELECT MIN(Age) AS min_age FROM singer) SELECT Song_Name, Song_release_year FROM singer, youngest WHERE Age = min_age
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(Name) FROM singer GROUP BY Country
SELECT Country, count(*) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT Song_Name FROM singer WHERE Age > (SELECT avg(Age) FROM singer)
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT COUNT(*) FROM concert WHERE Year IN (2014,2015)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT Name, count(concert_ID) FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID GROUP BY stadium.Stadium_ID , Name
SELECT Location, count(concert_ID) FROM stadium s LEFT JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Location, s.Name, s.Capacity
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = (SELECT Stadium_ID FROM concert WHERE Year >= 2014 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = (SELECT Stadium_ID FROM concert WHERE Year > 2013 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1)
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert WHERE Year IN (SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1) GROUP BY Year
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT s.Name FROM stadium s WHERE s.Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT DISTINCT s1.Country FROM singer s1 WHERE s1.Age > 40 AND EXISTS(SELECT 1 FROM singer s2 WHERE s2.Country = s1.Country AND s2.Age < 30)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT c.concert_Name, c.Theme, COUNT(sic.Singer_ID) FROM concert c JOIN singer_in_concert sic ON c.concert_ID  =  sic.concert_ID GROUP BY c.concert_ID, c.concert_Name, c.Theme
SELECT c.concert_Name, c.Theme, COUNT(sic.Singer_ID) FROM concert c JOIN singer_in_concert sic ON c.concert_ID  =  sic.concert_ID GROUP BY c.concert_ID, c.concert_Name, c.Theme
SELECT s.Name, count(sc.concert_ID) FROM singer_in_concert sc JOIN singer s ON sc.Singer_ID  =  s.Singer_ID GROUP BY s.Singer_ID, s.Name
SELECT s.Name ,  count(c.concert_ID) FROM singer AS s JOIN singer_in_concert AS sic ON s.Singer_ID  =  sic.Singer_ID JOIN concert AS c ON sic.concert_ID  =  c.concert_ID GROUP BY s.Singer_ID ,  s.Name
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year=2014))
SELECT Name FROM singer WHERE Singer_ID IN (SELECT Singer_ID FROM singer_in_concert WHERE concert_ID IN (SELECT concert_ID FROM concert WHERE Year=2014))
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name,Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT DISTINCT s.Name, s.Location FROM stadium s WHERE s.Stadium_ID IN (SELECT c.Stadium_ID FROM concert c WHERE c.Year = 2014) AND s.Stadium_ID IN (SELECT c.Stadium_ID FROM concert c WHERE c.Year = 2015)
SELECT DISTINCT T1.Location ,  T1.Name FROM stadium AS T1 WHERE T1.Stadium_ID IN (SELECT T3.Stadium_ID FROM concert AS T3 WHERE T3.Year = 2014) AND T1.Stadium_ID IN (SELECT T4.Stadium_ID FROM concert AS T4 WHERE T4.Year = 2015)
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1)
SELECT count(*) FROM Pets WHERE weight > 10
SELECT count(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT MIN(pet_age) FROM Pets WHERE PetType = 'dog')
SELECT weight FROM Pets WHERE PetType  =  'dog' ORDER BY pet_age ASC LIMIT 1
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, max(weight) FROM Pets GROUP BY PetType
SELECT count(*) FROM Pets P WHERE P.PetID IN (SELECT H.PetID FROM Has_Pet H JOIN Student S ON H.StuID = S.StuID WHERE S.Age > 20)
SELECT COUNT(*) FROM Pets P WHERE PetID IN (SELECT PetID FROM Has_Pet H WHERE StuID IN (SELECT StuID FROM Student WHERE Age > 20))
SELECT COUNT(*) FROM Pets P JOIN Has_Pet H ON P.PetID = H.PetID JOIN Student S ON H.StuID = S.StuID WHERE P.PetType = 'dog' AND S.Sex = 'F'
SELECT count(*) FROM Student S1 JOIN Has_Pet H1 ON S1.StuID  =  H1.StuID JOIN Pets P1 ON H1.PetID  =  P1.PetID WHERE S1.Sex  =  'F' AND P1.PetType  =  'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType='cat' OR PetType='dog'))
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' OR PetType = 'dog')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat' INTERSECT SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat') INTERSECT SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'dog'))
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT StuID FROM Student EXCEPT SELECT H.StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat'
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog') AND StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT PetType, weight FROM Pets ORDER BY pet_age LIMIT 1
SELECT PetType,weight FROM Pets WHERE pet_age=(SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType ,  avg(pet_age) ,  max(pet_age) FROM Pets GROUP BY PetType
SELECT PetType,avg(weight) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT h.PetID FROM Has_Pet h JOIN Student s ON h.StuID = s.StuID WHERE s.LName = 'Smith'
SELECT PetID FROM Pets WHERE PetID IN (SELECT PetID FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE LName = 'Smith'))
SELECT Student.StuID, COUNT(Has_Pet.PetID) FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID
SELECT h.StuID, count(h.PetID) FROM Has_Pet h JOIN Student s ON h.StuID  =  s.StuID GROUP BY h.StuID
SELECT Fname ,  Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING count(PetID) > 1)
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1)
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT S.StuID FROM Has_Pet S)
SELECT count(*) FROM continents
SELECT count(*) FROM continents
SELECT c.ContId, c.Continent, count(co.CountryId) FROM continents c, countries co WHERE c.ContId  =  co.Continent GROUP BY c.ContId, c.Continent
SELECT ContId, Continent, (SELECT count(CountryId) FROM countries WHERE Continent  =  continents.Continent) FROM continents
SELECT count(*) FROM countries
SELECT count(*) FROM countries
SELECT cm.FullName ,  cm.Id ,  COUNT(DISTINCT ml.Model) FROM car_makers AS cm JOIN model_list AS ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id ,  cm.FullName
SELECT cm.Id, cm.FullName, COUNT(ml.Model) FROM car_makers cm JOIN model_list ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT ml.Model FROM model_list ml INNER JOIN car_makers cm ON ml.Maker=cm.Maker WHERE ml.ModelId=(SELECT MIN(Id) FROM cars_data ORDER BY Horsepower)
SELECT Model FROM model_list m1 WHERE Maker IN (SELECT Maker FROM car_makers WHERE Country IN (SELECT Country FROM countries)) AND Model IN (SELECT Model FROM car_names) ORDER BY (SELECT MIN(Horsepower) FROM cars_data WHERE Id IN (SELECT Id FROM cars_data)) LIMIT 1
SELECT cn.Model FROM (SELECT Id FROM cars_data WHERE Weight < (SELECT AVG(Weight) FROM cars_data)) sub JOIN car_names cn ON sub.Id = cn.MakeId
SELECT Model FROM car_names WHERE MakeId IN (SELECT DISTINCT Id FROM cars_data WHERE Weight< (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT Maker FROM (SELECT cm.Maker, cd.Year FROM car_makers cm JOIN model_list ml ON cm.Id  =  ml.Maker JOIN cars_data cd ON ml.ModelId  =  cd.Id) t WHERE Year  =  1970
