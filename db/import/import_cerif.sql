

INSERT INTO cl.countries( code, name) (
	SELECT upper(countrycode), countryname from cris_country order by countrycode
);

INSERT INTO cl.sources (origid, acronym,country_id,name, description) (
	SELECT lower(s.origid), s.origid, c.id, s.name, s.description 
	from sources s
	left join cl.countries c on c.code=s.countrycode
	order by origid
);


---orgunits
INSERT INTO cl.orgunits (origid, acronym, url, name , fax, tel, email, 
		addrline1,addrline2, addrline3, addrline4, addrline5, postcode, city, startdate, enddate, activity, keywords, 
		source_id, created_at)(
	SELECT ou.cforgunitid, ou.cfacro, ou.cfuri, name.cfname, eafax.cfuri,eatel.cfuri, eaemail.cfuri, 
		paddr.cfaddrline1, paddr.cfaddrline2, paddr.cfaddrline3, paddr.cfaddrline4, paddr.cfaddrline5,paddr.cfpostcode, paddr.cfcitytown,
		addr.cfstartdate, addr.cfenddate, resact.cfresact, keywords.cfkeyw, source.id, now()
	from cforgunit ou
	left join cforgunitname name on name.cforgunitid=ou.cforgunitid and name.cflangcode='EN' and name.cftrans='o'
	left join cforgunitresact resact on resact.cforgunitid=ou.cforgunitid and resact.cflangcode='EN' and resact.cftrans='o'
	left join cforgunitkeyw keywords on keywords.cforgunitid=ou.cforgunitid and keywords.cflangcode='EN' and keywords.cftrans='o'
	left join cforgunit_eaddr fax on fax.cforgunitid=ou.cforgunitid and fax.cfclassid='FAX'
	left join cfeaddr eafax on eafax.cfeaddrid = fax.cfeaddrid
	left join cforgunit_eaddr tel on tel.cforgunitid=ou.cforgunitid and tel.cfclassid='TEL'
	left join cfeaddr eatel on eatel.cfeaddrid = tel.cfeaddrid
	left join cforgunit_eaddr email on email.cforgunitid=ou.cforgunitid and email.cfclassid='EMAIL'
	left join cfeaddr eaemail on eaemail.cfeaddrid = email.cfeaddrid
	left join cforgunit_paddr addr on addr.cforgunitid=ou.cforgunitid and addr.cfclassid='PADDR'
	left join cfpaddr paddr on paddr.cfpaddrid = addr.cfpaddrid
	left join cl.sources source on upper(source.origid) = upper(split_part(ou.cforgunitid, '|', 1))
	order by cforgunitid
);


---projects
INSERT INTO cl.projects (origid, acronym, url, startdate,enddate,title,abstract, keywords, 
	source_id, created_at)(
	SELECT pr.cfprojid, pr.cfacro, pr.cfuri, pr.cfstartdate, pr.cfenddate, title.cftitle, abstr.cfabstr, keyw.cfkeyw, source.id, now()
	from cfproj pr
	left join cfprojtitle title on title.cfprojid=pr.cfprojid and title.cflangcode='EN' and title.cftrans='o'
	left join cfprojabstr abstr on abstr.cfprojid=pr.cfprojid and abstr.cflangcode='EN' and abstr.cftrans='o'
	left join cfprojkeyw keyw on keyw.cfprojid=pr.cfprojid and keyw.cflangcode='EN' and keyw.cftrans='o'
	left join cl.sources source on upper(source.origid) = upper(split_part(pr.cfprojid, '|', 1))
	order by cfprojid
);


