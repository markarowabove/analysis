-- dp gift to opportunity
use dp_old;

-- update dpgift table
alter table dpgift alter column gift_date datetime2 not null;
alter table dpgift alter column gift_id int not null;
alter table dpgift alter column donor_id int not null;
alter table dpgift alter column amount float;
alter table dpgiftudf alter column transactionamount float;

select * from dpgift order by gift_id desc; -- 2888

select * from dp where donor_id = 11;

-- report total amount of gift types
select 
	case
		when record_type = 'G' then 'Gift'
		when record_type = 'P' then 'Pledge'
		when record_type = 'M' then 'Major'
		when record_type = 'N' then 'Notification'
		when record_type = 'S' then 'Soft Credit'
	end as record_type
	, count (*) as count
from dpgift
group by record_type
order by record_type;

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
where 1 = 1
	--and a.record_type = 'M'
	and a.campaign = 'ANNUA1'
--	and a.record_type in ('P','G')
--	and a.campaign = 'UPCYC17'
--	and a.donor_id = 9
order by a.record_type;

select campaign,record_type,donor_id, count(*) as count
from dpgift
group by campaign,record_type,donor_id
order by campaign;

select b.first_name, b.last_name, a.* from dpgift a
left join dp b on a.donor_id = b.donor_id
where a.donor_id = 599;

select * from dpgift where donor_id = 599
select * from dp where donor_id = 599

select * from dpgift where record_type in ('P','G') and donor_id = 9 order by gift_date;

-- run utils/createTableColumnNamesList.sql for column names list
-- gift_id,donor_id,record_type,gift_date,amount,gl_code,solicit_code,sub_solicit_code,campaign,gift_type,split_gift,pledge_payment,first_gift,reference,memory_honor,gfname,glname,fmv,batch_no,gift_narrative,ty_letter_no,glink,plink,nocalc,receipt,ty_date,start_date,total,bill,balance,delinquent,initial_payment,frequency,reminder,last_bill_date,last_paid_date,writeoff_date,writeoff_amount,created_by,created_date,modified_by,modified_date,membership_type,membership_level,membership_enr_date,membership_exp_date,address_id,alink,batch_gift_id,tlink,RCPT_TYPE,RCPT_STATUS,RCPT_DATE,RCPT_NUM,TRIBUTE_START_DATE,TRIBUTE_end_DATE,TRIBUTE_MAIN_CONTACT,tribute_description,line_id,gift_aid_date,batch_id_temp,gift_aid_amt,gift_aid_eligible_g,currency,vault_id,GA_origid,GA_timestmp,GA_Runby,eft_status_description,import_id,eftbatch,receipt_delivery_g,contact_id,EmailSentTY_Date,LetterSentTY_Date,auction_category,auction_sold,starting_bid,auction_item_no,bundle_id,event_id,ACKNOWLEDGEPREF,transaction_id,TOTAL_PAID,ga_pending,delinquentEFT,wl_import_id,lastEFTattemptdate,eft_sync_id,eftbatch2,eft_payment_reset,cfFRName,cfPageName,cfUrl,QuickBooksPostId,QuickBooksPostDate,cfOrganizationFormid,cfIndividualFormid
select a.* from dpgift a where a.donor_id = 19 order by a.gift_date desc;
-- first_name,last_name,gift_id,donor_id,record_type,gift_date,amount,gl_code,solicit_code,sub_solicit_code,campaign,gift_type,split_gift,pledge_payment,first_gift,reference,memory_honor,gfname,glname,fmv,batch_no,gift_narrative,ty_letter_no,glink,plink,nocalc,receipt,ty_date,start_date,total,bill,balance,delinquent,initial_payment,frequency,reminder,last_bill_date,last_paid_date,writeoff_date,writeoff_amount,created_by,created_date,modified_by,modified_date,membership_type,membership_level,membership_enr_date,membership_exp_date,address_id,alink,batch_gift_id,tlink,RCPT_TYPE,RCPT_STATUS,RCPT_DATE,RCPT_NUM,TRIBUTE_START_DATE,TRIBUTE_end_DATE,TRIBUTE_MAIN_CONTACT,tribute_description,line_id,gift_aid_date,batch_id_temp,gift_aid_amt,gift_aid_eligible_g,currency,vault_id,GA_origid,GA_timestmp,GA_Runby,eft_status_description,import_id,eftbatch,receipt_delivery_g,contact_id,EmailSentTY_Date,LetterSentTY_Date,auction_category,auction_sold,starting_bid,auction_item_no,bundle_id,event_id,ACKNOWLEDGEPREF,transaction_id,TOTAL_PAID,ga_pending,delinquentEFT,wl_import_id,lastEFTattemptdate,eft_sync_id,eftbatch2,eft_payment_reset,cfFRName,cfPageName,cfUrl,QuickBooksPostId,QuickBooksPostDate,cfOrganizationFormid,cfIndividualFormid
select b.first_name
	, b.last_name
	, a.*
