-- material donation pickups
use raftdb2den;

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.PickupId as Id into #ids from Pickup a
left join raftdb2den_old.dbo.Pickup b on a.PickupId = b.PickupId
where b.PickupId is null;
--select * from #ids order by id;

-- test queries
select count(*) from pickup;

-- PickupId__c,Raft_Contact_Db2_Id__c,Raft_Activity_Date__c,PickupStreet__c,PickupCity__c,Helper__c,Pallet_Jack__c,Dolly__c,Handtruck__c,Elevator__c,Number_Pallets__c,Number_Barrels__c,Multistory__c,Description,Best_Time__c,Status,Type,Subject,RecordTypeId,WhatId
select a.PickupId as PickupId__c
	, a.TYID as Raft_Contact_Db2_Id__c
	, isnull(convert(nvarchar,a.Date,126),'') as Raft_Activity_Date__c
	, a.PickupStreet as PickupStreet__c
	, a.PickupCity as PickupCity__c
	, a.Helper as Helper__c
	, a.PalletJack as Pallet_Jack__c
	, a.Dolly as Dolly__c
	, a.Handtruck as Handtruck__c
	, a.Elevator as Elevator__c
	, a.Pallets as Number_Pallets__c
	, a.Barrels as Number_Barrels__c
	, a.MultiStory as Multistory__c
	, a.Notes as Description
	, a.Flex as Best_Time__c
	, 'Completed' as Status
	, 'Pickup' as Type
	, concat('Material Pickup on ',convert(nvarchar,a.Date,110)) as Subject
	, '012f4000000iSqCAAU' as RecordTypeId
	, '' as WhatId
from Pickup a
where a.OrgID = 0
	and a.TYID in (1,13,14,36,53,61,96,101,101,113,173,180,180,231,239,248,249,329,399,19325)
order by a.PickupId;

-- test org pickups
-- PickupId__c,Raft_Account_Db2_Id__c,Raft_Activity_Date__c,PickupStreet__c,PickupCity__c,Helper__c,Pallet_Jack__c,Dolly__c,Handtruck__c,Elevator__c,Number_Pallets__c,Number_Barrels__c,Multistory__c,Description,Best_Time__c,Status,Type,Subject,RecordTypeId,WhatId
select top 10 a.PickupId as PickupId__c
	, a.OrgId as Raft_Account_Db2_Id__c
	, isnull(convert(nvarchar,a.Date,126),'') as Raft_Activity_Date__c
	, a.PickupStreet as PickupStreet__c
	, a.PickupCity as PickupCity__c
	, a.Helper as Helper__c
	, a.PalletJack as Pallet_Jack__c
	, a.Dolly as Dolly__c
	, a.Handtruck as Handtruck__c
	, a.Elevator as Elevator__c
	, a.Pallets as Number_Pallets__c
	, a.Barrels as Number_Barrels__c
	, a.MultiStory as Multistory__c
	, a.Notes as Description
	, a.Flex as Best_Time__c
	, 'Completed' as Status
	, 'Pickup' as Type
	, concat('Material Pickup on ',convert(nvarchar,a.Date,110)) as Subject
	, '012f4000000iSqCAAU' as RecordTypeId
	, '' as WhatId
from Pickup a
where a.OrgID > 0
	and a.OrgID in (2,8,5,10,4,6,11)
order by a.PickupId;

-- contact pickups
-- PickupId__c,Raft_Contact_Db2_Id__c,Raft_Activity_Date__c,PickupStreet__c,PickupCity__c,Helper__c,Pallet_Jack__c,Dolly__c,Handtruck__c,Elevator__c,Number_Pallets__c,Number_Barrels__c,Multistory__c,Description,Best_Time__c,Status,Type,Subject,RecordTypeId,WhatId
select a.PickupId as PickupId__c
	, a.TYID as Raft_Contact_Db2_Id__c
	, isnull(convert(nvarchar,a.Date,126),'') as Raft_Activity_Date__c
	, a.PickupStreet as PickupStreet__c
	, a.PickupCity as PickupCity__c
	, a.Helper as Helper__c
	, a.PalletJack as Pallet_Jack__c
	, a.Dolly as Dolly__c
	, a.Handtruck as Handtruck__c
	, a.Elevator as Elevator__c
	, a.Pallets as Number_Pallets__c
	, a.Barrels as Number_Barrels__c
	, a.MultiStory as Multistory__c
	, a.Notes as Description
	, a.Flex as Best_Time__c
	, 'Completed' as Status
	, 'Pickup' as Type
	, concat('Material Pickup on ',convert(nvarchar,a.Date,110)) as Subject
	, '012f4000000iSqCAAU' as RecordTypeId
	, '' as WhatId
from Pickup a
where a.OrgID = 0
order by a.tyid;

-- org pickups
-- PickupId__c,Raft_Account_Db2_Id__c,Raft_Activity_Date__c,PickupStreet__c,PickupCity__c,Helper__c,Pallet_Jack__c,Dolly__c,Handtruck__c,Elevator__c,Number_Pallets__c,Number_Barrels__c,Multistory__c,Description,Best_Time__c,Status,Type,Subject,RecordTypeId,WhatId
select a.PickupId as PickupId__c
	, a.OrgId as Raft_Account_Db2_Id__c
	, isnull(convert(nvarchar,a.Date,126),'') as Raft_Activity_Date__c
	, a.PickupStreet as PickupStreet__c
	, a.PickupCity as PickupCity__c
	, a.Helper as Helper__c
	, a.PalletJack as Pallet_Jack__c
	, a.Dolly as Dolly__c
	, a.Handtruck as Handtruck__c
	, a.Elevator as Elevator__c
	, a.Pallets as Number_Pallets__c
	, a.Barrels as Number_Barrels__c
	, a.MultiStory as Multistory__c
	, a.Notes as Description
	, a.Flex as Best_Time__c
	, 'Completed' as Status
	, 'Pickup' as Type
	, concat('Material Pickup on ',convert(nvarchar,a.Date,110)) as Subject
	, '012f4000000iSqCAAU' as RecordTypeId
	, '' as WhatId
from Pickup a
where a.OrgID > 0
order by a.PickupId;