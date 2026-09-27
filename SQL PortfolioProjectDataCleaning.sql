-- Cleaning Data in SQL Queries 

SELECT * FROM [Nashville Housing]


-- Standarize Date Format

SELECT 
SaleDate,
CONVERT(Date,SaleDate)
FROM [Nashville Housing]  

Update [Nashville Housing]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Nashville Housing]
Add SaleDateConverted Date;

Update [Nashville Housing]
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address Data

SELECT
*
FROM [Nashville Housing]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT 
a.ParcelID,
a.PropertyAddress,
b.ParcelID,
b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Nashville Housing] a
JOIN [Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Nashville Housing] a
JOIN [Nashville Housing] b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


-- Braeking out Address into Individual Columns (Address, City, State)

SELECT
PropertyAddress
FROM [Nashville Housing]
--WHERE PropertyAddress IS NULL
--ORDER BY ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
FROM [Nashville Housing]


ALTER TABLE [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

SELECT * FROM [Nashville Housing]


SELECT 
OwnerAddress
FROM [Nashville Housing]

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.' ) , 1) AS State, 
PARSENAME(REPLACE(OwnerAddress,',', '.' ) , 2) AS City,
PARSENAME(REPLACE(OwnerAddress,',', '.' ) , 3) AS [Street address]
FROM [Nashville Housing]

ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.' ) , 3) 

ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.' ) , 2)

ALTER TABLE [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.' ) , 1)


SELECT * FROM [Nashville Housing]


-- Change 1 and 0 to Yes and No in "SoldAsVacant" field

SELECT
Distinct(SoldAsVacant),
Count(SoldAsVacant)
FROM [Nashville Housing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT 
SoldAsVacant,
   CASE WHEN SoldAsVacant = 1 THEN 'Yes'
        WHEN SoldAsVacant = 0 THEN 'No'
    END AS SoldAsVacantConverted
FROM [Nashville Housing]


-- Remove Duplicates

WITH RowNumCTE AS (
SELECT 
*,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
		     PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
ORDER BY UniqueID 
                ) row_num
FROM [Nashville Housing]
--ORDER BY ParcelID

)

DELETE
FROM RowNumCTE
WHERE row_num > 1


-- Delete Unused Columns 

SELECT * FROM [Nashville Housing]

ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
	




    
