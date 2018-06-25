-- membership types
use raftdb2den;

-- Raft_Db2_Id__c,Name,Description__c,Unit_Price__c,Price_Book_2_Id__c,Product2__c
select a.memberTypeID as Raft_Db2_Id__c
	, a.Name as Name
	, a.Descriiption as Description__c
	, case a.Name
		when 'Annual' then 25.00
		when 'First Time' then 15.00
		when 'Day Pass' then 0.00
	  end as Unit_Price__c
	, case a.Name
		when 'Annual' then '01sf4000005m0ESAAY'
		when 'First Time' then ''
		when 'Day Pass' then ''
	  end as Price_Book_2_Id__c
from lookupMembershipType a 
order by a.name;