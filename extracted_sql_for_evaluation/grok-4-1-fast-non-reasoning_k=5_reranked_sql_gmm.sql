SELECT count(1) FROM singer
SELECT count(1) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name ,  Song_release_year FROM singer WHERE Age  IN (SELECT MIN(Age) FROM singer)
SELECT Song_Name, Song_release_year FROM singer ORDER BY Age ASC LIMIT 1
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(*) FROM singer GROUP BY Country
SELECT Country,count(*) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT Song_Name FROM singer WHERE Age  > ALL (SELECT avg(Age) FROM singer)
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location ,  Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average IN (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average IN (SELECT MAX(Average) FROM stadium)
SELECT COUNT(concert_ID) FROM concert WHERE Year BETWEEN 2014 AND 2015
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT s.Name, count(c.concert_ID) FROM stadium s JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Stadium_ID, s.Name
SELECT s.Stadium_ID, s.Name, COUNT(c.concert_ID) FROM stadium s LEFT JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Stadium_ID, s.Name
SELECT Name, Capacity FROM stadium WHERE Stadium_ID IN (SELECT Stadium_ID FROM (SELECT Stadium_ID, COUNT(*) AS cnt FROM concert WHERE Year  >=  2014 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1) t)
WITH concert_counts AS (SELECT Stadium_ID, COUNT(*) AS cnt FROM concert WHERE Year > 2013 GROUP BY Stadium_ID), max_concerts AS (SELECT MAX(cnt) AS max_cnt FROM concert_counts) SELECT stadium.Name, stadium.Capacity FROM stadium JOIN concert_counts ON stadium.Stadium_ID = concert_counts.Stadium_ID JOIN max_concerts ON concert_counts.cnt = max_concerts.max_cnt
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM stadium EXCEPT SELECT s.Name FROM stadium s INNER JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Stadium_ID IS NOT NULL)
SELECT Country FROM singer WHERE Age > 40 AND Singer_ID IN (SELECT Singer_ID FROM singer_in_concert sic1 WHERE sic1.concert_ID IN (SELECT sic2.concert_ID FROM singer_in_concert sic2 JOIN singer s2 ON sic2.Singer_ID = s2.Singer_ID WHERE s2.Age < 30)) GROUP BY Country
SELECT Name FROM stadium EXCEPT SELECT s.Name FROM stadium s JOIN concert c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = 2014
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name, Theme, (SELECT COUNT(*) FROM singer_in_concert WHERE concert_ID  =  c.concert_ID) FROM concert c
SELECT concert_Name, Theme, (SELECT COUNT(Singer_ID) FROM singer_in_concert WHERE concert_ID  =  concert.concert_ID) FROM concert
SELECT Name ,  (SELECT count(*) FROM singer_in_concert WHERE Singer_ID  =  s.Singer_ID) FROM singer s
SELECT Name ,  (SELECT count(concert_ID) FROM singer_in_concert WHERE Singer_ID  =  s.Singer_ID ) FROM singer AS s
SELECT DISTINCT s.Name FROM singer s, singer_in_concert sc, concert c WHERE s.Singer_ID=sc.Singer_ID AND sc.concert_ID=c.concert_ID AND c.Year=2014
SELECT s.Name FROM concert c JOIN singer_in_concert sc ON c.concert_ID  =  sc.concert_ID JOIN singer s ON sc.Singer_ID  =  s.Singer_ID WHERE c.Year  =  2014
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name, Country FROM singer WHERE LOCATE('Hey', Song_Name) > 0
SELECT DISTINCT T1.Name ,  T1.Location FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID JOIN concert AS T3 ON T1.Stadium_ID  =  T3.Stadium_ID WHERE T2.Year=2014 AND T3.Year=2015
SELECT DISTINCT s.Name, s.Location FROM stadium s JOIN concert c1 ON s.Stadium_ID  =  c1.Stadium_ID JOIN concert c2 ON s.Stadium_ID  =  c2.Stadium_ID WHERE c1.Year  =  2014 AND c2.Year  =  2015
SELECT COUNT(DISTINCT c.concert_ID) FROM concert c, stadium s WHERE c.Stadium_ID = s.Stadium_ID AND s.Capacity = (SELECT MAX(Capacity) FROM stadium)
SELECT count(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Capacity  =  (SELECT max(Capacity) FROM stadium)
SELECT count(1) FROM Pets WHERE weight > 10
SELECT COUNT(1) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType  =  'dog' AND pet_age  =  (SELECT MIN(pet_age) FROM Pets WHERE PetType  =  'dog')
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1
SELECT PetType, max(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT count(*) FROM Has_Pet H WHERE EXISTS (SELECT 1 FROM Student S WHERE S.StuID  =  H.StuID AND S.Age  >  20)
SELECT count(P.PetID) FROM Student S JOIN Has_Pet HP ON S.StuID = HP.StuID JOIN Pets P ON HP.PetID = P.PetID WHERE S.Age > 20
SELECT COUNT(P.PetID) FROM Pets P JOIN Has_Pet H ON P.PetID = H.PetID JOIN Student S ON H.StuID = S.StuID WHERE P.PetType = 'dog' AND S.Sex = 'F'
SELECT COUNT(*) FROM Student S1 JOIN Has_Pet HP1 ON S1.StuID  =  HP1.StuID JOIN Pets P1 ON HP1.PetID  =  P1.PetID WHERE S1.Sex  =  'F' AND P1.PetType  =  'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT count(*) FROM (SELECT PetType FROM Pets) AS T1 GROUP BY PetType
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' OR PetType = 'dog'))
SELECT DISTINCT Fname FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType IN ('cat','dog')
SELECT DISTINCT S1.Fname FROM Student S1 JOIN Has_Pet H1 ON S1.StuID = H1.StuID JOIN Pets P1 ON H1.PetID = P1.PetID JOIN Has_Pet H2 ON S1.StuID = H2.StuID JOIN Pets P2 ON H2.PetID = P2.PetID WHERE P1.PetType = 'cat' AND P2.PetType = 'dog' AND P1.PetID <> P2.PetID
SELECT DISTINCT T1.Fname FROM Student T1 JOIN Has_Pet T2 ON T1.StuID  =  T2.StuID JOIN Pets T3 ON T2.PetID  =  T3.PetID WHERE T3.PetType IN ('cat','dog') GROUP BY T1.StuID , T1.Fname HAVING COUNT(DISTINCT T3.PetType)  =  2
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID  =  P.PetID WHERE PetType  =  'cat')
SELECT Student.StuID FROM Student WHERE Student.StuID NOT IN (SELECT Has_Pet.StuID FROM Has_Pet, Pets WHERE Has_Pet.PetID = Pets.PetID AND Pets.PetType = 'cat')
SELECT StuID FROM Student EXCEPT SELECT DISTINCT H.StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE PetType = 'cat'
SELECT Fname, Age FROM Student S JOIN Has_Pet HP1 ON S.StuID = HP1.StuID JOIN Pets Pet1 ON HP1.PetID = Pet1.PetID WHERE Pet1.PetType = 'dog' AND S.StuID NOT IN (SELECT HP2.StuID FROM Has_Pet HP2 JOIN Pets Pet2 ON HP2.PetID = Pet2.PetID WHERE Pet2.PetType = 'cat')
SELECT DISTINCT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog' AND Student.StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets AS P2 ON Has_Pet.PetID = P2.PetID WHERE P2.PetType = 'cat')
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT MIN(pet_age) FROM Pets)
SELECT PetType, weight FROM Pets ORDER BY pet_age ASC LIMIT 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType
SELECT DISTINCT Fname, Age FROM Student S JOIN Has_Pet H ON S.StuID  =  H.StuID JOIN Pets P ON H.PetID  =  P.PetID
SELECT DISTINCT S.Fname, S.Age FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID
SELECT Has_Pet.PetID FROM Has_Pet, Student WHERE Has_Pet.StuID  =  Student.StuID AND LName  =  'Smith'
SELECT T2.PetID FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID  =  T2.StuID WHERE T1.LName  =  'Smith'
SELECT T1.StuID, COUNT(*) FROM Has_Pet T1 JOIN Student T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT H.StuID, COUNT(H.PetID) FROM Has_Pet H JOIN Student S ON H.StuID = S.StuID GROUP BY H.StuID
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1)
SELECT S.LName FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT LName FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(1) FROM continents
SELECT count(Continent) FROM continents
SELECT ContId, Continent, count(CountryId) FROM countries JOIN continents ON countries.Continent  =  continents.Continent GROUP BY ContId, Continent
SELECT ContId, Continent, COUNT(*) FROM continents JOIN countries ON continents.Continent  =  countries.Continent GROUP BY ContId, Continent
SELECT count(1) FROM countries
SELECT count(1) FROM countries
SELECT T1.FullName ,  T1.Id ,  count(T2.Model) FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Maker  =  T2.Maker GROUP BY T1.Id ,  T1.FullName
SELECT cm.Id, cm.FullName, COUNT(ml.ModelId) FROM car_makers cm JOIN model_list ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT Model FROM model_list M1 JOIN car_makers M2 ON M1.Maker  =  M2.Maker JOIN cars_data C ON M2.Country  =  C.Country WHERE Horsepower  =  (SELECT MIN(Horsepower) FROM cars_data)
SELECT Model FROM car_names WHERE MakeId = (SELECT Id FROM cars_data WHERE Horsepower = (SELECT MIN(Horsepower) FROM cars_data))
SELECT DISTINCT Model FROM model_list ml JOIN car_makers cm ON ml.Maker  =  cm.Maker JOIN cars_data cd ON cm.Country  =  cd.Country WHERE cd.Weight < (SELECT avg(Weight) FROM cars_data)
SELECT Model FROM model_list WHERE Maker IN (SELECT Maker FROM car_makers JOIN cars_data ON car_makers.Country = cars_data.Country WHERE Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT T2.Maker FROM cars_data AS T1 JOIN model_list AS T2 ON T1.Id  =  T2.ModelId WHERE T1.Year  =  1970
