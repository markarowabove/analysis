use dp;

select donor_id from dp where last_name = 'Szekeres' and first_name = 'Andy'; -- 547
select donor_id from dp where last_name = 'Bosworth' and first_name = 'Ladd'; -- 568

select * from dptributes where tribute_name = 'Andy Szekeres';
select donor_id from dp where last_name = 'Szekeres' and first_name = 'Andy';

if (object_id('tempdb..#names') is not null) begin drop table #names end;
select concat(a.first_name,' ',a.last_name) as Name
	, a.donor_id as Id into #names
from dp a
order by a.donor_id;
--select * from #names order by Id;

select a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, 'Posted' as StageName
	, isnull(convert(nvarchar,a.gift_date,110),'') as CloseDate
	, a.Amount as Amount
	, isnull(a.campaign,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as npsp__Notification_Message__c
	, case
		when b.donor_type in ('IN','INDIV3') or b.donor_type = '' then concat(b.first_name,' ',b.last_name,' Tribute ',isnull(convert(nvarchar,a.gift_date,110),''))
		when b.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(b.last_name,' Tribute ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
	, 'Honor' as npsp__Tribute_Type__c
	, c.Id as npsp__Honoree_Contact__c
	, isnull(a.tribute_name,'') as npsp__Honoree_Name__c
from dptributes a
inner join dp b on a.donor_id = b.donor_id
left join #names c on a.tribute_name = c.name
left join sf.dbo.accounts d on a.donor_id = d.Donor_Perfect_Id
where 1 = 1 
	and c.Id is not null
order by c.Id, a.Amount;

select a.gift_id as Donor_Perfect_Id__c
	, a.donor_id as Donor_Perfect_Contact_Id__c
	, a.donor_id as Donor_Perfect_Account_Id__c
	, 'Posted' as StageName
	, isnull(convert(nvarchar,a.gift_date,110),'') as CloseDate
	, a.Amount as Amount
	, isnull(a.campaign,'') as Donor_Perfect_Campaign_Id__c
	, isnull(a.gift_narrative,'') as npsp__Notification_Message__c
	, case
		when b.donor_type in ('IN','INDIV3') or b.donor_type = '' then concat(b.first_name,' ',b.last_name,' Tribute ',isnull(convert(nvarchar,a.gift_date,110),''))
		when b.donor_type in ('BIZ','BUSIN1','CO','FN','FOUND2','JO','OR','ORGAN4') then concat(b.last_name,' Tribute ',isnull(convert(nvarchar,a.gift_date,110),''))
	  end as Name
	, 'Honor' as npsp__Tribute_Type__c
	, isnull(a.tribute_name,'') as npsp__Honoree_Name__c
from dptributes a
inner join dp b on a.donor_id = b.donor_id
left join #names c on a.tribute_name = c.name
left join sf.dbo.accounts d on a.donor_id = d.Donor_Perfect_Id
where 1 = 1 
	and c.Id is null
order by c.Id, a.Amount;
