-- dp gift opportunity line items
use dp;

select * from dp where donor_id = 12;

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.gift_id as Id into #ids from dpgift a
left join dp_old.dbo.dpgift b on a.gift_id = b.gift_id
where b.gift_id is null;
--select * from #ids order by id;

-- posted DP opportunties
-- Donor_Perfect_Id__c,Donor_Perfect_Opporunity_Id__c,Product2Id,PriceBookEntryId,UnitPrice,Quantity
select a.gift_id as Donor_Perfect_Id__c
	, a.gift_id as Donor_Perfect_Opportunity_Id__c
	, '01tf4000000z0HwAAI' as Product2Id
	, '01uf4000004IDuUAAW' as PriceBookEntryId
	, a.amount as UnitPrice
	, '1' as Quantity
from dpgift a
--left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
inner join #ids d on a.gift_id = d.id
where 1 = 1
	--and a.record_type = 'G'
	--and a.record_type = 'G' or a.record_type = 'M'
	and a.record_type = 'M'
	and a.campaign != ''
order by a.gift_id;

-- posted opportunties with no campaign designation
-- Donor_Perfect_Id__c,Donor_Perfect_Opporunity_Id__c,Product2Id,PriceBookEntryId,UnitPrice,Quantity
select a.gift_id as Donor_Perfect_Id__c
	, a.gift_id as Donor_Perfect_Opportunity_Id__c
	, 'DN001' as Raft_Price_Book_Entry_Db2_Id__c
	, a.amount as UnitPrice
	, '1' as Quantity
	, 'DB Import 20180725' as Import_Tag__c
from dpgift a
--left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
inner join #ids d on a.gift_id = d.id
where 1 = 1
	and a.record_type in ('G','M','P')
	--and a.record_type = 'G' or a.record_type = 'M'
	--and a.record_type = 'P'
	--and a.campaign = ''
order by a.gift_id;

select * from dpgift where donor_id = 179 order by record_type, amount desc;




