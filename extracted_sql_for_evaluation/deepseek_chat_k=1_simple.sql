SELECT COUNT(*) FROM singer;
SELECT COUNT(*) FROM singer;
SELECT Name, Country, Age FROM singer ORDER BY Age DESC;
SELECT Name, Country, Age FROM singer ORDER BY Age DESC;
SELECT AVG(Age), MIN(Age), MAX(Age) FROM singer WHERE Country = 'France';
SELECT AVG(Age), MIN(Age), MAX(Age) FROM singer WHERE Country = 'France';
SELECT singer.Song_Name, singer.Song_release_year FROM singer WHERE singer.Age = (SELECT MIN(singer.Age) FROM singer)
SELECT singer.Song_Name, singer.Song_release_year FROM singer WHERE singer.Age = (SELECT MIN(singer.Age) FROM singer)
SELECT DISTINCT Country FROM singer WHERE Age > 20;
SELECT DISTINCT Country FROM singer WHERE Age > 20;
SELECT Country, COUNT(Singer_ID) FROM singer GROUP BY Country;
SELECT Country, COUNT(Singer_ID) FROM singer GROUP BY Country;
SELECT DISTINCT singer.Song_Name FROM singer WHERE singer.Age > (SELECT AVG(singer.Age) FROM singer);
SELECT DISTINCT singer.Song_Name FROM singer WHERE singer.Age > (SELECT AVG(singer.Age) FROM singer)
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000;
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000;
SELECT MAX(Capacity), AVG(Capacity) FROM stadium;
SELECT AVG(Capacity), MAX(Capacity) FROM stadium;
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium);
SELECT Name, Capacity FROM stadium WHERE Average = (SELECT MAX(Average) FROM stadium);
SELECT COUNT(*) FROM concert WHERE Year = 2014 OR Year = 2015;
SELECT COUNT(*) FROM concert WHERE Year = 2014 OR Year = 2015;
SELECT stadium.Name, COUNT(concert.concert_ID) FROM stadium LEFT JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Stadium_ID, stadium.Name;
SELECT stadium.Stadium_ID, COUNT(concert.concert_ID) FROM stadium LEFT JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Stadium_ID;
SELECT stadium.Name, stadium.Capacity FROM stadium INNER JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID WHERE concert.Year >= 2014 GROUP BY stadium.Stadium_ID ORDER BY COUNT(concert.concert_ID) DESC LIMIT 1;
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = ( SELECT Stadium_ID FROM concert WHERE Year > 2013 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1 );
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1;
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1;
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert);
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert)
SELECT DISTINCT Country FROM singer WHERE Age > 40 INTERSECT SELECT DISTINCT Country FROM singer WHERE Age < 30;
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert WHERE Year = 2014)
SELECT concert.concert_Name, concert.Theme, COUNT(singer_in_concert.Singer_ID) FROM concert LEFT JOIN singer_in_concert ON concert.concert_ID = singer_in_concert.concert_ID GROUP BY concert.concert_ID, concert.concert_Name, concert.Theme;
SELECT concert.concert_Name, concert.Theme, COUNT(singer_in_concert.Singer_ID) FROM concert LEFT JOIN singer_in_concert ON concert.concert_ID = singer_in_concert.concert_ID GROUP BY concert.concert_ID, concert.concert_Name, concert.Theme;
SELECT singer.Name, COUNT(singer_in_concert.concert_ID) FROM singer LEFT JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID GROUP BY singer.Singer_ID, singer.Name;
SELECT singer.Name, COUNT(singer_in_concert.concert_ID) FROM singer LEFT JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID GROUP BY singer.Singer_ID, singer.Name
SELECT singer.Name FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID JOIN concert ON singer_in_concert.concert_ID = concert.concert_ID WHERE concert.Year = 2014;
SELECT singer.Name FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID JOIN concert ON singer_in_concert.concert_ID = concert.concert_ID WHERE concert.Year = 2014;
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%';
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%';
SELECT Name, Location FROM stadium WHERE Stadium_ID IN (SELECT Stadium_ID FROM concert WHERE Year = 2014) AND Stadium_ID IN (SELECT Stadium_ID FROM concert WHERE Year = 2015);
SELECT Name, Location FROM stadium WHERE Stadium_ID IN ( SELECT Stadium_ID FROM concert WHERE Year = 2014 INTERSECT SELECT Stadium_ID FROM concert WHERE Year = 2015 )
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1);
SELECT COUNT(*) FROM concert WHERE Stadium_ID = (SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1);
SELECT COUNT(*) FROM Pets WHERE weight > 10;
SELECT COUNT(*) FROM Pets WHERE weight > 10;
SELECT weight FROM Pets WHERE PetType = 'dog' AND pet_age = (SELECT MIN(pet_age) FROM Pets WHERE PetType = 'dog')
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1;
SELECT MAX(weight), PetType FROM Pets GROUP BY PetType;
SELECT Pets.PetType, MAX(Pets.weight) FROM Pets GROUP BY Pets.PetType
SELECT COUNT(Has_Pet.PetID) FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID WHERE Student.Age > 20;
SELECT COUNT(Pets.PetID) FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID INNER JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.Age > 20;
SELECT COUNT(Pets.PetID) FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.Sex = 'F' AND Pets.PetType = 'dog';
SELECT COUNT(*) FROM Has_Pet INNER JOIN Student ON Has_Pet.StuID = Student.StuID INNER JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.Sex = 'F' AND Pets.PetType = 'dog';
SELECT COUNT(DISTINCT PetType) FROM Pets;
SELECT COUNT(DISTINCT PetType) FROM Pets;
SELECT Fname FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet WHERE PetID IN (SELECT PetID FROM Pets WHERE PetType = 'cat' OR PetType = 'dog'))
SELECT DISTINCT Student.Fname FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID INNER JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType IN ('cat', 'dog');
SELECT Student.Fname FROM Student WHERE Student.StuID IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' ) AND Student.StuID IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' );
SELECT Student.Fname FROM Student WHERE Student.StuID IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' ) AND Student.StuID IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' );
SELECT Student.Major, Student.Age FROM Student WHERE Student.StuID NOT IN (SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')
SELECT Student.Major, Student.Age FROM Student WHERE Student.StuID NOT IN (SELECT Has_Pet.StuID FROM Has_Pet INNER JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat');
SELECT Student.StuID FROM Student WHERE Student.StuID NOT IN (SELECT Has_Pet.StuID FROM Has_Pet INNER JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')
SELECT Student.StuID FROM Student WHERE Student.StuID NOT IN (SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')
SELECT Student.Fname, Student.Age FROM Student WHERE Student.StuID IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' ) AND Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' );
SELECT Student.Fname FROM Student WHERE Student.StuID IN ( SELECT Has_Pet.StuID FROM Has_Pet INNER JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' ) AND Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet INNER JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' );
SELECT Pets.PetType, Pets.weight FROM Pets WHERE Pets.pet_age = (SELECT MIN(Pets.pet_age) FROM Pets);
SELECT Pets.PetType, Pets.weight FROM Pets WHERE Pets.pet_age = (SELECT MIN(Pets.pet_age) FROM Pets)
SELECT PetID, weight FROM Pets WHERE pet_age > 1;
SELECT PetID, weight FROM Pets WHERE pet_age > 1;
SELECT Pets.PetType, AVG(Pets.pet_age) AS average_age, MAX(Pets.pet_age) AS maximum_age FROM Pets GROUP BY Pets.PetType
SELECT PetType, AVG(pet_age), MAX(pet_age) FROM Pets GROUP BY PetType;
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType;
SELECT Pets.PetType, AVG(Pets.weight) FROM Pets GROUP BY Pets.PetType;
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet);
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet);
SELECT Has_Pet.PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID WHERE Student.LName = 'Smith';
SELECT Has_Pet.PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID WHERE Student.LName = 'Smith';
SELECT Student.StuID, COUNT(Has_Pet.PetID) FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID;
SELECT Student.StuID, COUNT(Has_Pet.PetID) FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID;
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1);
SELECT Fname, Sex FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(PetID) > 1);
SELECT Student.LName FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' AND Pets.pet_age = 3;
SELECT Student.LName FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' AND Pets.pet_age = 3;
SELECT AVG(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT AVG(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT COUNT(DISTINCT Continent) FROM continents;
SELECT COUNT(DISTINCT Continent) FROM continents;
SELECT continents.ContId, continents.Continent, COUNT(countries.CountryId) FROM continents LEFT JOIN countries ON continents.Continent = countries.Continent GROUP BY continents.ContId, continents.Continent
SELECT continents.ContId, continents.Continent, COUNT(countries.CountryId) FROM continents LEFT JOIN countries ON continents.Continent = countries.Continent GROUP BY continents.ContId, continents.Continent
SELECT COUNT(DISTINCT CountryName) FROM countries;
SELECT COUNT(*) FROM countries;
SELECT car_makers.FullName, car_makers.Id, COUNT(model_list.ModelId) FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id, car_makers.FullName;
SELECT car_makers.Id, car_makers.FullName, COUNT(model_list.ModelId) FROM car_makers LEFT JOIN model_list ON car_makers.Id = model_list.Maker GROUP BY car_makers.Id, car_makers.FullName;
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model WHERE cars_data.Horsepower = (SELECT MIN(Horsepower) FROM cars_data);
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model WHERE cars_data.Horsepower = (SELECT MIN(Horsepower) FROM cars_data);
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT DISTINCT car_makers.Maker FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker JOIN car_names ON model_list.Model = car_names.Model JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.Year = 1970;
