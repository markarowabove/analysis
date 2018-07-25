-- dp gift opportunity line items
use dp;

select a.gift_id as Donor_Perfect_Id__c
	, a.gift_id as Donor_Perfect_Opportunity_Id__c
	, '01tf4000000z0HwAAI' as Product2Id
	, '01uf4000004IDuUAAW' as PriceBookEntryId
	, a.amount as UnitPrice
	, '1' as Quantity
from dptributes a
order by a.gift_id;





