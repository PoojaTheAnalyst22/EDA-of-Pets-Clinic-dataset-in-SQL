

 USE pets; 

/* Now that we have imported the data sets, let’s explore some of the tables. 
 To begin with, Let's know the shape of the tables and whether any column has null values.
*/


-- Finding the total number of rows in each table of the schema

 select count(*) from Pets;
 select count(*) from POwners;
 select count(*) from ProceduresDetails;
 select count(*) from ProceduresHistory;


-- Checking the pets table

 Select * from Pets;


-- Checking columns in the pets table for null values
-- we use case statements here

 select sum(case
             when 'petid' is null then 1
             else 0
           end) as petid__null_count,
		sum(case
             when 'name' is null then 1
             else 0
           end) as name__null_count,
		sum(case
             when 'kind' is null then 1
             else 0
           end) as kind__null_count,
		sum(case
             when 'gender' is null then 1
             else 0
           end) as gender__null_count,
		sum(case
             when 'age' is null then 1
             else 0
           end) as Age__null_count,
	   sum(case
             when 'owenerid' is null then 1
             else 0
           end) as owenerid__null_count
           
 From Pets;

/* Ans :
   We can see zero columns of the pets table has null values.*/ 


-- Finding the unique list of the kind present in the data set

 select distinct(kind) from pets;


-- Lets find total numbers of each kind

 select distinct kind, count(kind) total_number_of_each_kind from pets
 group by kind


-- Now, Check out male & female count 

 select kind, 
 count(case when gender = 'male' then 1  end)as male_count,
 count(case when gender = 'female' then 1  end) as female_count ,
 count(*) as total_count
 from Pets
 group by kind


-- let's find the minimum, average and  maximum price of the clinic

 select max(price) as max_price, avg(price) as avg_price, min(price) as min_price
 from ProceduresDetails;


-- join tables Pets & POwners
-- Find the top 10 cities where maximum no. of pets are living

 select Top 10 o.city, count(p.kind) as number_of_pets from POwners O
 join Pets p 
 on o.OwnerID = p.OwnerID
 group by city
 order by number_of_pets desc
 

-- find out the life_stage of pet with respect to age

 select * ,
 case
 when age <=2 then 'baby' 
 when age <=6 then 'young'
 when age <=10 then 'adult'
 else 'old'
 end as life_stage
 from pets


-- Extract information on pets names and owner names side-by-side
  
 select p.name as pets_names, o.name as owner_names
 from pets p , powners o
 where p.OwnerID = o.Ownerid


-- Find out which pets from this clinic had procedures performed

 select  p.Petid , p.kind , h.ProcedureType
 from pets p ,  ProceduresHistory h
 where p.Petid = h.PetID


-- match up all procedures performed to their description

 alter table proceduresdetails
 add constraint pk_ptype_code
 primary key (proceduretype,proceduresubcode)


 select d.proceduretype, d.description
 from  ProceduresDetails d
 inner join ProceduresHistory h
 on d.ProcedureSubCode = h.ProcedureSubCode
 and d.ProcedureType = h.ProcedureType
 group by d.ProcedureType,d.description


-- same as above but only / pets from clinic in question

 select p.Petid, h.proceduretype, d.description 
 from ProceduresHistory h , ProceduresDetails d, pets p
 where h.ProcedureSubCode = d.ProcedureSubCode
 and h.ProcedureType=d.ProcedureType
 and p.petid=h.PetID
 order by ProcedureType asc 



-- count the pets in each life_stage

 select kind,
 count( case when age <=2 then 1 end) as baby_count,
 count(case when age between 3 and 6 then 1 end) as young_count,
 count(case when age between 7 and 10 then 1 end) as adult_count,
 count (case when age  >10 then 1 end) as old_count,
 count(*) as total_count 
 from pets
 group by kind

 

-- Finding Which proceduretype used maximum time

 select proceduretype, count(proceduretype) as number_of_proceduretype
 from Procedureshistory
 group by ProcedureType

/* vaccination is most common proceduretype */


-- extract table of individual costs(proceddure prices)
-- incurred by owner & procedure price side - by - side


 select o.name as owner_name, d.price , d.proceduresubcode, d.proceduretype
 from ProceduresDetails d
 join ProceduresHistory h
 on d.ProcedureSubCode= h.ProcedureSubCode
 and d.ProcedureType=h.ProcedureType
 join pets p
 on h.PetID=p.Petid
 join powners o
 on p.OwnerID=o.ownerid



-- Finding the total number of prets had procedure each month 

 select date, count(petid) as 'number_of_pets'
 from ProceduresHistory
 group by date
 order by number_of_pets desc ;

/* 2016-02-04 month has maximum number procedures - 68  */



-- Find out the details of procedre on 2016-02-04

 select h.proceduretype , d.description from ProceduresHistory h
 join ProceduresDetails d
 on h.ProcedureSubCode = d.ProcedureSubCode
 where date = '2016-02-04'
 group by h.ProcedureType, d.Description


-- Now, let’s find out the top 10 description based on price

 select top 10 Description, price, 
 dense_rank() over(order by price DESC) as price_rank
 from ProceduresDetails







