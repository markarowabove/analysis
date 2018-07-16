-- org affiliations
use raftdb2den;

-- update the table for prepare for import
--alter table nameorg drop column Raft_Db2_Compound_Id;
--alter table nameorg add Raft_Db2_Compound_Id uniqueidentifier default newid();
--update nameorg set Raft_Db2_Compound_Id = newid();
--update organizations set email = '' where email is null;

select * from LookupNameOrgType;
select * from NameOrg;

-- test query
select a.OrgId as RaftDb2Id_Organization__c
	, a.NameId as RaftDb2Id_Contact__c
	, c.First
	, c.Last
	, b.NameOrgType as npe5__Role__c
	, 1 as npe5__Primary__c
	, a.Raft_Db2_Compound_Id as Raft_Db2_Compound_Id__c 
from NameOrg a
left join LookupNameOrgType b on a.type = b.NameOrgTypeID
left join names c on a.nameid = c.id
--where a.orgid in ('1','2','3')
--order by a.Raft_Db2_Compound_Id;
order by a.orgid;

-- dump org affiliations
-- npe5__Organization__r_Raft_Db2_Id__c,npe5__Contact__r_Raft_Db2_Id__c,npe5__Role__c,npe5__Primary__c,Raft_Db2_Compound_Id__c
select a.OrgId as Raft_Db2_Id_Organization__c
	, a.NameId as Raft_Db2_Id_Contact__c
	, b.NameOrgType as npe5__Role__c
	, 1 as npe5__Primary__c
	, a.Raft_Db2_Compound_Id as Raft_Db2_Compound_Id__c 
from NameOrg a
left join LookupNameOrgType b on a.type = b.NameOrgTypeID
order by a.Raft_Db2_Compound_Id;

select c.First, c.Last, a.*, b.* from nameorg a
inner join organizations b on a.orgid = b.id
left join names c on a.nameid = c.id
order by a.orgid;




