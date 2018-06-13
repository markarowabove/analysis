-- affiliations
use raftdb2den;

select * from LookupNameOrgType;
select * from NameOrg;

-- RaftDb2Id_Organization__c,RaftDb2Id_Contact__c,npe5__Role__c,npe5__Primary__c
select top 9 a.OrgId as RaftDb2Id_Organization__c
	, a.NameId as RaftDb2Id_Contact__c
	, b.NameOrgType as npe5__Role__c
	, 1 as npe5__Primary__c
from NameOrg a
left join LookupNameOrgType b on a.type = b.NameOrgTypeID
order by a.OrgId;
