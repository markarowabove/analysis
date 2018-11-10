use mlf;

set nocount on

-- select count(*) from sf_opportunities order by closedate;
-- select * from sf_opportunities_jul_sep_18 order by closedate;
--update sf_opportunities_jul_sep_18 set rownum = null;
--alter table sf_opportunities add namekey nvarchar(255);
--delete from sf_opportunities where closedate > '2018-06-30';
--select * from sf_opportunities where namekey = 'DonaldDavis' order by Id;

--alter table sf_opportunities alter column CloseDate date;
--alter table sf_opportunities alter column Amount float;
--alter table sf_opportunities add rownum int identity(1,1);
--alter table sf_opportunities add namekey nvarchar(255);

update a 
	set namekey = rtrim(replace(replace(replace(left(a.name,charindex('$',a.name,1)-1),' ',''),',',''),'.',''))
from sf_opportunities a 
inner join sf_opportunities b on a.id = b.id;
-- select * from sf_opportunities order by rownum;

--SET IDENTITY_INSERT sf_opportunities ON
insert into sf_opportunities
	SELECT [Id]
      ,[AccountId]
      ,[Amount]
      ,[CampaignId]
      ,[Campaign_Name__c]
      ,[Card_Expiration_Date__c]
      ,[Card_Number__c]
      ,[Card_Type__c]
      ,[Classy_Recurring_Donor_Start_Date__c]
      ,[CloseDate]
      ,[Description]
      ,[Designation__c]
      ,[IsClosed]
      ,[IsWon]
      ,[Name]
      ,[Payment_Type__c]
      ,[StageName]
      ,[Type]
      ,[stayclassy__sc_order_id__c]
      ,[stayclassy__check_number__c]
  FROM [dbo].[sf_opportunities_jul_sep_18]
  ORDER BY Id

-- test queries
/***
select id, count(*)
from sf_opportunities
group by id;
***/

set nocount off

select ID, count(*)
from mlf_sf_ids
group by id
having (count(*) > 1);

select a.* from sf_opportunities a
left join mlf_sf_ids b on a.Id = b.Id
where b.id is null
and a.StageName = 'Received'
and a.CloseDate >= '2018-01-01'
and a.CloseDate < '2018-07-01'
order by a.id

