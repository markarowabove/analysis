-- teacher visits
use raftdb2den;

--update queries

-- VisitId__c,ActivityDate,Raft_Account_Db2_Id__c,Raft_Contact_Db2_Id__c,Type,Status,Subject,RecordTypeId,WhoId,WhatId
select a.TVisitId as VisitId__c
	, isnull(convert(nvarchar,a.VisitDate,126),'') as ActivityDate
	, b.OrgId as Raft_Account_Db2_Id__c
	, c.NameId as Raft_Contact_Db2_Id__c
	, 'Visit' as Type
	, 'Completed' as Status
	, 'Teacher Visit' as Subject
	, '012f4000000iSq7AAE' as RecordTypeId
	, isnull(e.id,'') as WhoId
	, isnull(d.id,'') as WhatId
from Tvisit a 
left join SchoolOrgs b on a.SchoolID = b.SchoolID
left join Teachers c on a.TeacherID = c.TeacherID
left join sf.dbo.orgs d on b.orgid = d.Raft_Db2_Org_Id
left join sf.dbo.contacts e on c.nameid = e.Raft_Db2_Id
order by a.TVisitId;
