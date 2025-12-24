SELECT count(*) FROM singer
SELECT count(*) FROM singer
SELECT Name, Country, Age FROM singer ORDER BY Age DESC
SELECT Name ,  Country ,  Age FROM singer ORDER BY Age DESC
SELECT avg(Age), min(Age), max(Age) FROM singer WHERE Country = 'France'
SELECT avg(Age) ,  min(Age) ,  max(Age) FROM singer WHERE Country  =  'French'
SELECT T1.Song_Name ,  T1.Song_release_year FROM singer AS T1 WHERE T1.Age  =  (SELECT min(Age) FROM singer)
SELECT T1.Song_Name ,  T1.Song_release_year FROM singer AS T1 WHERE T1.Age = (SELECT min(Age) FROM singer GROUP BY Age ORDER BY Age LIMIT 1)
SELECT DISTINCT Country FROM singer WHERE Age > 20
SELECT Country FROM singer WHERE Age > 20 GROUP BY Country
SELECT Country ,  count(*) FROM singer WHERE Country = Country GROUP BY Country
SELECT Country ,  count(*) FROM singer WHERE Country IN (SELECT DISTINCT Country FROM singer) GROUP BY Country
SELECT T1.Song_Name FROM singer AS T1 WHERE T1.Age > (SELECT avg(Age) FROM singer GROUP BY (SELECT 1))
SELECT T1.Song_Name FROM singer AS T1 WHERE T1.Age > (SELECT avg(T2.Age) FROM singer AS T2)
SELECT Location, Name FROM stadium WHERE Capacity >= 5000 AND Capacity <= 10000
SELECT Location, Name FROM stadium WHERE Capacity >= 5000 AND Capacity <= 10000
SELECT max(Capacity) ,  avg(Capacity) FROM stadium
SELECT avg(Capacity), max(Capacity) FROM stadium
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium)
SELECT count(*) FROM concert WHERE Year IN (2014, 2015)
SELECT count(*) FROM concert WHERE Year IN (2014, 2015)
SELECT T1.Name ,  count(*) FROM stadium AS T1 JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID GROUP BY T1.Name ,  T1.Stadium_ID
SELECT T1.Stadium_ID ,  T1.Location ,  T1.Name ,  T1.Capacity ,  T1.Highest ,  T1.Lowest ,  T1.Average ,  count(T2.Stadium_ID) FROM stadium AS T1 LEFT JOIN concert AS T2 ON T1.Stadium_ID  =  T2.Stadium_ID GROUP BY T1.Stadium_ID ,  T1.Location ,  T1.Name ,  T1.Capacity ,  T1.Highest ,  T1.Lowest ,  T1.Average
SELECT T1.Name ,  T1.Capacity FROM stadium AS T1 WHERE T1.Stadium_ID  =  ( SELECT T2.Stadium_ID FROM  ( SELECT Stadium_ID ,  count(*) AS cnt FROM concert WHERE Year  >=  2014 GROUP BY Stadium_ID ) AS T2 ORDER BY T2.cnt DESC LIMIT 1 )
SELECT T1.Name, T1.Capacity FROM stadium AS T1 WHERE T1.Stadium_ID = (SELECT T2.Stadium_ID FROM (SELECT Stadium_ID, count(*) FROM concert WHERE Year > 2013 GROUP BY Stadium_ID ORDER BY count(*) DESC LIMIT 1) AS T2)
SELECT Year FROM concert GROUP BY Year HAVING count(*) = (SELECT max(cnt) FROM (SELECT Year, count(*) AS cnt FROM concert GROUP BY Year) AS T1)
SELECT Year FROM concert GROUP BY Year HAVING count(*)  =  (SELECT cnt FROM (SELECT count(*) AS cnt FROM concert GROUP BY Year ORDER BY cnt DESC LIMIT 1) AS T1)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT DISTINCT Country FROM singer WHERE Age > 40 AND Country IN (SELECT Country FROM singer WHERE Age < 30)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert_Name ,  Theme ,  (SELECT count(Singer_ID) FROM singer_in_concert WHERE concert_ID  =  concert.concert_ID) FROM concert
SELECT concert_Name , Theme , (SELECT count(Singer_ID) FROM singer_in_concert WHERE concert_ID = concert.concert_ID) FROM concert
SELECT T1.Name ,  COUNT(T2.concert_ID) FROM singer_in_concert AS T2 JOIN singer AS T1 ON T2.Singer_ID  =  T1.Singer_ID GROUP BY T1.Singer_ID ,  T1.Name
SELECT T1.Name ,  count(T2.concert_ID) FROM singer_in_concert AS T2 JOIN singer AS T1 ON T2.Singer_ID  =  T1.Singer_ID GROUP BY T1.Name
SELECT T1.Name FROM singer AS T1, singer_in_concert AS T2, concert AS T3 WHERE T1.Singer_ID = T2.Singer_ID AND T2.concert_ID = T3.concert_ID AND T3.Year = 2014
SELECT T1.Name FROM singer AS T1, singer_in_concert AS T2, concert AS T3 WHERE T1.Singer_ID = T2.Singer_ID AND T2.concert_ID = T3.concert_ID AND T3.Year = 2014 GROUP BY T1.Name
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%' OR Song_Name LIKE '%Hey %' OR Song_Name LIKE '% Hey%'
SELECT Name ,  Country FROM singer WHERE Song_Name LIKE '%Hey%'
SELECT T1.Name ,  T1.Location FROM stadium AS T1 WHERE T1.Stadium_ID IN (SELECT T2.Stadium_ID FROM concert AS T2 WHERE T2.Year  =  2014) AND T1.Stadium_ID IN (SELECT T2.Stadium_ID FROM concert AS T2 WHERE T2.Year  =  2015)
SELECT T1.Name ,  T1.Location FROM stadium AS T1 WHERE T1.Stadium_ID IN (SELECT T2.Stadium_ID FROM concert AS T2 WHERE T2.Year  =  2014) AND T1.Stadium_ID IN (SELECT T2.Stadium_ID FROM concert AS T2 WHERE T2.Year  =  2015)
SELECT count(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium WHERE Capacity = (SELECT max(Capacity) FROM stadium) LIMIT 1)
SELECT count(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium WHERE Capacity = (SELECT max(Capacity) FROM stadium) LIMIT 1)
SELECT count(*) FROM Pets WHERE weight > 10
SELECT count(*) FROM Pets WHERE weight > 10
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT pet_age FROM Pets WHERE PetType = 'dog' ORDER BY pet_age LIMIT 1)
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age LIMIT 1
SELECT PetType, weight FROM Pets P1 WHERE weight = (SELECT MAX(weight) FROM Pets P2 WHERE P2.PetType = P1.PetType)
SELECT PetType, max(weight) FROM Pets GROUP BY PetType
SELECT count(*) FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE Age > 20)
SELECT count(*) FROM Has_Pet WHERE StuID IN (SELECT StuID FROM Student WHERE Age > 20)
SELECT count(*) FROM Pets AS T1 JOIN Has_Pet AS T2 ON T1.PetID = T2.PetID JOIN Student AS T3 ON T2.StuID = T3.StuID WHERE T1.PetType = 'dog' AND T3.Sex = 'F'
SELECT COUNT(*) FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' AND Student.Sex = 'F'
SELECT count(*) FROM (SELECT DISTINCT PetType FROM Pets) AS T1
SELECT count(*) FROM (SELECT DISTINCT PetType FROM Pets) AS T1
SELECT T1.Fname FROM Student AS T1, Has_Pet AS T2, Pets AS T3 WHERE T1.StuID = T2.StuID AND T2.PetID = T3.PetID AND (T3.PetType = 'cat' OR T3.PetType = 'dog')
SELECT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID WHERE T2.PetID IN (SELECT T3.PetID FROM Pets AS T3 WHERE T3.PetType = 'cat' OR T3.PetType = 'dog')
SELECT T1.Fname FROM Student AS T1 WHERE 2 = (SELECT COUNT(DISTINCT T3.PetType) FROM Has_Pet AS T2 JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T2.StuID = T1.StuID AND T3.PetType IN ('cat', 'dog'))
SELECT T1.Fname FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID = T2.StuID JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'cat' AND T1.StuID IN (SELECT T2.StuID FROM Has_Pet AS T2 JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'dog')
SELECT T1.Major ,  T1.Age FROM Student AS T1 WHERE T1.StuID NOT IN (SELECT T2.StuID FROM Has_Pet AS T2 ,  Pets AS T3 WHERE T2.PetID  =  T3.PetID AND T3.PetType  =  'cat')
SELECT T1.Major ,  T1.Age FROM Student AS T1 WHERE T1.StuID NOT IN (SELECT T2.StuID FROM Has_Pet AS T2 , Pets AS T3 WHERE T2.PetID  =  T3.PetID AND T3.PetType  =  'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE PetType = 'cat')
SELECT StuID FROM Student WHERE StuID NOT IN (SELECT DISTINCT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat'))
SELECT T1.Fname, T1.Age FROM Student AS T1 WHERE T1.StuID IN (SELECT T2.StuID FROM Has_Pet AS T2 JOIN Pets AS T3 ON T2.PetID = T3.PetID WHERE T3.PetType = 'dog' AND T2.StuID NOT IN (SELECT T4.StuID FROM Has_Pet AS T4 JOIN Pets AS T5 ON T4.PetID = T5.PetID WHERE T5.PetType = 'cat'))
SELECT T1.Fname FROM Student AS T1 WHERE T1.StuID IN (SELECT T2.StuID FROM Has_Pet AS T2 WHERE T2.PetID IN (SELECT T3.PetID FROM Pets AS T3 WHERE T3.PetType = 'dog')) AND T1.StuID NOT IN (SELECT T4.StuID FROM Has_Pet AS T4 WHERE T4.PetID IN (SELECT T5.PetID FROM Pets AS T5 WHERE T5.PetType = 'cat'))
SELECT PetType, weight FROM Pets WHERE pet_age = (SELECT min(pet_age) FROM Pets)
SELECT PetType ,  weight FROM Pets ORDER BY pet_age LIMIT 1
SELECT Pets.PetID, Pets.weight FROM Pets WHERE Pets.pet_age > 1
SELECT Pets.PetID, Pets.weight FROM Pets WHERE Pets.pet_age > 1
SELECT PetType, avg(pet_age), max(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, avg(pet_age), max(pet_age) FROM Pets GROUP BY PetType
SELECT PetType, avg(weight) FROM Pets GROUP BY 1
SELECT PetType ,  avg(weight) FROM Pets GROUP BY 1
SELECT T1.Fname ,  T1.Age FROM Student AS T1 ,  Has_Pet AS T2 WHERE T1.StuID  =  T2.StuID
SELECT DISTINCT T1.Fname ,  T1.Age FROM Student AS T1 ,  Has_Pet AS T2 WHERE T1.StuID  =  T2.StuID
SELECT T1.PetID FROM Has_Pet AS T1, Student AS T2 WHERE T1.StuID = T2.StuID AND T2.LName = 'Smith'
SELECT T2.PetID FROM Student AS T1, Has_Pet AS T2 WHERE T1.StuID = T2.StuID AND T1.LName = 'Smith'
SELECT T1.StuID ,  COUNT(T2.PetID) FROM Student AS T1 ,  Has_Pet AS T2 WHERE T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT T1.StuID ,  count(*) FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID
SELECT T1.Fname ,  T1.Sex FROM Student AS T1 WHERE T1.StuID IN (SELECT T2.StuID FROM Has_Pet AS T2 GROUP BY T2.StuID HAVING count(*)  >  1)
SELECT T1.Fname ,  T1.Sex FROM Student AS T1 JOIN Has_Pet AS T2 ON T1.StuID  =  T2.StuID GROUP BY T1.StuID ,  T1.Fname ,  T1.Sex HAVING count(*)  >  1
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT LName FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' AND pet_age = 3))
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT Has_Pet.StuID FROM Has_Pet)
SELECT avg(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT count(DISTINCT Continent) FROM continents
SELECT count(Continent) FROM continents
SELECT ContId ,  Continent ,  (SELECT count(CountryId) FROM countries WHERE Continent  =  T1.Continent) FROM continents AS T1
SELECT ContId ,  Continent ,  (SELECT count(CountryId) FROM countries WHERE Continent  =  continents.Continent) FROM continents
SELECT count(*) FROM countries
SELECT count(*) FROM (SELECT CountryName FROM countries GROUP BY CountryName) T1
SELECT T1.FullName ,  T1.Id ,  count(*) FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id  =  T2.Maker GROUP BY T1.FullName ,  T1.Id
SELECT T1.Id ,  T1.FullName ,  count(T2.ModelId) FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id  =  T2.Maker GROUP BY T1.Id ,  T1.FullName
SELECT T1.Model FROM model_list AS T1 JOIN cars_data AS T2 ON T1.ModelId  =  T2.Id WHERE T2.Horsepower  =  (SELECT min(Horsepower) FROM cars_data)
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model JOIN cars_data AS T3 ON T2.MakeId = T3.Id WHERE T3.Horsepower = (SELECT min(Horsepower) FROM cars_data)
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model  =  T2.Model JOIN cars_data AS T3 ON T2.MakeId  =  T3.Id WHERE T3.Weight < (SELECT avg(Weight) FROM cars_data)
SELECT T1.Model FROM model_list AS T1 JOIN car_names AS T2 ON T1.Model = T2.Model JOIN cars_data AS T3 ON T2.MakeId = T3.Id WHERE T3.Weight < (SELECT avg(Weight) FROM cars_data)
SELECT DISTINCT T1.Maker FROM car_makers AS T1 JOIN model_list AS T2 ON T1.Id = T2.Maker JOIN car_names AS T3 ON T2.Model = T3.Model WHERE T3.MakeId IN (SELECT Id FROM cars_data WHERE Year = 1970)
