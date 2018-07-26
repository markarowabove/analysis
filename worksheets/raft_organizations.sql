use raftdb2den;

select count(*) from organizations;

-- diff - additional records
if (object_id('tempdb..#ids') is not null) begin drop table #ids end;
select a.id into #ids from organizations a
left join raftdb2den_old.dbo.organizations b on a.id = b.id
where b.id is null;
--select * from #ids order by id;

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
select distinct Text from raftdb2den_old.dbo.lookupSchType;
select * from lookupSchType order by Text;
select distinct Description from lookupvolorgtypes order by Description;

update lookupSchType set Text = 'Unknown' where Text = 'unknown';
update lookupvolorgtypes set Description = 'Corporate' where Description = 'Professional Services';

select * from schoolorgs where orgID = 74;

--dump org data for account import
-- Raft_Db2_Organization_Id__c,Name,CreatedDate,IsArchived__c,Type,SchoolType__c,CDSCode__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,Phone,RecordTypeId
select a.id as RaftId
	, a.Organization as Name
	, isnull(convert(nvarchar,a.Timestamp,126),'') as CreatedDate
	, isnull(a.Archive,'') as IsArchived__c
	, b.Description as Type
	, case
		when d.Text = 'Childcare' then 'Preschool / Other Early Childhood'
		when d.Text = 'Elementary' then 'Elementary School'
		when d.Text = 'K-12 single school' then 'K-12 School'
		when d.Text = 'K-8 Single School' then 'K-8 School'
		when d.Text = 'Non Profit' then 'Other'
		when d.Text = 'Religious Organization' then 'Other'
		when d.Text = 'Unknown' then 'Other'
		when d.Text not in ('Childcare','Elementary','K-12 single school','K-8 Single School','Non Profit','Religious Organization','Unknown') then d.Text
	  end as SchoolType__c
	, isnull(c.cds_code,'') as CDSCode__c  
	, isnull(e.Street,'') + char(13) + isnull(e.street2,'') as BillingStreet
	, isnull(e.city,'') as BillingCity
	, isnull(e.state,'') as BillingState
	, isnull(e.zip,'') as BillingPostalCode
	, isnull(f.phone,'') as Phone
	, '012f400000192PS' as RecordTypeId 
	, 'DB2 Import 20180725' as Import_Tag__c
from Organizations a
left join lookupvolorgtypes b on a.VolOrgTypeID = b.VolorgtypeID
left join schoolorgs c on a.Id = c.OrgID
left join lookupSchType d on c.Type = d.TypeId
left join OrgAddresses e on a.Id = e.OrgId AND e.IsPrimary=1
left join OrgPhones f on a.Id = f.OrgID AND f.Type=8
left join lookupPhonetype g on f.Type = g.PhoneTypeId
inner join #ids h on a.id = h.id
order by a.ID;