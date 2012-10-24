ALTER TABLE cl.countries ADD COLUMN socount integer;
ALTER TABLE cl.countries ADD COLUMN focount integer;
ALTER TABLE cl.countries ADD COLUMN rocount integer;
ALTER TABLE cl.countries ADD COLUMN fucount integer;
ALTER TABLE cl.countries ADD COLUMN prcount integer;
ALTER TABLE cl.countries ADD COLUMN pecount integer;

alter table cl.sources add column count integer;
alter table cl.classifications add column fucount integer;
alter table cl.classifications add column pecount integer;
alter table cl.classifications add column prcount integer;	
alter table cl.classifications add column oucount integer;
alter table cl.classifications add column count integer;
ALTER TABLE cl.projects ADD COLUMN ts_index_col tsvector;
ALTER TABLE cl.people ADD COLUMN ts_index_col tsvector;
ALTER TABLE cl.orgunits ADD COLUMN ts_index_col tsvector;
ALTER TABLE cl.fundings ADD COLUMN ts_index_col tsvector;
DROP INDEX cl.projects_ts_idx ;
CREATE INDEX projects_ts_idx ON cl.projects USING gin(ts_index_col);
DROP INDEX cl.people_ts_idx ;
CREATE INDEX people_ts_idx ON cl.people USING gin(ts_index_col);
DROP INDEX cl.orgunits_ts_idx ;
CREATE INDEX orgunits_ts_idx ON cl.orgunits USING gin(ts_index_col);
DROP INDEX cl.fundings_ts_idx ;
CREATE INDEX fundings_ts_idx ON cl.fundings USING gin(ts_index_col);


update cl.countries set socount=0, focount=0, rocount=0, fucount=0, prcount=0, pecount=0;

update cl.countries country set socount=tmp.count 
	from (select country_id,count(*) as count from cl.sources group by country_id) as tmp
where country.id = tmp.country_id;
update cl.countries country set fucount=tmp.count 
	from (select country_id,count(*) as count from cl.fundings fu
	left join cl.sources so on so.id =fu.source_id 
	group by country_id) as tmp
where country.id = tmp.country_id;
update cl.countries country set focount=tmp.count 
	from (select country_id,count(*) as count from cl.orgunits ou
	left join cl.sources so on so.id =ou.source_id 
	where ou.isFunding=true
	group by country_id) as tmp
where country.id = tmp.country_id;
update cl.countries country set rocount=tmp.count 
	from (select country_id,count(*) as count from cl.orgunits ou
	left join cl.sources so on so.id =ou.source_id 
	where ou.isFunding=false
	group by country_id) as tmp
where country.id = tmp.country_id;
update cl.countries country set prcount=tmp.count 
	from (select country_id,count(*) as count from cl.projects pr
	left join cl.sources so on so.id =pr.source_id 
	group by country_id) as tmp
where country.id = tmp.country_id;
update cl.countries country set pecount=tmp.count 
	from (select country_id,count(*) as count from cl.people pe
	left join cl.sources so on so.id =pe.source_id 
	group by country_id) as tmp
where country.id = tmp.country_id;

update cl.fundings set granted=tmp.total, currency=tmp.currency
		from (select funding_id, currency, sum(amount) as total from cl.project_funding where amount > 0 group by funding_id, currency) as tmp
where id = tmp.funding_id;

update cl.sources set  fucount=0,pecount=0, prcount=0, oucount=0;

update cl.sources source set fucount=tmp.count 
	from (select source_id,count(*) as count from cl.fundings group by source_id) as tmp
where source.id = tmp.source_id	;
update cl.sources source set prcount=tmp.count 
	from (select source_id,count(*) as count from cl.projects where ts_index_col is not null group by source_id) as tmp
where source.id = tmp.source_id;
update cl.sources source set pecount=tmp.count 
	from (select source_id,count(*) as count from cl.people group by source_id) as tmp
where source.id = tmp.source_id;
update cl.sources source set oucount=tmp.count 
	from (select source_id,count(*) as count from cl.orgunits group by source_id) as tmp
where source.id = tmp.source_id;

update cl.sources source set count=fucount+prcount+pecount+oucount; 

update cl.classifications set  fucount=0,pecount=0, prcount=0, oucount=0;

