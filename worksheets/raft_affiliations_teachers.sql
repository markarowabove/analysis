-- teacher affiliations
use raftdb2den;

-- update the table for prepare for import
alter table teachers drop column Raft_Db2_Compound_Id;
alter table teachers add Raft_Db2_Compound_Id uniqueidentifier default newid();
update teachers set Raft_Db2_Compound_Id = newid();

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.teacherId as Id into #ids from teachers a
left join raftdb2den_old.dbo.teachers b on a.teacherId = b.teacherId
where b.teacherId is null;
--select * from #ids order by id;

select * from teachers order by teacherid;

-- check for duplicte teacher records
select teacherid, count(*) as dupes
from teachers
group by teacherid
having (count(*) > 1);

-- test queries
select c.OrgId as RaftDb2Id_Organization__c
	, a.NameId as RaftDb2Id_Contact__c
	, d.First
	, d.Last
	, b.Text as npe5__Role__c
	, 1 as npe5__Primary__c
	, a.Raft_Db2_Compound_Id as Raft_Db2_Compound_Id__c
from teachers a
left join LookupTeacherType b on a.TeacherType = b.TTypeID
left join schoolorgs c on a.schoolID = c.SchoolID
left join names d on a.NameId = d.ID
inner join #ids e on a.teacherId = e.id
--where a.NameID = 12797
order by a.teacherId;

-- dump teacher affiliations
-- Raft_Db2_Teacher_Id__c,npe5__Organization__r_RaftDb2Id__c,npe5__Contact__r_RaftDb2Id__c,npe5__Role__c,npe5__Primary__c,Raft_Db2_Compound_Id__c
select a.TeacherID as Raft_Db2_Teacher_Id__c
	, c.OrgId as RaftDb2Id_Organization__c
	, a.NameId as RaftDb2Id_Contact__c
	, b.Text as npe5__Role__c
	, 1 as npe5__Primary__c
	, a.Raft_Db2_Compound_Id as Raft_Db2_Compound_Id__c
	, 'DB2 Import 20170725' as Import_Tag__c
from teachers a
left join LookupTeacherType b on a.TeacherType = b.TTypeID
left join schoolorgs c on a.schoolID = c.SchoolID
inner join #ids e on a.teacherId = e.id
order by a.TeacherId;




