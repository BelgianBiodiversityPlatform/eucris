# this script change the origid of a source, which impact all source objects.

update cl.fundings set origid= replace(origid, 'mec|', 'mineco|') where origid like 'mec|%';
update cl.projects set origid= replace(origid, 'mec|', 'mineco|') where origid like 'mec|%';
update cl.orgunits set origid= replace(origid, 'mec|', 'mineco|') where origid like 'mec|%';
update cl.people set origid= replace(origid, 'mec|', 'mineco|') where origid like 'mec|%';
update cl.publications set origid= replace(origid, 'mec|', 'mineco|') where origid like 'mec|%';

update cl.sources set origid='mineco', acronym='MINECO', name ='' where id=15;