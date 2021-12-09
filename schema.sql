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
