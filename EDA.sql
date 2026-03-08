SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off) FROM layoffs_staging2;

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1;

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1
order by total_laid_off desc;

SELECT * FROM layoffs_staging2 WHERE percentage_laid_off=1
order by funds_raised_millions desc;

SELECT company,SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY company
ORDER BY 2 DESC;

SELECT industry,SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY industry
ORDER BY 2 DESC;

SELECT * FROM layoffs_staging2;

SELECT country,SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY country
ORDER BY 2 DESC;

SELECT `date`,SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY `date`
ORDER BY 1 DESC;

SELECT YEAR(`date`),SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage,SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY stage
ORDER BY 1 DESC;

SELECT company,SUM(percentage_laid_off) FROM layoffs_staging2 
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,6,2) AS `MONTH`
FROM layoffs_staging2;

SELECT SUBSTRING(`date`,6,2) AS `MONTH`,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`,SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,total_off,SUM(total_off) over(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company,SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY company
ORDER BY 2 DESC;

SELECT company,YEAR(`date`),SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year(company,years,total_laid_off) AS
(
SELECT company,YEAR(`date`),SUM(total_laid_off) FROM layoffs_staging2 
GROUP BY company,YEAR(`date`)
),company_year_rank AS
(
SELECT *,DENSE_RANK() OVER(partition by years order by total_laid_off DESC) AS ranking
 FROM Company_Year
 WHERE years IS NOT NULL
 )
 SELECT * FROM company_year_rank
 WHERE ranking<=5;
 
