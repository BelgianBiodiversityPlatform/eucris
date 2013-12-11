
delete from cl.person_orgunit where source_id=11;
delete from cl.project_person where source_id=11;
delete from cl.project_funding where source_id=11;
delete from cl.project_orgunit where source_id=11;
delete from cl.orgunit_funding where source_id=11;
delete from cl.person_funding where source_id=11;
delete from cl.funding_funding where source_id=11;
delete from cl.orgunit_class where source_id=11;
delete from cl.project_class where source_id=11;
delete from cl.person_class where source_id=11;
delete from cl.funding_class where funding_id in (select id from cl.fundings where source_id=11);

delete from cl.orgunits where source_id=11;
delete from cl.projects where source_id=11;
delete from cl.people where source_id=11;	
delete from cl.fundings where source_id=11;
	

--- full import 14/02/13
---fundings
INSERT INTO cl.fundings(origid, startdate, enddate, amount , currency, url, name , description, keywords, source_id, created_at)(
	SELECT s.origid || '|' || fu.fuID as origid, fu.StartDate, fu.EndDate, fu.Budget, fu.Currency, fu.URL,
	fu.Name, fu.Description, fu.Keywords, fu.Source, now()
	from xls.fu fu
	left join cl.sources s on s.id=fu.Source

	order by fu.Line
);
---projects
INSERT INTO cl.projects (origid,  url, acronym, startdate,enddate,amount, currency,title,abstract, keywords, source_id, created_at)(
	SELECT s.origid || '|' || pr.prID as origid, pr.URL, pr.acronym,  pr.StartDate, pr.EndDate, pr.Budget, pr.Currency, pr.Title, pr.Abstract, pr.Keywords, pr.Source, now()
	from xls.pr pr
	left join cl.sources s on s.id=pr.Source
	order by pr.Line
);
---orgunits
INSERT INTO cl.orgunits (origid, acronym, url, name , fax, tel, email, addrline1, postcode, city, activity, keywords, source_id, created_at)(
	SELECT s.origid || '|' || ou.ouID as origid, ou.Acronym, ou.URL, ou.Name, ou.Fax, ou.Tel, ou.Email, ou.Address, ou.ZipCode, ou.City, ou.Activity, ou.Keywords, ou.Source, now()
		from xls.ou ou
		left join cl.sources s on s.id=ou.Source
		order by ou.Line
);

---people
INSERT INTO cl.people(origid , url, familyname, firstname, fax, tel, email, source_id, created_at)(
	SELECT  s.origid || '|' || pe.peID as origid, pe.URL, pe.LastName, pe.FirstName, pe.Fax, pe.Tel, pe.email, pe.Source, now()
	from xls.pe pe
	left join cl.sources s on s.id=pe.Source
	order by pe.Line
);


INSERT INTO cl.person_orgunit(person_id, orgunit_id, classification_id, startdate, enddate, source_id, created_at)
	SELECT p.id, o.id, class.id, link.StartDate, link.EndDate, p.source_id, now()
	from xls.pe_ou link
	join cl.sources s on s.id=link.Source
	join cl.people p on p.origid=s.origid || '|' || link.peID
	join cl.orgunits o on o.origid= s.origid || '|' || link.ouID
	join cl.classifications class on class.origid='PERSON-ORGUNIT-TeamMember' and class.schemeorigid='LinkRoles'
	order by link.Line
;
INSERT INTO cl.project_person(person_id, project_id, classification_id, startdate, enddate, source_id, created_at)
	SELECT pe.id, pr.id, class.id, link.StartDate, link.EndDate, pe.source_id, now()
	from xls.pe_pr link
	join cl.sources s on s.id=link.Source
	join cl.people pe on pe.origid=s.origid || '|' || link.peID
	join cl.projects pr on pr.origid= s.origid || '|' || link.prID
	join cl.classifications class on class.origid='PROJECT-PERSON-MEMBER' and class.schemeorigid='LinkRoles'
	order by link.Line
;

INSERT INTO cl.project_funding(project_id, funding_id, classification_id, startdate, enddate, amount, currency, source_id, created_at)
	SELECT pr.id, fu.id, class.id, link.StartDate, link.EndDate, link.Amount, link.Currency, pr.source_id, now()
	from xls.pr_fu link
	join cl.sources s on s.id=link.Source
	join cl.projects pr on pr.origid= s.origid || '|' || link.prID
	join cl.fundings fu on fu.origid= s.origid || '|' || link.fuID
	join cl.classifications class on class.origid='PROJECT-FUNDING-GRANT' and class.schemeorigid='LinkRoles'
	order by link.Line
;

INSERT INTO cl.project_orgunit(project_id, orgunit_id, classification_id, startdate, enddate,  source_id, created_at)
	SELECT pr.id, ou.id, class.id, link.StartDate, link.EndDate, pr.source_id, now()
	from xls.pr_ou link
	join cl.sources s on s.id=link.Source
	join cl.projects pr on pr.origid= s.origid || '|' || link.prID
	join cl.orgunits ou on ou.origid= s.origid || '|' || link.ouID
	join cl.classifications class on class.origid='PROJECT-ORGUNIT-LeadPartner' and class.schemeorigid='LinkRoles'
	order by link.Line
;
INSERT INTO cl.orgunit_funding(orgunit_id, funding_id, classification_id, startdate, enddate, amount, currency, source_id, created_at)
	SELECT ou.id, fu.id, class.id, link.StartDate, link.EndDate, link.Amount, link.Currency, ou.source_id, now()
	from xls.ou_fu link
	join cl.sources s on s.id=link.Source
	join cl.orgunits ou on ou.origid= s.origid || '|' || link.ouID
	join cl.fundings fu on fu.origid= s.origid || '|' || link.fuID
	join cl.classifications class on class.origid='FUNDING-ORGUNIT-LEADING' and class.schemeorigid='LinkRoles'
	order by link.Line
;

update cl.orgunits ou  set isFunding=true
	from (select orgunit_id from cl.orgunit_funding where source_id=11) as tmp
	where ou.id = tmp.orgunit_id;


UPDATE cl.sources set updated_at=now() where id=11;
update cl.sources source set 
fucount= (select count(*) as count from cl.fundings where source_id=11), 
prcount= (select count(*) as count from cl.projects where source_id=11), 
oucount= (select count(*) as count from cl.orgunits where source_id=11), 
focount= (select count(*) as count from cl.orgunits where source_id=11 and isFunding=true), 
rocount= (select count(*) as count from cl.orgunits where source_id=11 and isFunding=false), 
pecount= (select count(*) as count from cl.people where source_id=11), 
updated_at=now()
where id=11;

UPDATE cl.sources set count=fucount+prcount+oucount+pecount where id=11;

