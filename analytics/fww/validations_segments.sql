use fww;

set nocount on

--alter table donations_actions_contacts_segmented alter column Amount float not null;

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
declare @segment int;

set @channel = 'Distributed Organizing';
set @type = 'Relay';
set @segment = 4;

--select count(*) from donations_actions_contacts_segmented; -- 10,199,017

set @totalrecordcount = (select count(*) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment); -- 906
set @totaldonations = (select sum(amount) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 1); -- $242
set @contactdistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment); -- 561
set @contactcount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment); -- 687
set @donorcount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 1); -- 8
set @donordistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 1); -- 7
set @donornewcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 1 and active = 1); 
set @activistcount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 2); -- 643
set @activistdistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 2); -- 554
set @activistnewcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 2 and active = 1);
set @unsubscribecount = (select count(contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 3); -- 36
set @unsubscribedistinctcount = (select count(distinct contactid) from donations_actions_contacts_segmented where channel = @channel and type = @type and segment = @segment and recordtype = 3); -- 36

print N'Channel,' + rtrim(@channel);
print N'Type,' + rtrim(@type);
print N'Total Number of Records,' +  cast(@totalrecordcount as nvarchar(40));
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

set nocount off