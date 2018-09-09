-- eventbrite ticket types
use raftdb2den;

if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.Id as Id into #ids from workshops a
left join raftdb2den_old.dbo.workshops b on a.Id = b.Id
where b.Id is null;
--select * from #ids order by id;

-- test queries
-- Workshop_Id__c,Name,EventBriteSync__FullName__c,Member_Cost__c,Non_Member_Cost__c,Family__c,IsActive__c,EventbriteSync__Campaign__c
select top 20 a.ID as Workshop_Id__c
	, isnull(left(a.Title,80),'') as Name
	, isnull(left(a.Title,80),'') as EventBriteSync__FullName__c
	, a.MemberCost as Member_Cost__c
	, a.NonMemberCost as Non_Member_Cost__c
	, 'Ticket' as Family__c
	, '1' as IsActive__c
	, '' as EventbriteSync__Campaign__c
from workshops a
order by a.ID;

-- Workshop_Id__c,Name,EventBriteSync__FullName__c,Member_Cost__c,Non_Member_Cost__c,Family__c,IsActive__c,EventbriteSync__Campaign__c
select a.ID as Workshop_Id__c
	, isnull(left(a.Title,80),'') as Name
	, isnull(left(a.Title,80),'') as EventBriteSync__FullName__c
	, a.MemberCost as Member_Cost__c
	, a.NonMemberCost as Non_Member_Cost__c
	, 'Ticket' as Family__c
	, '1' as IsActive__c
	, a.Id as Raft_Campaign_Db2_Id__c
	, 'DB2 Import 20180725' as Import_Tag__c
from workshops a
inner join #ids b on a.id = b.id
order by a.ID;
