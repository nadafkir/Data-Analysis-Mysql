
-- CLEANING DATA ::::::::::::::::::::::::::::

-- 1. remove dublicate 
-- 2. Standardize the data 
-- 3. looking for Null values or blank values 
-- 4. RemovE any rows or  columns 

create table staging like layoffs;
insert into  staging select * from layoffs;
select * from staging;
select *, row_number() over( partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_numb from staging;

WITH cte_duplicate AS 
(select *, row_number() over( partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_numb from staging)

select * from cte_duplicate where row_numb >1;

CREATE TABLE `staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_numb` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert into staging2 select *, row_number() over( partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_numb from staging;

select * from staging2 where row_numb > 1;

delete from staging2 where row_numb > 1;

SET SQL_SAFE_UPDATES = 0;

select company, trim(company) from staging2;

update staging2
set company=trim(company);

select distinct industry from staging2;

select * from staging2 where industry like 'Crypto%';

update staging2 set industry = 'Crypto' where industry like 'Crypto%';

select count(*) from staging2 where industry like 'Crypto%';
-- gives same result 

select distinct country from staging2;

update staging2 set country = 'United States' where country like 'United States%';
-- set country = trim( trailing '.' from country) where country like 'United States%'

select `date` , str_to_date(`date`, '%m/%d/%Y') from staging2;

update staging2 set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table staging2 modify column `date` DATE;
 
select * from staging2 where total_laid_off is NULL
AND percentage_laid_off is NULL;

select * from staging2 where industry is NULL OR industry = '';

select * from staging2 where company = "Airbnb";

select * from staging2 t1
JOIN staging2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL ;

update staging2 set industry = NULL where industry='';

UPDATE staging2 t1
JOIN staging2 t2 ON t1.company = t2.company
SET t1.industry= t2.industry
where (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

SELECT *  FROM staging2 
WHERE total_laid_off IS NULL 
AND  percentage_laid_off IS NULL;

DELETE from staging2
WHERE total_laid_off IS NULL 
AND  percentage_laid_off IS NULL;

alter table staging2
drop column row_numb;

select * from staging2 where company="Airbnb";

select * from staging2;

-- DONE --------------------------------------


