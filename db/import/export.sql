# Export to Nicolas Turenne 14/06/2013
select s.id, s.acronym, s.name, country.code as country from cl.sources s left join cl.countries country on country.id=s.country_id order by s.id; 
select id, origid, acronym, url, startdate, enddate, amount, currency, title, abstract, keywords, source_id from cl.projects order by id;
select id, origid, firstname, familyname, source_id from cl.people order by id;
select id, origid, acronym, name, source_id from cl.orgunits where isfunding=false order by id;
select project_id, person_id, class.term as role, pp.source_id from cl.project_person pp left join cl.classifications class on class.id=pp.classification_id;
select project_id, orgunit_id, class.term as role, po.source_id from cl.project_orgunit po left join cl.classifications class on class.id=po.classification_id;

