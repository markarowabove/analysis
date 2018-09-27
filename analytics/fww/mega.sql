use fww;

alter table donations_actions_contacts_segmented alter column Amount float not null;

select count(*) from donations_actions_contacts_segmented; -- 10,199,017
select count(*) from donations_actions_contacts_segmented where channel = 'Distributed Organizing' and type = 'Relay'; -- 906
select distinct contactid from donations_actions_contacts_segmented where channel = 'Distributed Organizing' and type = 'Relay' and segment = 1;
select contactid from donations_actions_contacts_segmented where channel = 'Distributed Organizing' and type = 'Relay' and segment = 1;
select contactid from donations_actions_contacts_segmented where channel = 'Distributed Organizing' and type = 'Relay' and segment = 1 and recordtype = 1;
select distinct contactid from donations_actions_contacts_segmented where channel = 'Distributed Organizing' and type = 'Relay' and segment = 1 and recordtype = 1;
select distinct contactid from donations_actions_contacts_segmented where channel = 'Distributed Organizing' and type = 'Relay' and segment = 1 and recordtype = 2;
select distinct contactid from donations_actions_contacts_segmented where channel = 'Distributed Organizing' and type = 'Relay' and segment = 1 and recordtype = 3;

select count(*) from donations_actions_contacts_segmented where channel = 'FWA Website' and type = 'Donate Button'; -- 73
select distinct contactid from donations_actions_contacts_segmented where channel = 'FWA Website' and type = 'Donate Button' and segment = 1;
select distinct contactid from donations_actions_contacts_segmented where channel = 'FWA Website' and type = 'Donate Button' and segment = 1 and recordtype = 1;
select distinct contactid from donations_actions_contacts_segmented where channel = 'FWA Website' and type = 'Donate Button' and segment = 1 and recordtype = 1 and active = 1;

select count(*) from donations_actions_contacts_segmented 
where channel = 'Integrated Channels' and type = 'DM' and segment = 1 and recordtype = 1;
select sum(amount) from donations_actions_contacts_segmented 
where channel = 'Integrated Channels' and type = 'DM' and segment = 1 and recordtype = 1;
select distinct contactid from donations_actions_contacts_segmented 
where channel = 'Integrated Channels' and type = 'DM' and segment = 1 and recordtype = 1;