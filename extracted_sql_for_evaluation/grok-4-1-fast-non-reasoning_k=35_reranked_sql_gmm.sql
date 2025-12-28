SELECT count(1) FROM singer
SELECT COUNT(1) FROM singer
SELECT Name ,  Country ,  Age FROM singer ORDER BY -Age
SELECT Name ,  Country ,  Age FROM singer ORDER BY Age DESCENDING
SELECT min(Age), avg(Age), max(Age) FROM singer WHERE Country  =  'France'
SELECT avg(singer.Age), min(singer.Age), max(singer.Age) FROM singer WHERE singer.Country  =  'France'
WITH youngest AS (SELECT MIN(Age) min_age FROM singer) SELECT Name,Song_release_year FROM singer,youngest WHERE Age=min_age
SELECT Song_Name, Song_release_year FROM singer WHERE Age IN (SELECT MIN(Age) FROM singer)
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country,COUNT(*) FROM singer GROUP BY Country ORDER BY Country
SELECT Country, count(Name) FROM singer GROUP BY Country
SELECT Song_Name FROM singer WHERE Age > AVG(Age) OVER()
SELECT Song_Name FROM singer WHERE Age > SOME (SELECT AVG(Age) FROM singer)
SELECT Location,Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Name, Location FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average IN (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium HAVING Average = MAX(Average)
SELECT COUNT(1) FROM concert WHERE Year IN (2014,2015)
SELECT count(1) FROM concert WHERE Year IN (2014,2015)
SELECT Name, count(concert_ID) FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID GROUP BY stadium.Stadium_ID , Name
SELECT Location, (SELECT count(concert_ID) FROM concert WHERE Stadium_ID  =  stadium.Stadium_ID) FROM stadium
SELECT * FROM (SELECT Name, Capacity, COUNT(*) as concert_count FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID WHERE concert.Year >= 2014 GROUP BY Stadium_ID, Name, Capacity ORDER BY concert_count DESC LIMIT 1)
WITH concerts_after_2013 AS (SELECT Stadium_ID, COUNT(*) AS cnt FROM concert WHERE Year > 2013 GROUP BY Stadium_ID), top_stadium AS (SELECT Stadium_ID FROM concerts_after_2013 ORDER BY cnt DESC LIMIT 1) SELECT s.Name, s.Capacity FROM stadium s JOIN top_stadium ts ON s.Stadium_ID = ts.Stadium_ID
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert WHERE Year IN (SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1)
SELECT Name FROM stadium WHERE NOT (Stadium_ID IN (SELECT Stadium_ID FROM concert))
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT Country FROM singer WHERE Age > 40 AND Country IN (SELECT Country FROM singer WHERE Age < 30)
SELECT Name FROM stadium EXCEPT SELECT s.Name FROM stadium s JOIN concert c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = 2014
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year=2014)
SELECT DISTINCT concert_Name, Theme FROM concert, singer_in_concert
SELECT concert_Name, Theme, (SELECT COUNT(1) FROM singer_in_concert WHERE concert_ID  =  c.concert_ID) FROM concert c
SELECT s.Name, count(sic.concert_ID) FROM singer_in_concert sic JOIN singer s ON sic.Singer_ID  =  s.Singer_ID GROUP BY s.Singer_ID, s.Name
SELECT Name ,  (SELECT count(concert_ID) FROM singer_in_concert WHERE Singer_ID  =  s.Singer_ID) FROM singer s
SELECT Name FROM singer s, singer_in_concert sic, concert c WHERE s.Singer_ID=sic.Singer_ID AND sic.concert_ID=c.concert_ID AND c.Year=2014
WITH concerts14 AS (SELECT * FROM concert WHERE Year=2014) SELECT DISTINCT s.Name FROM singer s JOIN singer_in_concert sic ON s.Singer_ID=sic.Singer_ID JOIN concerts14 c ON sic.concert_ID=c.concert_ID
SELECT Name, Country FROM singer WHERE Song_Name ~* 'hey'
SELECT Name, Country FROM singer WHERE Song_Name ~* 'hey'
SELECT DISTINCT s.Name ,  s.Location FROM stadium s JOIN concert c1 ON s.Stadium_ID  =  c1.Stadium_ID JOIN concert c2 ON s.Stadium_ID  =  c2.Stadium_ID WHERE c1.Year=2014 AND c2.Year=2015
SELECT DISTINCT s.Name, s.Location FROM stadium s JOIN concert c1 ON s.Stadium_ID = c1.Stadium_ID JOIN concert c2 ON s.Stadium_ID = c2.Stadium_ID WHERE c1.Year = 2014 AND c2.Year = 2015
WITH highest_capacity AS (SELECT MAX(Capacity) max_cap FROM stadium) SELECT COUNT(*) FROM concert C JOIN stadium S ON C.Stadium_ID = S.Stadium_ID JOIN highest_capacity H ON S.Capacity = H.max_cap
WITH largest_capacity AS (SELECT MAX(Capacity) max_cap FROM stadium) SELECT COUNT(*) FROM concert c JOIN stadium s ON c.Stadium_ID = s.Stadium_ID, largest_capacity l WHERE s.Capacity = l.max_cap
SELECT count(1) FROM Pets WHERE weight > 10
SELECT count(weight) FROM Pets WHERE weight > 10
SELECT weight FROM (SELECT pet_age,weight FROM Pets WHERE PetType='dog') AS T1 WHERE pet_age=MIN(pet_age)
WITH youngest_dog_age AS (SELECT MIN(pet_age) AS min_age FROM Pets WHERE PetType='dog') SELECT weight FROM Pets, youngest_dog_age WHERE PetType='dog' AND pet_age=min_age
SELECT PetType, max(weight) FROM Pets GROUP BY ALL
SELECT PetType, max(weight) FROM Pets GROUP BY ALL
SELECT COUNT(P.PetID) FROM Pets P, Has_Pet H, Student S WHERE P.PetID = H.PetID AND H.StuID = S.StuID AND S.Age > 20
SELECT COUNT(H.*) FROM Has_Pet H INNER JOIN Student S ON H.StuID = S.StuID WHERE S.Age > 20
SELECT count(P.PetID) FROM Pets P, Has_Pet H, Student S WHERE P.PetType = 'dog' AND P.PetID = H.PetID AND H.StuID = S.StuID AND S.Sex = 'F'
WITH FemaleDogOwners AS (SELECT H1.PetID FROM Has_Pet H1 JOIN Student S1 ON H1.StuID  =  S1.StuID JOIN Pets P1 ON H1.PetID  =  P1.PetID WHERE S1.Sex  =  'F' AND P1.PetType  =  'dog') SELECT COUNT(*) FROM FemaleDogOwners
SELECT count(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT Fname FROM Student MATCH (SELECT H.StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType IN ('cat','dog')) ON StuID
SELECT Fname FROM (SELECT DISTINCT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE PetType IN ('cat','dog')) T1 JOIN Student S ON T1.StuID = S.StuID
SELECT DISTINCT S.Fname FROM Student S JOIN Has_Pet H1 ON S.StuID = H1.StuID JOIN Pets P1 ON H1.PetID = P1.PetID JOIN Has_Pet H2 ON S.StuID = H2.StuID JOIN Pets P2 ON H2.PetID = P2.PetID WHERE P1.PetType = 'cat' AND P2.PetType = 'dog'
SELECT DISTINCT Fname FROM Student S1, Has_Pet HP1, Pets P1, Has_Pet HP2, Pets P2 WHERE S1.StuID=HP1.StuID AND HP1.PetID=P1.PetID AND P1.PetType='cat' AND S1.StuID=HP2.StuID AND HP2.PetID=P2.PetID AND P2.PetType='dog'
SELECT Major, Age FROM Student MINUS SELECT s.Major, s.Age FROM Student s, Has_Pet h, Pets p WHERE s.StuID = h.StuID AND h.PetID = p.PetID AND p.PetType = 'cat'
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT DISTINCT H.StuID FROM Has_Pet H, Pets P WHERE H.PetID = P.PetID AND P.PetType = 'cat')
SELECT StuID FROM Student EXCEPT SELECT H.StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat'
SELECT S.Fname, S.Age FROM Student S WHERE StuID IN (SELECT DISTINCT H.StuID FROM Has_Pet H, Pets P WHERE H.PetID = P.PetID AND P.PetType = 'dog') MINUS SELECT S2.Fname, S2.Age FROM Student S2 WHERE S2.StuID IN (SELECT DISTINCT H2.StuID FROM Has_Pet H2, Pets P2 WHERE H2.PetID = P2.PetID AND P2.PetType = 'cat')
WITH DogOwners AS (SELECT DISTINCT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog'), CatOwners AS (SELECT DISTINCT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat') SELECT Fname FROM Student JOIN DogOwners ON Student.StuID = DogOwners.StuID LEFT JOIN CatOwners ON Student.StuID = CatOwners.StuID WHERE CatOwners.StuID IS NULL
SELECT PetType, weight FROM Pets QUALIFY pet_age = MIN(pet_age) OVER ()
WITH youngest AS (SELECT MIN(pet_age) AS min_age FROM Pets) SELECT PetType, weight FROM Pets, youngest WHERE pet_age = min_age
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType ,  avg(weight*1.0) FROM Pets GROUP BY PetType
SELECT PetType, AVG(weight) FROM Pets GROUP BY ALL
SELECT S.Fname, S.Age FROM Student S NATURAL JOIN Has_Pet
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT PetID FROM Pets P, Has_Pet H, Student S WHERE P.PetID = H.PetID AND H.StuID = S.StuID AND S.LName = 'Smith'
SELECT H.PetID FROM Student S, Has_Pet H WHERE S.LName = 'Smith' AND S.StuID = H.StuID
SELECT h.StuID, COUNT(*) FROM Has_Pet h INNER JOIN Student s ON h.StuID = s.StuID GROUP BY h.StuID
SELECT s.StuID, COUNT(*) FROM Student s INNER JOIN Has_Pet h ON s.StuID = h.StuID GROUP BY s.StuID
SELECT Fname, Sex FROM Student WHERE (SELECT COUNT(*) FROM Has_Pet WHERE StuID = Student.StuID) > 1
WITH MultiPetStudents AS (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1) SELECT Fname, Sex FROM Student JOIN MultiPetStudents ON Student.StuID = MultiPetStudents.StuID
SELECT LName FROM Student S, (SELECT PetID FROM Pets WHERE PetType='cat' AND pet_age=3) p, Has_Pet H WHERE S.StuID=H.StuID AND H.PetID=p.PetID
SELECT LName FROM Student S, (SELECT H.StuID, P.PetType FROM Has_Pet H, Pets P WHERE H.PetID = P.PetID AND P.PetType = 'cat' AND P.pet_age = 3) T WHERE S.StuID = T.StuID
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(Continent) FROM continents
SELECT count(Continent) FROM continents
SELECT ContId, Continent, (SELECT COUNT(*) FROM (SELECT CountryId FROM countries WHERE Continent  =  continents.Continent) x) FROM continents
SELECT continents.ContId, continents.Continent, COUNT(countries.CountryId) FROM continents, countries WHERE continents.ContId = countries.Continent GROUP BY continents.ContId, continents.Continent
SELECT count(1) FROM countries
SELECT COUNT(1) FROM countries
SELECT FullName ,  Id ,  (SELECT count(Model) FROM model_list WHERE Maker  =  car_makers.Maker) FROM car_makers
SELECT cm.Id, cm.FullName, COUNT(DISTINCT ml.ModelId) FROM car_makers cm JOIN model_list ml ON cm.Maker  =  ml.Maker GROUP BY cm.Id, cm.FullName
SELECT Model FROM car_names WHERE MakeId = (SELECT Id FROM cars_data WHERE Horsepower = (SELECT MIN(Horsepower) FROM cars_data) LIMIT 1)
SELECT * FROM (SELECT Model FROM car_names ORDER BY (SELECT MIN(Horsepower) FROM cars_data WHERE Id = MakeId) LIMIT 1) t
SELECT Model FROM (SELECT * FROM car_names WHERE MakeId IN (SELECT Id FROM cars_data WHERE Weight < (SELECT AVG(Weight) FROM cars_data)))
SELECT Model FROM car_names WHERE EXISTS (SELECT 1 FROM cars_data WHERE Id = car_names.MakeId AND Weight < (SELECT AVG(Weight) FROM cars_data))
SELECT DISTINCT Maker FROM car_makers, model_list, cars_data WHERE car_makers.Id  =  model_list.Maker AND model_list.ModelId  =  cars_data.Id AND cars_data.Year  =  1970
