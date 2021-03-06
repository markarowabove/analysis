use sf;

--select * from anonymous_household_accounts order by id;

select * from accounts where id like '001f400000JWnG7%';
select * from contacts where accountid like '001f400000JWnG7%';
select * from contacts where accountid like '001f400000JWnG7%';
select * from contacts where id = '003f400000RGTD1AAP';

select * from dp.dbo.dp where last_name = 'Anonymous';
select * from dp.dbo.dp where donor_id = 752;


select a.*
--	, b.*
from dp.dbo.dpgift a
--left join dp.dbo.dp b on a.donor_id = b.donor_id
where a.gift_id = 294;

select count(*) from anonymous_household_accounts where id = '001f400000JWEduAAH';
select * from accounts where name like 'Anonymous%' and (Donor_Perfect_Id != '' or Raft_Db2_Id != '');

if (object_id('tempdb..#primarycontactids') is not null) begin drop table #primarycontactids end;
select distinct b.Primary_Contact_Id as Id into #primarycontactids
from anonymous_household_accounts a
inner join opportunities b on a.id = b.accountid
left join contacts c on a.id = c.AccountId
order by b.Primary_Contact_Id;
--select * from #primarycontactids where id = '003f400000RGTD1AAP' order by id;

if (object_id('tempdb..#primaryaccountids') is not null) begin drop table #primaryaccountids end;
select a.AccountId as Id into #primaryaccountids from contacts a
inner join #primarycontactids b on a.id = b.id
inner join accounts c on a.AccountId = c.Id
--where a.id = '003f400000RGTD1AAP'
order by a.AccountId;
--select * from #primaryaccountids;

--select * from opportunities where accountId = '001f400000S0EeCAAV';

select a.Id, b.AccountId from #primarycontactids a
inner join contacts b on a.Id = b.Id
where a.Id = '003f400000IPeESAA1'
order by a.id;

--select * from anonymous_household_accounts where Id = '001f400000JWELKAA5';
--select * from contacts where Id = '003f400000IPeESAA1';

-- get properly related opps
select * from opportunities where accountId = '001f400000JWELKAA5'
-- get improperly related opportunites
select * from opportunities where accountId != '001f400000JWELKAA5' and Primary_Contact_Id = '003f400000IPeESAA1';

select * from opportunities where id = '006f4000006f5PZAAY';
select * from contacts where Donor_Perfect_Id = 95;
select * from opportunities where AccountId = '001f400000JWEecAAH';

-- get new account id for opportunities of anonymous households
select a.Id as OpportuntityId
	, a.AccountId as OldAccountId
	, d.Id as NewAccountId
	, a.Primary_Contact_Id as PrimaryContactId
	, (select first_name + ' ' + last_name from dp.dbo.dp where donor_id = b.Donor_Perfect_Id) as Name
from opportunities a
left join contacts b on a.Primary_Contact_Id = b.Id
left join #primarycontactids c on b.id = c.id
left join #primaryaccountids d on b.AccountId = d.Id
inner join anonymous_household_accounts e on a.AccountId = e.id
where 1 = 1
	and a.AccountId != d.Id
	--and a.Primary_Contact_Id = '003f400000RGTD1AAP'
	--and b.Donor_Perfect_Id = 95
	--and a.AccountId = '001f400000JWEecAAH'
	--and a.Id = '006f4000006eLKtAAM'
order by a.Primary_Contact_Id;

-- delete anonymous household accounts
select distinct a.AccountId as Id
from opportunities a
inner join contacts b on a.Primary_Contact_Id = b.Id
inner join #primarycontactids c on b.id = c.id
order by a.AccountId;