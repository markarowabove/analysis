-- membership to opportunity line item
use raftdb2den;

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.membershipID as Id into #ids from membership a
left join raftdb2den_old.dbo.membership b on a.membershipID = b.membershipID
where b.membershipID is null;
--select * from #ids order by id;

-- dump test data
-- Raft_Db2_Id__c,Raft_Opportunity_Db2_Id__c,Raft_Product_Db2_Id__c,Raft_Price_Book_Entry_Db2_Id__c,UnitPrice,Quantity
select a.membershipID as Raft_Db2_Id_
	, a.membershipID as Raft_Opportunity_Db2_Id__c 
	, b.memberTypeID as Raft_Product_Db2_Id__c
	, b.memberTypeID as Raft_Price_Book_Entry_Db2_Id__c
	, a.Payment as UnitPrice
	, '1' as Quantity
	, 'DB2 Import 20180725' as Import_Tag__c
from membership a
left join lookupMembershipType b on a.MemberType = b.memberTypeID
inner join #ids c on a.membershipId = c.Id
order by a.membershipID;