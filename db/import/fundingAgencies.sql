---List all orgunits to see which one is funding organisation
select distinct on (ou.id) ou.id ,ou.name Orgunit, so.acronym as source, co.name as country , cl.term as FundingOrg, fu.id as FPID, fu.name as FPNAME
from cl.orgunits ou
left join cl.sources so on so.id= ou.source_id
left join cl.countries co on co.id= so.country_id
left join cl.orgunit_funding of on of.orgunit_id=ou.id
left join cl.fundings fu on fu.id = of.funding_id
left join cl.orgunit_class oc on oc.orgunit_id= ou.id and oc.classification_id = 785
left join cl.classifications cl on cl.id = oc.classification_id
order by ou.id;



---Orgunits can be researchOrganiZations or FundingOrganizations
--- to distinguish the two we added an isFunding boolean attribute
alter table cl.orgunits add column isFunding boolean default false;

--- Set isFunding flag when ou is classified as 'FundingOrganization'
update cl.orgunits ou set isFunding=true
	from (select  orgunit_id from cl.orgunit_class oc where oc.classification_id= 785) as tmp 
	where ou.id = tmp.orgunit_id;

--- Set isFunding flag when ou is linked to fundingProgramme(s)
update cl.orgunits ou  set isFunding=true
	from (select orgunit_id from cl.orgunit_funding) as tmp
	where ou.id = tmp.orgunit_id;
	
INSERT INTO cl.orgunits (origid, acronym, url, name ,  activity, source_id, isfunding, created_at) VALUES 
('anr|ANR', 'ANR','http://www.agence-nationale-recherche.fr/','National Agency for Research - Agence Nationale de la Recherche', 
	'ANR is a funding agency active in all fields of science. The agency publishes calls for research proposals in the field of biodiversity as part of its Ecosystem and sustainable development programme. The biodiversity part of the programme is managed by IFB.',
	27, true, now());
INSERT INTO cl.orgunit_funding(orgunit_id, funding_id, classification_id, source_id)
	SELECT 5879, fu.id, class.id, 27
	from cl.fundings fu
	join cl.classifications class on class.origid='FUNDING-ORGUNIT-MANAGER' and class.schemeorigid='LinkRoles'
	where fu.source_id=27
;

INSERT INTO cl.orgunits (origid, acronym, url, name ,  activity, source_id, isfunding, created_at) VALUES 
('belspo|BELSPO', 'BELSPO','http://www.belspo.be/','Federal Public planning Service - Science Policy', '',
	2, true, now());
INSERT INTO cl.orgunit_funding(orgunit_id, funding_id, classification_id, source_id) VALUES
(6204, 1, 1614, 2)

INSERT INTO cl.orgunits (origid, acronym, url, name ,  activity, source_id, isfunding, created_at) VALUES 
('mfal|MFAL', 'MFAL','','Ministry of Food, Agriculture and Livestock- General Directorate of Agricultural Research and Policies', '',
	26, true, now());
INSERT INTO cl.orgunit_funding(orgunit_id, funding_id, classification_id, source_id) VALUES
(6205, 818, 1614, 26)


INSERT INTO cl.orgunits (origid, acronym, url, name ,  activity, source_id, isfunding, created_at) VALUES 
('nerc|NERC', 'NERC','','Natural Environment Research Council', '',
	18, true, now());
	
INSERT INTO cl.orgunits (origid, acronym, url, name ,  activity, source_id, isfunding, created_at) VALUES 
('vm|VM', 'VM','','Ministry of Rural Development', '',
	25, true, now());	
