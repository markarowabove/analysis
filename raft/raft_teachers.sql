-- raft teachers
use raftdb2den;

select a.* from teachers a
inner join names b on a.nameid = b.id
order by a.nameid;