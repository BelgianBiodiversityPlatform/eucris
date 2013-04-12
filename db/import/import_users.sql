---drop table cris_country;
create table cris_country(
	id integer primary key,
	countryname varchar(200),
		countrycode	char(2)
);
COPY cris_country FROM '/home/aheugheb/db2/biodiversa/cris_country.csv' NULL as '' DELIMITER ';' HEADER CSV;

---drop table sources;
create table sources(
	origid	varchar(128) unique,
	countrycode	char(2),
	name varchar(200),
	description text
);
COPY sources FROM '/home/aheugheb/db2/biodiversa/Sources.csv' NULL as '' DELIMITER ';' HEADER CSV;
---	SELECT distinct(split_part(cforgunitid, '|', 1) ) as source from cforgunit	UNION
---	SELECT distinct(split_part(cffundid, '|', 1) ) as source from cffund	UNION
---	SELECT distinct(split_part(cfprojid, '|', 1) ) as source from cfproj	UNION
---	SELECT distinct(split_part(cfpersid, '|', 1) ) as source from cfpers order by source
INSERT INTO cl.sources(origid, url, acronym, name, description, country_id) values 
('self','http://www.biodiversa.org/','BiodivERsA','BiodivERsA', 
	'Funded under the FP7 European Research Area Programme(ERA-NET), BiodivERsA works with a network of 21 national funding agencies in 15 countries.',
	247);



INSERT INTO cl.roles(code,name)(
	SELECT distinct on (r.abbreviaton) r.abbreviaton, r.rolefull from rnx_role r
);
INSERT INTO cl.users (origid, login, familyname, firstname, email, url, startdate, enddate,
	admin, blocked, password) (

		SELECT u.userid::text, u.username, u.familynames, u.firstnames, u.email, u.uri, u.startdate, u.enddate, 
		false, (u.status!='A')::boolean, u.password
		from rnx_user u
		order by u.userid

);
INSERT INTO cl.user_source(user_id, source_id, role_id)(
	SELECT u.id, s.id, r.id 
	from rnx_usermandatoryrole rumr
	left join cl.users u on u.origid=rumr.userid::text
	left join rnx_mandatory rm on rm.mandatoryid = rumr.mandatoryid
	left join cl.sources s on upper(s.origid)=upper(btrim(rm.abbreviation, ' '))
	left join rnx_role rr on rr.roleid = rumr.roleid
	left join cl.roles r on r.code = rr.abbreviaton
);


select u.familyname, u.firstname, tmp.sources from
(select u.id as userid, array_accum(s.origid) as sources from cl.user_source us
	left join cl.users u on u.id=us.user_id
	left join cl.sources s on s.id=us.source_id
group by u.id) as tmp
left join cl.users u on u.id=tmp.userid
order by familyname, firstname;

