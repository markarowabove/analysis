-- constanct contact orgs
use cc;

-- update queries
--update contacts set school = 'Eastridge Elementary School' where school = '----';

-- get affilated count for each school
select school, count(*) as affilatedCount
from contacts
where school != ''
group by school
order by count(*);


--if (object_id('tempdb..#schoolnames') is not null) begin drop table #schoolnames end;

-- get school names not in db2
-- Name,RecordTypeId,Import_Tag__c
select distinct a.school as Name
	, '012f400000192PS' as RecordTypeId
	, 'Constant Contact Import' as Import_Tag__c
from contacts a
left join raftdb2den.dbo.Organizations b on a.school = b.organization
where b.organization is null
	and a.school != ''
order by a.school;