update cl.classifications class set fucount=tmp.count 
	from (select classification_id,count(*) as count from cl.funding_class group by classification_id) as tmp
where class.id = tmp.classification_id;
update cl.classifications class set prcount=tmp.count 
	from (select classification_id,count(*) as count from cl.project_class group by classification_id) as tmp
where class.id = tmp.classification_id;
update cl.classifications class set pecount=tmp.count 
	from (select classification_id,count(*) as count from cl.person_class group by classification_id) as tmp
where class.id = tmp.classification_id;
update cl.classifications class set oucount=tmp.count 
	from (select classification_id,count(*) as count from cl.orgunit_class group by classification_id) as tmp
where class.id = tmp.classification_id;
update cl.classifications source set count=fucount+prcount+pecount+oucount; 



UPDATE cl.projects SET ts_index_col =
	setweight(to_tsvector( 'english', coalesce(title,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(acronym,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(keywords,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(abstract,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(pclass.classterms,'')), 'B')
	from (select p.id as project_id, array_accum(c.term)::text as classterms
	 		from cl.projects p 
	 		left join cl.project_class pc on pc.project_id= p.id 
	 		left join cl.classifications c on c.id=pc.classification_id
			group by p.id ) as pclass
	where id=pclass.project_id;
	
--- remove NERC sub-projects(classified as 'Part' in project table) from search index
UPDATE cl.projects SET ts_index_col=NULL from (select distinct project1_id from cl.project_project where source_id=18 and classification_id=9103) as tmp where id=tmp.project1_id;

UPDATE cl.people SET ts_index_col =
		setweight(to_tsvector( 'english', coalesce(familyname,'')), 'A') ||
		setweight(to_tsvector( 'english', coalesce(firstname,'')), 'A') ||
		setweight(to_tsvector( 'english', coalesce(pclass.classterms,'')), 'B') ||
		setweight(to_tsvector( 'english', coalesce(pclass.pr_titles,'')), 'C') ||
		setweight(to_tsvector( 'english', coalesce(pclass.pr_keywords,'')), 'C')
		from (select p.id as person_id, array_accum(c.term)::text as classterms, array_accum(pr.title)::text as pr_titles, array_accum(pr.keywords)::text as pr_keywords
				from cl.people p 
				left join cl.person_class pc on pc.person_id= p.id 
				left join cl.classifications c on c.id=pc.classification_id
				left join cl.project_person pp on pp.person_id = p.id
				left join cl.projects pr on pr.id = pp.project_id
				group by p.id) as pclass
where id=pclass.person_id;
---     to_tsvector('english', coalesce(familyname,'') || ' ' || coalesce(firstname,''));

UPDATE cl.orgunits SET ts_index_col =
	setweight(to_tsvector( 'english', coalesce(name,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(acronym,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(keywords,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(activity,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(ouclass.classterms,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(ouclass.pr_titles,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(ouclass.pr_keywords,'')), 'C')
	from (select ou.id as orgunit_id, array_accum(c.term)::text as classterms, array_accum(pr.title)::text as pr_titles, array_accum(pr.keywords)::text as pr_keywords
 		from cl.orgunits ou 
 		left join cl.orgunit_class ouc on ouc.orgunit_id= ou.id 
 		left join cl.classifications c on c.id=ouc.classification_id
		left join cl.project_orgunit po on po.orgunit_id = ou.id
		left join cl.projects pr on pr.id = po.project_id
		group by ou.id ) as ouclass
where id=ouclass.orgunit_id;
---     to_tsvector('english', coalesce(name,'') || ' ' || coalesce(keywords,'') || ' ' || coalesce(activity,''));

UPDATE cl.fundings SET ts_index_col =
	setweight(to_tsvector( 'english', coalesce(name,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(keywords,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(description,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(fuclass.classterms,'')), 'B')
	from (select fu.id as funding_id, array_accum(c.term)::text as classterms
 		from cl.fundings fu 
 		left join cl.funding_class fuc on fuc.funding_id= fu.id 
 		left join cl.classifications c on c.id=fuc.classification_id
		group by fu.id ) as fuclass
where id=fuclass.funding_id;
---     to_tsvector('english', coalesce(name,'') || ' ' || coalesce(keywords,'') || ' ' || coalesce(description,''));
