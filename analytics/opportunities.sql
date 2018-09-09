use fww;

-- alter table
alter table opportunities alter column Amount float not null;
alter table opportunities alter column CloseDate date not null;

-- opportunities
select count(*) from opportunities;
-- dupe check
select id, count(*) as dupes
from opportunities
group by id
having (count(*) > 1);

-- 3625 with no primary contact
select count(*) from opportunities where npsp__Primary_Contact__c = '';
-- 686,638 with primary contact
select count(*) from opportunities where npsp__Primary_Contact__c! = '';
--
select a.npsp__Primary_Contact__c, b.Id, a.Amount from opportunities a
inner join contacts b on a.npsp__Primary_Contact__c = b.Id
order by a.Id;

select count(*) 
-- analyze opp segments
select Segment__c, count(*) from opportunities where Segment__c != '' group by Segment__c order by count(*) desc;
-- analyze opp stages
--StageName	Count
--Received	690233
--Report Submitted	17
--Partially Refunded	12
--Soft Credit	1
select StageName, count(*) from opportunities where StageName != '' group by StageName order by count(*) desc;
-- analyze opp campaigns
-- 875
select CampaignId, count(*) from opportunities where CampaignId != '' group by CampaignId order by count(*) desc;