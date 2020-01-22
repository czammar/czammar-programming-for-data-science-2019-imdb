/***********************************************************************************/
/**************************** Preparación de las tablas ****************************/
/***********************************************************************************/


/**************************** Título Also know as ****************************/
drop table if exists raw.title_akas;
create table raw.title_akas (
  "titleid" TEXT,
  "ordering" TEXT,
  "title" TEXT,
  "region" TEXT,
  "language" TEXT,
  "types" TEXT,
  "attributes" TEXT,
  "isoriginaltitle" TEXT
);
comment on table raw.title_akas is 'describe el titulo adaptado de las peliculas';


/**************************** Título Basics ****************************/
drop table if exists raw.title_basics;
create table raw.title_basics (
  "tconst" TEXT,
  "titletype" TEXT,
  "primarytitle" TEXT,
  "originaltitle" TEXT,
  "isadult" TEXT,
  "startyear" TEXT,
  "endyear" TEXT,
  "runtimeminutes" TEXT,
  "genres" TEXT

);
comment on table raw.title_basics is 'describe caracteristicas especiales de los titulos de las peliculas';


/**************************** Título crew ****************************/
drop table if exists raw.title_crew;
create table raw.title_crew (
  "tconst" TEXT,
  "directors" TEXT,
  "writers" TEXT

);
comment on table raw.title_crew is 'describe informacion sobre el director y escritores de las peliculas';


/**************************** Título episode ****************************/
drop table if exists raw.title_episode;
create table raw.title_episode (
  "tconst" TEXT,
  "parenttconst" TEXT,
  "seasonnumber" TEXT,
  "episodenumber" TEXT

);
comment on table raw.title_episode is 'describe informacion de los episodios de series de tv';


/**************************** Título principals ****************************/
drop table if exists raw.title_principals;
create table raw.title_principals (
  "tconst" TEXT,
  "ordering" TEXT,
  "nconst" TEXT,
  "category" TEXT,
  "job" TEXT,
  "characters" TEXT
);
comment on table raw.title_principals is 'describe a los principales miembros del crew de las peliculas';


/**************************** Título ratings ****************************/
drop table if exists raw.title_ratings;
create table raw.title_ratings (
  "tconst" TEXT,
  "averagerating" TEXT,
  "numvotes" TEXT
);
comment on table raw.title_ratings is 'describe los ratings y votos de las peliculas';


/**************************** Título basics ****************************/
drop table if exists raw.name_basics;
create table raw.name_basics (
  "nconst" TEXT,
  "primaryname" TEXT,
  "birthyear" TEXT,
  "deathyear" TEXT,
  "primaryprofession" TEXT,
  "knownfortitles" TEXT

);
comment on table raw.name_basics is 'describe la información principal de los actores';