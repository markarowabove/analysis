-- dp gift opportunity line items
use dp;

-- test queries
-- Donor_Perfect_Id__c,Donor_Perfect_Opporunity_Id__c,Product2Id,PriceBookEntryId,UnitPrice,Quantity
select a.gift_id as Donor_Perfect_Id__c
	, a.gift_id as Donor_Perfect_Opporunity_Id__c
	, '01tf4000000z0HwAAI' as Product2Id
	, '01uf4000004IDuUAAW' as PriceBookEntryId
	, a.amount as UnitPrice
	, '1' as Quantity
from dpgift a
left join dpcampaigns b on a.campaign = b.donor_perfect_id__c
left join dp c on a.donor_id = c.donor_id
where 1 = 1
	and a.record_type = 'G'
	--and a.record_type = 'G' or a.record_type = 'M'
	--and a.record_type = 'M'
	and a.campaign != ''
order by a.gift_id;






