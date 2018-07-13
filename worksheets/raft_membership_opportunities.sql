-- membership to opportunity
use raftdb2den;

-- test queries
select membershipid,payment,timestamp from membership order by payment;

-- Raft_Db2_Id__c,CloseDate,Amount,npsp_Primary_Contact_r_Raft_Db2_Id__c,Raft_Account_Db2_Id__c,Name,RecordTypeId,StageName
select a.membershipID as Raft_Db2_Id__c 
	, convert(nvarchar,a.StartDate,126) as CloseDate
	, a.Payment as Amount
	, c.ID as npsp_Primary_Contact_r_Raft_Db2_Id__c
	, c.ID as Raft_Account_Db2_Id__c
	, concat(c.First,' ',c.Last,' Purchase ',convert(nvarchar,a.Timestamp,110)) as Name
	, '012f4000000iG6mAAE' as RecordTypeId
	, 'Posted' as StageName
from membership a
left join teachers b on a.TeacherID = b.TeacherID
left join names c on b.nameID = c.ID
order by a.MembershipID;
