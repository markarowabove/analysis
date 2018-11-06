-- teacher visits
use raftdb2den;

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.TVisitId as Id into #ids from TVisit a
left join raftdb2den_old.dbo.TVisit b on a.TVisitId = b.TVisitId
where b.TVisitId is null;
--select * from #ids order by id;

select * from tvisit where tvisitid = 52123;
select * from teachers where teacherid = 410305;
select * from names where id = 24583;
select * from organizations where id = 6104;

select * from names where id = 24583;

-- VisitId__c,ActivityDate,Raft_Account_Db2_Id__c,Raft_Contact_Db2_Id__c,Type,Status,Subject,RecordTypeId,WhoId,WhatId
select a.TVisitId as Db2ID_c__c	
	, isnull(convert(nvarchar,a.VisitDate,126),'') as Date__c
	, b.OrgId as Raft_Organization_Db2_Id__c
	, c.NameId as Raft_Contact_Db2_Id__c
	, 'Member Check In' as Check_In_Type__c
	, '012f4000000tFu0AAE' as RecordTypeId
	, 'DB2 Import 20180725' as Import_Tag__c
from Tvisit a 
left join SchoolOrgs b on a.SchoolID = b.SchoolID
left join Teachers c on a.TeacherID = c.TeacherID
left join sf.dbo.orgs d on b.orgid = d.Raft_Db2_Org_Id
left join sf.dbo.contacts e on c.nameid = e.Raft_Db2_Id
left join names f on c.nameid = f.id
inner join #ids g on a.TVisitID = g.Id
order by a.TVisitId;

