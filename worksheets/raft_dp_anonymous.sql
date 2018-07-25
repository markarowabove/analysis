use sf;

--select * from anonymous_household_accounts order by id;
select * from accounts where id like '001f400000JWnG7%';
select * from contacts where accountid like '001f400000JWnG7%';
select * from contacts where accountid like '001f400000JWnG7%';

select * from dp.dbo.dp where last_name = 'Anonymous';
select * from dp.dbo.dp where donor_id = 752;

select a.*
--	, b.*
from dp.dbo.dpgift a
--left join dp.dbo.dp b on a.donor_id = b.donor_id
where a.gift_id = 294;

if (object_id('tempdb..#primarycontactids') is not null) begin drop table #primarycontactids end;
select distinct b.Primary_Contact_Id as Id into #primarycontactids
from anonymous_household_accounts a
inner join opportunities b on a.id = b.accountid
left join contacts c on a.id = c.AccountId
order by b.Primary_Contact_Id;
--select * from #primarycontactids where id = '003f400000IQG12AAH' order by id;

select a.Id, b.AccountId from #primarycontactids a
inner join contacts b on a.Id = b.Id
--where b.id = '003f400000IQG12AAH'
order by a.id;

-- get new account id for opportunties of anonymous households
select a.Id as OpportuntitId
	, a.AccountId as OldAccountId
	, b.AccountId as PrimaryContactId
from opportunities a
inner join contacts b on a.Primary_Contact_Id = b.Id
inner join #primarycontactids c on b.id = c.id
order by a.Id;

-- delete anonymous household accunts
select distinct a.AccountId as Id
from opportunities a
inner join contacts b on a.Primary_Contact_Id = b.Id
inner join #primarycontactids c on b.id = c.id
order by a.AccountId;