-- workshop enrollments
use raftdb2den;

select * from WorkshopEnrollment order by id;

-- dump workshop enrollments
-- Enrollment_Id__c,Raft_Campaign_Db2_Id__c,npsp_Primary_Contact_r_Raft_Db2_Id__c,CloseDate,Attended__c,Wait_Listed__c,Cancelled__c,Date_Cancelled__c,Description,Paid__c,StageName,Name
select a.Id as Enrollment_Id__c
	, a.WorkshopID as Raft_Campaign_Db2_Id__c
	, a.NameID as npsp_Primary_Contact_r_Raft_Db2_Id__c
	, isnull(convert(nvarchar,a.EnrollmentDate,126),'') as CloseDate
	, a.Attendance as Attended__c
	, a.WaitList as Wait_Listed__c
	, a.Cancel as Cancelled__c
	, isnull(convert(nvarchar,a.CancelDate,126),'') as Date_Cancelled__c
	, a.Note as Description
	, a.payment as Paid__c
	, 'Posted' as StageName
	, concat(b.First,' ',b.Last,' Purchase ',convert(nvarchar,a.EnrollmentDate,110)) as Name
from WorkshopEnrollment a
left join names b on a.NameID = b.ID
order by a.Id;


