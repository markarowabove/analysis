-- material donations
use raftdb2den;

-- data modification queries
--update MaterialDonation set TYEmail = 'noemail@raft.com' where TYEmail = 'noemail@raft';
--select * from MaterialDonation where TYEmail != '' and TYEmail not like '%_@__%.__%';
--update MaterialDonation set TYEmail = 'noemail@raft.com'  where TYEmail != '' and TYEmail not like '%_@__%.__%';
--select * from MaterialDonation where TYEmail = 'noemail@raft.net';
--update MaterialDonation set TYEmail = 'noemail@raft.com'  where TYEmail = 'noemail@raft.net';

-- test queries
select * from materialdonation where description = 'Foamcore';

-- get contacts id
select top 25 a.DonationID
from MaterialDonation a 
where a.NameID is not null and a.OrgId is null
order by a.DonationID;

-- get org ids
select top 25 a.DonationID 
from MaterialDonation a 
where a.NameID is null and a.OrgId is not null
order by a.DonationID;

-- 15,16,19,20,28,29,30,33,38,57,67,76,77,78,79,80,81,84,86,87,88,92,94,95,96
-- test dump of contactd pickups
-- Db2Id__c,Raft_Contact_Db2_Id__c,Donation_Date__c,Description__c,Volume__c,Acknowledgement_Email__c
select a.DonationID as Db2Id__c
	, isnull(a.NameId,'0') as Raft_Contact_Db2_Id__c
	, isnull(convert(nvarchar,a.DonationDate,126),'') as Donation_Date__c
	, isnull(a.Description,'') as Description__c
	, isnull(a.Volume,'0.0') as Volume__c
	, isnull(a.TYEmail,'') as Acknowledgement_Email__c
from MaterialDonation a 
where a.NameID is not null and a.OrgId is null
	and a.DonationId in (15,16,19,20,28,29,30,33,38,57,67,76,77,78,79,80,81,84,86,87,88,92,94,95,96)
order by a.DonationID;

-- 21,22,42,91,161,163,219,258,292,294,302,303,304,313,315,343,352,358,362,366,386,387,390,391,392
-- Db2Id__c,Raft_Organization_Db2_Id__c,Donation_Date__c,Description__c,Volume__c,Acknowledgement_Email__c
select top 25 a.DonationID as Db2Id__c
	, isnull(a.OrgId,'0') as Raft_Organization_Db2_Id__c
	, isnull(convert(nvarchar,a.DonationDate,126),'') as Donation_Date__c
	, isnull(a.Description,'') as Description__c
	, isnull(a.Volume,'0.0') as Volume__c
	, isnull(a.TYEmail,'') as Acknowledgement_Email__c
from MaterialDonation a 
where a.NameID is null and a.OrgId is not null
	and a.DonationID in (21,22,42,91,161,163,219,258,292,294,302,303,304,313,315,343,352,358,362,366,386,387,390,391,392)
order by a.DonationID;

-- dump contact donations
-- Raft_Db2_Id__c,Raft_Contact_Db2_Id__c,Donation_Date__c,Description__c,Volume__c,Acknowledgement_Email__c
select a.DonationID as Raft_Db2_Id__c
	, isnull(a.NameId,'0') as Raft_Contact_Db2_Id__c
	, isnull(convert(nvarchar,a.DonationDate,126),'') as Donation_Date__c
	, isnull(a.Description,'') as Description__c
	, isnull(a.Volume,'0.0') as Volume__c
	, isnull(a.TYEmail,'') as Acknowledgement_Email__c
from MaterialDonation a 
where a.NameID is not null 
  and a.OrgId is null
order by a.DonationID;

-- dump org donations
-- Raft_Db2_Id__c,Raft_Organization_Db2_Id__c,Donation_Date__c,Description__c,Volume__c,Acknowledgement_Email__c
select a.DonationID as Raft_Db2_Id__c
	, isnull(a.OrgId,'0') as Raft_Organization_Db2_Id__c
	, isnull(convert(nvarchar,a.DonationDate,126),'') as Donation_Date__c
	, isnull(a.Description,'') as Description__c
	, isnull(a.Volume,'0.0') as Volume__c
	, isnull(a.TYEmail,'') as Acknowledgement_Email__c
from MaterialDonation a 
where a.OrgId is not null
order by a.DonationID;