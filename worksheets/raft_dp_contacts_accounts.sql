-- dp contacts and accounts
use dp;

-- update queries
--alter table dp alter column donor_id int not null;

if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.donor_id as Id into #ids from dp a
left join dp_old.dbo.dp b on a.donor_id = b.donor_id
where b.donor_id is null;
--select * from #ids order by id;

select count(*) from dp;
select count(*) from dpaddress;
select count(*) from dpcodes where code IS NOT NULL;
select count(*) from dpcontact;
select count(*) from dpgiftudf;
select count(*) from dplink;
select count(*) from dpudf;
select count(*) from dpusermultivalues;

select a.address, a.address2, a.city, a.state, a.zip, a.address_type
from dp a 
where a.donor_id = 1068;

select distinct address_type from dpaddress order by address_type;
select distinct address_type from dp order by address_type;

select a.address, a.address2, a.city, a.state, a.zip, a.address_type
from dpaddress a 
where a.donor_id = 1068;

select * from dp order by donor_id;

-- update created date
-- Donor_Perfect_Id__c,Donor_Perfect_Created_Date__c
select a.donor_id as Donor_Perfect_Id__c
	, isnull(convert(varchar(10),cast(a.created_date as datetime),101),'') as CreatedDate
from dp a 
order by a.donor_id;

/********* dp ****************/
-- dump dp for contacts
-- Donor_Perfect_Id__c,FirstName,LastName,Suffix,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,npe01__Primary_Address_Type__c,Phone,npe01__WorkPhone__c,Fax,MobilePhone,npe01__HomeEmail__c,CreatedDate
select a.donor_id as Donor_Perfect_Id__c
	, isnull(a.first_name,'') as FirstName
	, isnull(a.last_name,'') as LastName
	, isnull(a.suffix,'') as Suffix
	, isnull(a.prof_title,'') as Title
	, case
		when a.address != '' and a.address2 != '' then concat(a.address,' ',a.address2)
		when a.address != '' and (a.address2 is null or a.address2 = '') then a.address
		when a.address is null or a.address = '' then  ''
	  end as MailingStreet
	, isnull(a.city,'') as MailingCity
	, isnull(a.state,'') as MailingState
	, isnull(a.zip,'') as MailingPostalCode
	, isnull(a.country,'') as MailingCountry
	, case
		when a.address_type = 'HOME' then 'Home'
		when a.address_type = 'WORK' then 'Work'
		when a.address_type != 'HOME' and a.address_type != 'WORK' then 'Other'
	  end as npe01__Primary_Address_Type__c
	, isnull(a.home_phone,'') as Phone
	, isnull(a.business_phone,'') as npe01__WorkPhone__c
	, isnull(a.fax_phone,'') as Fax
	, isnull(a.mobile_phone,'') as MobilePhone
	, isnull(a.email,'') as npe01__HomeEmail__c
	, isnull(convert(nvarchar,a.created_date,126),'') as CreatedDate
	, isnull(convert(varchar(10),cast(a.created_date as datetime),101),'') as Donor_Perfect_Created_Date__c
	, 'DP Import 20180725' as Import_Tag__c
from dp a 
inner join #ids b on a.donor_id = b.id
order by a.donor_id;

-- dump dp for accounts
select a.donor_id as Donor_Perfect_Id__c
	, a.first_name + ' ' + a.last_name +' Household' as Name
	, '012f400000192PR' as AccountRecordType 
	, 'DP Import 20180725' as Import_Tag__c
from dp a
inner join #ids b on a.donor_id = b.id
order by a.donor_id;

-- Donor_Perfect_Id__c,Name,RecordTypeId,npo02__Formal_Greeting__c,npo02__Informal_Greeting__c,AccountId
select a.donor_id as Donor_Perfect_Id__c
	,  case
		when a.donor_type in ('IN','INDIV3') or a.donor_type = '' then concat(a.first_name,' ',a.last_name,' Household')
		when a.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then a.last_name
	  end as Name
	, case
		when a.donor_type in ('IN','INDIV3') then '012f400000192PR'
		when a.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then '012f400000192PS'
		when a.donor_type = '' then '012f400000192PR'
	  end as RecordTypeId
	, '' as AccountId
from dp a 
inner join #ids b on a.donor_id = b.id
order by a.donor_type;
