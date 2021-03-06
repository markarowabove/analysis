-- workshops
use raftdb2den;

if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.Id as Id into #ids from workshops a
left join raftdb2den_old.dbo.workshops b on a.Id = b.Id
where b.Id is null;
--select * from #ids order by id;

select * from workshops order by Id;

select distinct description from terms order by description;

--update scripts
--select * from terms
--update terms set description = 'Fall Workshops'
--update terms set description = 'Winter Workshops'
--update terms set description = 'Spring Workshops'
update terms set description = 'Summer Workshops'
--update terms set description = 'Symposium'
where 1=1
-- and description = 'Fall 2009';
-- and description like 'February%';
-- and description like 'January%';
--and description like 'November%';
 and description = 'Summer 2009'
--and description = 'Symposium III';
-- and termid = 54;

select * from workshops where UpperGradeRange > 12;
select title, left(title,80) from workshops where id = 353;
update workshops set title = 'Dem Bones, Dem Bones, Dem Dry Bones are Simple Machines? with Chris DeKay' where id = 353;

-- dump test load workshops
-- Raft_Db2_Id__c,Name,StartDate,Sponsor_Name__c,Member_Cost__c,Non_Member_Cost__c,Description,Lower_Grade_Range__c,Upper_Grade_Range__c,Capacity__c,EndDate,Cost_Text__c,Audience__c,Published__c,Status,Type,Category__c,RecordTypeId,IsActive
select top 20 a.Id as Raft_Db2_Id__c
	, left(a.title,80) as Name
	, isnull(convert(nvarchar,a.Time,126),'') as StartDate
	, isnull(a.Sponsor,'') as Sponsor_Name__c
	, a.MemberCost as Member_Cost__c
	, a.NonMemberCost as Non_Member_Cost__c
	, isnull(a.CourseDescription,'') as Description
	, a.LowerGradeRange as Lower_Grade_Range__c
	, a.UpperGradeRange as Upper_Grade_Range__c
	, a.Limit as Capacity__c
	, isnull(convert(nvarchar,a.EndTime,126),'') as EndDate
	, isnull(a.CostText,'') as Cost_Text__c
	, isnull(a.Target,'') as Audience__c
	, case  
		when a.DontUpload = 0 then 1
		when a.DontUpload = 1 then 0
	  end as Published__c
	, case	
		when a.Cancelled = 1 then 'Aborted'
		when a.Cancelled = 0 then 'Completed'
	  end as Status
	, b.CourseType as Type
	, c.Description as Category__c
	, '012f4000000iS0ZAAU' as RecordTypeId
	, case
		when a.Cancelled > 1 then 1
		when a.Cancelled <=1 then 0
	  end as IsActive
from workshops a
left join LookupWorkshopTypes b on a.CourseType = b.WSTypeID
left join Terms c on a.term = c.TermID
where a.Title not like 'CANCELLED:%'
order by a.Id;

-- dump workshops
-- Raft_Db2_Id__c,Name,StartDate,Sponsor_Name__c,Member_Cost__c,Non_Member_Cost__c,Description,Lower_Grade_Range__c,Upper_Grade_Range__c,Capacity__c,EndDate,Cost_Text__c,Audience__c,Published__c,Status,Type,Category__c,RecordTypeId,IsActive
select a.Id as Raft_Db2_Id__c
	, left(a.title,80) as Name
	, isnull(convert(nvarchar,a.Time,126),'') as StartDate
	, isnull(a.Sponsor,'') as Sponsor_Name__c
	, a.MemberCost as Member_Cost__c
	, a.NonMemberCost as Non_Member_Cost__c
	, isnull(a.CourseDescription,'') as Description
	, a.LowerGradeRange as Lower_Grade_Range__c
	, a.UpperGradeRange as Upper_Grade_Range__c
	, a.Limit as Capacity__c
	, isnull(convert(nvarchar,a.EndTime,126),'') as EndDate
	, isnull(a.CostText,'') as Cost_Text__c
	, isnull(a.Target,'') as Audience__c
	, case  
		when a.DontUpload = 0 then 1
		when a.DontUpload = 1 then 0
	  end as Published__c
	, case	
		when a.Cancelled = 1 then 'Aborted'
		when a.Cancelled = 0 then 'Completed'
	  end as Status
	, b.CourseType as Type
	, c.Description as Category__c
	, '012f4000000iS0ZAAU' as RecordTypeId
	, case
		when a.Cancelled > 1 then 1
		when a.Cancelled <=1 then 0
	  end as IsActive
	, 'DB2 Import 20180725' as Import_Tag__c
from workshops a
left join LookupWorkshopTypes b on a.CourseType = b.WSTypeID
left join Terms c on a.term = c.TermID
inner join #ids d on a.id = d.id
where a.Title not like 'CANCELLED:%'
order by a.Id;
