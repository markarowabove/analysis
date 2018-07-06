-- constanct contact orgs
use cc;

-- cd orgs not in db2
select distinct a.school from contacts a
left join raftdb2den.dbo.Organizations b on a.school = b.organization
where b.organization is null
order by a.school;

