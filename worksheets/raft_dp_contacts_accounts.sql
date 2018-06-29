-- dp contacts and accounts
use dp;

select count(*) from dp;
select count(*) from dpaddress;
select count(*) from dpcodes where code IS NOT NULL;
select count(*) from dpcontact;
select count(*) from dpgiftudf;
select count(*) from dplink;
select count(*) from dpudf;
select count(*) from dpusermultivalues;

select * from dp where donor_id = 1145;

/********* dp ****************/
-- dump dp for contacts
-- Donor_Perfect_Id__c,FirstName,LastName,Suffix,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,npe01__Primary_Address_Type__c,Phone,npe01__WorkPhone__c,Fax,MobilePhone,npe01__HomeEmail__c
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
from dp a 
order by a.donor_id;

-- dump dp for accounts
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
	, b.ENVSAL as npo02__Formal_Greeting__c
	, b.SHTSAL as npo02__Informal_Greeting__c
	, '' as AccountId
from dp a 
left join dpudf b on a.donor_id = b.donor_id
order by a.donor_type;


