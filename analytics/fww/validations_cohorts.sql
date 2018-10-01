use fww;

set nocount on

--alter table donations_actions_contacts_segmented alter column Amount float not null;
/*********** CONTACTS SEGMENTS ***********/
-- segment 1: 0 - 91 days (0 - 3 months)
-- segment 2: 92 - 183 days (3 - 6 months)
-- segment 3: 184 - 275 days (6 - 9 months)
-- segment 4: 276 - 367 days (9 - 12 months)
-- segment 5: 368 - 733 days (12 - 24 months) (2 years)
-- segment 6: 734 - 1098 (12 - 36 months) (3 years)
-- segment 7: 1099+ (36+ months) (> 3 years)

declare @channel nvarchar(255);
declare @type nvarchar(255);
declare @totalrecordcount int;
declare @totaldonations float;
declare @contactdistinctcount int;
declare @contactcount int;
declare @donorcount int;
declare @donordistinctcount int;
declare @donornewcount int;
declare @activistcount int;
declare @activistdistinctcount int;
declare @activistnewcount int;
declare @unsubscribecount int;
declare @unsubscribedistinctcount int;
declare @cohortmax int;
declare @cohort int;

set @channel = 'Distributed Organizing';
set @type = 'Relay';

set @cohortmax = 4;

print N'Channel,' + @channel;
print N'Type,' + @type;

set @cohort = 1;
while (@cohort <= @cohortmax)
begin

	set @totalrecordcount = (select count(*) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort); -- 906
	set @totaldonations = (select sum(amount) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 1); -- $242
	set @contactdistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort); -- 561
	set @contactcount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort); -- 687
	set @donorcount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 1); -- 8
	set @donordistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 1); -- 7
	set @donornewcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 1 and active = 1); 
	set @activistcount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 2); -- 643
	set @activistdistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 2); -- 554
	set @activistnewcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 2 and active = 1);
	set @unsubscribecount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 3); -- 36
	set @unsubscribedistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and cohort = @cohort and recordtype = 3); -- 36

	print N',';
	print N'Cohort Segment,' + cast(@cohort as nvarchar(40));
	print N'Total Number of Records,' +  rtrim(cast(@totalrecordcount as nvarchar(40)));
	print N'Total Amount Donations,' +  cast(@totaldonations as nvarchar(40));
	print N'Total Number of Contacts,' +  cast(@contactcount as nvarchar(40));
	print N'Total Number of Distinct Contacts,' +  cast(@contactdistinctcount as nvarchar(40));
	print N'Total Number of Donors,' +  cast(@donorcount as nvarchar(40));
	print N'Total Number of Distinct Donors,' +  cast(@donordistinctcount as nvarchar(40));
	print N'Total Number of New Donors,' +  cast(@donornewcount as nvarchar(40));
	print N'Total Number of Activists,' +  cast(@activistcount as nvarchar(40));
	print N'Total Number of Distinct Activists,' +  cast(@activistdistinctcount as nvarchar(40));
	print N'Total Number of New Activists,' +  cast(@activistnewcount as nvarchar(40));
	print N'Total Number of Unsubscribes,' +  cast(@unsubscribecount as nvarchar(40));

	set @cohort = @cohort + 1;

end

set nocount off

select * from donations_actions_contacts_segmented where channel = 'Distributed Organizing'  and type = 'Relay' order by recordtype, segment, cohort;

select * from donations_actions_contacts_segmented where channel = 'Distributed Organizing'  and type = 'Relay' and recordtype = 1 order by cohort, segment, amount;