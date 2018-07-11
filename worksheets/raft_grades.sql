--this creates a CSV file for teacher grades
use raftdb2den;

set nocount on;

declare @compoundid varchar(50);
declare @gradefromstr varchar(10);
declare @gradetostr varchar(10);
declare @gradefrom int;
declare @gradeto int;
declare @i int;
declare @gradecount int;
declare @gradestr varchar(200);
declare @gradelabel varchar(10);

if (object_id('tempdb..#appkeys') is not null) begin drop table #appkeys end;
select max(applicationkey) as appkey into #appkeys from application where teacherid != '' group by nameid order by appkey;

if (object_id('tempdb..#application') is not null) begin drop table #application end;
select a.applicationkey,a.nameid into #application 
from application a
inner join #appkeys b on a.ApplicationKey = b.appkey;
--select * from #application;

-- create a temp table of grade values and grade labels
if (object_id('tempdb..#gradelabels') is not null) begin drop table #gradelabels end;
create table #gradelabels (
	val int
	, label varchar(10)
)
insert into #gradelabels (val,label) values (-1,'Pre');
insert into #gradelabels (val,label) values (0,'K');
insert into #gradelabels (val,label) values (1,'1');
insert into #gradelabels (val,label) values (2,'2');
insert into #gradelabels (val,label) values (3,'3');
insert into #gradelabels (val,label) values (4,'4');
insert into #gradelabels (val,label) values (5,'5');
insert into #gradelabels (val,label) values (6,'6');
insert into #gradelabels (val,label) values (7,'7');
insert into #gradelabels (val,label) values (8,'8');
insert into #gradelabels (val,label) values (9,'9');
insert into #gradelabels (val,label) values (10,'10');
insert into #gradelabels (val,label) values (11,'11');
insert into #gradelabels (val,label) values (12,'12');
insert into #gradelabels (val,label) values (13,'College');
insert into #gradelabels (val,label) values (14,'Adult');

set nocount off;

declare teachers_cursor cursor for
select isnull(e.GradeFrom,'') as GradeFrom
	, isnull(e.GradeTo,'') as GradeTo
	, a.Raft_Db2_Compound_Id as Raft_Db2_Compound_Id__c
from teachers a
inner join #application b on a.NameID = b.NameID
left join ApplicationGradeLevel e on b.ApplicationKey = e.ApplicationKey
left join schoolorgs c on a.schoolID = c.SchoolID
left join names d on a.NameId = d.ID
where e.GradeFrom is not null
	and e.GradeTo is not null
order by a.SchoolId;

open teachers_cursor;
fetch next from teachers_cursor into @gradefromstr, @gradetostr, @compoundid

print 'Raft_Db2_Compound_Id__c,Grades__c';
while @@FETCH_STATUS = 0
begin
	--print 'Compound ID: ' + @compoundid + ' Grade From: ' + @gradefromstr + ' Grade To: ' + @gradetostr;
	set @i = 0;
	set @gradefrom = convert(int,replace(@gradefromstr,char(0),''));
	set @gradeto = convert(int,replace(@gradetostr,char(0),''));
	set @gradecount = @gradeto - @gradefrom + 1;
	set @gradestr = '';
	while (@i < @gradecount)
	begin
		select @gradelabel = label from #gradelabels where val = @gradefrom + @i;
		set @gradestr = @gradestr + @gradelabel + ';';
		--print '@i : ' + rtrim(cast(@i as nvarchar(10))) + ' @gradelabel: ' + @gradelabel + ' @gradcount: ' + rtrim(cast(@gradecount as nvarchar(10))) + ' Grade Str: ' + rtrim(cast(@gradestr as nvarchar(100)));
		set @i = @i + 1;
	end;
	print @compoundid + ',' + rtrim(cast(@gradestr as nvarchar(100)));
	fetch next from teachers_cursor into @gradefromstr, @gradetostr, @compoundid;
end;

close teachers_cursor;
deallocate teachers_cursor;
