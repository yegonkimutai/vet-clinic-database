/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN 'Jan 1, 2016' AND 'Dec 31, 2019';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- updates

BEGIN;

UPDATE animals SET species = 'unspecified';

SELECT * FROM animals;


BEGIN;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT;

SELECT * FROM animals;


BEGIN;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

COMMIT;

SELECT * FROM animals;

-- delete

BEGIN;

DELETE FROM animals;

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;


BEGIN TRANSACTION;

DELETE from animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT STR;

UPDATE animals SET weight_kg = weight_kg * -1;

ROLLBACK STR;

SELECT * from animals;

SAVEPOINT STR;

UPDATE animals SET weight_kg = weight_kg * -1;

ROLLBACK STR;

SELECT * from animals;

COMMIT;


-- count
SELECT COUNT(*) FROM animals;


SELECT COUNT(escape_attempts) FROM animals WHERE escape_attempts = 0;


SELECT AVG(weight_kg) FROM animals;


SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;


SELECT species, MAX(weight_kg), MIN(weight_kg) FROM animals GROUP BY species;


SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN 'Jan 1, 1990' AND 'Dec 31, 2000' 
GROUP BY species;

-- multiple table queries
-- select animals whose owner is Melody Pond
SELECT name, full_name FROM animals JOIN owners ON animals.owners_id = owners.id WHERE full_name = 'Melody Pond';

-- select animals of pokemon species
SELECT animals.name, species.name FROM animals JOIN species ON animals.species_id = species.id WHERE species.name = 'Pokemon';

-- display list of all owners, owning or not owning the animals
SELECT full_name, name FROM animals RIGHT JOIN owners ON animals.owners_id = owners.id;

-- count all animals according to species
SELECT species.name, COUNT(*) FROM animals JOIN species ON animals.species_id = species.id GROUP BY species.name;

-- select animal owned by Jennifer Orwell belonging to the  Digimon species
SELECT animals.name, full_name, species.name FROM animals JOIN owners ON animals.owners_id = owners.id JOIN species ON animals.species_id = species.id WHERE full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- display all animals with 0 escape_attempts that are owned by Dean Winchester
SELECT animals.name, full_name, escape_attempts FROM animals JOIN owners ON animals.owner_id = owners.id WHERE full_name = 'Dean Winchester' AND escape_attempts = 0;

-- display owner that has the most animals
SELECT full_name, COUNT(*) as most FROM animals JOIN owners ON animals.owners_id = owners.id GROUP BY full_name ORDER BY COUNT(*) DESC LIMIT 1;

-- junction tables queries
-- animals last seen by William Tatcher
SELECT A.name, vets.name, V.date
FROM visits V
JOIN animals A
ON V.animal_id = A.animalid
JOIN vets
ON V.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY V.date DESC LIMIT 1;

-- total animals visited by Stephanie Mendez
SELECT V.name, COUNT(animals.animalid) AS "TOTAL ANIMALS"
FROM visits
JOIN animals
ON visits.animal_id = animals.animalid
JOIN vets V
ON visits.vet_id = V.id
WHERE V.name = 'Stephanie Mendez'
GROUP BY V.name;

-- list of all vets and their specializations
SELECT vets.name, species.name
FROM vets
LEFT JOIN specializations
ON vets.id = specializations.vet_id
LEFT JOIN species
ON specializations.species_id = species.id;

-- list of animals visited by Stephanie Mendez between April 1st and August 30th, 2020
SELECT vets.name, animals.name, visits.date
FROM animals
JOIN visits
ON visits.animal_id = animals.animalid
JOIN vets
ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez' AND visits.date BETWEEN '2020-04-01' AND '2020-08-30';

-- animals with the most visits
SELECT animals.name, COUNT(visits.animal_id) AS VISITS
FROM animals
JOIN visits
ON animals.animalid = visits.animal_id
GROUP BY animals.name
ORDER BY VISITS DESC LIMIT 1;

-- first animal that visited Maisy Smith
SELECT A.name, vets.name, V.date
FROM visits V
JOIN animals A
ON V.animal_id = A.animalid
JOIN vets
ON V.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
ORDER BY V.date ASC LIMIT 1;

-- all details of the most recent visit
SELECT animals.* AS ANIMAL_INFORMATION, vets.* AS VET_INFORMATION, visits.date
FROM animals
JOIN visits
ON animals.animalid = visits.animal_id
JOIN vets
ON visits.vet_id = vets.id
ORDER BY visits.date DESC LIMIT 1;

-- number of visits made by a non-specialized vet
SELECT COUNT(*) AS "VISITS TO VETS NOT SPECIALISED IN THAT SPECIES"
FROM visits
JOIN vets
ON visits.vet_id = vets.id
JOIN animals
ON visits.animal_id = animals.animalid
LEFT JOIN specializations
ON vets.id = specializations.vet_id AND animals.species_id = specializations.species_id
WHERE specializations.species_id IS NULL;

-- specialization Maisy should consider getting
SELECT MAX(species.name) AS "SPECIES MAISY SHOULD CONSIDER"
FROM animals
JOIN visits
ON animals.animalid = visits.animal_id
JOIN species
ON animals.species_id = species.id
WHERE visits.vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
GROUP BY species.id ORDER BY COUNT(*) DESC LIMIT 1;