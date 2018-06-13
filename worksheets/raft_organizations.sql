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
-- RaftId,Name,CreatedDate,IsArchive__c,Type,SchoolType__c,CDSCode__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,Phone,AccountRecordType
select top 3 a.id as RaftId
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
--where Last != ''
order by a.Organization;

Select Organizations.*, 
lookupVolorgtypes.Description, 
lookupvolorgtypes.CanBeMemberOrg, 
OrgAddresses.IsPrimary, 
OrgAddresses.Street, 
OrgAddresses.Street2, 
OrgAddresses.City, 
OrgAddresses.State,
OrgAddresses.Zip, 
OrgPhones.Phone, 
OrgPhones.Type,
lookupPhonetype.PhoneType, 
SchoolOrgs.Mailcode, 
SchoolOrgs.District, 
SchoolOrgs.cds_code, 
SChoolOrgs.Title1, 
SchoolOrgs.Principal,
SchoolOrgs.TeacherCount, 
SchoolOrgs.Tax,
SchoolOrgs.Type, 
LookupSchType.Text,
LookupSchType.PublicSchool
 from Organizations
LEFT JOIN lookupVolorgtypes on Organizations.volOrgTypeID = lookupVolorgtypes.volorgtypeId
LEFT JOIN OrgAddresses on Organizations.Id = OrgAddresses.OrgId AND OrgAddresses.IsPrimary=1
LEFT JOIN OrgPhones on Organizations.Id = OrgPhones.OrgID AND Type=8
LEFT JOIN lookupPhonetype on OrgPhones.Type = lookupPhonetype.PhoneTypeId
LEFT JOIN SchoolOrgs on Organizations.Id = SchoolOrgs.OrgID
LEFT JOIN lookupSchType on SchoolOrgs.Type = LookupSchtype.TypeId