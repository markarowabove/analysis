use mlf;

--select class from opportunities where class like '%:%' order by class;
--select class, fund from opportunities order by class;
/*** count duplicates -- its ok to have dupes
select fund, count(*)
from opportunities
group by fund
order by count(*);
**/

-- update queries
/****
alter table opportunities alter column id int not null;
alter table opportunities add constraint pk_opportunities primary key(id);
alter table opportunities alter column Date date not null;
alter table opportunities add namekey nvarchar(255);
alter table opportunities add fund nvarchar(255);

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

-- update data queries
update 
--select id, name from
opportunities 
set name = replace(name,',','') 
where name like 'YourCause,%' or name like '%Inc%';
--order by name;

update opportunities set name = 'Batlan, Robert D. and Mary Lou' where name = 'Batlan, Robert D. ("Bob") and Mary Lou';
update opportunities set name = 'Alexander, Margo' where name = 'Alexander, Margo (2)';
update opportunities set name = 'Glenn, Michael & Lisa' where name = 'Glenn, Michael & Lisa (Maura)';
update opportunities set name = 'Henderson, Danny "Preacher"' where name = 'Henderson, Danny "Preacher"';
update opportunities set name = 'Klasson, Eric' where name = 'Klasson, Eric (donor)';
update opportunities set name = 'Lewis-Johnson, Carrie' where name = 'Lewis-Johnson, Carrie (donor)';
update opportunities set name = 'Lubben, John' where name = 'Lubben, John "Jack"';
update opportunities set name = 'Lutz, Amy' where name = 'Lutz, Amy (was Mooney)';
update opportunities set name = 'Mason, DLanna J and John T' where name = 'Mason, D''Lanna J and John T';
update opportunities set name = 'McConkey, Suzanne and Robert' where name = 'McConkey, Suzanne and Robert - CF Tenant';
update opportunities set name = 'McDonald, Mary Ross & James R' where name = 'McDonald, Mary Ross & James R (Bob&Polly)';
update opportunities set name = 'Meihaus, Carolyn and George' where name = 'Meihaus, Carolyn and George, III';
update opportunities set name = 'Miller, Nancy & Edward' where name = 'Miller, Nancy & Edward - CF Tenant';
update opportunities set name = 'Moore, Tim' where name = 'Moore, Tim 2';
update opportunities set name = 'Mullin, Matthew B and Lynne' where name ='Mullin, Matthew B and Lynne  (donor)';
update opportunities set name = 'Olsson, Clas & Marianne Barnevik' where name ='Olsson, Clas & Marianne Barnevik-';
update opportunities set name = 'Reynolds, Robert & Carol' where name ='Reynolds, Robert (Rob) & Carol';
update opportunities set name = 'Smith, Rachel' where name ='Smith, Rachel (2)';
update opportunities set name = 'Yi-O''Kelly, Seagan' where name ='Yi-OKelly, Seagan';
update opportunities set name = 'Young, James' where name ='Young, James (2)';
update opportunities set name = 'McDonald''s Corporation' where name = 'McDonald''s (cust)';
update opportunities set name = 'Deborah Sour' where id = 2833;
update opportunities set name = 'Waylon Walker' where id = 2887;
update opportunities set name = 'Rolling Hills Church' where id = 3997;
update opportunities set name = 'National Christian Foundation Houston' where id = 4177;
update opportunities set name = 'MISSING NAME 4823' where id = 4823;
update opportunities set name = 'MISSING NAME  4824' where id = 4824;
update opportunities set name = 'JP''s Peace Love & Happiness Foundation' where name = 'JPs Peace Love & Happiness Foundation';


update opportunities set name = 'Alexander, Margo' where name = 'Alexander, Margo (2)';
update opportunities set name = 'Batlan, Robert D. and Mary Lou' where id = 164;
update opportunities set name = 'Brown, Jan' where name = 'Brown, Jan (2)';
update opportunities set name = 'Chapman Jr, J Winston & Patricia R' where name = 'Chapman Jr, J Winston (Winn) & Patricia R';
update opportunities set name = 'Graham, Taylor' where name = 'Graham, Taylor (donor)';
update opportunities set name = 'HEB' where name = 'HEB (Donor)';
update opportunities set name = 'Klasson, Eric' where name = 'Klasson, Eric (donor)';
update opportunities set name = 'Lutz, Amy' where name = 'Lutz, Amy (was Mooney)';
update opportunities set name = 'McConkey, Suzanne and Robert' where name = 'McConkey, Suzanne and Robert - CF Tenant';
update opportunities set name = 'McDonald, Mary Ross & James R' where name = 'McDonald, Mary Ross & James R (Bob&Polly)';
update opportunities set name = 'Miller, Nancy & Edward' where name = 'iller, Nancy & Edward - CF Tenant';
update opportunities set name = 'Reynolds, Robert & Carol' where name = 'Reynolds, Robert (Rob) & Carol';
update opportunities set name = 'Smith, Rachel' where name = 'Smith, Rachel (2)';
update opportunities set name = 'YourCause, LLC-PwC' where name = 'YourCause, LLC-PwC (Pricewaterhouse)';
update opportunities set name = 'Batlan, Robert D. and Mary Lou' where name = 'Batlan, Robert D. ("Bob") and Mary Lou';
update opportunities set name = 'First Baptist Church Hamilton' where name = 'First Baptist Church (Hamilton)';
update opportunities set name = 'Rowalt, Jim and Beverly B' where name = 'Rowalt, Jim (Ralph) and Beverly B';
insert into opportunities
	select Id, Type, Date, Source, Num, Name, Memo, Class, Split, Debit, Credit, Balance, LastName, namekey
	from mlf_opportunities_jul_sep_18;
select Id, Name, namekey from opportunities where id > 5259 and namekey like '%(%' order by Id;
***/

