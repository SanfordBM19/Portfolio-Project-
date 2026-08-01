SELECT * FROM PortfolioProject..[dbo.NashvilleHousing]

SELECT salesDateConverted, CONVERT(Date,saleDate)
FROM PortfolioProject..[dbo.NashvilleHousing]


ALTER TABLE [dbo.NashvilleHousing]
Add salesDateConverted Date;


UPDATE [dbo.NashvilleHousing]
SET  salesDateConverted = CONVERT(Date, saleDate)


SELECT *
FROM PortfolioProject..[dbo.NashvilleHousing]
WHERE PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..[dbo.NashvilleHousing] a
JOIN PortfolioProject..[dbo.NashvilleHousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..[dbo.NashvilleHousing] a
JOIN PortfolioProject..[dbo.NashvilleHousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

SELECT PropertyAddress 
FROM PortfolioProject..[dbo.NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject..[dbo.NashvilleHousing]

ALTER TABLE [dbo.NashvilleHousing]
Add PropertySplitAddress Nvarchar(255);


UPDATE [dbo.NashvilleHousing]
SET  PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE [dbo.NashvilleHousing]
Add PropertySplitCity Nvarchar(255);


UPDATE [dbo.NashvilleHousing]
SET  PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT OwnerAddress
FROM PortfolioProject..[dbo.NashvilleHousing]

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM PortfolioProject..[dbo.NashvilleHousing]

ALTER TABLE [dbo.NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255);

UPDATE [dbo.NashvilleHousing]
SET  OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE [dbo.NashvilleHousing]
Add OwnerSplitCity Nvarchar(255);

UPDATE [dbo.NashvilleHousing]
SET  OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE [dbo.NashvilleHousing]
Add OwnerSplitState Nvarchar(255);

UPDATE [dbo.NashvilleHousing]
SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


SELECT DISTINCT SoldAsVacant, Count(SoldAsVacant)
FROM PortfolioProject..[dbo.NashvilleHousing]
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE when SoldAsVacant = 'Y'THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject..[dbo.NashvilleHousing]
 
UPDATE PortfolioProject..[dbo.NashvilleHousing]
SET SoldAsVacant = CASE when SoldAsVacant = 'Y'THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


WITH RowNumCTE AS (
SELECT *,  
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject..[dbo.NashvilleHousing]
)
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

ALTER TABLE PortfolioProject..[dbo.NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject..[dbo.NashvilleHousing]
DROP COLUMN SaleDate