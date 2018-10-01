create function replacechar (@charfind char(1), @charreplace char(1), @inputstr varchar(255))
returns varchar(255)
as
begin
declare @resultstr varchar(255)
set @resultstr = @inputstr
while charindex(@charfind, @resultstr) > 0
    set @resultstr = replace(@inputstr,@charfind,@charreplace)
return @resultstr
end