/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Agumon', '2020-02-03', 0, true, 10.23);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Gabumon', '2018-11-15', 2, true, 8.0);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Pikachu', '2021-01-07', 1, false, 15.04);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Devimon', '2017-05-12', 5, true, 11.0);

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Charmander','2020-02-08',11.0,false,0);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Plantmon','2022-11-05',5.7,true,2);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Squirtle','1993-04-02',12.13,false,3);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Angemon','2005-06-12',45.0,true,1);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Boarmon','2005-06-07',20.4,true,7);
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts) VALUES ('Blossom','1998-10-13',17.0,true,3);

BEGIN TRANSACTION;
	INSERT INTO owners (full_name, age) VALUES ('Sam Smith',34);
	INSERT INTO owners (full_name, age) VALUES ('Jennifer Orwell',19);
	INSERT INTO owners (full_name, age) VALUES ('Bob',45);
	INSERT INTO owners (full_name, age) VALUES ('Melody Pond',77);
	INSERT INTO owners (full_name, age) VALUES ('Dean Winchester',14);
	INSERT INTO owners (full_name, age) VALUES ('Jodie Whittaker',38);
	SELECT * FROM owners;
COMMIT;

BEGIN TRANSACTION;
	INSERT INTO species (name) VALUES ('Pokemon');
	INSERT INTO species (name) VALUES ('Digimon');
	SELECT * FROM species;
COMMIT;

BEGIN TRANSACTION;
	UPDATE animals SET species_id = (SELECT id FROM species WHERE name = 'Digimon') WHERE name LIKE '%mon';
	UPDATE animals SET species_id = 1 WHERE species_id IS NULL;
	SELECT * FROM animals;
COMMIT;

BEGIN TRANSACTION;
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Sam Smith') WHERE name = 'Agumon';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell') WHERE name = 'Gabumon';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell') WHERE name = 'Pikachu';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Bob') WHERE name = 'Devimon';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Bob') WHERE name = 'Plantmon';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond') WHERE name = 'Charmander';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond') WHERE name = 'Squirtle';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond') WHERE name = 'Blossom';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Dean Winchester') WHERE name = 'Angemon';
	UPDATE animals SET owner_id = (SELECT id FROM owners WHERE full_name = 'Dean Winchester') WHERE name = 'Boarmon';
	SELECT * FROM animals;
COMMIT;

BEGIN TRANSACTION;
	INSERT INTO vets (name, age, date_of_graduation) VALUES ('William Tatcher',45,'2000-04-23');
	INSERT INTO vets (name, age, date_of_graduation) VALUES ('Maisy Smith',26,'2019-01-17');
	INSERT INTO vets (name, age, date_of_graduation) VALUES ('Stephanie Mendez',64,'1981-05-04');
	INSERT INTO vets (name, age, date_of_graduation) VALUES ('Jack Harkness',38,'2008-06-08');
	SELECT * FROM VETS;
COMMIT;

BEGIN TRANSACTION;
	INSERT INTO specializations (id_vet, id_species) VALUES (
		(SELECT id FROM vets WHERE name = 'William Tatcher'),
		(SELECT id FROM species WHERE name = 'Pokemon')
	);
	INSERT INTO specializations (id_vet, id_species) VALUES (
		(SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
		(SELECT id FROM species WHERE name = 'Digimon')
	);
	INSERT INTO specializations (id_vet, id_species) VALUES (
		(SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
		(SELECT id FROM species WHERE name = 'Pokemon')
	);
	INSERT INTO specializations (id_vet, id_species) VALUES (
		(SELECT id FROM vets WHERE name = 'Jack Harkness'),
		(SELECT id FROM species WHERE name = 'Digimon')
	);
	SELECT * FROM specializations;
COMMIT;

BEGIN TRANSACTION;
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'William Tatcher'),
		(SELECT id FROM animals WHERE name = 'Agumon'),
		'2020-05-24'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
		(SELECT id FROM animals WHERE name = 'Agumon'),
		'2020-07-22'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Jack Harkness'),
		(SELECT id FROM animals WHERE name = 'Gabumon'),
		'2021-02-02'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Pikachu'),
		'2020-01-05'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Pikachu'),
		'2020-03-08'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Pikachu'),
		'2020-05-14'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
		(SELECT id FROM animals WHERE name = 'Devimon'),
		'2021-05-04'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Jack Harkness'),
		(SELECT id FROM animals WHERE name = 'Charmander'),
		'2021-02-24'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Plantmon'),
		'2019-12-21'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'William Tatcher'),
		(SELECT id FROM animals WHERE name = 'Plantmon'),
		'2020-08-10'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Plantmon'),
		'2021-04-07'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
		(SELECT id FROM animals WHERE name = 'Squirtle'),
		'2019-09-29'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Jack Harkness'),
		(SELECT id FROM animals WHERE name = 'Angemon'),
		'2020-10-03'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Jack Harkness'),
		(SELECT id FROM animals WHERE name = 'Angemon'),
		'2020-11-04'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Boarmon'),
		'2019-01-24'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Boarmon'),
		'2019-05-15'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Boarmon'),
		'2020-02-27'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Maisy Smith'),
		(SELECT id FROM animals WHERE name = 'Boarmon'),
		'2020-08-03'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
		(SELECT id FROM animals WHERE name = 'Blossom'),
		'2020-05-24'
	);
	INSERT INTO visits (id_vets, id_animals, visit_date) VALUES (
		(SELECT id FROM vets WHERE name = 'William Tatcher'),
		(SELECT id FROM animals WHERE name = 'Blossom'),
		'2021-01-11'
	);
	SELECT * FROM visits;
COMMIT;
