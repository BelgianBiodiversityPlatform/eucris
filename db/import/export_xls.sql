---Export CRISTAL tables to xls schema for one source of data
---drop sequence line cascade;
---CREATE temp SEQUENCE line;
drop schema export cascade;
create schema export;
	
CREATE TABLE export.sources (
	id integer primary key,
	origid	varchar(64)	
);
---sources to be exported
INSERT into export.sources (select id, origid from cl.sources where origid='nwo');

---people-
CREATE OR REPLACE VIEW export.people AS 
	SELECT split_part(p.origid, '|', 2) as peID, 
		p.firstname as FirstName, 
		p.familyname as LastName, 
		c.code as CountryCode,
		NULL::text as ZIPCode,
		NULL::text as City,
		NULL::text as Address, 
		p.email as email,
		p.url as URL, 
		p.tel as Tel, 
		p.fax as Fax,
		p.source_id as Source
	from cl.people p
	left join cl.sources s on s.id= p.source_id
	left join cl.countries c on c.id= s.country_id
	where p.source_id in (select id from export.sources)
order by Source, peID;

---orgunits-
CREATE OR REPLACE VIEW export.orgunits AS 
	SELECT split_part(o.origid, '|', 2) as ouID, 
		o.acronym as Acronym, 
		o.name as Name, 
		translate(o.activity, E'\r\n', '  ') as InstituteType,
		o.keywords as Keywords, 
		NULL::text as ControlledKeywords,
		NULL::text as MainTypeActivitiy,
		c.code as CountryCode, 
		o.postcode as ZipCode,
		o.city as City, 
		o.addrline1 as Address, 
		o.email as email, 
		o.url as URL, 
		o.tel as Tel, 
		o.Fax as Fax,
		o.source_id as Source		 
	from cl.orgunits o 
	left join cl.sources s on s.id= o.source_id
	left join cl.countries c on c.id= s.country_id
	where o.source_id in (select id from export.sources)
order by Source, ouID;


---projects-
CREATE OR REPLACE VIEW export.projects AS 
	SELECT split_part(p.origid, '|', 2) as prID, 
		p.title as Title, 
		translate(p.abstract, E'\r\n', '  ') as Abstract, 
		p.amount as budget,
		p.currency as currency,
		p.startdate as StartDate,
		p.enddate as EndDate,
		p.keywords as Keywords,
		NULL::text as ControlledKeywords, 
		CASE 
		WHEN p.startdate > now() THEN 'future'
		WHEN p.startdate <= now() and p.enddate > now() THEN 'ongoing'
		ELSE 'terminated' END as Status,
		p.url as URL,
		p.source_id as Source
	from cl.projects p
	left join cl.sources s on s.id= p.source_id
	left join cl.countries c on c.id= s.country_id
	where p.source_id in (select id from export.sources)
order by Source, prID;

---fundings-
CREATE OR REPLACE VIEW export.fundings AS 
	SELECT split_part(f.origid, '|', 2) as fuID, 
		f.name as Name, 
		f.amount as Budget,
		f.currency as Currency,
		translate(f.description, E'\r\n', '  ') as Description, 
		f.startdate as StartDate,
		f.enddate as EndDate,
		f.keywords as Keywords,
		NULL::text as ControlledKeywords, 
		f.url as URL,
		f.source_id as Source	
	from cl.fundings f
	left join cl.sources s on s.id= f.source_id
	left join cl.countries c on c.id= s.country_id
	where f.source_id in (select id from export.sources)
order by Source, fuID;

---pe_ou links-
CREATE OR REPLACE VIEW export.person_orgunit AS 
	SELECT split_part(pe.origid, '|', 2) as peID, 
		split_part(ou.origid, '|', 2) as ouID, 
		c.term as Role, 
		l.startdate as StartDate,
		l.enddate as EndDate,
		l.source_id as Source
	from cl.person_orgunit l
	left join cl.people pe on pe.id = l.person_id
	left join cl.orgunits ou on ou.id= l.orgunit_id
	left join cl.classifications c on c.id= l.classification_id
	where l.source_id in (select id from export.sources)
order by Source, peID, ouID;

---pe_pr links-
CREATE OR REPLACE VIEW export.person_project AS 
	SELECT split_part(pe.origid, '|', 2) as peID, 
		split_part(pr.origid, '|', 2) as prID, 
		c.term as Role, 
		l.startdate as StartDate,
		l.enddate as EndDate,
		l.source_id as Source
	from cl.project_person l
	left join cl.people pe on pe.id = l.person_id
	left join cl.projects pr on pr.id= l.project_id
	left join cl.classifications c on c.id= l.classification_id
	where l.source_id in (select id from export.sources)
order by Source, peID, prID;

---pr_fu links-
CREATE OR REPLACE VIEW export.project_funding AS 
	SELECT split_part(pr.origid, '|', 2) as prID, 
		split_part(fu.origid, '|', 2) as fuID, 
		c.term as Role, 
		l.startdate as StartDate,
		l.enddate as EndDate,
		l.amount as Amount,
		l.currency as Currency,
		l.source_id as Source
	from cl.project_funding l
	left join cl.projects pr on pr.id= l.project_id
	left join cl.fundings fu on fu.id = l.funding_id
	left join cl.classifications c on c.id= l.classification_id
	where l.source_id in (select id from export.sources)
order by Source, prID, fuID;

---pr_ou links-
CREATE OR REPLACE VIEW export.project_orgunit AS 
	SELECT split_part(pr.origid, '|', 2) as prID, 
		split_part(ou.origid, '|', 2) as ouID, 
		c.term as Role, 
		l.startdate as StartDate,
		l.enddate as EndDate,
		NULL::text as Amount,
		NULL::text as Currency,
		l.source_id as Source
	from cl.project_orgunit l
	left join cl.projects pr on pr.id= l.project_id
	left join cl.orgunits ou on ou.id = l.orgunit_id
	left join cl.classifications c on c.id= l.classification_id
	where l.source_id in (select id from export.sources)
order by Source, prID, ouID;

---ou_fu links-
CREATE OR REPLACE VIEW export.orgunit_funding AS 
	SELECT split_part(ou.origid, '|', 2) as ouID, 
		split_part(fu.origid, '|', 2) as fuID, 
		c.term as Role, 
		l.startdate as StartDate,
		l.enddate as EndDate,
		NULL::text as Amount,
		NULL::text as Currency,
		l.source_id as Source
	from cl.orgunit_funding l
	left join cl.fundings fu on fu.id= l.funding_id
	left join cl.orgunits ou on ou.id = l.orgunit_id
	left join cl.classifications c on c.id= l.classification_id
	where l.source_id in (select id from export.sources)
order by Source, ouID, fuID;


---select setval('line', 1);
copy (select * from export.people ) to '/home/aheugheb/export/people.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.projects ) to '/home/aheugheb/export/projects.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.orgunits ) to '/home/aheugheb/export/orgunits.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.fundings ) to '/home/aheugheb/export/fundings.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.person_orgunit ) to '/home/aheugheb/export/person_orgunit.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.person_project) to '/home/aheugheb/export/person_project.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.project_funding ) to '/home/aheugheb/export/project_funding.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.project_orgunit) to '/home/aheugheb/export/project_orgunit.csv'  DELIMITER E'\t' HEADER CSV;

copy (select * from export.orgunit_funding) to '/home/aheugheb/export/orgunit_funding.csv'  DELIMITER E'\t' HEADER CSV;
