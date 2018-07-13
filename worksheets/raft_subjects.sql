--this creates a CSV file for teacher subjects
use raftdb2den;

set nocount on;

declare @compoundid varchar(50);
declare @subject varchar(100);
declare @i int;
declare @subjectcount int;
declare @subjectstr varchar(500);
declare @subjectlabel varchar(500);

if (object_id('tempdb..#appkeys') is not null) begin drop table #appkeys end;
select max(applicationkey) as appkey into #appkeys from application where teacherid != '' group by nameid order by appkey;

if (object_id('tempdb..#application') is not null) begin drop table #application end;
select a.applicationkey,a.nameid into #application 
from application a
inner join #appkeys b on a.ApplicationKey = b.appkey;
--select * from #application;

-- create a temp table of subject labels
if (object_id('tempdb..#subjectlabels') is not null) begin drop table #subjectlabels end;
create table #subjectlabels (
	label varchar(100)
	, id varchar(50)
)
insert into #subjectlabels (label,id) 
	select 
		case
			when f.Subject = 'Art/Music/Drama' then 'Art/Music/Theater'
			when f.Subject = 'Career Ed/ Life Skills' then 'Other'
			when f.Subject = 'Vocational' then 'Other'
			when f.Subject = 'Core Elementary' then 'Core Elementary'
			when f.Subject = 'Early Education' then 'ECE'
			when f.Subject = 'English/Language Arts' then 'Humanities'
			when f.Subject = 'Foreign Language' then 'Humanities'
			when f.Subject = 'History/Social Studies' then 'Humanities'
			when f.Subject = 'Math' then 'STEM'
			when f.Subject = 'Other' then 'Other'
			when f.Subject = 'Sciences' then 'STEM'
			when f.Subject = 'Technology' then 'STEM'
			when f.Subject = 'Vocational' then 'Other'
		end as label
		, a.Raft_Db2_Compound_Id as id
	from teachers a
	inner join #application b on a.NameID = b.NameID
	left join ApplicationSubject e on b.ApplicationKey = e.ApplicationKey
	left join Subjects f on e.SubjectID = f.SubjectID
	where f.subject is not null
	order by a.Raft_Db2_Compound_Id;
--select * from #subjectlabels;

set nocount off;

declare subjects_cursor cursor for
select distinct a.Raft_Db2_Compound_Id
from teachers a
inner join #application b on a.NameID = b.NameID
left join ApplicationSubject e on b.ApplicationKey = e.ApplicationKey
left join Subjects f on e.SubjectID = f.SubjectID
where f.subject is not null
order by a.Raft_Db2_Compound_Id;

open subjects_cursor;
fetch next from subjects_cursor into @compoundid

print 'Raft_Db2_Compound_Id__c,Subjects__c';
while @@FETCH_STATUS = 0
begin
	--print 'Compound ID: ' + @compoundid;
	set @subjectlabel = '';
	select @subjectlabel = coalesce(@subjectlabel,'') + label + ';' from (select distinct label from #subjectlabels where id = @compoundid) a;
	--print '@subjectlabel: ' + @subjectlabel;
		
	print @compoundid + ',' + @subjectlabel;
	fetch next from subjects_cursor into @compoundid;
end;

close subjects_cursor;
deallocate subjects_cursor;
