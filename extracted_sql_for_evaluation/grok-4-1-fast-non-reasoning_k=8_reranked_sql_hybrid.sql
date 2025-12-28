SELECT count(1) FROM singer
SELECT count(1) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY -Age
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT avg(singer.Age), min(singer.Age), max(singer.Age) FROM singer WHERE singer.Country  =  'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT Name,Song_release_year FROM singer WHERE Age IN (SELECT MIN(Age) FROM singer)
WITH youngest AS (SELECT MIN(Age) AS min_age FROM singer) SELECT Song_Name, Song_release_year FROM singer, youngest WHERE singer.Age  =  youngest.min_age
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country ,  count(Name) FROM singer GROUP BY Country
SELECT Country, count(Name) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age  > (SELECT avg(Age) FROM singer)
SELECT Song_Name FROM singer WHERE Age > (SELECT AVG(Age) FROM singer)
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location,Name FROM stadium WHERE Capacity >= 5000 AND Capacity < 10001
SELECT max(Capacity) ,  avg(Capacity) FROM stadium
SELECT avg(Capacity) AS Average, max(Capacity) AS Maximum FROM stadium
SELECT Name ,  Capacity FROM stadium WHERE Average  =  (SELECT MAX(Average ) FROM stadium)
SELECT Name ,  Capacity FROM stadium WHERE Average  IN (SELECT max(Average) FROM stadium)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT count(*) FROM concert WHERE Year IN (2014,2015)
SELECT Name, count(concert_ID) FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID GROUP BY stadium.Stadium_ID , Name
SELECT Location, COUNT(concert_ID) FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID GROUP BY Location
SELECT s.Name, s.Capacity FROM stadium s JOIN (SELECT Stadium_ID, COUNT(*) as cnt FROM concert WHERE Year >= 2014 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1) t ON s.Stadium_ID = t.Stadium_ID
SELECT s.Name, s.Capacity FROM stadium s JOIN (SELECT Stadium_ID, COUNT(*) as cnt FROM concert WHERE Year > 2013 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1) t ON s.Stadium_ID = t.Stadium_ID
WITH cnts AS (SELECT Year,count(*) cnt FROM concert GROUP BY Year) SELECT Year FROM cnts WHERE cnt  =  (SELECT max(cnt) FROM cnts)
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT s.Name FROM stadium s WHERE s.Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT DISTINCT Country FROM singer WHERE Age > 40 AND Country IN (SELECT Country FROM singer WHERE Age < 30)
SELECT Name FROM stadium EXCEPT SELECT s.Name FROM stadium s JOIN concert c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = 2014
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name, Theme, (SELECT COUNT(*) FROM singer_in_concert sic2 WHERE sic2.concert_ID  =  c.concert_ID) FROM concert c
SELECT concert_Name , Theme , (SELECT COUNT(*) FROM singer_in_concert WHERE concert_ID  =  C.concert_ID ) FROM concert C
SELECT T2.Name ,  count(T1.concert_ID) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T2.Singer_ID ,  T2.Name
SELECT Name, count(sic.concert_ID) FROM singer_in_concert sic JOIN singer ON sic.Singer_ID  =  singer.Singer_ID GROUP BY Name
SELECT DISTINCT Name FROM singer s JOIN singer_in_concert sc ON s.Singer_ID=sc.Singer_ID JOIN concert c ON sc.concert_ID=c.concert_ID WHERE c.Year=2014
SELECT s.Name FROM singer s JOIN singer_in_concert sc ON s.Singer_ID = sc.Singer_ID JOIN concert c ON sc.concert_ID = c.concert_ID WHERE c.Year = 2014
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT Name ,  Country FROM singer WHERE Song_Name  LIKE '%Hey%'
SELECT stadium.Name, stadium.Location FROM stadium WHERE stadium.Stadium_ID IN (SELECT concert.Stadium_ID FROM concert WHERE concert.Year = 2014) AND stadium.Stadium_ID IN (SELECT concert.Stadium_ID FROM concert WHERE concert.Year = 2015)
SELECT Name ,  Location FROM stadium WHERE (SELECT COUNT(DISTINCT Year) FROM concert WHERE Stadium_ID  =  stadium.Stadium_ID AND Year IN (2014,2015)) = 2
SELECT COUNT(DISTINCT concert_ID ) FROM concert JOIN stadium ON concert.Stadium_ID  =  stadium.Stadium_ID  WHERE stadium.Capacity  =  (SELECT MAX(Capacity ) FROM stadium)
SELECT count(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID WHERE T2.Capacity  =  (SELECT max(Capacity) FROM stadium)
SELECT COUNT(1) FROM Pets WHERE weight > 10
SELECT COUNT(1) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE pet_age  =  (SELECT MIN(pet_age) FROM Pets WHERE PetType  =  'dog') AND PetType  =  'dog'
WITH youngest_dog_age AS (SELECT MIN(pet_age) AS min_age FROM Pets WHERE PetType='dog') SELECT weight FROM Pets p, youngest_dog_age yda WHERE p.PetType='dog' AND p.pet_age=yda.min_age
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT COUNT(*) FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE Age > 20)
SELECT count(*) FROM Pets P JOIN Has_Pet H ON P.PetID  =  H.PetID JOIN Student S ON S.StuID  =  H.StuID WHERE S.Age  >  20
SELECT count(H.PetID) FROM Has_Pet H JOIN Student S ON H.StuID = S.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'dog' AND S.Sex = 'F'
SELECT count(*) FROM (SELECT H1.PetID FROM Has_Pet H1 JOIN Student S1 ON H1.StuID  =  S1.StuID WHERE S1.Sex  =  'F') AS female_pets JOIN Pets P1 ON female_pets.PetID  =  P1.PetID WHERE P1.PetType  =  'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT DISTINCT Fname FROM Student S, Has_Pet H, Pets P WHERE S.StuID = H.StuID AND H.PetID = P.PetID AND (P.PetType = 'cat' OR P.PetType = 'dog')
SELECT DISTINCT Fname FROM Student S, Has_Pet H, Pets P WHERE S.StuID = H.StuID AND H.PetID = P.PetID AND (P.PetType = 'cat' OR P.PetType = 'dog')
SELECT DISTINCT S.Fname FROM Student S JOIN Has_Pet HP1 ON S.StuID = HP1.StuID JOIN Pets P1 ON HP1.PetID = P1.PetID JOIN Has_Pet HP2 ON S.StuID = HP2.StuID JOIN Pets P2 ON HP2.PetID = P2.PetID WHERE P1.PetType = 'cat' AND P2.PetType = 'dog'
WITH cat_owners AS (SELECT DISTINCT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID=Pets.PetID WHERE PetType='cat'), dog_owners AS (SELECT DISTINCT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID=Pets.PetID WHERE PetType='dog') SELECT Fname FROM Student JOIN cat_owners ON Student.StuID=cat_owners.StuID JOIN dog_owners ON Student.StuID=dog_owners.StuID
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT StuID FROM Student EXCEPT SELECT H.StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat'
SELECT StuID FROM Student EXCEPT SELECT DISTINCT H.StuID FROM Has_Pet H JOIN Pets P ON H.PetID  =  P.PetID WHERE P.PetType  =  'cat'
SELECT DISTINCT S.Fname, S.Age FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'dog' AND S.StuID NOT IN (SELECT H2.StuID FROM Has_Pet H2 JOIN Pets P2 ON H2.PetID = P2.PetID WHERE P2.PetType = 'cat')
SELECT Fname FROM (SELECT DISTINCT s.StuID, s.Fname FROM Student s JOIN Has_Pet hp ON s.StuID = hp.StuID JOIN Pets p ON hp.PetID = p.PetID WHERE p.PetType = 'dog') dog_owners WHERE StuID NOT IN (SELECT StuID FROM Has_Pet hp2 JOIN Pets p2 ON hp2.PetID = p2.PetID WHERE p2.PetType = 'cat')
WITH youngest_age AS (SELECT MIN(pet_age) AS min_age FROM Pets) SELECT PetType, weight FROM Pets, youngest_age WHERE pet_age = min_age
SELECT PetType, weight FROM Pets WHERE pet_age IN (SELECT MIN(pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight*1.0) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT DISTINCT S.Fname, S.Age FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID
SELECT DISTINCT PetID FROM Has_Pet H, Student S WHERE H.StuID  =  S.StuID AND S.LName  =  'Smith'
SELECT DISTINCT P.PetID FROM Pets P, Has_Pet H, Student S WHERE P.PetID = H.PetID AND H.StuID = S.StuID AND S.LName = 'Smith'
SELECT s.StuID, COUNT(h.PetID) FROM Student s, Has_Pet h WHERE s.StuID  =  h.StuID GROUP BY s.StuID
SELECT StuID ,  count(*) FROM Has_Pet GROUP BY StuID
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1)
SELECT S.Fname, S.Sex FROM Student S WHERE (SELECT COUNT(*) FROM Has_Pet WHERE StuID = S.StuID) > 1
SELECT LName FROM ((Student S JOIN Has_Pet H ON S.StuID = H.StuID) JOIN Pets P ON H.PetID = P.PetID) WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT LName FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat' AND P.pet_age = 3
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(Continent) FROM continents
SELECT count(Continent) FROM continents
SELECT c.ContId, c.Continent, count(co.CountryId) FROM continents c JOIN countries co ON c.Continent  =  co.Continent GROUP BY c.ContId, c.Continent
SELECT ContId, Continent, (SELECT count(CountryId) FROM countries c2 WHERE c2.Continent  =  continents.ContId GROUP BY c2.Continent) FROM continents
SELECT count(1) FROM countries
SELECT count(1) FROM countries
SELECT FullName, Id, (SELECT COUNT(DISTINCT Model) FROM model_list WHERE Maker  =  car_makers.Maker) FROM car_makers
SELECT Id, FullName, (SELECT COUNT(Model) FROM model_list WHERE Maker  =  car_makers.Maker) FROM car_makers
WITH min_hp AS (SELECT MIN(Horsepower) AS min_power FROM cars_data) SELECT cn.Model FROM car_names cn JOIN cars_data cd ON cn.MakeId  =  cd.Id JOIN min_hp mh ON cd.Horsepower  =  mh.min_power
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Horsepower  =  (SELECT MIN(Horsepower) FROM cars_data))
SELECT Model FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT avg(Weight) FROM cars_data))
SELECT Model FROM car_names WHERE EXISTS (SELECT 1 FROM cars_data WHERE Id  =  MakeId AND Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT Maker FROM model_list JOIN cars_data ON model_list.ModelId  =  cars_data.Id WHERE cars_data.Year  =  1970
