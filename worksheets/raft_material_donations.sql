-- material donations
use raftdb2den;

select * into MaterialDonation_orig from MaterialDonation;

-- data modification queries
--update MaterialDonation set TYEmail = 'noemail@raft.com' where TYEmail = 'noemail@raft';
--select * from MaterialDonation where TYEmail != '' and TYEmail not like '%_@__%.__%';
--update MaterialDonation set TYEmail = 'noemail@raft.com'  where TYEmail != '' and TYEmail not like '%_@__%.__%';
--select * from MaterialDonation where TYEmail = 'noemail@raft.net';
--update MaterialDonation set TYEmail = 'noemail@raft.com'  where TYEmail = 'noemail@raft.net';

-- dump contact non-org donations
-- Db2Id__c,Raft_Contact_Db2_Id__c,Donation_Date__c,Description__c,Volume__c,Acknowledgement_Email__c
select top 25 a.DonationID as Db2Id__c
	, isnull(a.NameId,'0') as Raft_Contact_Db2_Id__c
	, isnull(convert(nvarchar,a.DonationDate,126),'') as Donation_Date__c
	, isnull(a.Description,'') as Description__c
	, isnull(a.Volume,'0.0') as Volume__c
	, isnull(a.TYEmail,'') as Acknowledgement_Email__c
from MaterialDonation a 
where a.NameID is not null and a.OrgId is null
order by a.DonationID;

-- dump org donations
-- Db2Id__c,Raft_Organization_Db2_Id__c,Donation_Date__c,Description__c,Volume__c,Acknowledgement_Email__c
select top 25 a.DonationID as Db2Id__c
	, isnull(a.OrgId,'0') as Raft_Organization_Db2_Id__c
	, isnull(convert(nvarchar,a.DonationDate,126),'') as Donation_Date__c
	, isnull(a.Description,'') as Description__c
	, isnull(a.Volume,'0.0') as Volume__c
	, isnull(a.TYEmail,'') as Acknowledgement_Email__c
from MaterialDonation a 
where a.NameID is null and a.OrgId is not null
order by a.DonationID;