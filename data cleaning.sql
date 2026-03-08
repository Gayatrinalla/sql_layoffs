SELECT * FROM layoffs;

-- create a staging  table
CREATE TABLE layoffs_staging LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

-- 1.Remove Duplicates

select *,row_number() over(partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num from layoffs_staging;

with duplicate_cte as
(
  select *,
  row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
  from layoffs_staging
)

select * from duplicate_cte where row_num>1;

select * from layoffs_staging  where company='Casper';
  
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2
 select *,
  row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num 
  from layoffs_staging;

select * from layoffs_staging2 where row_num>1;

DELETE FROM layoffs_staging2
WHERE row_num >= 2;



