# this script change the origid of a source, which impact all source objects.

update cl.fundings set origid= replace(origid, 'est_sf|', 'etag|') where origid like 'est_sf|%';
update cl.projects set origid= replace(origid, 'est_sf|', 'etag|') where origid like 'est_sf|%';
update cl.orgunits set origid= replace(origid, 'est_sf|', 'etag|') where origid like 'est_sf|%';
update cl.people set origid= replace(origid, 'est_sf|', 'etag|') where origid like 'est_sf|%';
update cl.publications set origid= replace(origid, 'est_sf|', 'etag|') where origid like 'est_sf|%';

update cl.sources set origid='etag', acronym='ETAG' where id=7;