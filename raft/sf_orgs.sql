-- sf orgs
-- this is an import of the exported SF Org Accounts
use sf;

-- update queries
alter table orgs alter column Raft_Db2_Org_Id int not null;
alter table orgs add constraint pk_orgs primary key(id);

select * from orgs order by Raft_Db2_Org_Id;