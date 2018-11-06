-- db2 phones
use raftdb2den;

--PhoneTypeID	PhoneType
--1	alternate
--2	cell phone
--3	emergency
--4	fax
--5	home
--6	pager
--7	work
--8	Primary

-- get phones
-- Raft_Db2_Id,HomePhone,MobilePhone,OtherPhone,Phone,npe01__WorkPhone__c,Id
select a.nameid as Raft_Db2_Id
	, case
		when a.type = 5 then a.phone else ''
	  end as HomePhone
	, case
		when a.type = 2 then a.phone else ''
	  end as MobilePhone
	, case
		when a.type = 1 then a.phone else ''
	  end as OtherPhone
	, case
		when a.type = 8 then a.phone else ''
	  end as Phone
	, case
		when a.type = 7 then a.phone else ''
	  end as npe01__WorkPhone__c	
	, c.id as Id
from phones a
inner join names b on a.nameid = b.id
left join sf.dbo.contacts c on a.nameid = c.Raft_Db2_Id
where a.phone != ''
order by a.nameid;