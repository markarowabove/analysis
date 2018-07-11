-- sf accounts
-- this is an import of the exported SF accounts
use sf;

-- update queries
alter table accounts alter column Raft_Db2_Id int not null;
alter table accounts add constraint pk_accounts primary key(id);

select * from accounts order by Raft_Db2_Id;