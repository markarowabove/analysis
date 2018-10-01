use mlf;

set nocount on

update a 
	set namekey = rtrim(replace(replace(replace(left(a.name,charindex('$',a.name,1)-1),' ',''),',',''),'.',''))
from sf_opportunities a 
inner join sf_opportunities b on a.id = b.id;

-- select id, name, namekey from sf_opportunities order by id;
-- test queries
/***
select id, count(*)
from sf_opportunities
group by id;
***/

set nocount off