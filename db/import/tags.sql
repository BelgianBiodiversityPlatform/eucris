-- DROP TABLE cl.tags CASCADE;
create table cl.tags(
	id 			serial primary key,
	tag			varchar(255),
	fucount 	integer,
	prcount 	integer,
	pecount		integer,
	oucount		integer
);

--- from classifications
insert into cl.tags (tag) 	
		
	select distinct cl.term from	
	(select id from (select classification_id as id, count(*) as count from cl.funding_class  group by classification_id
	union select classification_id, count(*) as count from cl.project_class  group by classification_id
	) as tags
	order by count desc limit 200) as ids
	left join cl.classifications cl on cl.id=ids.id
	order by term ;
	