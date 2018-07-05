-- membership to opportunity line item
use raftdb2den;

-- dump test data
-- Raft_Db2_Id__c,Raft_Opportunity_Db2_Id__c,Raft_Product_Db2_Id__c,Raft_Price_Book_Entry_Db2_Id__c,UnitPrice,Quantity
select a.membershipID as Raft_Db2_Id_
	, a.membershipID as Raft_Opportunity_Db2_Id__c 
	, b.memberTypeID as Raft_Product_Db2_Id__c
	, b.memberTypeID as Raft_Price_Book_Entry_Db2_Id__c
	, a.Payment as UnitPrice
	, '1' as Quantity
from membership a
left join lookupMembershipType b on a.MemberType = b.memberTypeID
order by a.membershipID;