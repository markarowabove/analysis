-- workshop enrollments
use raftdb2den;

if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.Id as Id into #ids from WorkshopEnrollment a
left join raftdb2den_old.dbo.WorkshopEnrollment b on a.Id = b.Id
where b.Id is null;
--select * from #ids order by id;

select * from WorkshopEnrollment order by id;

-- dump workshop enrollments
-- Enrollment_Id__c,Raft_Campaign_Db2_Id__c,npsp_Primary_Contact_r_Raft_Db2_Id__c,CloseDate,Attended__c,Wait_Listed__c,Cancelled__c,Date_Cancelled__c,Description,Paid__c,StageName,Name,RecordTypeId
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
	, '012f4000000iG6mAAE' as RecordTypeId
	, 'DB2 Import 20180725' as Import_Tag__c
from WorkshopEnrollment a
left join names b on a.NameID = b.ID
inner join #ids c on a.Id = c.Id
--left join sf.dbo.contacts c on a.nameid = c.Raft_Db2_Id
order by a.nameid;



