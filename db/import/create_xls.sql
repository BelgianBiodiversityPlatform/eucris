--- DROP schema xls CASCADE;
create schema xls;


---drop table xls.pe CASCADE;
create table xls.pe(
 	peID 	varchar(64),
	FirstName	varchar(80),
	LastName	varchar(80),
	CountryCode	char(2),
	ZipCode		varchar(64),
	City		varchar(64),
	Address		varchar(200),
	email		varchar(64),
	URL			varchar(256),
	Tel			varchar(64),
	Fax			varchar(64),
	Source		integer,
	Line		integer,
	primary key(Source, peID)
);

---drop table xls.ou CASCADE;
create table xls.ou(
 	ouID 	varchar(64),
	Acronym		varchar(80),
	Name		varchar(255),
	Activity	text,	
	Keywords	text,
	ControlledKeywords	text,
	MainTypeActivitiy	text,
	CountryCode	char(2),
	ZipCode		varchar(64),
	City		varchar(64),
	Address		varchar(200),
	email		varchar(64),
	URL			varchar(256),
	Tel			varchar(64),
	Fax			varchar(64),
	Source		integer,
	Line		integer,
	primary key(Source, ouID)
);

---drop table xls.pr CASCADE;
create table xls.pr(
 	prID varchar(64),
	Title		varchar(512),
	Acronym		varchar(80),
	Abstract	text,
	Budget		integer,
	Currency	char(3),
	StartDate	date,	
	EndDate		date,
	Keywords	text,
	ControlledKeywords	text,
	Status		char(64),
	URL			varchar(256),
	Source		integer,
	Line		integer,
	primary key(Source,prID)
);

---drop table xls.fu CASCADE;
create table xls.fu(
 	fuID varchar(64),
	Name		varchar(255),
	Budget		integer,
	Currency	char(3),
	Description	text,
	StartDate	date,	
	EndDate		date,
	Keywords	text,
	ControlledKeywords	text,
	URL			varchar(256),
	Source		integer,
	Line		integer,
	primary key(Source, fuID)
);
---drop table xls.pe_ou CASCADE;
create table xls.pe_ou(
 	peID 	varchar(64),
 	ouID 	varchar(64),
	Role		varchar(64),
	StartDate	date,	
	EndDate		date,	
	Source		integer,
	Line		integer,
	primary key(Source, Line)
);
---drop table xls.pe_pr CASCADE;
create table xls.pe_pr(
 	peID 	varchar(64),
 	prID 	varchar(64),
	Role		varchar(64),
	StartDate	date,	
	EndDate		date,	
	Source		integer,
	Line		integer,
	primary key(Source, Line)
);

---drop table xls.pr_fu CASCADE;
create table xls.pr_fu(
 	prID 	varchar(64),
 	fuID 	varchar(64),
	Role		varchar(64),
	StartDate	date,	
	EndDate		date,	
	Amount		integer,
	Currency	char(3),
	Source		integer,
	Line		integer,
	primary key(Source, Line)
);
---drop table xls.pr_ou CASCADE;
create table xls.pr_ou(
 	prID 	varchar(64),
 	ouID 	varchar(64),
	Role		varchar(64),
	StartDate	date,	
	EndDate		date,	
	Amount		integer,
	Currency	char(3),
	Source		integer,
	Line		integer,
	primary key(Source, Line)
);
---drop table xls.ou_fu CASCADE;
create table xls.ou_fu(
 	ouID 	varchar(64),
 	fuID 	varchar(64),
	Role		varchar(64),
	StartDate	date,	
	EndDate		date,	
	Amount		integer,
	Currency	char(3),
	Source		integer,
	Line		integer,
	primary key(Source, Line)
);