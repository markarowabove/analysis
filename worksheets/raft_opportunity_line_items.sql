-- membership to opportunity line item
use raftdb2den;

-- dump test data
-- Raft_Db2_Id__c,Raft_Opportunity_Db2_Id__c,Raft_Product_Db2_Id__c,Raft_Price_Book_Entry_Db2_Id__c,Name,Unit_Price__c,Total_Price__c,Quantity__c
select a.membershipID as Raft_Db2_Id_
	, a.membershipID as Raft_Opportunity_Db2_Id__c 
	, b.memberTypeID as Raft_Product_Db2_Id__c
	, b.memberTypeID as Raft_Price_Book_Entry_Db2_Id__c
	, b.Descriiption as Name
	, a.Payment as Unit_Price__c
	, a.Payment as Total_Price__c
	, '1' as Quantity__c
from membership a
left join lookupMembershipType b on a.MemberType = b.memberTypeID
where a.membershipID <= 101
order by a.membershipID;

-- dump all opportunity line items
-- Raft_Db2_Id__c,Raft_Opportunity_Db2_Id__c,Raft_Product_Db2_Id__c,Raft_Price_Book_Entry_Db2_Id__c,Name,Unit_Price__c,Total_Price__c,Quantity__c
select a.membershipID as Raft_Db2_Id_
	, a.membershipID as Raft_Opportunity_Db2_Id__c 
	, b.memberTypeID as Raft_Product_Db2_Id__c
	, b.memberTypeID as Raft_Price_Book_Entry_Db2_Id__c
	, b.Descriiption as Name
	, a.Payment as Unit_Price__c
	, a.Payment as Total_Price__c
	, '1' as Quantity__c
from membership a
left join lookupMembershipType b on a.MemberType = b.memberTypeID
order by a.membershipID;