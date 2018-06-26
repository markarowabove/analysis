-- teacher visits
use raftdb2den;

--update queries

-- VisitId__c,Raft_Activity_Date__c,Raft_Account_Db2_Id__c,Raft_Contact_Db2_Id__c,Type,Status,Subject,RecordTypeId,WhoId,WhatId
select top 10 a.TVisitId as VisitId__c
	, isnull(convert(nvarchar,a.VisitDate,126),'') as Raft_Activity_Date__c
	, b.OrgId as Raft_Account_Db2_Id__c
	, c.NameId as Raft_Contact_Db2_Id__c
	, 'Visit' as Type
	, 'Completed' as Status
	, 'Visit' as Subject
	, '012f4000000iSq7AAE' as RecordTypeId
	, '' as WhoId
	, '' as WhatId
from Tvisit a 
left join SchoolOrgs b on a.SchoolID = b.SchoolID
left join Teachers c on a.TeacherID = c.TeacherID
order by a.TVisitId;
