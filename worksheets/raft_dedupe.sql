-- dedupe worksheet
use raftdb2den;

select a.Id as Raft_Db2_Id__c
	, isnull(a.Last,'') as Last
	, isnull(a.First,'') as First
	, isnull(a.Email,'') as Email
from names a
--left join teachers b on a.id = b.nameid
where 1 = 1
--	and a.Id in ('1810','3946','17149','20617','24540')
order by a.Id;

-- 150 dupes in db2 on email
select email, count(*) as dupeCount
from names
group by Email
having (count(*) > 1);

-- 413, 324
select email, count(*) as dupeCount
from sf.dbo.contacts
where email != ''
group by email
having (count(*) > 1);

-- 16,821 with unique email in db2
if (object_id('tempdb..#db2emails') is not null) begin drop table #db2emails end;
select email, count(*) as dupeCount into #db2emails
from names
group by Email
having (count(*) = 1);
--select * from #db2emails where email = 'asholmeson@gmail.com';

-- 19 dupes in dp on email
select email, count(*) as dupeCount
from dp.dbo.dp
where email != ''
group by email
having (count(*) > 1);

-- 934 with unique email in dp
if (object_id('tempdb..#dpemails') is not null) begin drop table #dpemails end;
select email, count(*) as dupeCount into #dpemails
from dp.dbo.dp
where email != ''
group by email
having (count(*) = 1);
--select * from #dpemails where email = 'asholmeson@gmail.com';

-- 189 unique emails found in dp and db2
if (object_id('tempdb..#dupeemails') is not null) begin drop table #dupeemails end;
select distinct a.email into #dupeemails from #db2emails a
inner join #dpemails b on a.email = b.email
order by a.email;
--select * from #dupeemails where email = 'asholmeson@gmail.com';

--select * from sf.dbo.contacts c where c.email = 'ally.spanbauer@rodef-shalom.org' group by email having(count(*) > 1);

-- survivor ids - select donor perfect data
if (object_id('tempdb..#survivorids') is not null) begin drop table #survivorids end;
select a.email, (select Id from sf.dbo.contacts c where a.email = c.email and c.Raft_Db2_Id = 0) as SurvivorId into #survivorids
from #dupeemails a
left join sf.dbo.contacts b on a.email = b.email
where (select Id from sf.dbo.contacts c where a.email = c.email and c.Raft_Db2_Id = 0) is not null
order by a.email;
--select * from #survivorids  order by email;

-- non-survivor ids - select db2 data
if (object_id('tempdb..#nonsurvivorids') is not null) begin drop table #nonsurvivorids end;
select a.email
	, (select Id from sf.dbo.contacts c where a.email = c.email and c.Donor_Perfect_Id = 0) as NonSurvivorId into #nonsurvivorids
from #dupeemails a
left join sf.dbo.contacts b on a.email = b.email
where (select Id from sf.dbo.contacts c where a.email = c.email and c.Donor_Perfect_Id = 0) is not null
order by a.email;
--select * from #nonsurvivorids order by email;

-- dump email, survivor and non-surivor ids and feed to demand tools
-- dump this CSV into Google Sheet and then remove the Email column then save sheet as CSV and
-- then feed to demand tools
-- Email,SurvivorId,NonSurvivorId
-- PASS 1
select distinct a.email
	,a.SurvivorId
	, (select distinct NonSurvivorId from #nonsurvivorids where email = a.email) as NonSurvivorId
from #survivorids a
order by a.email;

-- PASS2
-- MasterIds
-- 003f400000IPeKOAA1,003f400000IPeJFAA1,003f400000IPeC2AAL,003f400000IPeUyAAL,003f400000IPeKpAAL,003f400000IPeL5AAL,003f400000IPeDgAAL,
-- Email,SurvivorId,NonSurvivorId
select distinct a.email
	,a.SurvivorId
	, (select distinct NonSurvivorId from #nonsurvivorids where email = a.email) as NonSurvivorId
from #survivorids a
where a.SurvivorId in ('003f400000IPeKOAA1','003f400000IPeJFAA1','003f400000IPeC2AAL','003f400000IPeUyAAL','003f400000IPeKpAAL','003f400000IPeL5AAL','003f400000IPeDgAAL')
order by a.email;

-- update account with donor_perfect_id = null with donor_perfect_id from associated contact from the merge above
-- AccountId,Donor_Perfect_Id__c
select b.AccountId, b.Donor_Perfect_Id
from sf.dbo.data_dedupe_emails_unique_db2_dp a
inner join sf.dbo.contacts b on a.SurvivorId = b.id
inner join sf.dbo.accounts c on b.AccountId = c.id
--where c.Donor_Perfect_Id = 0
order by b.Donor_Perfect_Id;
