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