---people
INSERT INTO cl.people(origid , gender, birthdate, url, familyname, firstname, fax, tel, email, 
	source_id, created_at)(
	SELECT pe.cfpersid, pe.cfgender, pe.cfbirthdate, pe.cfuri, pn.cffamilynames, pn.cffirstnames,
	eafax.cfuri, eatel.cfuri, eaemail.cfuri, source.id, now()
	from cfpers pe
	left join cfpersname pn on pn.cfpersid = pe.cfpersid
	left join cfpers_eaddr fax on fax.cfpersid= pe.cfpersid and fax.cfclassid='FAX'
	left join cfeaddr eafax on eafax.cfeaddrid = fax.cfeaddrid
	left join cfpers_eaddr tel on tel.cfpersid= pe.cfpersid and tel.cfclassid='TEL'
	left join cfeaddr eatel on eatel.cfeaddrid = tel.cfeaddrid
	left join cfpers_eaddr email on email.cfpersid= pe.cfpersid and email.cfclassid='EMAIL'
	left join cfeaddr eaemail on eaemail.cfeaddrid = email.cfeaddrid
	left join cl.sources source on upper(source.origid) = upper(split_part(pe.cfpersid, '|', 1))
	order by cfpersid
);

---fundings
INSERT INTO cl.fundings(origid, startdate, enddate, amount , currency, url, name , description, keywords, 
	source_id, created_at)(
	SELECT fu.cffundid, fu.cfstartdate, fu.cfenddate, fu.cfamount, fu.cfcurrcode, fu.cfuri,
	name.cfname, descr.cfdescr, keyw.cfkeyw, source.id, now()
	from cffund fu
	left join cffundname name on name.cffundid=fu.cffundid and name.cflangcode='EN' and name.cftrans='o'
	left join cffunddescr descr on descr.cffundid=fu.cffundid and descr.cflangcode='EN' and descr.cftrans='o'
	left join cffundkeyw keyw on keyw.cffundid=fu.cffundid and keyw.cflangcode='EN' and keyw.cftrans='o'
	left join cl.sources source on upper(source.origid) = upper(split_part(fu.cffundid, '|', 1))
	order by cffundid
);


INSERT INTO cl.classschemes(origid, description, created_at) (
	SELECT cs.cfclassschemeid, csd.cfdescr, now()
	from cfclassscheme cs
	left join cfclassschemedescr csd on csd.cfclassschemeid=cs.cfclassschemeid and csd.cflangcode='EN' and csd.cftrans='o'
	order by cfclassschemeid
);

INSERT INTO cl.classifications(origid,schemeorigid, classscheme_id, term, description, created_at) (
	SELECT c.cfclassid, c.cfclassschemeid, scheme.id,term.cfterm, descr.cfdescr, now()
	from cfclass c
	left join cl.classschemes scheme on scheme.origid=c.cfclassschemeid
	left join cfclassterm term on term.cfclassid=c.cfclassid and term.cfclassschemeid=c.cfclassschemeid and term.cflangcode='EN' and term.cftrans='o'
	left join cfclassdescr descr on descr.cfclassid=c.cfclassid and descr.cfclassschemeid=c.cfclassschemeid and descr.cflangcode='EN' and descr.cftrans='o'
	order by c.cfclassschemeid, c.cfclassid
);

UPDATE cl.classifications
	SET parent_id = tmp.parentid from 
	(select c.id as classid, p.id as parentid from cl.classifications c 
		left join cfclass_class cc on cc.cfclassschemeid2=c.schemeorigid and cc.cfclassid2=c.origid
		left join cl.classifications p on p.origid=cc.cfclassid1 and p.schemeorigid = cc.cfclassschemeid1) as tmp
	where id=tmp.classid
;


INSERT INTO cl.funding_class (funding_id, classification_id, source_id, created_at)
	SELECT fund.id, class.id, fund.source_id, now()
	from cffund_class link
	join cl.fundings fund on fund.origid= link.cffundid
	join cl.classifications class on class.origid= link.cfclassid and class.schemeorigid= link.cfclassschemeid
;


