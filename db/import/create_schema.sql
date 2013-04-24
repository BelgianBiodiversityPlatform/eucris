---select * from pg_stat_all_tables where schemaname='public' and n_live_tup >0 order by relname;


---CERIF LITE a simplified version of CERIF 2008 1.0 schema

---DROP AGGREGATE array_accum ( anyelement) cascade;
CREATE AGGREGATE array_accum (
    sfunc = array_append,
    basetype = anyelement,
    stype = anyarray,
    initcond = '{}'
);


--- DROP schema cl CASCADE;
create schema cl;


-- DROP TABLE cl.countries CASCADE;
create table cl.countries(
		id 			serial primary key,
		code 		char(2) unique,
		name		varchar(255) unique
);

-- DROP TABLE cl.documents CASCADE;
create table cl.documents(
		id 			serial primary key,
		filename	varchar(255) unique,
		title		varchar(255)
);

-- DROP TABLE cl.sources CASCADE;
create table cl.sources(
	id 			serial primary key,
	origid 		varchar(128) unique,
	url			varchar(256),
	acronym		varchar(128),
	name		varchar(255),
	description text,
	country_id	integer references cl.countries,
	fucount 	integer,
	prcount 	integer,
	pecount		integer,
	oucount		integer,
	created_at	timestamp,
	updated_at	timestamp
);

-- DROP TABLE cl.roles CASCADE;
create table cl.roles(
	id 		serial primary key,
	code	char(3) unique,
	name	varchar(255)
);

-- DROP TABLE cl.users CASCADE;
create table cl.users(
	id 		serial primary key,
	origid 	varchar(128) unique,	
	login		varchar(64),
	gender		char,
	birthdate	date,
	url			varchar(256),	
	familyname	varchar(64),
	firstname	varchar(64),
	fax			varchar(64),
	tel			varchar(64),
	email		varchar(64),
	startdate	date,
	enddate		date,
	admin		boolean,
	blocked		boolean,	
	salt		varchar(64),
	salted_password	varchar(64),	
	lastlogin	timestamp,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);

-- DROP TABLE cl.user_source CASCADE;
create table cl.user_source(
	user_id 	integer references cl.users,
	source_id	integer references cl.sources,
	role_id		integer references cl.roles,
	created_at	timestamp,
	updated_at	timestamp
);


