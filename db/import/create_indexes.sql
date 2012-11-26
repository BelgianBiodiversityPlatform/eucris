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

update cl.sources set  fucount=0,pecount=0, prcount=0, oucount=0, focount=0, rocount=0;

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
update cl.sources source set focount=tmp.count 
	from (select source_id,count(*) as count from cl.orgunits where isFunding=true group by source_id) as tmp
where source.id = tmp.source_id;
update cl.sources source set rocount=tmp.count 
	from (select source_id,count(*) as count from cl.orgunits where isFunding=false group by source_id) as tmp
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


---	Project Fulltext Search Index: 
---	A: title, acornym
--- B: keywords, classifications terms
--- C: abstract
--- D: related researchers familyNames, related research orgunits names, related funding (programmes) names

UPDATE cl.projects SET ts_index_col =
	setweight(to_tsvector( 'english', coalesce(title,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(acronym,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(keywords,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(tmp.pcterms,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(abstract,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(tmp.ppnames,'')), 'D') ||
	setweight(to_tsvector( 'english', coalesce(tmp.ponames,'')), 'D') ||
	setweight(to_tsvector( 'english', coalesce(tmp.pfnames,'')), 'D')
	from (select p.project_id, pc.pcterms, pp.ppnames, po.ponames, pf.pfnames
		from (select id as project_id from cl.projects) as p
				left join (select pc.project_id, array_accum(c.term)::text as pcterms from cl.project_class pc
						left join cl.classifications c on c.id=pc.classification_id
						group by pc.project_id) as pc on pc.project_id = p.project_id
				left join (select pp.project_id, array_accum(pe.familyname)::text as ppnames from cl.project_person pp 
						left join cl.people pe on pe.id = pp.person_id
						group by pp.project_id) as pp on pp.project_id= p.project_id
				left join (select po.project_id, array_accum(ou.name)::text as ponames from cl.project_orgunit po 
						left join cl.orgunits ou on ou.id = po.orgunit_id
						group by po.project_id) as po on po.project_id= p.project_id
				left join (select pf.project_id, array_accum(fu.name)::text as pfnames from cl.project_funding pf 
						left join cl.fundings fu on fu.id = pf.funding_id
						group by pf.project_id) as pf on pf.project_id= p.project_id
		 ) as tmp
	where id=tmp.project_id;
	
--- remove NERC sub-projects(classified as 'Part' in project table) from search index
UPDATE cl.projects SET ts_index_col=NULL from (select distinct project1_id from cl.project_project where source_id=18 and classification_id=9103) as tmp where id=tmp.project1_id;

---	People Fulltext Search Index: 
---	A: familyname, firstname
--- B: classifications terms
--- C: related project titles and keywords
--- D: related research orgunits names
UPDATE cl.people SET ts_index_col =
		setweight(to_tsvector( 'english', coalesce(familyname,'')), 'A') ||
		setweight(to_tsvector( 'english', coalesce(firstname,'')), 'A') ||
		setweight(to_tsvector( 'english', coalesce(tmp.pcterms,'')), 'B') ||
		setweight(to_tsvector( 'english', coalesce(tmp.prtitles,'')), 'C') ||
		setweight(to_tsvector( 'english', coalesce(tmp.prkeywords,'')), 'C') ||
		setweight(to_tsvector( 'english', coalesce(tmp.ponames,'')), 'D')
		from (select p.person_id, pc.pcterms, pp.prtitles, pp.prkeywords, po.ponames
			from (select id as person_id from cl.people) as p
			left join (select pc.person_id, array_accum(c.term)::text as pcterms from cl.person_class pc 
				left join cl.classifications c on c.id=pc.classification_id
				group by pc.person_id) as pc on pc.person_id = p.person_id
			left join (select pp.person_id, array_accum(pr.title)::text as prtitles, array_accum(pr.keywords)::text as prkeywords
				from cl.project_person pp 
				left join cl.projects pr on pr.id = pp.project_id
				group by pp.person_id) as pp on pp.person_id= p.person_id
			left join (select po.person_id, array_accum(ou.name)::text as ponames from cl.person_orgunit po
					left join cl.orgunits ou on ou.id = po.orgunit_id
					group by po.person_id) as po on po.person_id= p.person_id			
			 ) as tmp
	where id=tmp.person_id;

---	Orgunit Fulltext Search Index: 
---	A: name, acronym
--- B: keywords, activity, classifications terms
--- C: related project titles and keywords
--- D: related researchers familyNames, related funding (programme) names
UPDATE cl.orgunits SET ts_index_col =
	setweight(to_tsvector( 'english', coalesce(name,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(acronym,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(keywords,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(activity,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(tmp.octerms,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(tmp.prtitles,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(tmp.prkeywords,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(tmp.ponames,'')), 'D') ||
	setweight(to_tsvector( 'english', coalesce(tmp.ofnames,'')), 'D')	
	from (select o.orgunit_id, oc.octerms, pr.prtitles, pr.prkeywords, po.ponames, of.ofnames
			from (select id as orgunit_id from cl.orgunits) as o
			left join (select oc.orgunit_id, array_accum(c.term)::text as octerms from cl.orgunit_class oc 
				left join cl.classifications c on c.id=oc.classification_id
				group by oc.orgunit_id) as oc on oc.orgunit_id=o.orgunit_id
			left join (select po.orgunit_id, array_accum(pr.title)::text as prtitles, array_accum(pr.keywords)::text as prkeywords
				from cl.project_orgunit po 
				left join cl.projects pr on pr.id = po.project_id
				group by po.orgunit_id) as pr on pr.orgunit_id=o.orgunit_id
			left join (select po.orgunit_id, array_accum(pe.familyname)::text as ponames from cl.person_orgunit po 
					left join cl.people pe on pe.id = po.person_id
					group by po.orgunit_id) as po on po.orgunit_id=o.orgunit_id
			left join (select of.orgunit_id, array_accum(fu.name)::text as ofnames from cl.orgunit_funding of 
					left join cl.fundings fu on fu.id = of.funding_id
					group by of.orgunit_id) as of on of.orgunit_id=o.orgunit_id
	) as tmp
	where id=tmp.orgunit_id;

---	Funding Fulltext Search Index: 
---	A: name
--- B: description, keywords, classifications terms
--- C: related project titles and keywords
--- D: related researchers familyNames, related funding orgunit names

UPDATE cl.fundings SET ts_index_col =
	setweight(to_tsvector( 'english', coalesce(name,'')), 'A') ||
	setweight(to_tsvector( 'english', coalesce(keywords,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(description,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(tmp.fcterms,'')), 'B') ||
	setweight(to_tsvector( 'english', coalesce(tmp.prtitles,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(tmp.prkeywords,'')), 'C') ||
	setweight(to_tsvector( 'english', coalesce(tmp.ofnames,'')), 'D') 
	from (select f.funding_id, fc.fcterms, pr.prtitles, pr.prkeywords, of.ofnames
			from (select id as funding_id from cl.fundings) as f
			left join (select fc.funding_id, array_accum(c.term)::text as fcterms from cl.funding_class fc 
				left join cl.classifications c on c.id=fc.classification_id
				group by fc.funding_id) as fc on fc.funding_id=f.funding_id
			left join (select pf.funding_id, array_accum(pr.title)::text as prtitles, array_accum(pr.keywords)::text as prkeywords
				from cl.project_funding pf 
				left join cl.projects pr on pr.id = pf.project_id
				group by pf.funding_id) as pr on pr.funding_id=f.funding_id
			left join (select of.funding_id, array_accum(ou.name)::text as ofnames from cl.orgunit_funding of 
					left join cl.orgunits ou on ou.id = of.orgunit_id
					group by of.funding_id) as of on of.funding_id=f.funding_id
	) as tmp
	where id=tmp.funding_id;

