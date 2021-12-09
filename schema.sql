/* Database schema to keep the structure of entire database. */

/* Create the Database */
CREATE DATABASE vet_clinic;

/* Create table animals */
CREATE TABLE IF NOT EXISTS animals (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(250) NOT NULL,
	date_of_birth DATE NOT NULL DEFAULT now(),
	escape_attempts INT,
	neutered BOOLEAN DEFAULT false,
	weight_kg NUMERIC,
	PRIMARY KEY(id)
);

ALTER TABLE animals ADD species VARCHAR(250);


/*
Create a table named owners with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
full_name: string
age: integer
Create a table named species with the following columns:
id: integer (set it as autoincremented PRIMARY KEY)
name: string
*/

CREATE TABLE IF NOT EXISTS owners (
	id INT GENERATED ALWAYS AS IDENTITY,
	full_name VARCHAR(250) NOT NULL,
	age NUMERIC,
	PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS species (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(250) NOT NULL,
	PRIMARY KEY(id)
);

/* Modify animals table: */
/* Make sure that id is set as autoincremented PRIMARY KEY */
SELECT 
table_name,
column_name,
is_identity,
identity_generation
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'animals' AND column_name='id';

/* Remove column species */
ALTER TABLE animals DROP species;

/* Add column species_id which is a foreign key referencing species table */
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD CONSTRAINT manyAnimals_oneSpecies FOREIGN KEY (species_id) REFERENCES species (id);
ALTER TABLE animals ADD owner_id INT;
ALTER TABLE animals ADD CONSTRAINT manyAnimals_oneOwner FOREIGN KEY (owner_id) REFERENCES owners (id);

CREATE TABLE IF NOT EXISTS vets (
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL,
	age INT,
	date_of_graduation DATE DEFAULT now(),
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS specializations (
	id_vet INT NOT NULL,
	id_species INT NOT NULL
);
ALTER TABLE specializations ADD CONSTRAINT specializations_vet FOREIGN KEY (id_vet) REFERENCES vets (id);
ALTER TABLE specializations ADD CONSTRAINT specializations_species FOREIGN KEY (id_species) REFERENCES species (id);

CREATE TABLE IF NOT EXISTS visits (
	id_animals INT NOT NULL,
	id_vets INT NOT NULL,
	visit_date DATE DEFAULT now()
);
ALTER TABLE visits ADD CONSTRAINT visits_vet FOREIGN KEY (id_vets) REFERENCES vets (id);
ALTER TABLE visits ADD CONSTRAINT visits_animals FOREIGN KEY (id_animals) REFERENCES animals (id);


