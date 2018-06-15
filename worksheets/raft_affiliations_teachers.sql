-- teacher affiliations
use raftdb2den;

-- update the table for prepare for import
--alter table teachers drop column Raft_Db2_Compound_Id;
--alter table teachers add Raft_Db2_Compound_Id uniqueidentifier default newid();
--update teachers set Raft_Db2_Compound_Id = newid();

select * from teachers order by teacherid;

-- check for duplicte teacher records
select teacherid, count(*) as dupes
from teachers
group by teacherid
having (count(*) > 1);

-- dump teacher affiliations
-- npe5__Organization__r_RaftDb2Id__c,npe5__Contact__r_RaftDb2Id__c,npe5__Role__c,npe5__Primary__c,Raft_Db2_Compound_Id__c
select a.SchoolId as RaftDb2Id_Organization__c
	, a.NameId as RaftDb2Id_Contact__c
	, b.Text as npe5__Role__c
	, 1 as npe5__Primary__c
	, a.Raft_Db2_Compound_Id as Raft_Db2_Compound_Id__c 
from teachers a
left join LookupTeacherType b on a.TeacherType = b.TTypeID
where a.schoolid in ('85','102','130')
order by a.SchoolId;



