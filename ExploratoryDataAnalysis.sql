
-- EXPLOROTARY DATA ANALYSIS

SELECT * FROM staging2;

SELECT MAX(total_laid_off), Max(percentage_laid_off) from staging2;

SELECT * FROM staging2 WHERE  percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) FROM staging2 
GROUP BY company ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`) FROM staging2;

SELECT industry, SUM(total_laid_off) FROM staging2 
GROUP BY industry ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) FROM staging2 
GROUP BY YEAR(`date`) ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off) FROM staging2 
GROUP BY stage ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off) FROM staging2 
GROUP BY company ORDER BY 2 DESC;

SELECT substring(`date`, 6, 2) AS `MONTH` , SUM(total_laid_off)
from staging2 where substring(`date`, 6, 2) is NOT NULL
GROUP BY substring(`date`, 6, 2) ORDER BY 2 DESC;

SELECT company, YEAR(`date`),  SUM(total_laid_off) from staging2 
group by company, YEAR(`date`) ORDER BY 3 DESC ;

WITH Company_year(company, years, total_laid_off) as
(
select company, YEAR(`date`), SUM(total_laid_off)
from staging2 group by company,  YEAR(`date`)
),  Company_Year_Rank AS 
(select * , DENSE_RANK() OVER( PARTITION By years ORDER BY  total_laid_off desc) AS ranking
from Company_year where years is not null order by ranking ASC)

-- SO

select * from Company_Year_Rank where ranking <= 3;















