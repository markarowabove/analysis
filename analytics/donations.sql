use fww;

/***************** DONATIONS *************/
if object_id('dbo.source_donations','U') is not null
	drop table source_donations;
select id
	, Origin_Source_Code_Channel__c as channel
	, Origin_Source_Code_Type__c as type
	, joineddate
	, Total_Combined_Credits_Lifetime__c as amount
	into source_donations
from sources
where Total_Combined_Credits_Lifetime__c > 0
order by id;
-- select * from source_donations;
