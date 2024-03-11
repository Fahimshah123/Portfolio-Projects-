-- cleaning data in sql queries
select *
From [portfolio project]..NationalHouseing

-- standardize date format

select SaleDateConverted, CONVERT(date,SaleDate)
from [portfolio project]..NationalHouseing

UPDATE NationalHouseing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NationalHouseing
add SaleDateConverted DATE;

UPDATE NationalHouseing
SET SaleDateConverted = CONVERT(date,SaleDate)


-- populate property address date

select PropertyAddress
from [portfolio project]..NationalHouseing
where PropertyAddress is NULL
ORDER by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolio project]..NationalHouseing a
JOIN [portfolio project]..NationalHouseing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolio project]..NationalHouseing a
JOIN [portfolio project]..NationalHouseing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ] 

-- Breaking out Address into individual colums (Address, City, State)


select PropertyAddress
from [portfolio project]..NationalHouseing
-- where PropertyAddress is NULL
-- ORDER by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM [portfolio project]..NationalHouseing



ALTER TABLE NationalHouseing
add PropertySplitAddress NVARCHAR(255);

UPDATE NationalHouseing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NationalHouseing
add PropertySplitCitys NVARCHAR(255);

UPDATE NationalHouseing
SET PropertySplitCitys = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM [portfolio project]..NationalHouseing
-- WHERE OwnerAddress is not NULL


SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM [portfolio project]..NationalHouseing
WHERE OwnerAddress is not NULL 


ALTER TABLE NationalHouseing
add OwnerSplitAddress NVARCHAR(255);

UPDATE NationalHouseing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NationalHouseing
add OwnerSplitCitys NVARCHAR(255);

UPDATE NationalHouseing
SET OwnerSplitCitys = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NationalHouseing
add OwnerSplitState NVARCHAR(255);

UPDATE NationalHouseing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


-- Change Y and N to 'yes' and 'no' in SoldAsVacant
SELECT distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM [portfolio project]..NationalHouseing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, case when SoldAsVacant = 'Y' THEN 'Yes'
    when SoldAsVacant = 'N' THEN 'No'
    else SoldAsVacant
    END
FROM [portfolio project].dbo.NationalHouseing

UPDATE NationalHouseing
SET SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
    when SoldAsVacant = 'N' THEN 'No'
    else SoldAsVacant
    END

-- Remove duplicates
with rownumCte AS(
 SELECT *,
 ROW_NUMBER() over(
 partition by ParcelID,
              PropertyAddress,
			  SoldAsVacant,
			  SaleDate,
			  LegalReference
			  order by
			      UniqueID
 ) row_num

FROM [portfolio project]..NationalHouseing
)
select *
FROM rownumCte
WHERE row_num > 1
ORDER by PropertyAddress


-- Delete unused colums

SELECT *
From [portfolio project]..NationalHouseing

ALTER TABLE [portfolio project]..NationalHouseing
DROP COLUMN PropertySplitCity