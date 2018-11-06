-- cc emails with no names
use cc;

-- update queries
--update emails set createdat = left(createdat,10);

alter table emails alter column id int not null;
alter table emails add constraint pk_emails primary key(id);
alter table emails alter column createdat datetime2 not null;
alter table emails alter column updatedat datetime2 not null;

-- populate the nonames table
select id,emailhomeoptin,createdat into nonames from emails;

select email, count(*) as dupes
from nonames
where email != ''
group by email
having (count(*) > 1);

select a.id, a.email from nonames a
inner join raftdb2den.dbo.names b on a.email = b.email
where a.email != ''
order by a.id;





