-- dp campaigns
use dp;

if (object_id('tempdb..#campaigns') is not null) begin drop table #campaigns end;
select distinct a.campaign into #campaigns
from dpgift a 
where a.campaign != ''
order by a.campaign;

-- select * from #campaigns order by campaign;

-- dump campaigns
select '012f4000000iS0Z' as RecordTypeId
	, isnull(b.campaign,'') as Name
from dpgift a
left join #campaigns b on a.campaign = b.campaign
where a.record_type in ('P','G')
	and a.campaign != ''
order by b.campaign;