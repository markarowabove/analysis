-- price book entries
use raftdb2den;

-- Raft_Db2_Id__c,Name,Description__c,Unit_Price__c,Price_Book_2_Id__c,Raft_Db2_Id__c
select a.memberTypeID as Raft_Db2_Id__c
	, a.Name as Name
	, a.Descriiption as Description__c
	, case a.Name
		when 'Annual' then 25.00
		when 'First Time' then 15.00
		when 'Day Pass' then 0.00
	  end as Unit_Price__c
	, '01sf4000005m0ESAAY' as Price_Book_2_Id__c
	, a.memberTypeID as Raft_Db2_Id__c
from lookupMembershipType a 
order by a.name;