--- CORE ENTITIES ---
-- DROP TABLE cl.orgunits CASCADE;
create table cl.orgunits(
	id 			serial primary key,
	origid 		varchar(128) unique,
	acronym		varchar(64),
	url			varchar(256),
	name		varchar(255),
	fax			varchar(64),
	tel			varchar(64),
	email		varchar(64),
	addrline1	varchar(200),
	addrline2	varchar(200),
	addrline3	varchar(200),
	addrline4	varchar(200),
	addrline5	varchar(200),
	postcode	varchar(64),
	city		varchar(64),
	country		char(2),	
	startdate	date,
	enddate		date,
	activity	text,
	keywords	text,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.projects CASCADE;
create table cl.projects(
	id 			serial primary key,
	origid 		varchar(128) unique,
	acronym		varchar(64),
	url			varchar(256),
	startdate	date,
	enddate		date,
	amount		bigint,
	currency	char(3),
	title		varchar(512),
	abstract	text,
	keywords	text,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);	

-- DROP TABLE cl.people CASCADE;
create table cl.people(
	id 			serial primary key,
	origid 		varchar(128) unique,
	gender		char,
	birthdate	date,
	url			varchar(256),	
	familyname	varchar(64),
	firstname	varchar(64),
	fax			varchar(64),
	tel			varchar(64),
	email		varchar(64),
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
	
);

--- 2ND LEVEL ENTITIES ---
-- DROP TABLE cl.fundings CASCADE;
create table cl.fundings(
	id 			serial primary key,
	origid 		varchar(128) unique,
	startdate	date,
	enddate		date,
	amount		bigint,
	currency	char(3),
	url			varchar(256),
	name		varchar(255),
	description	text,
	keywords	text,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp

);

-- DROP TABLE cl.publications CASCADE;
create table cl.publications(
	id 			serial primary key,
	origid 		varchar(128) unique,
	publitype		varchar(64),
	publidate	date,
	url			varchar(256),
	reference	text,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
--- SEMANTIC ENTITIES CLASSIFICATIONS SCHEME---

-- DROP TABLE cl.classschemes CASCADE;
create table cl.classschemes(
	id 			serial primary key,
	origid 		varchar(128) unique,
	description	text,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp

);
-- DROP TABLE cl.classifications CASCADE;
create table cl.classifications(
	id 			serial primary key,
	origid 		varchar(128),
	schemeorigid 	varchar(128),
	parent_id	int references cl.classifications,
	classscheme_id	int references cl.classschemes,
	term 		varchar(255),
	description	text,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp,
	unique (origid, schemeorigid)
);

--- LINK ENTITIES ---
-- DROP TABLE cl.funding_class CASCADE;
create table cl.funding_class(
	funding_id 	int references cl.fundings,
	classification_id	int references cl.classifications,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.orgunit_class CASCADE;
create table cl.orgunit_class(
	orgunit_id 	int references cl.orgunits,
	classification_id	int references cl.classifications,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.person_class CASCADE;
create table cl.person_class(
	person_id 	int references cl.people,
	classification_id	int references cl.classifications,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.project_class CASCADE;
create table cl.project_class(
	project_id 	int references cl.projects,
	classification_id	int references cl.classifications,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);

-- DROP TABLE cl.funding_funding CASCADE;
create table cl.funding_funding(
	funding1_id 	int references cl.fundings,
	funding2_id 	int references cl.fundings,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);

-- DROP TABLE cl.orgunit_funding CASCADE;
create table cl.orgunit_funding(
	orgunit_id 	int references cl.orgunits,
	funding_id 	int references cl.fundings,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	amount		bigint,
	currency	char(3),
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.orgunit_orgunit CASCADE;
create table cl.orgunit_orgunit(
	orgunit1_id 	int references cl.orgunits,
	orgunit2_id 	int references cl.orgunits,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.person_funding CASCADE;
create table cl.person_funding(
	person_id 	int references cl.people,
	funding_id 	int references cl.fundings,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	amount		bigint,
	currency	char(3),
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.person_orgunit CASCADE;
create table cl.person_orgunit(
	person_id 	int references cl.people,
	orgunit_id 	int references cl.orgunits,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);

-- DROP TABLE cl.person_person CASCADE;
create table cl.person_person(
	person1_id 	int references cl.people,
	person2_id 	int references cl.people,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);

-- DROP TABLE cl.project_funding CASCADE;
create table cl.project_funding(
	project_id 	int references cl.projects,
	funding_id 	int references cl.fundings,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	amount		bigint,
	currency	char(3),
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.project_orgunit CASCADE;
create table cl.project_orgunit(
	project_id 	int references cl.projects,
	orgunit_id 	int references cl.orgunits,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.project_person CASCADE;
create table cl.project_person(
	project_id 	int references cl.projects,
	person_id 	int references cl.people,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.project_project CASCADE;
create table cl.project_project(
	project1_id 	int references cl.projects,
	project2_id 	int references cl.projects,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);
-- DROP TABLE cl.project_publication CASCADE;
create table cl.project_publication(
	project_id 	int references cl.projects,
	publication_id 	int references cl.publications,
	classification_id	int references cl.classifications,
	startdate	date,
	enddate		date,
	source_id	integer references cl.sources,
	created_at	timestamp,
	updated_at	timestamp
);

-- Add id as primary key for link tables (for rails)
alter table cl.funding_class add column id serial primary key;
alter table cl.orgunit_class add column id serial primary key;
alter table cl.person_class add column id serial primary key;
alter table cl.project_class add column id serial primary key;

alter table cl.funding_funding add column id serial primary key;
alter table cl.orgunit_funding add column id serial primary key;
alter table cl.orgunit_orgunit add column id serial primary key;
alter table cl.person_funding add column id serial primary key;
alter table cl.person_orgunit add column id serial primary key;
alter table cl.person_person add column id serial primary key;
alter table cl.project_funding add column id serial primary key;
alter table cl.project_orgunit add column id serial primary key;
alter table cl.project_person add column id serial primary key;
alter table cl.project_project add column id serial primary key;
alter table cl.project_publication add column id serial primary key;
