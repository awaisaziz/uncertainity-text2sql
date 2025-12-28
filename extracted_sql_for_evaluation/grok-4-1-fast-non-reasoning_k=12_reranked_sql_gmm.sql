SELECT count(1) FROM singer
SELECT count(1) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY -Age
SELECT Name, Country, Age FROM singer ORDER BY -Age
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
WITH youngest AS (SELECT MIN(Age) as min_age FROM singer) SELECT Name,Song_release_year FROM singer,youngest WHERE Age = min_age
SELECT Song_Name, Song_release_year FROM singer WHERE Age  =  (SELECT MIN(Age) FROM singer)
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(Name) FROM singer GROUP BY Country
SELECT Country, count(*) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT DISTINCT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location, Name FROM stadium WHERE Capacity >= 5000 AND Capacity < 10001
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average IN (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average IN (SELECT MAX(Average) FROM stadium)
SELECT count(*) FROM concert WHERE Year IN (2014, 2015)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT s.Name ,  count(*) FROM stadium s JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Stadium_ID ,  s.Name
SELECT s.Name, count(c.Stadium_ID) FROM stadium AS s, concert AS c WHERE s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Name
SELECT s.Name, s.Capacity FROM stadium s JOIN concert c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year >= 2014 GROUP BY s.Stadium_ID, s.Name, s.Capacity ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name ,  Capacity FROM stadium WHERE Stadium_ID IN (SELECT Stadium_ID FROM (SELECT Stadium_ID ,  count(*) AS cnt FROM concert WHERE Year  >  2013 GROUP BY Stadium_ID ORDER BY cnt DESC LIMIT 1) t)
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM (SELECT Year, count(*) cnt FROM concert GROUP BY Year) sub ORDER BY cnt DESC LIMIT 1
SELECT s.Name FROM stadium s WHERE s.Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT s.Name FROM stadium s WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT Country FROM singer WHERE Age < 30 AND Country IN (SELECT Country FROM singer WHERE Age > 40)
SELECT Name FROM stadium EXCEPT SELECT s.Name FROM stadium s JOIN concert c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = 2014
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name, Theme, COUNT(*) FROM concert C INNER JOIN singer_in_concert S ON C.concert_ID  =  S.concert_ID GROUP BY C.concert_ID, concert_Name, Theme
SELECT concert_Name, Theme, singers_per_concert FROM (SELECT concert_ID, COUNT(Singer_ID) singers_per_concert FROM singer_in_concert GROUP BY concert_ID) sc JOIN concert ON sc.concert_ID  =  concert.concert_ID
SELECT s.Name ,  count(c.concert_ID) FROM singer s ,  singer_in_concert sic ,  concert c WHERE s.Singer_ID  =  sic.Singer_ID AND sic.concert_ID  =  c.concert_ID GROUP BY s.Singer_ID ,  s.Name
SELECT s.Name ,  count(DISTINCT sic.concert_ID) FROM singer AS s JOIN singer_in_concert AS sic ON s.Singer_ID  =  sic.Singer_ID GROUP BY s.Singer_ID ,  s.Name
SELECT s.Name FROM singer s JOIN singer_in_concert sic ON s.Singer_ID=sic.Singer_ID JOIN concert c ON sic.concert_ID=c.concert_ID WHERE c.Year=2014
SELECT s.Name FROM singer s JOIN singer_in_concert sic ON s.Singer_ID = sic.Singer_ID JOIN concert c ON sic.concert_ID = c.concert_ID WHERE c.Year = 2014
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE LOCATE('Hey', Song_Name) > 0
SELECT DISTINCT s.Name, s.Location FROM stadium s JOIN concert c1 ON s.Stadium_ID  =  c1.Stadium_ID JOIN concert c2 ON s.Stadium_ID  =  c2.Stadium_ID WHERE c1.Year=2014 AND c2.Year=2015
SELECT DISTINCT s.Name ,  s.Location FROM stadium s JOIN concert c1 ON s.Stadium_ID  =  c1.Stadium_ID JOIN concert c2 ON s.Stadium_ID  =  c2.Stadium_ID WHERE c1.Year = 2014 AND c2.Year = 2015
SELECT COUNT(c.concert_ID) FROM concert c JOIN stadium s ON c.Stadium_ID  =  s.Stadium_ID WHERE s.Capacity  =  (SELECT MAX(Capacity) FROM stadium)
SELECT COUNT(*) FROM concert C JOIN stadium S ON C.Stadium_ID = S.Stadium_ID WHERE S.Capacity = (SELECT MAX(Capacity) FROM stadium)
SELECT count(1) FROM Pets WHERE weight > 10
SELECT count(weight) FROM Pets WHERE weight > 10
SELECT weight FROM (SELECT pet_age, MIN(weight) as weight FROM Pets WHERE PetType = 'dog' GROUP BY pet_age ORDER BY pet_age ASC LIMIT 1)
WITH youngest_dog AS (SELECT PetID FROM Pets WHERE PetType  =  'dog' ORDER BY pet_age ASC LIMIT 1) SELECT weight FROM Pets WHERE PetID IN (SELECT PetID FROM youngest_dog)
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT COUNT(*) FROM Pets P JOIN Has_Pet H ON P.PetID = H.PetID JOIN Student S ON H.StuID = S.StuID WHERE S.Age > 20
SELECT count(*) FROM Has_Pet HP JOIN Student S ON HP.StuID = S.StuID JOIN Pets P ON P.PetID = HP.PetID WHERE S.Age > 20
SELECT count(*) FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE S.Sex = 'F' AND P.PetType = 'dog'
SELECT count(*) FROM Student S JOIN Has_Pet H ON S.StuID  =  H.StuID JOIN Pets P ON H.PetID  =  P.PetID WHERE S.Sex  =  'F' AND P.PetType  =  'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' OR PetType = 'dog'))
SELECT DISTINCT S.Fname FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat' OR P.PetType = 'dog'
SELECT DISTINCT S.Fname FROM Student S JOIN Has_Pet HP1 ON S.StuID = HP1.StuID JOIN Pets P1 ON HP1.PetID = P1.PetID JOIN Has_Pet HP2 ON S.StuID = HP2.StuID JOIN Pets P2 ON HP2.PetID = P2.PetID WHERE P1.PetType = 'cat' AND P2.PetType = 'dog' AND P1.PetID != P2.PetID
SELECT DISTINCT s.Fname FROM Student s JOIN Has_Pet hp1 ON s.StuID = hp1.StuID JOIN Pets p1 ON hp1.PetID = p1.PetID JOIN Has_Pet hp2 ON s.StuID = hp2.StuID JOIN Pets p2 ON hp2.PetID = p2.PetID WHERE p1.PetType = 'cat' AND p2.PetType = 'dog'
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT H.StuID FROM Has_Pet H, Pets P WHERE H.PetID=P.PetID AND P.PetType='cat')
SELECT StuID FROM Student EXCEPT SELECT h.StuID FROM Has_Pet h JOIN Pets p ON h.PetID = p.PetID WHERE p.PetType = 'cat'
SELECT StuID FROM Student MINUS SELECT DISTINCT H.StuID FROM Has_Pet H, Pets P WHERE H.PetID = P.PetID AND P.PetType = 'cat'
SELECT S.Fname ,  S.Age FROM Student S JOIN Has_Pet H ON S.StuID  =  H.StuID JOIN Pets P ON H.PetID  =  P.PetID WHERE P.PetType  =  'dog' AND S.StuID NOT IN (SELECT H2.StuID FROM Has_Pet H2 JOIN Pets P2 ON H2.PetID  =  P2.PetID WHERE P2.PetType  =  'cat')
SELECT Fname FROM (SELECT DISTINCT S.StuID, S.Fname FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'dog') AS DogOwners WHERE StuID NOT IN (SELECT H2.StuID FROM Has_Pet H2 JOIN Pets P2 ON H2.PetID = P2.PetID WHERE P2.PetType = 'cat')
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
WITH youngest AS (SELECT MIN(pet_age) min_age FROM Pets) SELECT PetType, weight FROM Pets, youngest WHERE pet_age = min_age
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType ORDER BY avg(weight) DESC
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT Fname ,  Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT PetID FROM Student S, Has_Pet H WHERE S.LName = 'Smith' AND S.StuID = H.StuID
SELECT H.PetID FROM Has_Pet H JOIN Student S ON H.StuID  =  S.StuID WHERE S.LName  =  'Smith'
SELECT T1.StuID, count(*) FROM Has_Pet AS T1 JOIN Student AS T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT H.StuID, count(H.PetID) FROM Has_Pet H INNER JOIN Student S ON H.StuID  =  S.StuID GROUP BY H.StuID
SELECT DISTINCT S.Fname, S.Sex FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID GROUP BY S.StuID, S.Fname, S.Sex HAVING count(H.PetID) > 1
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1)
SELECT LName FROM Student S1 JOIN Has_Pet H ON S1.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT LName FROM Student S1 JOIN Has_Pet H ON S1.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(Continent) FROM continents
SELECT count(Continent) FROM continents
SELECT continent.ContId, continent.Continent, count(*) FROM continents continent, countries country WHERE continent.Continent  =  country.Continent GROUP BY continent.ContId, continent.Continent
SELECT ContId, Continent, count(CountryId) FROM continents c JOIN countries co ON c.Continent  =  co.Continent GROUP BY ContId, Continent
SELECT count(1) FROM countries
SELECT count(1) FROM countries
SELECT cm.FullName ,  cm.Id ,  count(DISTINCT ml.Model) FROM car_makers AS cm JOIN model_list AS ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id ,  cm.FullName
SELECT cm.Id, cm.FullName, COUNT(ml.ModelId) FROM car_makers cm JOIN model_list ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT m.Model FROM model_list m JOIN car_makers cm ON m.Maker=cm.Maker JOIN cars_data cd ON cm.FullName=cd.Make WHERE cd.Horsepower=MIN(cd.Horsepower)
WITH min_car AS (SELECT Id FROM cars_data ORDER BY Horsepower LIMIT 1) SELECT Model FROM car_names cn JOIN min_car mc ON cn.MakeId=mc.Id
SELECT Model FROM model_list M1 JOIN cars_data C1 ON M1.Maker  =  C1.Maker WHERE C1.Weight  < (SELECT AVG(Weight) FROM cars_data)
SELECT Model FROM model_list WHERE Maker IN (SELECT Maker FROM car_makers JOIN cars_data ON car_makers.Country = cars_data.Country WHERE Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT Maker FROM car_makers WHERE Country IN (SELECT Country FROM cars_data WHERE Year  =  1970)
