select s.origid as source, fu.count as fundings, pr.count as projects, ou.count as orgunits, pe.count as people, 
fufu.count as fufulinks, oufu.count as oufulinks, pefu.count as pefulinks, prfu.count as prfulinks,
prpr.count as prprlinks, prou.count as proulinks, prpe.count as prpelinks, peou.count as peoulinks, pepe.count as pepelinks, ouou.count as ououlinks
from cl.sources s
left join (select source_id,count(*) as count from cl.fundings group by source_id order by source_id) as fu on fu.source_id=s.id
left join (select source_id,count(*) as count from cl.projects group by source_id order by source_id) as pr on pr.source_id=s.id
left join (select source_id,count(*) as count from cl.orgunits group by source_id order by source_id) as ou on ou.source_id=s.id
left join (select source_id,count(*) as count from cl.people group by source_id order by source_id) as pe on pe.source_id=s.id
left join (select source_id,count(*) as count from cl.funding_funding group by source_id order by source_id) as fufu on fufu.source_id=s.id
left join (select source_id,count(*) as count from cl.orgunit_funding group by source_id order by source_id) as oufu on oufu.source_id=s.id
left join (select source_id,count(*) as count from cl.person_funding group by source_id order by source_id) as pefu on pefu.source_id=s.id
left join (select source_id,count(*) as count from cl.project_funding group by source_id order by source_id) as prfu on prfu.source_id=s.id
left join (select source_id,count(*) as count from cl.project_project group by source_id order by source_id) as prpr on prpr.source_id=s.id
left join (select source_id,count(*) as count from cl.project_orgunit group by source_id order by source_id) as prou on prou.source_id=s.id
left join (select source_id,count(*) as count from cl.project_person group by source_id order by source_id) as prpe on prpe.source_id=s.id
left join (select source_id,count(*) as count from cl.person_orgunit group by source_id order by source_id) as peou on peou.source_id=s.id
left join (select source_id,count(*) as count from cl.person_person group by source_id order by source_id) as pepe on pepe.source_id=s.id
left join (select source_id,count(*) as count from cl.orgunit_orgunit group by source_id order by source_id) as ouou on ouou.source_id=s.id
;

alter table cl.sources add column fucount integer;
alter table cl.sources add column prcount integer;
alter table cl.sources add column pecount integer;
alter table cl.sources add column oucount integer;
alter table cl.sources add column created_at timestamp;
alter table cl.sources add column updated_at timestamp;

update cl.sources source set fucount=tmp.count 
	from (select source_id,count(*) as count from cl.fundings group by source_id) as tmp
where source.id = tmp.source_id	;
update cl.sources source set prcount=tmp.count 
	from (select source_id,count(*) as count from cl.projects group by source_id) as tmp
where source.id = tmp.source_id;
update cl.sources source set pecount=tmp.count 
	from (select source_id,count(*) as count from cl.people group by source_id) as tmp
where source.id = tmp.source_id;
update cl.sources source set oucount=tmp.count 
	from (select source_id,count(*) as count from cl.orgunits group by source_id) as tmp
where source.id = tmp.source_id;


	
---RANKING text search---
SELECT id, origid, title, ts_rank(ts_index_col, query) AS rank
FROM cl.projects, plainto_tsquery('sustainable ecology') query
WHERE query @@ ts_index_col and ts_rank(ts_index_col, query) > 0.10
ORDER BY rank DESC



select s.origid as source, fu.count as numFPs, fuwa.count as numFPs_with_direct_bugdet, fuwpa.count as numFPs_with_project_budget, 
pr.count as numPRs,  prwab.count as numPRs_with_abstract, prwf.count as numPRs_with_funding
from cl.sources s
left join (select source_id,count(*) as count from cl.fundings group by source_id order by source_id) as fu on fu.source_id=s.id
left join (select source_id,count(*) as count from cl.fundings where amount is not null group by source_id order by source_id) as fuwa on fuwa.source_id=s.id
left join (select source_id,count(*) as count from cl.fundings where id in (select funding_id from cl.project_funding where amount is not null) group by source_id order by source_id) as fuwpa on fuwpa.source_id=s.id
left join (select source_id,count(*) as count from cl.projects group by source_id order by source_id) as pr on pr.source_id=s.id
left join (select source_id,count(*) as count from cl.projects where id in (select project_id from cl.project_funding where amount is not null) group by source_id order by source_id) as prwf on prwf.source_id=s.id
left join (select source_id,count(*) as count from cl.projects where abstract is not null group by source_id order by source_id) as prwab on prwab.source_id=s.id
order by source;