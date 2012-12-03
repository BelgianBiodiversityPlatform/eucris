### Select project's funding without dates for project that have dates.
select p.startdate, p.enddate, pf.startdate, pf.enddate
from cl.project_funding pf left join cl.projects p on p.id=pf.project_id
where (pf.startdate  is null and pf.enddate is null and p.startdate is not null and p.enddate is not null) ;

### When project's funding dates are unknown, force them to project dates.
update cl.project_funding pf
	set startdate=tmp.startdate, enddate=tmp.enddate
	from (select pf.project_id, pf.funding_id, p.startdate, p.enddate
		from cl.project_funding pf left join cl.projects p on p.id=pf.project_id
		where (pf.startdate is null and pf.enddate is null and p.startdate is not null and p.enddate is not null)) as tmp
where pf.project_id=tmp.project_id and pf.funding_id=tmp.funding_id;	

### Select project's funding without amount for project that have a budget.
select p.amount, pf.amount
from cl.project_funding pf left join cl.projects p on p.id=pf.project_id
where (pf.amount  is null and p.amount is not null) ;

### When project's funding amount is unknown, force it to project budget.
update cl.project_funding pf
	set amount=tmp.amount, currency=tmp.currency
	from (select pf.project_id, pf.funding_id, p.amount, p.currency
		from cl.project_funding pf left join cl.projects p on p.id=pf.project_id
		where (pf.amount is null and p.amount is not null)) as tmp
where pf.project_id=tmp.project_id and pf.funding_id=tmp.funding_id;
