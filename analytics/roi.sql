use fww;



-- 686,638
select count(a.id)
from contacts a
inner join opportunities b on a.id = b.npsp__Primary_Contact__c;

-- 686,638
select a.npsp__Primary_Contact__c, b.id
from opportunities a
left join contacts b on a.npsp__Primary_Contact__c = b.id
where a.npsp__Primary_Contact__c != ''
order by a.npsp__Primary_Contact__c;
