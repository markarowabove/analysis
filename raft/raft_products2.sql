-- membership types
use raftdb2den;

-- Raft_Db2_Id__c,Name,Description__c,IsActive__c,Raft_Membership_Type_Db2_Id__c
select a.memberTypeID as Raft_Db2_Id__c
	, a.Name as Name
	, a.Descriiption as Description__c
	, 1 as IsActive__c
	, a.memberTypeID as Raft_Membership_Type_Db2_Id__c
from lookupMembershipType a 
order by a.name;