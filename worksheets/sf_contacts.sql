-- sf contacts
-- this is an import of the exported SF contacts
use sf;

-- update queries
alter table contacts alter column Raft_Db2_Id int not null;
alter table contacts add constraint pk_contacts primary key(id);

select * from contacts order by Raft_Db2_Id;