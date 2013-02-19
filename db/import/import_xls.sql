--- incremental import 13/12/11
---0/fix import: btrim IDs
update xls.fu set fuID=btrim(fuID);
update xls.pr set prID=btrim(prID);
update xls.ou set ouID=btrim(ouID);
update xls.pe set peID=btrim(peID);

update xls.pe_ou set peID=btrim(peID), ouID=btrim(ouID);
update xls.pe_pr set peID=btrim(peID), prID=btrim(prID);
update xls.pr_fu set prID=btrim(prID), fuID=btrim(fuID);
update xls.pr_ou set prID=btrim(prID), ouID=btrim(ouID);
update xls.ou_fu set ouID=btrim(ouID), fuID=btrim(fuID);

---1/flag all new objects,


alter table xls.fu add column new boolean default true;
alter table xls.pr add column new boolean default true;
alter table xls.pe add column new boolean default true;
alter table xls.ou add column new boolean default true;
alter table xls.pe_pr add column new boolean default true;
alter table xls.pe_ou add column new boolean default true;
alter table xls.pr_fu add column new boolean default true;
alter table xls.pr_ou add column new boolean default true;
alter table xls.ou_fu add column new boolean default true;

update xls.fu xls set new=false 
from (select xls.fuID from xls.fu xls 
join cl.Sources s on s.id=xls.source
join cl.Fundings f on f.origid= s.origid || '|' || xls.fuID) as tmp
where xls.fuID=tmp.fuID;


update xls.pr xls set new=false 
from (select xls.prID from xls.pr xls 
join cl.Sources s on s.id=xls.source
join cl.Projects p on p.origid= s.origid || '|' || xls.prID) as tmp
where xls.prID=tmp.prID;


update xls.ou xls set new=false 
from (select xls.ouID from xls.ou xls 
join cl.Sources s on s.id=xls.source
join cl.Orgunits o on o.origid= s.origid || '|' || xls.ouID) as tmp
where xls.ouID=tmp.ouID;


update xls.pe xls set new=false 
from (select xls.peID from xls.pe xls 
join cl.Sources s on s.id=xls.source
join cl.People p on p.origid= s.origid || '|' || xls.peID) as tmp
where xls.peID=tmp.peID;



---2/insert new objects
---fundings
INSERT INTO cl.fundings(origid, startdate, enddate, amount , currency, url, name , description, keywords, source_id, created_at)(
	SELECT s.origid || '|' || fu.fuID, fu.StartDate, fu.EndDate, fu.Budget, fu.Currency, fu.URL,
	fu.Name, fu.Description, fu.Keywords, fu.Source, now()
	from xls.fu fu
	left join cl.sources s on s.id=fu.Source
	where fu.new=true 
	order by fu.Line
);

---projects
INSERT INTO cl.projects (origid, acronym, url, startdate,enddate,title,abstract, keywords, source_id, created_at)(
	SELECT s.origid || '|' || pr.prID, 
		pr.Acronym, pr.URL, pr.StartDate, pr.EndDate, pr.Title, pr.Abstract, pr.Keywords, pr.Source, now()
	from xls.pr pr
	left join cl.sources s on s.id=pr.Source
	where  pr.new=true
	order by pr.Line
);

---orgunits
INSERT INTO cl.orgunits (origid, acronym, url, name , fax, tel, email, addrline1, postcode, city, activity, keywords, source_id, created_at)(
	SELECT s.origid || '|' || ou.ouID as origid, 
		ou.Acronym, ou.URL, ou.Name, ou.Fax, ou.Tel, ou.Email, ou.Address, ou.ZipCode, ou.City, ou.Activity, ou.Keywords, ou.Source, now()
		from xls.ou ou
		left join cl.sources s on s.id=ou.Source
		where  ou.new=true
		order by ou.Line
);

---people
INSERT INTO cl.people(origid , url, familyname, firstname, fax, tel, email, source_id, created_at)(
	SELECT  s.origid || '|' || pe.peID, pe.URL, pe.LastName, pe.FirstName, pe.Fax, pe.Tel, pe.email, pe.Source, now()
	from xls.pe pe
	left join cl.sources s on s.id=pe.Source
		where  pe.new=true
	order by pe.Line
);

---3/flag all  new links
update xls.pe_ou xls set new=false 
from (select xls.peID, xls.ouID from xls.pe_ou xls 
join cl.Sources s on s.id=xls.source
join cl.people pe on pe.origid=s.origid || '|' || xls.peID
join cl.orgunits ou on ou.origid=s.origid || '|' || xls.ouID
join cl.person_orgunit po on po.person_id= pe.id and po.orgunit_id=ou.id) as tmp
where xls.peID=tmp.peID and xls.ouID=tmp.ouID;

update xls.pe_pr xls set new=false 
from (select xls.peID, xls.prID from xls.pe_pr xls 
join cl.Sources s on s.id=xls.source
join cl.people pe on pe.origid=s.origid || '|' || xls.peID
join cl.projects pr on pr.origid=s.origid || '|' || xls.prID
join cl.project_person pp on pp.person_id= pe.id and pp.project_id=pr.id) as tmp
where xls.peID=tmp.peID and xls.prID=tmp.prID;