from dpgift a
left join dp b on a.donor_id = b.donor_id
where a.campaign = '' 
order by a.donor_id, a.gift_id;

select * from dpcampaigns;

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
where 1 = 1
--	and a.record_type = 'G'
--	and a.campaign != ''
	and a.donor_id = 402
order by a.amount desc;


-- dump gifts that are posted
-- Donor_Perfect_Id__c,Donor_Perfect_Contact_Id__c,Donor_Perfect_Account_Id__c,StageName,CloseDate,Amount,Donor_Perfect_Campaign_Id__c,Description,Name
select top 1 a.gift_id as Donor_Perfect_Id__c
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


-- dump major gifts that are posted
-- Donor_Perfect_Id__c,Donor_Perfect_Contact_Id__c,Donor_Perfect_Account_Id__c,StageName,CloseDate,Amount,Donor_Perfect_Campaign_Id__c,Description,Name
select a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, case
		when a.record_type = 'G' then 'Posted'
		when a.record_type = 'M' then 'Posted'
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
where a.record_type = 'M'
--	and a.campaign != ''
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
--	and a.campaign = ''
order by a.donor_id;

-- gifts with missing campaign
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
	, isnull(d.campaign,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as Description
	, case
		when c.donor_type in ('IN','INDIV3') or c.donor_type = '' then concat(c.first_name,' ',c.last_name,' Purchase ',isnull(convert(nvarchar,a.gift_date,110),''))
		when c.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(c.last_name,' Purchase ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
from dpgift a
left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
left join dpidscampaigns d on a.gift_id = d.id
where a.record_type = 'G'
--	and a.campaign = ''
order by a.donor_id;

-- soft credits
-- Donor_Perfect_Id__c,Donor_Perfect_Contact_Id__c,Donor_Perfect_Account_Id__c,StageName,CloseDate,Amount,Donor_Perfect_Campaign_Id__c,Description,Name
select a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, 'Posted' as StageName
	, isnull(convert(nvarchar,a.gift_date,110),'') as CloseDate
	, a.amount as Amount
	, isnull(b.donor_perfect_id__c,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as Description
	, case
		when c.donor_type in ('IN','INDIV3') or c.donor_type = '' then concat(c.first_name,' ',c.last_name,' Soft Credit ',isnull(convert(nvarchar,a.gift_date,110),''))
		when c.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(c.last_name,' Soft Credit ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
from dpgift a
left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
where a.record_type = 'S'
	--and a.campaign != ''
order by a.campaign;

/***************** OLD
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
	, isnull(d.campaign,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as Description
	, case
		when c.donor_type in ('IN','INDIV3') or c.donor_type = '' then concat(c.first_name,' ',c.last_name,' Pledge ',isnull(convert(nvarchar,a.gift_date,110),''))
		when c.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(c.last_name,' Pledge ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
from dpgift a
left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
left join dpidscampaigns d on a.gift_id = d.id
where a.record_type = 'P'
--	and a.campaign != ''
order by a.donor_id;
**************/