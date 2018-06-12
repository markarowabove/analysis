use raftdb2den;

select count(*) from organizations;

select * from organizations 
where volorgtypeid = 10
order by Organization;

-- dupe check in organizations
select id, count(*) as dupes
from organizations
group by id
having (count(*) > 1);

-- get org description
select * from lookupvolorgtypes;

-- get distinct school type
select distinct Text from lookupSchType;
select * from lookupSchType order by Text;

select a.id as RaftId
	, a.Organization as Name
	, isnull(convert(nvarchar,a.Timestamp,126),'') as CreatedDate
	, isnull(a.Archive,'') as Archive
	, '012f400000192PS' as AccountRecordType 
	, b.Description as Type
--	, c.Text as SchoolType__c
from Organizations a
left join lookupvolorgtypes b on a.VolOrgTypeID = b.VolorgtypeID
left join LookupSchtype c 
--where Last != ''
order by a.Organization;