declare @i int
declare @icnt int
declare @lastname nvarchar(255)
declare @name nvarchar(255)
declare @fund nvarchar(255)
declare @class nvarchar(255)
declare @namekey nvarchar(255)
declare @commaindex int
DECLARE @source VARCHAR(255)
DECLARE @dest VARCHAR(255)
DECLARE @length INT 

-- select * from opportunities where name = '' order by accountname; -- 23,163
-- select * from opportunities where name like '%Happiness%';
set @i = 1
select @icnt = count(*) from opportunities;
while (@i <= @icnt) 
begin
	
	--set @lastname = '';
	set @namekey = '';
	set @name = '';
	set @name = (select name from opportunities where id = @i);
	set @class = (select class from opportunities where id = @i);
	set @fund = (select substring(class, len(class) - charindex(':',reverse(class)) + 2,len(class)) from opportunities where id  = @i);
	--set @lastname = (select left(name,charindex(',',name,1)-1) from opportunities where id = @i);
	--set @lastname = (select SUBSTRING(@lastname, 1 ,
		--case when  CHARINDEX(' ', @lastname ) = 0 then LEN(@lastname) 
		--else CHARINDEX(' ', @lastname) -1 end));
	--update opportunities set LastName = @lastname where id = @i;

	SET @source = replace(@name,' ','')
	SET @source = replace(@source,',',' ')
	SET @dest = ''

	--set @commaindex = (select charindex(',',name,1) from opportunities where id = @i);
	--if @commaindex > 0
	--begin

		WHILE LEN(@source) > 0
		BEGIN
			IF CHARINDEX(' ', @source) > 0
			BEGIN
				SET @dest = SUBSTRING(@source,0,CHARINDEX(' ', @source)) + ' ' + @dest
				SET @source = LTRIM(RTRIM(SUBSTRING(@source,CHARINDEX(' ', @source)+1,LEN(@source))))
			END
			ELSE
			BEGIN
				SET @dest = @source + ' ' + @dest
				SET @source = ''
			END
		END

		set @namekey = rtrim(replace(replace(replace(@dest,' ',''),',',''),'.',''));

		print N' name: ' + @name + ' -- dest: ' + @dest + ' namekey: ' + @namekey + ' class: ' + @class + ' fund: ' + @fund; 
		update opportunities set namekey = @namekey, fund = @fund where id = @i;
	

	--end
	--else
	--begin
		--set @namekey = rtrim(replace(replace(replace(@dest,' ',''),',',''),'.',''));
		--print N' name: ' + @name + ' -- dest: ' + @dest + ' namekey: ' + @namekey; 
		--update opportunities set namekey = @namekey where id = @i;
	--end

	set @i = @i + 1;

end
-- select id, name, namekey from opportunities order by id;
-- test queries
/***
select type, count(*)
from opportunities
group by type;
***/

set nocount off