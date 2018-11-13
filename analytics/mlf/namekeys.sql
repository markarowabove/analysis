use mlf;

select * from qb_namekeys where qbkeyname1 like '%DonaldDavis%';

select * from qb_namekeys where qbkeyname1 like '% %';
update a 
	set qbkeyname1 = rtrim(replace(a.qbkeyname1,' ',''))
from qb_namekeys a 
inner join qb_namekeys b on a.qbid = b.qbid;

select * from qb_namekeys where qbkeyname2 like '% %';
update a 
	set qbkeyname2 = rtrim(replace(a.qbkeyname2,' ',''))
from qb_namekeys a 
inner join qb_namekeys b on a.qbid = b.qbid;

select * from qb_namekeys where qbkeyname3 like '% %';
update a 
	set qbkeyname3 = rtrim(replace(a.qbkeyname3,' ',''))
from qb_namekeys a 
inner join qb_namekeys b on a.qbid = b.qbid;

select * from qb_namekeys where qbkeyname4 like '% %';
update a 
	set qbkeyname4 = rtrim(replace(a.qbkeyname4,' ',''))
from qb_namekeys a 
inner join qb_namekeys b on a.qbid = b.qbid;