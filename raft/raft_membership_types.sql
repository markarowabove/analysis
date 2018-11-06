-- membership types
use raftdb2den;

-- Raft_Db2_Id__c,Name,Description__c,Duration__c,Enabled__c
select a.* from lookupMembershipType a 
order by a.name;