use raftdb2den;

select count(*) from names;
select * from names where id = 3316 order by Last;

select * from names where id = 1960;
update names set Street = '900 S. Broadway' where id = 1960;

-- dup check in names
select id, count(*) as dupes
from names
group by id
having (count(*) > 1);

-- dup check in names
select email, count(*) as dupes
from names
group by email
having (count(*) > 1)
order by dupes desc;

select * from names where email = 'pauline.walls@spectracenter.org' order by Last;

-- dup check in teachers
select nameid, count(*) as dupes
from teachers
group by nameid
having (count(*) > 1);

--check for dupes in name org
select nameid, count(*) as dupes
from nameorg
group by nameid
having (count(*) > 1);

select * from names where id = 616;

--select * into names_orig from names;
-- set created date to last modified
--   FIELD_INTEGRITY_EXCEPTION:Last Modified Date(Fri Jan 18 00:51:00 GMT 2013) before Create Date(Thu Mar 28 03:03:00 GMT 2013).: Last Modified Date Error fields: LastModifiedDate 
update names 
set Timestamp = LastCC
where Timestamp > LastCC;

-- dump accounts from names
--Raft_db2_Id__c,Name,RecordTypeId
select a.id as RaftId, a.First + ' ' + a.Last +' Household' as Name, '012f400000192PR' as AccountRecordType 
from names a
order by a.id;

-- dump non-org contacts from names and teachers
--Raft_Db2_Id__c,Raft_Db2_Teacher_Id__c,CreatedDate,LastModifiedDate,LastName,FirstName,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,Email,Notes,AccountId
select a.Id as Raft_Db2_Id__c
	, isnull(b.TeacherId,'') as Raft_Db2_Teacher_Id__c
	, isnull(convert(nvarchar,a.Timestamp,126),'') as CreatedDate
	, isnull(convert(nvarchar,a.LastCC,126),'') as LastModifiedDate
	, isnull(a.Last,'') as Last
	, isnull(a.First,'') as First
	, isnull(a.Title,'') as Title
	, isnull( a.Street + ' ' + isnull(a.Street2,''),'') as Street
	, isnull(a.City,'') as City
	, isnull(upper(a.State),'') as State
	, isnull(a.Zip,'') as Zip
	, isnull(a.Email,'') as Email
	, isnull(b.Notes,'') as Notes 
from names a
left join teachers b on a.id = b.nameid
where 1 = 1
--	and a.Id in ('1810','3946','17149','20617','24540')
order by a.Id;
