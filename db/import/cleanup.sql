alter table cl.fundings add column trash boolean default false;
alter table cl.projects add column trash boolean default false;
alter table cl.people add column trash boolean default false;
alter table cl.orgunits add column trash boolean default false ;

update cl.fundings set trash=true where id in (597);
update cl.projects set trash=true where id in (select project_id from cl.project_funding where funding_id in (597) and source_id=10);
update cl.people set trash=true where id in 
	(select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=true and pp.source_id= 10
			except select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=false and pp.source_id=10) 
update cl.orgunits set trash=true where id in 
	(select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=true and po.source_id= 10
			except select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=false and po.source_id= 10) 

delete from cl.funding_class where funding_id in (select id from cl.fundings where trash=true and source_id=10);
delete from cl.orgunit_class where orgunit_id in (select id from cl.orgunits where trash=true and source_id=10;
delete from cl.person_class where person_id in (select id from cl.people where trash=true and source_id=10);
delete from cl.project_class where project_id in (select id from cl.projects where trash=true and source_id=10);

delete from cl.project_funding where project_id in (select id from cl.projects where trash=true) and source_id=10;
delete from cl.project_orgunit where project_id in (select id from cl.projects where trash=true) and source_id=10;
delete from cl.project_person where project_id in (select id from cl.projects where trash=true) and source_id=10;

delete from cl.fundings where trash=true;
delete from cl.projects where trash=true;
delete from cl.orgunits where trash=true;
delete from cl.people where trash=true;


alter table cl.fundings drop column trash;
alter table cl.projects drop column trash;
alter table cl.people drop column trash;
alter table cl.orgunits drop column trash;



update cl.funding_funding set startdate=null where startdate='01-01-0001';
update cl.funding_funding set enddate=null where enddate='31-12-9999';
update cl.orgunit_funding set startdate=null where startdate='01-01-0001';
update cl.orgunit_funding set enddate=null where enddate='31-12-9999';
update cl.orgunit_orgunit set startdate=null where startdate='01-01-0001';
update cl.orgunit_orgunit set enddate=null where enddate='31-12-9999';
update cl.person_funding set startdate=null where startdate='01-01-0001';
update cl.person_funding set enddate=null where enddate='31-12-9999';
update cl.person_orgunit set startdate=null where startdate='01-01-0001';
update cl.person_orgunit set enddate=null where enddate='31-12-9999';
update cl.person_person set startdate=null where startdate='01-01-0001';
update cl.person_person set enddate=null where enddate='31-12-9999';
update cl.project_funding set startdate=null where startdate='01-01-0001';
update cl.project_funding set enddate=null where enddate='31-12-9999';
update cl.project_orgunit set startdate=null where startdate='01-01-0001';
update cl.project_orgunit set enddate=null where enddate='31-12-9999';
update cl.project_person set startdate=null where startdate='01-01-0001';
update cl.project_person set enddate=null where enddate='31-12-9999';
update cl.project_project set startdate=null where startdate='01-01-0001';
update cl.project_project set enddate=null where enddate='31-12-9999';
