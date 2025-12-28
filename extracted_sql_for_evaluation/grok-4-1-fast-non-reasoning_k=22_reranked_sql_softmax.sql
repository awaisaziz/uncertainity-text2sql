SELECT count(Name) FROM singer
SELECT count(1) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY -Age
SELECT Name, Country, Age FROM singer ORDER BY -Age
SELECT min(Age), avg(Age), max(Age) FROM singer WHERE Country = 'France'
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country  =  'France'
WITH youngest AS (SELECT MIN(Age) as min_age FROM singer) SELECT Name, Song_release_year FROM singer, youngest WHERE Age = min_age
WITH youngest AS (SELECT MIN(Age) AS min_age FROM singer) SELECT Song_Name, Song_release_year FROM singer, youngest WHERE Age = min_age
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country, count(Name) FROM singer GROUP BY Country
SELECT Country, count(DISTINCT Name) FROM singer GROUP BY Country
SELECT Song_Name FROM (SELECT *, avg(Age) OVER() AS avg_age FROM singer) t WHERE Age  > avg_age
SELECT Song_Name FROM (SELECT *, avg(Age) OVER() AS avg_age FROM singer) WHERE Age > avg_age
SELECT Name ,  Location FROM stadium WHERE Capacity BETWEEN 5000 AND 10000
SELECT Location, Name FROM stadium WHERE Capacity >= 5000 AND Capacity <= 10000
SELECT max(Capacity), avg(Capacity) FROM stadium
SELECT AVG(Capacity) average, MAX(Capacity) maximum FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average IN (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average IN (SELECT MAX(Average) FROM stadium)
SELECT COUNT(*) FROM concert WHERE Year IN (2014,2015)
SELECT count(1) FROM concert WHERE Year IN (2014,2015)
SELECT Name, count(concert_ID) FROM stadium JOIN concert ON stadium.Stadium_ID  =  concert.Stadium_ID GROUP BY stadium.Stadium_ID , Name
SELECT Location, count(concert_ID) FROM stadium s LEFT JOIN concert c ON s.Stadium_ID  =  c.Stadium_ID GROUP BY s.Location, s.Name, s.Capacity
WITH stadium_concerts AS (SELECT Stadium_ID, COUNT(*) AS concerts FROM concert WHERE Year >= 2014 GROUP BY Stadium_ID), top_stadium AS (SELECT Stadium_ID FROM stadium_concerts ORDER BY concerts DESC LIMIT 1) SELECT s.Name, s.Capacity FROM stadium s, top_stadium t WHERE s.Stadium_ID = t.Stadium_ID
WITH post2013_concerts AS (SELECT * FROM concert WHERE Year > 2013) SELECT s.Name, s.Capacity FROM stadium s JOIN post2013_concerts c ON s.Stadium_ID = c.Stadium_ID GROUP BY s.Stadium_ID, s.Name, s.Capacity ORDER BY COUNT(*) DESC LIMIT 1
SELECT Year FROM concert GROUP BY Year ORDER BY count(*) DESC LIMIT 1
SELECT Year FROM concert WHERE Year IN (SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1) GROUP BY Year
SELECT s.Name FROM stadium s WHERE s.Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT s.Name FROM stadium s WHERE s.Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT Country FROM singer WHERE Age > 40 INTERSECT SELECT Country FROM singer WHERE Age < 30
SELECT Name FROM stadium EXCEPT SELECT s.Name FROM stadium s JOIN concert c ON s.Stadium_ID = c.Stadium_ID WHERE c.Year = 2014
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name, Theme, (SELECT COUNT(*) FROM singer_in_concert sic2 WHERE sic2.concert_ID  =  c.concert_ID) FROM concert c
SELECT concert_Name, Theme, (SELECT COUNT(*) FROM singer_in_concert sic2 WHERE sic2.concert_ID  =  c.concert_ID) FROM concert c
SELECT s.Name, count(sc.concert_ID) FROM singer_in_concert sc JOIN singer s ON sc.Singer_ID  =  s.Singer_ID GROUP BY s.Singer_ID, s.Name
SELECT s.Name ,  count(DISTINCT sic.concert_ID) FROM singer AS s JOIN singer_in_concert AS sic ON s.Singer_ID  =  sic.Singer_ID GROUP BY s.Singer_ID ,  s.Name
SELECT DISTINCT Name FROM singer NATURAL JOIN singer_in_concert NATURAL JOIN concert WHERE Year = 2014
SELECT s.Name FROM singer s JOIN singer_in_concert sic ON s.Singer_ID=sic.Singer_ID JOIN concert c ON sic.concert_ID=c.concert_ID WHERE c.Year=2014
SELECT Name, Country FROM singer WHERE Song_Name ~ 'Hey'
SELECT Name,Country FROM singer WHERE Song_Name ~ 'Hey'
SELECT s1.Name, s1.Location FROM stadium s1 WHERE 2014 IN (SELECT c.Year FROM concert c WHERE c.Stadium_ID = s1.Stadium_ID) AND 2015 IN (SELECT c.Year FROM concert c WHERE c.Stadium_ID = s1.Stadium_ID)
SELECT DISTINCT Location ,  Name FROM stadium s WHERE 2014 = ANY (SELECT c.Year FROM concert c WHERE c.Stadium_ID  =  s.Stadium_ID) AND 2015 = ANY (SELECT c.Year FROM concert c WHERE c.Stadium_ID  =  s.Stadium_ID)
SELECT COUNT(c.concert_ID) FROM concert c, stadium s WHERE c.Stadium_ID = s.Stadium_ID AND s.Capacity = (SELECT MAX(Capacity) FROM stadium)
SELECT COUNT(*) FROM concert C, stadium S WHERE C.Stadium_ID = S.Stadium_ID AND S.Capacity = (SELECT MAX(Capacity) FROM stadium)
SELECT count(weight) FROM Pets WHERE weight > 10
SELECT count(weight) FROM Pets WHERE weight > 10
WITH youngest_dog AS (SELECT * FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1) SELECT weight FROM youngest_dog
WITH youngest_dog AS (SELECT pet_age, MIN(weight) as min_weight FROM Pets WHERE PetType  =  'dog' GROUP BY pet_age ORDER BY pet_age ASC LIMIT 1) SELECT min_weight FROM youngest_dog
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType
SELECT PetType, max(weight) FROM Pets GROUP BY PetType
SELECT count(H.PetID) FROM Has_Pet H, Student S WHERE H.StuID = S.StuID AND S.Age > 20
SELECT COUNT(*) FROM Student S JOIN Has_Pet H ON S.StuID = H.StuID JOIN Pets P ON H.PetID = P.PetID WHERE S.Age > 20
SELECT COUNT(*) FROM Pets P, Has_Pet H, Student S WHERE P.PetID = H.PetID AND H.StuID = S.StuID AND P.PetType = 'dog' AND S.Sex = 'F'
SELECT count(*) FROM Student S1, Has_Pet H1, Pets P1 WHERE S1.StuID  =  H1.StuID AND H1.PetID  =  P1.PetID AND S1.Sex  =  'F' AND P1.PetType  =  'dog'
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT COUNT(DISTINCT PetType) FROM Pets
SELECT DISTINCT Fname FROM Student, Has_Pet H, Pets P WHERE Student.StuID=H.StuID AND H.PetID=P.PetID AND (P.PetType='cat' OR P.PetType='dog')
WITH pet_owners AS (SELECT DISTINCT StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE PetType IN ('cat','dog')) SELECT Fname FROM Student S JOIN pet_owners PO ON S.StuID = PO.StuID
SELECT DISTINCT S.Fname FROM Student S JOIN Has_Pet H1 ON S.StuID = H1.StuID JOIN Pets P1 ON H1.PetID = P1.PetID JOIN Has_Pet H2 ON S.StuID = H2.StuID JOIN Pets P2 ON H2.PetID = P2.PetID WHERE P1.PetType = 'cat' AND P2.PetType = 'dog'
WITH BothPets AS (SELECT H.StuID, COUNT(DISTINCT P.PetType) as pet_count FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType IN ('cat','dog') GROUP BY H.StuID HAVING pet_count = 2) SELECT Fname FROM Student S JOIN BothPets B ON S.StuID = B.StuID
SELECT Major, Age FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT Major, Age FROM Student s WHERE StuID NOT IN (SELECT h.StuID FROM Has_Pet h WHERE h.PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT StuID FROM Student EXCEPT SELECT H.StuID FROM Has_Pet H JOIN Pets P ON H.PetID = P.PetID WHERE P.PetType = 'cat'
SELECT Fname, Age FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog' MINUS SELECT Fname, Age FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat'
WITH DogOwners AS (SELECT DISTINCT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'dog'), CatOwners AS (SELECT DISTINCT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat') SELECT Fname FROM Student JOIN DogOwners ON Student.StuID = DogOwners.StuID LEFT JOIN CatOwners ON Student.StuID = CatOwners.StuID WHERE CatOwners.StuID IS NULL
WITH youngest_age AS (SELECT pet_age FROM Pets ORDER BY pet_age LIMIT 1) SELECT PetType, weight FROM Pets, youngest_age WHERE pet_age = youngest_age.pet_age
WITH youngest AS (SELECT MIN(pet_age) min_age FROM Pets) SELECT PetType,weight FROM Pets p,youngest y WHERE p.pet_age=y.min_age
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetID, weight FROM Pets WHERE pet_age > 1
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType
SELECT PetType ,  avg(pet_age) ,  max(pet_age) FROM Pets GROUP BY PetType
SELECT PetType,avg(weight) FROM Pets GROUP BY PetType ORDER BY avg(weight)
SELECT PetType, avg(weight) FROM Pets GROUP BY PetType
SELECT Fname, Age FROM Student S, Has_Pet H WHERE S.StuID = H.StuID
SELECT S.Fname, S.Age FROM Student S, Has_Pet H WHERE S.StuID = H.StuID
SELECT h.PetID FROM Has_Pet h JOIN Student s ON h.StuID = s.StuID WHERE s.LName = 'Smith'
SELECT PetID FROM ((Student S JOIN Has_Pet H ON S.StuID = H.StuID) JOIN Pets P ON P.PetID = H.PetID) WHERE S.LName = 'Smith'
SELECT Student.StuID, COUNT(Has_Pet.PetID) FROM Has_Pet JOIN Student ON Has_Pet.StuID = Student.StuID GROUP BY Student.StuID
SELECT StuID, count(*) FROM Has_Pet JOIN Student ON Has_Pet.StuID  =  Student.StuID GROUP BY StuID
WITH multi_pet_students AS (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING count(*) > 1) SELECT Fname ,  Sex FROM Student WHERE StuID IN (SELECT StuID FROM multi_pet_students)
WITH multi_pet_students AS (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1) SELECT Fname, Sex FROM Student S JOIN multi_pet_students M ON S.StuID = M.StuID
SELECT LName FROM Student, Has_Pet, Pets WHERE Student.StuID = Has_Pet.StuID AND Has_Pet.PetID = Pets.PetID AND Pets.PetType = 'cat' AND Pets.pet_age = 3
SELECT LName FROM Student S, Has_Pet H, Pets P WHERE S.StuID = H.StuID AND H.PetID = P.PetID AND P.PetType = 'cat' AND P.pet_age = 3
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT S.StuID FROM Has_Pet S)
SELECT count(DISTINCT Continent) FROM continents
SELECT count(Continent) FROM continents
SELECT ContId, Continent, count(co.CountryId) FROM continents, countries co WHERE continents.ContId  =  co.Continent GROUP BY ContId, Continent
SELECT continents.ContId, continents.Continent, count(countries.CountryId) FROM continents, countries WHERE continents.Continent  =  countries.Continent GROUP BY continents.ContId, continents.Continent
SELECT count(1) FROM countries
SELECT count(1) FROM countries
SELECT FullName ,  Id ,  (SELECT COUNT(*) FROM model_list WHERE Maker  =  car_makers.Maker) FROM car_makers
SELECT Maker AS Id, FullName, COUNT(Model) FROM car_makers JOIN model_list ON Maker  =  Maker GROUP BY Maker, FullName
SELECT ml.Model FROM model_list ml INNER JOIN car_makers cm ON ml.Maker=cm.Maker WHERE ml.ModelId=(SELECT MIN(Id) FROM cars_data ORDER BY Horsepower)
SELECT Model FROM (SELECT ml.Model, MIN(cd.Horsepower) min_hp FROM model_list ml JOIN car_names cn ON ml.Model=cn.Model JOIN cars_data cd ON cn.MakeId=cd.Id JOIN car_makers cm ON ml.Maker=cm.Maker, countries c WHERE cm.Country=c.CountryName GROUP BY ml.Model) ORDER BY min_hp LIMIT 1
SELECT DISTINCT Model FROM car_names cn WHERE cn.MakeId = (SELECT MIN(Id) FROM cars_data WHERE Weight < (SELECT AVG(Weight) FROM cars_data))
WITH light_cars AS (SELECT Country FROM cars_data WHERE Weight<(SELECT AVG(Weight) FROM cars_data)) SELECT DISTINCT Model FROM model_list ml JOIN car_makers cm ON ml.Maker=cm.Maker JOIN light_cars lc ON cm.Country=lc.Country
SELECT DISTINCT car_makers.Maker FROM car_makers JOIN cars_data ON car_makers.Country  =  cars_data.Country WHERE cars_data.Year  =  1970
