-- dp gift to opportunity
use dp;

-- update dpgift table
alter table dpgift alter column gift_date datetime2 not null;
alter table dpgift alter column gift_id int not null;
alter table dpgift alter column donor_id int not null;
alter table dpgift alter column amount float;
alter table dpgiftudf alter column transactionamount float;
select * from dpgift order by gift_id desc;

-- test queries
select top 100 a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, case
		when a.record_type = 'G' then 'Posted'
		when a.record_type = 'P' then 'Pledged'
	  end as StageName
	, isnull(convert(nvarchar,a.gift_date,110),'') as CloseDate
	, a.amount as Amount
	, isnull(b.donor_perfect_id__c,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as Description
	, case
		when c.donor_type in ('IN','INDIV3') or c.donor_type = '' then concat(c.first_name,' ',c.last_name,' Purchase ',isnull(convert(nvarchar,a.gift_date,110),''))
		when c.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(c.last_name,' Purchase ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
from dpgift a
left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
where a.record_type in ('P','G')
	and a.campaign = 'UPCYC17'
	and a.donor_id = 9
order by a.record_type;

select campaign,record_type,donor_id, count(*) as count
from dpgift
group by campaign,record_type,donor_id
order by campaign;


select * from dpgift where record_type in ('P','G') and donor_id = 9 order by gift_date;


-- dump gifts that are posted
-- Donor_Perfect_Id__c,Donor_Perfect_Contact_Id__c,Donor_Perfect_Account_Id__c,StageName,CloseDate,Amount,Donor_Perfect_Campaign_Id__c,Description,Name
select a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, case
		when a.record_type = 'G' then 'Posted'
		when a.record_type = 'P' then 'Pledged'
	  end as StageName
	, isnull(convert(nvarchar,a.gift_date,110),'') as CloseDate
	, a.amount as Amount
	, isnull(b.donor_perfect_id__c,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as Description
	, case
		when c.donor_type in ('IN','INDIV3') or c.donor_type = '' then concat(c.first_name,' ',c.last_name,' Purchase ',isnull(convert(nvarchar,a.gift_date,110),''))
		when c.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(c.last_name,' Purchase ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
from dpgift a
left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
--where a.record_type = 'G'
where a.record_type = 'G'
	and a.campaign != ''
order by a.donor_id;

-- dump gifts that are pledged
-- Donor_Perfect_Id__c,Donor_Perfect_Contact_Id__c,Donor_Perfect_Account_Id__c,StageName,CloseDate,Amount,Donor_Perfect_Campaign_Id__c,Description,Name
select a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, case
		when a.record_type = 'G' then 'Posted'
		when a.record_type = 'P' then 'Pledged'
	  end as StageName
	, isnull(convert(nvarchar,a.gift_date,110),'') as CloseDate
	, a.amount as Amount
	, isnull(b.donor_perfect_id__c,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as Description
	, case
		when c.donor_type in ('IN','INDIV3') or c.donor_type = '' then concat(c.first_name,' ',c.last_name,' Pledge ',isnull(convert(nvarchar,a.gift_date,110),''))
		when c.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(c.last_name,' Pledge ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
from dpgift a
left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
where a.record_type = 'P'
	and a.campaign != ''
order by a.donor_id;


