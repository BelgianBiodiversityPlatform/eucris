select tmp.source_id, s.origid as source_name, tmp.withamount, tmp.countall from (select source_id, count(amount) as withAmount, count (*) as countall from cl.fundings group by source_id order by source_id) as tmp
left join cl.sources s on s.id=tmp.source_id;


### CREATE
drop schema stats cascade;
create schema stats;
create table stats.fundings (
 	id 	int references cl.fundings,
	source_id	int references cl.sources,
	hasBudget		boolean,
	nbClassifications	int,
	nbProjects		int,
	nbPeople		int,
	nbOrgunits		int
);

create table stats.projects(
 	id 	int references cl.projects,
	source_id	int references cl.sources,
	hasAbstract		boolean,
	hasBudget		boolean,
	hasDates		boolean,
	nbClassifications	int,
	nbFundings		int,
	nbPeople		int,
	nbOrgunits		int
);
create table stats.people(
 	id 	int references cl.people,
	source_id	int references cl.sources,
	nbClassifications	int,
	nbProjects		int,
	nbOrgunits		int
);
#drop table stats.orgunits;
create table stats.orgunits(
 	id 	int references cl.orgunits,
	source_id	int references cl.sources,
	isfunding		boolean,
	nbClassifications	int,
	nbFundings		int,
	nbProjects		int,
	nbPeople		int
);
### Populate
insert into stats.fundings (id, source_id, hasBudget,nbClassifications, nbProjects, nbPeople, nbOrgunits) 
select id, source_id,
case when fu.amount is not null or prfu.amount is not null then true else null::boolean end as hasBudget, 
clfu.clcount, prfu.prcount, pefu.pecount, oufu.oucount from cl.fundings fu
left join (select funding_id,count(*) as clcount from cl.funding_class group by funding_id) as clfu on clfu.funding_id=fu.id
left join (select funding_id,count(*) as prcount, sum(amount) as amount from cl.project_funding group by funding_id) as prfu on prfu.funding_id=fu.id
left join (select funding_id,count(*) as pecount, sum(amount) as amount from cl.person_funding group by funding_id) as pefu on pefu.funding_id=fu.id
left join (select funding_id,count(*) as oucount from cl.orgunit_funding group by funding_id) as oufu on oufu.funding_id=fu.id;

insert into stats.projects (id, source_id, hasAbstract, hasBudget,hasDates, nbClassifications, nbFundings, nbPeople, nbOrgunits) 
select id, source_id,
case when abstract is not null then true else null::boolean end as hasAbstract,
case when pr.amount is not null or prfu.amount is not null then true else null::boolean end as hasBudget, 
case when startdate is not null then true else null::boolean end as hasDates, 
clpr.clcount, prfu.fucount, prpe.pecount, prou.oucount from cl.projects pr
left join (select project_id,count(*) as clcount from cl.project_class group by project_id) as clpr on clpr.project_id=pr.id
left join (select project_id,count(*)as fucount, sum(amount) as amount from cl.project_funding group by project_id) as prfu on prfu.project_id=pr.id
left join (select project_id,count(*) as pecount from cl.project_person group by project_id) as prpe on prpe.project_id=pr.id
left join (select project_id,count(*) as oucount from cl.project_orgunit group by project_id) as prou on prou.project_id=pr.id;

insert into stats.people (id, source_id, nbClassifications, nbProjects, nbOrgunits) 
select id, source_id,
clpe.clcount, prpe.prcount, peou.oucount from cl.people pe
left join (select person_id,count(*) as clcount from cl.person_class group by person_id) as clpe on clpe.person_id=pe.id
left join (select person_id,count(*) as prcount from cl.project_person group by person_id) as prpe on prpe.person_id=pe.id
left join (select person_id,count(*) as oucount from cl.person_orgunit group by person_id) as peou on peou.person_id=pe.id;

insert into stats.orgunits (id, source_id, isFunding, nbClassifications, nbFundings, nbProjects, nbPeople) 
select id, source_id,
case when ou.isFunding then true else null::boolean end as isfunding, 
clou.clcount, oufu.fucount, prou.prcount, peou.pecount from cl.orgunits ou
left join (select orgunit_id,count(*) as clcount from cl.orgunit_class group by orgunit_id) as clou on clou.orgunit_id=ou.id
left join (select orgunit_id,count(*) as fucount, sum(amount) as amount from cl.orgunit_funding group by orgunit_id) as oufu on oufu.orgunit_id=ou.id
left join (select orgunit_id,count(*) as prcount from cl.project_orgunit group by orgunit_id) as prou on prou.orgunit_id=ou.id
left join (select orgunit_id,count(*) as pecount from cl.person_orgunit group by orgunit_id) as peou on peou.orgunit_id=ou.id;

### Extract
select s.id, s.origid as source_name, tmp.all, tmp.withBudget, tmp.withClassifications, tmp.withProjects, tmp.withPeople, tmp.withOrgunits from  cl.sources s
left join (select source_id, count(*) as all, count(hasBudget) as withBudget, count (nbClassifications) as withClassifications, count(nbProjects) as withProjects, count(nbPeople) as withPeople, count(nbOrgunits) as withOrgunits 
from stats.fundings group by source_id order by source_id) as tmp on tmp.source_id=s.id order by s.id;

select s.id, s.origid as source_name, tmp.all, tmp.withAbstract, tmp.withBudget, tmp.withDates, tmp.withClassifications, tmp.withFundings, tmp.withPeople, tmp.withOrgunits from cl.sources s
left join (select source_id, count(*) as all, count(hasAbstract) as withAbstract, count(hasBudget) as withBudget, count(hasDates) as withDates,
count (nbClassifications) as withClassifications, count(nbFundings) as withFundings, count(nbPeople) as withPeople, count(nbOrgunits) as withOrgunits 
from stats.projects group by source_id order by source_id) as tmp on tmp.source_id= s.id order by s.id;

select s.id, s.origid as source_name, tmp.all, tmp.withClassifications, tmp.withProjects, tmp.withOrgunits from cl.sources s
left join (select source_id, count(*) as all, count (nbClassifications) as withClassifications, count(nbProjects) as withProjects, count(nbOrgunits) as withOrgunits 
from stats.people group by source_id order by source_id) as tmp on tmp.source_id= s.id order by s.id;

select s.id, s.origid as source_name, tmp.all, tmp.fundingOrgunits, tmp.withClassifications, tmp.withFundings, tmp.withProjects, tmp.withPeople from cl.sources s
left join (select source_id, count(*) as all, count(isFunding) as fundingOrgunits, count (nbClassifications) as withClassifications, 
count(nbFundings) as withFundings, count(nbProjects) as withProjects, count(nbPeople) as withPeople 
from stats.orgunits group by source_id order by source_id) as tmp on tmp.source_id=s.id order by s.id;

---more stats on budget granted to project by fundingProgramme
select source_id, currency,   sum(amount), avg(amount), min (amount), max(amount), count(*) from cl.project_funding where amount > 0
group by source_id, currency order by funding_id;

select source_id, currency,   sum(amount), avg(amount), min (amount), max(amount), count(*) from cl.project_funding where amount > 0
group by source_id, currency order by source_id;

select c.code, currency,sum(amount),avg(amount), min (amount), max(amount), count(*) from 
(select currency, amount, c.id as country_id from cl.project_funding pf 
left join cl.sources s on s.id= pf.source_id
left join cl.countries c on c.id=s.country_id
where amount > 0) as tmp
left join cl.countries c on c.id=tmp.country_id
group by tmp.country_id, c.code, currency order by country_id;
