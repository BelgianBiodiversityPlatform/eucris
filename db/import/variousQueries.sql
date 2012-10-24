--- all projects(2005-2012) with budget
select pr.source_id, pr.id as project_id, pr.startdate, pr.enddate, pr.title, pf.funding_id, pf.startdate, pf.enddate, pf.amount, pf.currency from cl.projects pr
left join cl.project_funding pf on pf.project_id = pr.id
where pr.enddate > '01-01-2005' and pr.startdate < '01-01-2012'  and pf.amount is not null
order by pr.source_id, pr.id;



