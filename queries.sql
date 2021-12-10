/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts<3;
SELECT date_of_birth FROM animals WHERE name='Agumon' OR name='Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg>10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE NOT name='Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


/*
Inside a transaction update the animals table by setting the species column to unspecified. 
Verify that change was made. Then roll back the change and verify that species columns went 
back to the state before tranasction.
*/
BEGIN TRANSACTION;
	UPDATE animals SET species='unspecified';
	SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;
/* -------------------------------------------------------------------------------------------------------------- */

/*
Inside a transaction:
Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
Commit the transaction.
Verify that change was made and persists after commit.
*/
BEGIN TRANSACTION;
	UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
	UPDATE animals SET species='pokemon' WHERE name IS NULL;
COMMIT;
SELECT * FROM animals;
/* -------------------------------------------------------------------------------------------------------------- */

/*
Inside a transaction delete all records in the animals table, then roll back the transaction.
*/
BEGIN TRANSACTION;
	DELETE FROM animals;
	SELECT * FROM animals;
ROLLBACK;
/* -------------------------------------------------------------------------------------------------------------- */

/*
After the roll back verify if all records in the animals table still exist
*/
SELECT * FROM animals ORDER BY (date_of_birth);
/* -------------------------------------------------------------------------------------------------------------- */

/*
Inside a transaction:
Delete all animals born after Jan 1st, 2022.
Create a savepoint for the transaction.
Update all animals' weight to be their weight multiplied by -1.
Rollback to the savepoint
Update all animals' weights that are negative to be their weight multiplied by -1.
Commit transaction
*/
BEGIN TRANSACTION;
	DELETE FROM animals WHERE date_of_birth < '2022-01-01';
	SAVEPOINT afterdelete;
		UPDATE animals SET weight_kg = weight_kg * -1;
	ROLLBACK TO afterdelete;
	UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
/* -------------------------------------------------------------------------------------------------------------- */

/*	How many animals are there? */
SELECT COUNT (*) FROM animals;
/* -------------------------------------------------------------------------------------------------------------- */

/*	How many animals have never tried to escape? */
SELECT COUNT (*) FROM animals WHERE escape_attempts = 0 or escape_attempts = null;
/* -------------------------------------------------------------------------------------------------------------- */

/*	What is the average weight of animals? */
SELECT AVG(weight_kg) FROM animals;
/* -------------------------------------------------------------------------------------------------------------- */

/*	Who escapes the most, neutered or not neutered animals? */
SELECT * FROM (
	SELECT neutered, SUM (escape_attempts) as count_escape_attempts FROM animals GROUP BY neutered
) AS countAnimals 
ORDER BY(count_escape_attempts) DESC
LIMIT 1;
/* -------------------------------------------------------------------------------------------------------------- */

/*	What is the minimum and maximum weight of each type of animal? */
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY (species);
/* -------------------------------------------------------------------------------------------------------------- */

/*	What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
SELECT species, AVG(escape_attempts) 
FROM animals 
WHERE date_of_birth > '1990-01-01' AND date_of_birth < '2000-12-31' GROUP BY (species);
/* -------------------------------------------------------------------------------------------------------------- */

/* What animals belong to Melody Pond? */
SELECT full_name, name FROM owners onr JOIN animals ani ON onr.id = ani.owner_id WHERE onr.full_name='Melody Pond';
/* -------------------------------------------------------------------------------------------------------------- */

/* List of all animals that are pokemon (their type is Pokemon). */
SELECT spc.name as specie_name, ani.name as animal_name FROM species spc JOIN animals ani ON spc.id = ani.species_id WHERE spc.name='Pokemon';
/* -------------------------------------------------------------------------------------------------------------- */

/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT onr.full_name as owner_name, ani.name as animal_name FROM owners onr LEFT JOIN animals ani ON onr.id = ani.owner_id;
/* -------------------------------------------------------------------------------------------------------------- */

/* How many animals are there per species? */
SELECT spc.name as species_name, COUNT(ani.*) as animals_amount FROM species spc JOIN animals ani ON spc.id = ani.species_id GROUP BY spc.name;
/* -------------------------------------------------------------------------------------------------------------- */

