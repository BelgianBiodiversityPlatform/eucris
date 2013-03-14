alter table cl.fundings add column trash boolean default false;
alter table cl.projects add column trash boolean default false;
alter table cl.people add column trash boolean default false;
alter table cl.orgunits add column trash boolean default false ;

### flag things to be removed(see below)

select distinct source_id from cl.fundings where trash;
select distinct source_id from cl.projects where trash;
select distinct source_id from cl.people where trash;
select distinct source_id from cl.orgunits where trash;

### then start to delete trashed objects
delete from cl.funding_class where funding_id in (select id from cl.fundings where trash=true);
delete from cl.orgunit_class where orgunit_id in (select id from cl.orgunits where trash=true);
delete from cl.person_class where person_id in (select id from cl.people where trash=true);
delete from cl.project_class where project_id in (select id from cl.projects where trash=true);

delete from cl.project_funding where project_id in (select id from cl.projects where trash=true) ;
delete from cl.project_orgunit where project_id in (select id from cl.projects where trash=true) ;
delete from cl.project_person where project_id in (select id from cl.projects where trash=true) ;
delete from cl.person_orgunit where person_id in (select id from cl.people where trash=true) ;
delete from cl.person_orgunit where orgunit_id in (select id from cl.orgunits where trash=true) ;
delete from cl.orgunit_funding where orgunit_id in (select id from cl.orgunits where trash=true) ;
delete from cl.orgunit_funding where funding_id in (select id from cl.fundings where trash=true) ;
delete from cl.project_project where project1_id in (select id from cl.projects where trash=true) ;
delete from cl.project_project where project2_id in (select id from cl.projects where trash=true) ;
delete from cl.orgunit_orgunit where orgunit1_id in (select id from cl.orgunits where trash=true) ;
delete from cl.orgunit_orgunit where orgunit2_id in (select id from cl.orgunits where trash=true) ;

delete from cl.fundings where trash=true ;
delete from cl.projects where trash=true ;
delete from cl.orgunits where trash=true ;
delete from cl.people where trash=true;


alter table cl.fundings drop column trash;
alter table cl.projects drop column trash;
alter table cl.people drop column trash;
alter table cl.orgunits drop column trash;

###
update cl.fundings set trash=true where id in (597);
update cl.projects set trash=true where id in (select project_id from cl.project_funding where funding_id in (597) and source_id=10);
update cl.people set trash=true where id in 
	(select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=true and pp.source_id= 10
			except select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=false and pp.source_id=10) 
update cl.orgunits set trash=true where id in 
	(select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=true and po.source_id= 10
			except select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=false and po.source_id= 10) 

###Belspo cleaning 01/03/2013
update cl.projects set trash=true where id > 14379 and id < 14414 and source_id=2;

update cl.people set trash=true where id in 
			(select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=true and pp.source_id= 2
					except select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=false and pp.source_id=2) 
update cl.orgunits set trash=true where id in 
			(select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=true and po.source_id= 2
					except select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=false and po.source_id= 2) 

###VM cleaning 01/03/2013
select * from cl.fundings where source_id=25 order by name;
update cl.fundings set trash=true where source_id=25 and id in (479, 489, 503, 468, 470, 474, 553, 476, 565, 486, 497, 517, 536, 555, 472);
update cl.projects set trash=true where id in 
				(select distinct project_id from cl.project_funding pf left join cl.fundings f on f.id=pf.funding_id where f.trash=true and pf.source_id= 25
						except select distinct project_id from cl.project_funding pf left join cl.fundings f on f.id=pf.funding_id where f.trash=false and pf.source_id= 25) 
update cl.orgunits set trash=true where id in 
				(select distinct orgunit_id from cl.orgunit_funding of left join cl.fundings f on f.id=of.funding_id where f.trash=true and of.source_id= 25
						except select distinct orgunit_id from cl.orgunit_funding of left join cl.fundings f on f.id=of.funding_id where f.trash=false and of.source_id= 25) 
update cl.people set trash=true where id in 
			(select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=true and pp.source_id= 25
					except select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=false and pp.source_id=25) 
update cl.orgunits set trash=true where id in 
			(select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=true and po.source_id= 25
					except select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=false and po.source_id= 25) 

### NERC cleaning 01/03/2013
### APPRAISE, ARCTIC IPY, BIOREMEDIATION LINK, CAPITAL EQUIPMENT, CHANGING WATER CYCLE, 1st entry of EO ENABLING FUND, ES4 SUMMERSCHOOL, FREE, JREI (Joint Research Equipment Initiative), 
#NOT (2 separate entries), TECHNOLOGY CLUSTERS, TSEC,  UKERC
update cl.fundings set trash=true where source_id=18 and id in (757, 728, 762, 799, 758, 715, 724, 756, 792, 785, 773, 768, 775, 789);
update cl.projects set trash=true where id in 
				(select distinct project_id from cl.project_funding pf left join cl.fundings f on f.id=pf.funding_id where f.trash=true and pf.source_id= 18
						except select distinct project_id from cl.project_funding pf left join cl.fundings f on f.id=pf.funding_id where f.trash=false and pf.source_id= 18) ;
update cl.orgunits set trash=true where id in 
				(select distinct orgunit_id from cl.orgunit_funding of left join cl.fundings f on f.id=of.funding_id where f.trash=true and of.source_id= 18
						except select distinct orgunit_id from cl.orgunit_funding of left join cl.fundings f on f.id=of.funding_id where f.trash=false and of.source_id= 18) ;
update cl.people set trash=true where id in 
			(select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=true and pp.source_id= 18
					except select distinct person_id from cl.project_person pp left join cl.projects p on p.id=pp.project_id where p.trash=false and pp.source_id=18) ;
update cl.orgunits set trash=true where id in 
			(select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=true and po.source_id= 18
					except select distinct orgunit_id from cl.project_orgunit po left join cl.projects p on p.id=po.project_id where p.trash=false and po.source_id= 18); 

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


###remove FPs amount

update cl.fundings set amount=null where source_id=18;
select * from cl.fundings where source_id=18;