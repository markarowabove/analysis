use sf;

delete from opportunities where Raft_Db2_Id  like 'org%';

alter table opportunities alter column Donor_Perfect_Id int not null;
alter table opportunities alter column Raft_Db2_Id int not null;

if (object_id('tempdb..#primecontactaccountids') is not null) begin drop table #primecontactaccountids end;
select a.id as OpportunityId, c.Id as PrimaryContactAccountId into #primecontactaccountids
from opportunities a
left join contacts b on a.Primary_Contact_Id = b.id
left join accounts c on b.accountid = c.id
where c.Id != ''
order by a.Id;
--select * from #primecontactaccountids order by AccountId;

-- You should be able find them by looking for opportunities where the Opporturnity -> primary contact -> Account Id doesn't match the opportunity -> account id.
-- OpportunityId,PrimaryContactAccountId
select a.Id as OpportunityId
--	, a.AccountId
	, b.PrimaryContactAccountId  
from opportunities a
inner join #primecontactaccountids b on a.Id = b.OpportunityId
where a.AccountId <> b.PrimaryContactAccountId
order by a.AccountId;

select * from opportunities where accountid != ''