/* List all Digimon owned by Jennifer Orwell. */
SELECT onr.full_name as owner_name, ani_spc.*
FROM owners onr
JOIN ( 
	SELECT spc.name as species_name, ani.name as animal_name, owner_id
	FROM species spc
	JOIN animals ani
	ON spc.id = ani.species_id
) ani_spc
ON onr.id = ani_spc.owner_id
WHERE onr.full_name = 'Jennifer Orwell' AND ani_spc.species_name = 'Digimon';
/* -------------------------------------------------------------------------------------------------------------- */

/* List all animals owned by Dean Winchester that haven't tried to escape. */
SELECT * FROM owners onr JOIN animals ani ON onr.id = ani.owner_id WHERE onr.full_name = 'Dean Winchester' AND ani.escape_attempts = 0;
/* -------------------------------------------------------------------------------------------------------------- */

/* Who owns the most animals? */
SELECT onr.full_name as owner_of_more_animals, COUNT(ani.*) as animals_amount FROM owners onr
JOIN animals ani
ON onr.id = ani.owner_id
GROUP BY(onr.id)
ORDER BY (animals_amount) DESC
LIMIT 1;
/* -------------------------------------------------------------------------------------------------------------- */

/* Who was the last animal seen by William Tatcher? */
SELECT vets.name as vet_name, animals.name as animal_name, visits.visit_date FROM vets 
JOIN visits ON  vets.id = visits.id_vets
JOIN animals ON visits.id_animals = animals.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC
LIMIT 1;
/* -------------------------------------------------------------------------------------------------------------- */

/* How many different animals did Stephanie Mendez see? */
SELECT SUM(times_to_vet) as different_animals_visited FROM (
	SELECT COUNT(*) as times_to_vet FROM animals 
	  INNER JOIN visits ON animals.id = visits.id_animals
	  INNER JOIN vets ON vets.id = visits.id_vets
	  WHERE vets.name = 'Stephanie Mendez'
	  GROUP BY animals.id
) query_join;
/* -------------------------------------------------------------------------------------------------------------- */

/* List all vets and their specialties, including vets with no specialties. */
SELECT vets.name, species.name as specie_specialized
FROM vets
LEFT JOIN specializations ON vets.id = specializations.id_vet
LEFT JOIN species ON specializations.id_species = species.id;
/* -------------------------------------------------------------------------------------------------------------- */

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT animals.name, visits.visit_date
FROM animals
JOIN visits ON animals.id = visits.id_animals
JOIN vets ON visits.id_vets = vets.id
WHERE vets.name = 'Stephanie Mendez' AND (visit_date BETWEEN '2020-04-01' AND '2020-08-30');
/* -------------------------------------------------------------------------------------------------------------- */

/* What animal has the most visits to vets? */
SELECT animals.name, COUNT(*) as total_visits
FROM animals
JOIN visits ON animals.id = visits.id_animals
GROUP BY animals.name
ORDER BY (total_visits) DESC;
/* -------------------------------------------------------------------------------------------------------------- */

/* Who was Maisy Smith's first visit? */
SELECT animals.name, visits.visit_date
FROM vets
JOIN visits ON vets.id = visits.id_vets
JOIN animals ON visits.id_animals = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.visit_date DESC
LIMIT 1;
/* -------------------------------------------------------------------------------------------------------------- */

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT animals.*, vets.*, visits.visit_date
FROM vets
JOIN visits ON vets.id = visits.id_vets
JOIN animals ON visits.id_animals = animals.id
ORDER BY visits.visit_date DESC
LIMIT 1;
/* -------------------------------------------------------------------------------------------------------------- */

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(*)
FROM visits
JOIN vets ON visits.id_vets = vets.id
JOIN animals ON visits.id_animals = animals.id
LEFT JOIN specializations ON vets.id = specializations.id_vet
WHERE specializations.id_vet IS NULL OR (animals.species_id != specializations.id_species);

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT species.name, COUNT(*) AS species_visited
FROM animals
JOIN species ON animals.species_id = species.id
JOIN visits ON animals.id = visits.id_animals
JOIN vets on visits.id_vets = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY species_visited DESC
LIMIT 1;
/* -------------------------------------------------------------------------------------------------------------- */
