SELECT COUNT(*) FROM singer;
SELECT COUNT(*) FROM singer;
SELECT Name, Country, Age FROM singer ORDER BY Age DESC;
SELECT Name, Country, Age FROM singer ORDER BY Age DESC;
SELECT AVG(Age) AS Average, MIN(Age) AS Minimum, MAX(Age) AS Maximum FROM singer WHERE Country = 'France';
SELECT AVG(Age) AS Average, MIN(Age) AS Minimum, MAX(Age) AS Maximum FROM singer WHERE Country = 'French';
SELECT singer.Song_Name, singer.Song_release_year FROM singer ORDER BY singer.Age ASC LIMIT 1;
SELECT Song_Name, Song_release_year FROM singer WHERE Age = (SELECT MIN(Age) FROM singer) ORDER BY Song_Name;
SELECT DISTINCT Country FROM singer WHERE Age > 20;
SELECT DISTINCT Country FROM singer WHERE Age > 20;
SELECT Country, COUNT(*) AS NumberOfSingers FROM singer GROUP BY Country;
SELECT Country, COUNT(*) FROM singer GROUP BY Country;
SELECT DISTINCT singer.Song_Name FROM singer WHERE singer.Age > (SELECT AVG(Age) FROM singer);
SELECT DISTINCT singer.Song_Name FROM singer WHERE singer.Age > (SELECT AVG(Age) FROM singer)
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000;
SELECT Location, Name FROM stadium WHERE Capacity BETWEEN 5000 AND 10000;
SELECT MAX(Capacity), AVG(Capacity) FROM stadium;
SELECT AVG(Capacity) AS Average, MAX(Capacity) AS Maximum FROM stadium;
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1;
SELECT Name, Capacity FROM stadium ORDER BY Average DESC LIMIT 1;
SELECT COUNT(*) FROM concert WHERE Year IN (2014, 2015);
SELECT COUNT(*) FROM concert WHERE Year IN (2014, 2015);
SELECT stadium.Name, COUNT(concert.concert_ID) FROM stadium LEFT JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID GROUP BY stadium.Stadium_ID, stadium.Name;
SELECT Stadium_ID, COUNT(*) FROM concert GROUP BY Stadium_ID;
SELECT stadium.Name, stadium.Capacity FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID WHERE concert.Year >= 2014 GROUP BY stadium.Stadium_ID, stadium.Name, stadium.Capacity ORDER BY COUNT(*) DESC LIMIT 1;
SELECT Name, Capacity FROM stadium WHERE Stadium_ID = ( SELECT Stadium_ID FROM concert WHERE Year > 2013 GROUP BY Stadium_ID ORDER BY COUNT(*) DESC LIMIT 1 );
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1;
SELECT Year FROM concert GROUP BY Year ORDER BY COUNT(*) DESC LIMIT 1;
SELECT Name FROM stadium WHERE Stadium_ID NOT IN ( SELECT Stadium_ID FROM concert );
SELECT Name FROM stadium WHERE Stadium_ID NOT IN (SELECT Stadium_ID FROM concert);
SELECT DISTINCT Country FROM singer WHERE Age > 40 OR Age < 30;
SELECT Name FROM stadium WHERE Stadium_ID NOT IN ( SELECT Stadium_ID FROM concert WHERE Year = 2014 );
SELECT Name FROM stadium WHERE Stadium_ID NOT IN ( SELECT DISTINCT Stadium_ID FROM concert WHERE Year = 2014 );
SELECT concert.concert_Name, concert.Theme, COUNT(singer_in_concert.Singer_ID) AS singer_count FROM concert LEFT JOIN singer_in_concert ON concert.concert_ID = singer_in_concert.concert_ID GROUP BY concert.concert_ID, concert.concert_Name, concert.Theme;
SELECT concert.concert_Name, concert.Theme, COUNT(singer_in_concert.Singer_ID) AS number_of_singers FROM concert LEFT JOIN singer_in_concert ON concert.concert_ID = singer_in_concert.concert_ID GROUP BY concert.concert_ID, concert.concert_Name, concert.Theme;
SELECT singer.Name, COUNT(*) AS number_of_concerts FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID GROUP BY singer.Singer_ID, singer.Name;
SELECT singer.Name, COUNT(*) AS number_of_concerts FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID GROUP BY singer.Singer_ID, singer.Name;
SELECT DISTINCT singer.Name FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID JOIN concert ON singer_in_concert.concert_ID = concert.concert_ID WHERE concert.Year = 2014;
SELECT DISTINCT singer.Name FROM singer JOIN singer_in_concert ON singer.Singer_ID = singer_in_concert.Singer_ID JOIN concert ON singer_in_concert.concert_ID = concert.concert_ID WHERE concert.Year = 2014;
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%';
SELECT Name, Country FROM singer WHERE Song_Name LIKE '%Hey%';
SELECT DISTINCT stadium.Name, stadium.Location FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID WHERE concert.Year = 2014 INTERSECT SELECT DISTINCT stadium.Name, stadium.Location FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID WHERE concert.Year = 2015;
SELECT DISTINCT stadium.Name, stadium.Location FROM stadium JOIN concert ON stadium.Stadium_ID = concert.Stadium_ID WHERE concert.Year IN (2014, 2015) GROUP BY stadium.Stadium_ID, stadium.Name, stadium.Location HAVING COUNT(DISTINCT concert.Year) = 2;
SELECT COUNT(*) FROM concert WHERE Stadium_ID = ( SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1 );
SELECT COUNT(*) FROM concert WHERE Stadium_ID = ( SELECT Stadium_ID FROM stadium ORDER BY Capacity DESC LIMIT 1 );
SELECT COUNT(*) FROM Pets WHERE weight > 10;
SELECT COUNT(*) FROM Pets WHERE weight > 10;
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1;
SELECT weight FROM Pets WHERE PetType = 'dog' ORDER BY pet_age ASC LIMIT 1;
SELECT PetType, MAX(weight) FROM Pets GROUP BY PetType;
SELECT PetType, MAX(weight) AS max_weight FROM Pets GROUP BY PetType;
SELECT COUNT(*) FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID WHERE Student.Age > 20;
SELECT COUNT(*) FROM Has_Pet JOIN Student ON Has_Pet.StuID = Student.StuID WHERE Student.Age > 20;
SELECT COUNT(*) FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.Sex = 'F' AND Pets.PetType = 'dog';
SELECT COUNT(*) FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.Sex = 'F' AND Pets.PetType = 'dog';
SELECT COUNT(DISTINCT PetType) FROM Pets;
SELECT COUNT(DISTINCT PetType) FROM Pets;
SELECT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType IN ('cat', 'dog') GROUP BY Student.StuID, Student.Fname;
SELECT DISTINCT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType IN ('cat', 'dog')
SELECT DISTINCT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets AS cat_pets ON Has_Pet.PetID = cat_pets.PetID AND cat_pets.PetType = 'cat' JOIN Has_Pet AS dog_has_pet ON Student.StuID = dog_has_pet.StuID JOIN Pets AS dog_pets ON dog_has_pet.PetID = dog_pets.PetID AND dog_pets.PetType = 'dog
SELECT DISTINCT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets AS cat_pets ON Has_Pet.PetID = cat_pets.PetID AND cat_pets.PetType = 'cat' JOIN Has_Pet AS dog_has_pet ON Student.StuID = dog_has_pet.StuID JOIN Pets AS dog_pets ON dog_has_pet.PetID = dog_pets.PetID AND dog_pets.PetType = 'dog
SELECT Student.Major, Student.Age FROM Student WHERE Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' )
SELECT Student.Major, Student.Age FROM Student WHERE Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' ) ORDER BY Student.Major, Student.Age;
SELECT Student.StuID FROM Student WHERE Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' )
SELECT Student.StuID FROM Student WHERE Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' )
SELECT Student.Fname, Student.Age FROM Student WHERE Student.StuID IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' ) AND Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' );
SELECT DISTINCT Student.Fname FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'dog' AND Student.StuID NOT IN ( SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' );
SELECT PetType, weight FROM Pets ORDER BY pet_age ASC LIMIT 1;
SELECT PetType, weight FROM Pets ORDER BY pet_age ASC LIMIT 1;
SELECT PetID, weight FROM Pets WHERE pet_age > 1;
SELECT PetID, weight FROM Pets WHERE pet_age > 1;
SELECT Pets.PetType, AVG(Pets.pet_age) AS average_age, MAX(Pets.pet_age) AS maximum_age FROM Pets GROUP BY Pets.PetType;
SELECT PetType, AVG(pet_age) AS average_age, MAX(pet_age) AS maximum_age FROM Pets GROUP BY PetType;
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType;
SELECT PetType, AVG(weight) FROM Pets GROUP BY PetType;
SELECT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT DISTINCT Fname, Age FROM Student WHERE StuID IN (SELECT StuID FROM Has_Pet)
SELECT Pets.PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.LName = 'Smith
SELECT Pets.PetID FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Student.LName = 'Smith
SELECT Student.StuID, COUNT(*) AS num_pets FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID HAVING COUNT(*) > 0;
SELECT Student.StuID, COUNT(*) AS pet_count FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID ORDER BY Student.StuID;
SELECT Fname, Sex FROM Student WHERE StuID IN ( SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1 )
SELECT Fname, Sex FROM Student WHERE StuID IN ( SELECT StuID FROM Has_Pet GROUP BY StuID HAVING COUNT(*) > 1 ) ORDER BY Fname;
SELECT Student.LName FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' AND Pets.pet_age = 3;
SELECT Student.LName FROM Student JOIN Has_Pet ON Student.StuID = Has_Pet.StuID JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat' AND Pets.pet_age = 3;
SELECT AVG(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT AVG(Age) FROM Student WHERE StuID NOT IN (SELECT StuID FROM Has_Pet)
SELECT COUNT(DISTINCT Continent) FROM continents;
SELECT COUNT(*) FROM continents;
SELECT continents.ContId, continents.Continent, COUNT(countries.CountryId) FROM continents LEFT JOIN countries ON continents.Continent = countries.Continent GROUP BY continents.ContId, continents.Continent;
SELECT continents.ContId, continents.Continent, COUNT(countries.CountryId) FROM continents LEFT JOIN countries ON continents.Continent = countries.Continent GROUP BY continents.ContId, continents.Continent;
SELECT COUNT(*) FROM countries;
SELECT COUNT(*) FROM countries;
SELECT car_makers.FullName, car_makers.Id, COUNT(model_list.ModelId) AS NumberOfModels FROM car_makers JOIN model_list ON car_makers.Maker = model_list.Maker GROUP BY car_makers.Id, car_makers.FullName ORDER BY car_makers.Id;
SELECT car_makers.Id, car_makers.FullName, COUNT(model_list.ModelId) AS ModelCount FROM car_makers LEFT JOIN model_list ON car_makers.Maker = model_list.Maker GROUP BY car_makers.Id, car_makers.FullName ORDER BY car_makers.Id;
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model ORDER BY cars_data.Horsepower ASC LIMIT 1;
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model ORDER BY cars_data.Horsepower ASC LIMIT 1;
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data)
SELECT model_list.Model FROM cars_data JOIN car_names ON cars_data.Id = car_names.MakeId JOIN model_list ON car_names.Model = model_list.Model WHERE cars_data.Weight < (SELECT AVG(Weight) FROM cars_data);
SELECT DISTINCT car_makers.Maker FROM car_makers JOIN model_list ON car_makers.Id = model_list.Maker JOIN car_names ON model_list.Model = car_names.Model JOIN cars_data ON car_names.MakeId = cars_data.Id WHERE cars_data.Year = 1970;