INSERT INTO cl.orgunit_class (orgunit_id, classification_id, source_id, created_at)
	SELECT orgunit.id, class.id, orgunit.source_id, now()
	from cforgunit_class link
	join cl.orgunits orgunit on orgunit.origid=link.cforgunitid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.person_class (person_id, classification_id, source_id, created_at)
	SELECT person.id, class.id, person.source_id, now()
	from cfpers_class link
	join cl.people person on person.origid=link.cfpersid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.project_class (project_id, classification_id, source_id, created_at)
	SELECT project.id, class.id, project.source_id, now()
	from cfproj_class link
	join cl.projects project on project.origid=link.cfprojid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.funding_funding(funding1_id,funding2_id, classification_id, startdate, enddate, source_id, created_at)
	SELECT f1.id, f2.id, class.id, link.cfstartdate, link.cfenddate, f1.source_id, now()
	from cffund_fund link
	join cl.fundings f1 on f1.origid=link.cffundid1
	join cl.fundings f2 on f2.origid=link.cffundid2
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.orgunit_funding(orgunit_id, funding_id, classification_id, startdate, enddate, amount, currency, source_id, created_at)
	SELECT o.id, f.id, class.id, link.cfstartdate, link.cfenddate, link.cfamount, link.cfcurrcode, o.source_id, now()
	from cforgunit_fund link
	join cl.orgunits o on o.origid=link.cforgunitid
	join cl.fundings f on f.origid=link.cffundid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.orgunit_orgunit(orgunit1_id,orgunit2_id, classification_id, startdate, enddate, source_id, created_at)
	SELECT o1.id, o2.id, class.id, link.cfstartdate, link.cfenddate, o1.source_id, now()
	from cforgunit_orgunit link
	join cl.orgunits o1 on o1.origid=link.cforgunitid1
	join cl.orgunits o2 on o2.origid=link.cforgunitid2
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.person_funding(person_id, funding_id, classification_id, startdate, enddate, amount, currency, source_id, created_at)
	SELECT p.id, f.id, class.id, link.cfstartdate, link.cfenddate, link.cfamount, link.cfcurrcode, p.source_id, now()
	from cfpers_fund link
	join cl.people p on p.origid=link.cfpersid
	join cl.fundings f on f.origid=link.cffundid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.person_orgunit(person_id, orgunit_id, classification_id, startdate, enddate, source_id, created_at)
	SELECT p.id, o.id, class.id, link.cfstartdate, link.cfenddate, p.source_id, now()
	from cfpers_orgunit link
	join cl.people p on p.origid=link.cfpersid
	join cl.orgunits o on o.origid=link.cforgunitid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;
INSERT INTO cl.person_person(person1_id, person2_id, classification_id, startdate, enddate, source_id,created_at)
	SELECT p1.id, p2.id, class.id, link.cfstartdate, link.cfenddate, p1.source_id, now()
	from cfpers_pers link
	join cl.people p1 on p1.origid=link.cfpersid1
	join cl.people p2 on p2.origid=link.cfpersid2
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.project_funding(project_id, funding_id, classification_id, startdate, enddate, amount, currency, source_id, created_at)
	SELECT p.id, f.id, class.id, link.cfstartdate, link.cfenddate, link.cfamount, link.cfcurrcode, p.source_id, now()
	from cfproj_fund link
	join cl.projects p on p.origid=link.cfprojid
	join cl.fundings f on f.origid=link.cffundid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.project_orgunit(project_id, orgunit_id, classification_id, startdate, enddate, source_id, created_at)
	SELECT p.id, o.id, class.id, link.cfstartdate, link.cfenddate, p.source_id, now()
	from cfproj_orgunit link
	join cl.projects p on p.origid=link.cfprojid
	join cl.orgunits o on o.origid=link.cforgunitid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.project_person(project_id, person_id, classification_id, startdate, enddate, source_id,created_at)
	SELECT pr.id, pe.id, class.id, link.cfstartdate, link.cfenddate, pr.source_id, now()
	from cfproj_pers link
	join cl.projects pr on pr.origid=link.cfprojid
	join cl.people pe on pe.origid=link.cfpersid
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

INSERT INTO cl.project_project(project1_id,project2_id, classification_id, startdate, enddate, source_id,created_at)
	SELECT p1.id, p2.id, class.id, link.cfstartdate, link.cfenddate, p1.source_id, now()
	from cfproj_proj link
	join cl.projects p1 on p1.origid=link.cfprojid1
	join cl.projects p2 on p2.origid=link.cfprojid2
	join cl.classifications class on class.origid=link.cfclassid and class.schemeorigid=link.cfclassschemeid
;

