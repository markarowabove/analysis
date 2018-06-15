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

update lookupSchType set Text = 'Unknown' where Text = 'unknown';

--dump org data for account import
-- Raft_Db2_Organization_Id__c,Name,CreatedDate,IsArchived__c,Type,SchoolType__c,CDSCode__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,Phone,RecordTypeId
select a.id as RaftId
	, a.Organization as Name
	, isnull(convert(nvarchar,a.Timestamp,126),'') as CreatedDate
	, isnull(a.Archive,'') as IsArchived__c
	, b.Description as Type
	, isnull(d.Text,'') as SchoolType__c
	, isnull(c.cds_code,'') as CDSCode__c  
	, isnull(e.Street,'') + char(13) + isnull(e.street2,'') as BillingStreet
	, isnull(e.city,'') as BillingCity
	, isnull(e.state,'') as BillingState
	, isnull(e.zip,'') as BillingPostalCode
	, isnull(f.phone,'') as Phone
	, '012f400000192PS' as RecordTypeId 
from Organizations a
left join lookupvolorgtypes b on a.VolOrgTypeID = b.VolorgtypeID
left join schoolorgs c on a.Id = c.OrgID
left join lookupSchType d on c.Type = d.TypeId
left join OrgAddresses e on a.Id = e.OrgId AND e.IsPrimary=1
left join OrgPhones f on a.Id = f.OrgID AND f.Type=8
LEFT JOIN lookupPhonetype g on f.Type = g.PhoneTypeId
--where b.Description = 'School'
order by a.id;