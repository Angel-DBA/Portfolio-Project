select	*
from	PortfolioProject..NashvilleHousing

--standardize date format

select	SaleDateConverted,	convert(Date,SaleDate)
from PortfolioProject..NashvilleHousing

update	PortfolioProject.dbo.NashvilleHousing
set SaleDate	=	convert(Date,SaleDate)


update	PortfolioProject.dbo.NashvilleHousing
set SaleDate	=	convert(Date,SaleDate)


--populate property address

select	*
from	PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order	by	ParcelID



select	a.ParcelID,	a.PropertyAddress,	b.ParcelID,	b.PropertyAddress
from	PortfolioProject.dbo.NashvilleHousing	a
join	PortfolioProject.dbo.NashvilleHousing	b
	on a.ParcelID	=	b.ParcelID
	and a.[UniqueID ]	<>	b.[uniqueID]
where	a.PropertyAddress	is	null


update a
set PropertyAddress	=	isnull(a.PropertyAddress,b.PropertyAddress)
from	PortfolioProject.dbo.NashvilleHousing	a
join	PortfolioProject.dbo.NashvilleHousing	b
	on a.ParcelID	=	b.ParcelID
	and a.[UniqueID ]	<>	b.[uniqueID]
where	a.PropertyAddress	is	null


select	PropertyAddress
from	PortfolioProject.dbo.NashvilleHousing

select
SUBSTRING(PropertyAddress,	1,CHARINDEX(',',PropertyAddress)) as Address,
SUBSTRING(PropertyAddress,	CHARINDEX(',',PropertyAddress)	+1	,LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

alter	table	PortfolioProject.dbo.NashvilleHousing
add	PropertySplitAddress nvarchar(255);

update 	PortfolioProject.dbo.NashvilleHousing
set PropertySplitAddress	=	SUBSTRING(PropertyAddress,	1,CHARINDEX(',',PropertyAddress)) 

alter table PortfolioProject.dbo.NashvilleHousing
add	PropertySplitCity nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity	=	SUBSTRING(PropertyAddress,	CHARINDEX(',',PropertyAddress)	+1	,LEN(PropertyAddress))

select	*
from PortfolioProject.dbo.NashvilleHousing


select	OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select
parsename(replace(Owneraddress,	',',	'.'),3),
parsename(replace(Owneraddress,	',',	'.'),2),
parsename(replace(Owneraddress,	',',	'.'),1)
from PortfolioProject.dbo.NashvilleHousing

  
alter	table	PortfolioProject.dbo.NashvilleHousing
add	OwnerSplitAddress nvarchar(255);

update 	PortfolioProject.dbo.NashvilleHousing
set OwnerSplitAddress	=	parsename(replace(Owneraddress,	',',	'.'),3)

alter table PortfolioProject.dbo.NashvilleHousing
add	OwnerSplitCity nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity	=	parsename(replace(Owneraddress,	',',	'.'),2)

alter table PortfolioProject.dbo.NashvilleHousing
add	OwnerSplitState nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState	=	parsename(replace(Owneraddress,	',',	'.'),1)


select	*
from PortfolioProject.dbo.NashvilleHousing

--change Y and N to YES and NO in 'sold as vacant' field

select	distinct(SoldAsVacant),	count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group	by	SoldAsVacant
order by 2

select SoldAsVacant,
case when  SoldAsVacant	= 'Y'	then 'Yes'
	 when  SoldAsVacant	= 'N'	then 'No'
	 else SoldAsVacant
	 end
from PortfolioProject.dbo.NashvilleHousing

update PortfolioProject.dbo.NashvilleHousing
set	SoldAsVacant	=	case  when  SoldAsVacant	= 'Y'	then 'Yes'
	 when  SoldAsVacant	= 'N'	then 'No'
	 else SoldAsVacant
	 end


 ---removing duplicates

 with RowNumCTE as(
 select	*,
		ROW_NUMBER() over(
		partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by
					UniqueID
					) row_num

 from PortfolioProject.dbo.NashvilleHousing
 )
 delete
 from RowNumCTE
 where row_num >1

 ---delete unused columns

 select*
 from PortfolioProject.dbo.NashvilleHousing

 alter	table	PortfolioProject.dbo.NashvilleHousing
 drop column SaleDateConverted1,OwnerAddress


 alter	table	PortfolioProject.dbo.NashvilleHousing
 drop column SaleDate