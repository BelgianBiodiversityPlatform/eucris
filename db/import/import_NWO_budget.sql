---drop table nwo_projects;
create table nwo_projects(
	id 			integer primary key,
	origid 		varchar(128) unique,
	startdate	date,
	enddate		date,
	amount		integer,
	title		text
);
set datestyle='DMY';
COPY nwo_projects FROM '/home/aheugheb/db2/biodiversa/NWOProjects.csv' NULL as '' DELIMITER ';' HEADER CSV;


update cl.projects  set amount=np.amount from nwo_projects np where projects.id= np.id;
update cl.projects set amount=null where amount=0;
select * from cl.projects where id in (select id from nwo_projects);