use raftdb2den;

select count(*) from names;
select * from names order by Last;

-- dup check in names
select id, count(*) as dupes
from names
group by id
having (count(*) > 1);

-- dup check in teachers
select nameid, count(*) as dupes
from teachers
group by nameid
having (count(*) > 1);

select teacherid, count(*) as dupes
from teachers
group by teacherid
having (count(*) > 1);

-- dump accounts from names
select id as RaftId, First + ' ' + Last +' Household' as Name, '012f400000192PR' as AccountRecordType from names 
--where Last != ''
order by Last;

-- dump contacts from names and teachers
--RaftId,TeacherID,CreatedDate,LastModifiedDate,LastName,FirstName,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,Email,Notes,AccountId
select a.Id as RaftId
	, isnull(b.TeacherId,'') as TeacherId
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
--	and a.Id in ('17336','8604' ,'22713' ,'8652' ,'12441' ,'11743' ,'10600' ,'3989')
order by a.Last;


