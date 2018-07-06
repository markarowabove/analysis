-- constanct contact 
use cc;

-- update tables
alter table contacts drop constraint pk_contacts;
alter table contacts drop id_str;
alter table contacts alter column id int not null;
alter table contacts add constraint pk_contacts primary key(id);
alter table contacts alter column createdat datetime2 not null;
alter table contacts alter column updatedat datetime2 not null;

select count(*) from contacts;

delete from contacts where id = 437; -- remove bad record
select * from contacts where email = 'bethany.grosser@gmail.com';

-- research queries
select email, count(*) as dupes
from contacts
group by email
having (count(*) > 1);

-- 5879 - match: email, first, last
select a.ID
from contacts a 
inner join raftdb2den.dbo.names b on a.Email = b.Email
where a.FirstName = b.First
	and a.Lastname = b.Last
order by a.ID;

-- 5938 - match: email, last
select a.ID
from contacts a 
inner join raftdb2den.dbo.names b on a.Email = b.Email
where 1 = 1
--	and a.FirstName = b.First
	and a.Lastname = b.Last
order by a.ID;

-- 5934 - match: email, first
select a.ID
from contacts a 
inner join raftdb2den.dbo.names b on a.Email = b.Email
where 1 = 1
	and a.FirstName = b.First
--	and a.Lastname = b.Last
order by a.ID;

-- 5993 - match email, first or last
select a.ID
from contacts a 
inner join raftdb2den.dbo.names b on a.Email = b.Email
where 1 = 1
	and a.FirstName = b.First
	or a.Lastname = b.Last
order by a.ID;

-- 6086 - match email
select a.ID
from contacts a 
inner join raftdb2den.dbo.names b on a.Email = b.Email
where 1 = 1
--	and a.FirstName = b.First
--	or a.Lastname = b.Last
order by a.ID;

if (object_id('tempdb..#db2ids') is not null) begin drop table #db2ids end;
select a.ID as id into #db2ids
from contacts a 
inner join raftdb2den.dbo.names b on a.Email = b.Email
where 1 = 1
	and a.FirstName = b.First
	and a.Lastname = b.Last
order by b.ID;

if (object_id('tempdb..#notdb2ids') is not null) begin drop table #notdb2ids end;
select a.ID as id into #notdb2ids
from contacts a 
left join raftdb2den.dbo.names b on a.Email = b.Email
where b.Email is null
order by a.id; 

if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select id into #ids from (
	select id from #db2ids
	union 
	select id from #notdb2ids
) a;

-- mystery 125 contacts
select id, email from contacts where id in (
	select a.id from contacts a left join #ids b on a.id = b.id where b.id is null
) order by id;


-- assign to newsletter group - set Contact.Member_Newsletter__c to true
-- dump cc and db2 contacts with matching FirstName, LastName and Email
-- Raft_Db2_Id__c,Member_Newsletter__c
select b.ID as Raft_Db2_Id__c
--	, a.FirstName as FirstName
--	, a.LastName as LastName
--	, a.Suffix as Suffix
--	, a.Email as Email
--	, a.ID
	, '1' as Member_Newsletter__c
--	, '0' as Member_Newsletter__c
from contacts a 
inner join raftdb2den.dbo.names b on a.Email = b.Email
where 1 = 1
	and a.FirstName = b.First
	and a.Lastname = b.Last
order by b.ID;

-- 1768
-- dump cc contacts not in db2 with bad dates (corrected now)
-- FirstName,LastName,Suffix,Email,npe01__HomeEmail__c,npe01__AlternateEmail__c,HomePhone,MobilePhone,npe01__WorkPhone__c,npe01__Primary_Address_Type__c,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,npe01__OtherAddress__c_Street,nnpe01__OtherAddress__c_City,npe01__OtherAddress__c_State,npe01__OtherAddress__c_PostalCode,npe01__OtherAddress__c_Country,Notes__c,CreatedDate,LastModifiedDate,Import_Tag__c,Member_Newsletter__c
select a.FirstName as FirstName
	, a.LastName as LastName
	, a.Suffix as Suffix
	, isnull(a.Email,'') as Email
	, isnull(a.Email,'') as npe01__HomeEmail__c
	, isnull(a.EmailOther,'') as npe01__AlternateEmail__c
	, isnull(a.PhoneHome,'') as HomePhone
	, isnull(a.PhoneMobile,'') as MobilePhone
	, isnull(a.PhoneWork,'') as npe01__WorkPhone__c
	, 'Home' as npe01__Primary_Address_Type__c
	, isnull( a.Address1Home,'') as MailingStreet
	, isnull(a.CityHome,'') as MailingCity
	, isnull(upper(a.StateHome),'') as MailingState
	, isnull(a.ZipHome,'') as MailingPostalCode
	, isnull(a.CountryHome,'United States') as MailingCountry
	, isnull(a.Address1Other,'') as npe01__OtherAddress__c_Street
	, isnull(a.CityOther,'') as nnpe01__OtherAddress__c_City
	, isnull(a.StateOther,'') as npe01__OtherAddress__c_State
	, isnull(a.ZipOther,'') as npe01__OtherAddress__c_PostalCode
	, isnull(a.CountryOther,'') as npe01__OtherAddress__c_Country
	, concat(isnull(a.Tags,''),' - Constant Contact export 201807') as Notes__c
	, case 
		when a.CreatedAt = '' then getdate() 
		when a.CreatedAt = '1900-01-01 00:00:00.0000000' then getdate()
		when a.CreatedAt != '' and a.CreatedAt = '1900-01-01 00:00:00.0000000' then convert(nvarchar,a.CreatedAt,126)
	  end as CreatedDate
	, case 
		when a.UpdatedAt = '' then getdate() 
		when a.UpdatedAt = '1900-01-01 00:00:00.0000000' then getdate()
		when a.UpdatedAt != '' and a.UpdatedAt = '1900-01-01 00:00:00.0000000' then convert(nvarchar,a.UpdatedAt,126)
	  end as LastModifiedDate
	, 'Constant Contact Import' as Import_Tag__c
	, '1' as Member_Newsletter__c
from contacts a 
left join raftdb2den.dbo.names b on a.Email = b.Email
where b.Email is null
order by b.ID; 



