use dp;

select count(*) from dp;
select count(*) from dpaddress;
select count(*) from dpcodes where code IS NOT NULL;
select count(*) from dpcontact;
select count(*) from dpgiftudf;
select count(*) from dplink;
select count(*) from dpudf;
select count(*) from dpusermultivalues;

/********* dp ****************/
-- look for complex last names
select donor_id, first_name, last_name, org_rec, donor_type from dp where first_name is NULL 
and last_name is not null
and org_rec = 'N'
order by donor_type;

-- get unique donor types
select distinct donor_type from dp
order by donor_type;

--NULL
--BIZ
--BUSIN1
--CO
--FOUND2
--IN
--INDIV3
--JO
--OR
--ORGAN4




-- get all gifts
select a.first_name, a.last_name, a.donor_type, b.amount from dp a
inner join dpgift b on a.donor_id = b.donor_id
order by a.last_name;
