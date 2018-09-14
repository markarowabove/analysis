use mlf;

-- update queries
alter table opportunities alter column id int not null;
alter table opportunities add constraint pk_opportunities primary key(id);
alter table opportunities alter column Date date not null;

select Debit from opportunities order by Debit;
update opportunities set Debit = 0 where Debit = '';
select Debit from opportunities where Debit  like '%,%';
update opportunities set Debit = replace(Debit,',','') where Debit like '%,%';
alter table opportunities alter column Debit float;

select Credit from opportunities order by Credit;
update opportunities set Credit = 0 where Credit = '';
select Credit from opportunities where Credit  like '%,%';
update opportunities set Credit = replace(Credit,',','') where Credit like '%,%';
alter table opportunities alter column Credit float;

select Balance from opportunities order by Balance;
update opportunities set Balance = 0 where Balance = '';
select Balance from opportunities where Balance  like '%,%';
update opportunities set Balance = replace(Balance,',','') where Balance like '%,%';
alter table opportunities alter column Balance float;

alter table opportunities add LastName nvarchar(255); 

declare @i int
declare @icnt int
declare @lastname nvarchar(255)
declare @name nvarchar(255)
declare @commaindex int

-- select * from opportunities order by accountname; -- 23,163
set @i = 1
select @icnt = count(*) from opportunities;
while (@i <= @icnt) 
begin
	set @commaindex = (select charindex(',',name,1) from opportunities where id = @i);
	if @commaindex > 0
	begin
		set @lastname = '';
		set @name = '';
		set @name = (select name from opportunities where id = @i);
		set @lastname = (select left(name,charindex(',',name,1)-1) from opportunities where id = @i);
		set @lastname = (select SUBSTRING(@lastname, 1 ,
			case when  CHARINDEX(' ', @lastname ) = 0 then LEN(@lastname) 
			else CHARINDEX(' ', @lastname) -1 end));
		update opportunities set LastName = @lastname where id = @i;
		print N' name: ' + @name + ' -- last name: ' + @lastname;
	end
	set @i = @i + 1;
end

-- test queries
/***
select type, count(*)
from opportunities
group by type;
***/