update xls.pr_fu xls set new=false 
from (select xls.prID, xls.fuID from xls.pr_fu xls 
join cl.Sources s on s.id=xls.source
join cl.fundings fu on fu.origid=s.origid || '|' || xls.fuID
join cl.projects pr on pr.origid=s.origid || '|' || xls.prID
join cl.project_funding pf on pf.project_id= pr.id and pf.funding_id=fu.id) as tmp
where xls.prID=tmp.prID and xls.fuID=tmp.fuID;

update xls.pr_ou xls set new=false 
from (select xls.prID, xls.ouID from xls.pr_ou xls 
join cl.Sources s on s.id=xls.source
join cl.orgunits ou on ou.origid=s.origid || '|' || xls.ouID
join cl.projects pr on pr.origid=s.origid || '|' || xls.prID
join cl.project_orgunit po on po.project_id= pr.id and po.orgunit_id=ou.id) as tmp
where xls.prID=tmp.prID and xls.ouID=tmp.ouID;

update xls.ou_fu xls set new=false 
from (select xls.ouID, xls.fuID from xls.ou_fu xls 
join cl.Sources s on s.id=xls.source
join cl.fundings fu on fu.origid=s.origid || '|' || xls.fuID
join cl.orgunits ou on ou.origid=s.origid || '|' || xls.ouID
join cl.orgunit_funding of on of.orgunit_id= ou.id and of.funding_id=fu.id) as tmp
where xls.ouID=tmp.ouID and xls.fuID=tmp.fuID;

---4/insert new links
INSERT INTO cl.person_orgunit(person_id, orgunit_id, classification_id, startdate, enddate, source_id)
	SELECT p.id, o.id, class.id, link.StartDate, link.EndDate, p.source_id
	from xls.pe_ou link
	join cl.sources s on s.id=link.Source
	join cl.people p on p.origid=s.origid || '|' || link.peID
	join cl.orgunits o on o.origid= s.origid || '|' || link.ouID
	join cl.classifications class on class.origid='PERSON-ORGUNIT-TeamMember' and class.schemeorigid='LinkRoles'
	where link.new=true
;

INSERT INTO cl.project_person(person_id, project_id, classification_id, startdate, enddate, source_id)
	SELECT pe.id, pr.id, class.id, link.StartDate, link.EndDate, pe.source_id
	from xls.pe_pr link
	join cl.sources s on s.id=link.Source
	join cl.people pe on pe.origid=s.origid || '|' || link.peID
	join cl.projects pr on pr.origid= s.origid || '|' || link.prID
	join cl.classifications class on class.origid='PROJECT-PERSON-MEMBER' and class.schemeorigid='LinkRoles'
	where link.new=true
;

INSERT INTO cl.project_funding(project_id, funding_id, classification_id, startdate, enddate, amount, currency, source_id)
	SELECT pr.id, fu.id, class.id, link.StartDate, link.EndDate, link.Amount, link.Currency, pr.source_id
	from xls.pr_fu link
	join cl.sources s on s.id=link.Source
	join cl.projects pr on pr.origid= s.origid || '|' || link.prID
	join cl.fundings fu on fu.origid= s.origid || '|' || link.fuID
	join cl.classifications class on class.origid='PROJECT-FUNDING-GRANT' and class.schemeorigid='LinkRoles'
	where link.new=true
;

INSERT INTO cl.project_orgunit(project_id, orgunit_id, classification_id, startdate, enddate,  source_id)
	SELECT pr.id, ou.id, class.id, link.StartDate, link.EndDate, pr.source_id
	from xls.pr_ou link
	join cl.sources s on s.id=link.Source
	join cl.projects pr on pr.origid= s.origid || '|' || link.prID
	join cl.orgunits ou on ou.origid= s.origid || '|' || link.ouID
	join cl.classifications class on class.origid='PROJECT-ORGUNIT-LeadPartner' and class.schemeorigid='LinkRoles'
	where link.new=true
;

INSERT INTO cl.orgunit_funding(orgunit_id, funding_id, classification_id, startdate, enddate, amount, currency, source_id)
	SELECT ou.id, fu.id, class.id, link.StartDate, link.EndDate, link.Amount, link.Currency, ou.source_id
	from xls.ou_fu link
	join cl.sources s on s.id=link.Source
	join cl.orgunits ou on ou.origid= s.origid || '|' || link.ouID
	join cl.fundings fu on fu.origid= s.origid || '|' || link.fuID
	join cl.classifications class on class.origid='FUNDING-ORGUNIT-LEADING' and class.schemeorigid='LinkRoles'
	where link.new=true
;

UPDATE cl.sources set updated_at=now() where id=9;
update cl.sources source set 
fucount= (select count(*) as count from cl.fundings where source_id=9), 
prcount= (select count(*) as count from cl.projects where source_id=9), 
oucount= (select count(*) as count from cl.orgunits where source_id=9), 
focount= (select count(*) as count from cl.orgunits where isFunding=true and source_id=9), 
rocount= (select count(*) as count from cl.orgunits where isFunding=false and source_id=9), 
pecount= (select count(*) as count from cl.people where source_id=9), 
updated_at=now()
where id=9;
UPDATE cl.sources set count=fucount+prcount+oucount+pecount where id=9;


