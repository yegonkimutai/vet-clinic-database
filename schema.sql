/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;
USE vet_clinic; 

CREATE TABLE animals (
    animalid INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name varchar(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL(5, 2)
);

ALTER TABLE animals ADD COLUMN species varchar(100);

-- multiple tables

-- species
CREATE TABLE species(
	id INT GENERATED ALWAYS AS IDENTITY,
	name varchar(200),
	PRIMARY KEY(id)
);

-- owners
CREATE TABLE owners(
	id INT GENERATED ALWAYS AS IDENTITY,
	full_name varchar(200),
    age INT,
	PRIMARY KEY(id)
);

-- modify animals table
ALTER TABLE animals DROP column species;

ALTER TABLE animals ADD species_id INT REFERENCES species(id);

ALTER TABLE animals ADD owners_id INT REFERENCES owners(id);


