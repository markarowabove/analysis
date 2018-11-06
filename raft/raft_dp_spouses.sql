-- dp spouses
use dp;

-- update queries
alter table dpspouses add import_id int;

select * from dpspouses order by donor_id;

-- dump spouses
-- Import_Id__c,FirstName,LastName,Suffix,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,npe01__Primary_Address_Type__c,Phone,npe01__WorkPhone__c,Fax,MobilePhone,Import_Tag__c
select b.donor_id as Import_Id__c
	, b.First as FirstName
	, b.Last as LastName
	, b.Suffix as Suffix
	, b.Salutation as Title
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
	, 'Spouse Import 20180712' as Import_Tag__c
from dp a 
inner join dpspouses b on a.donor_id = b.donor_id
order by a.donor_id;
