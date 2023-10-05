SELECT distinct c.SessionId
FROM c
JOIN o IN c.OldCode
WHERE c.label = 'Session' AND o._value = '5Q0816411AM'

g.V().hasLabel('Session').has('OldCode', '5Q0816411AM').values('SessionId').dedup()


    SELECT c.SessionId, c.OldCode, c.NewCode
    FROM c
    JOIN o IN c.OldCode
    WHERE o._value = '000000001935' AND c.SessionId = '44'

WITH Recursive SupersedeChain AS (
    SELECT SessionId, OldCode, NewCode
    FROM Session
    WHERE OldCode = '000000001935' AND SessionId = '44'
    
    UNION ALL
    
    SELECT c.SessionId, c.OldCode, c.NewCode
    FROM c
    JOIN o IN c.OldCode
    JOIN SupersedeChain sc ON s.OldCode = sc.NewCode
)
SELECT NewCode FROM SupersedeChain WHERE NewCode NOT IN (SELECT OldCode FROM Session);


g.V().hasLabel('Session').has('OldCode', '000000001935').has('SessionId', '44').emit().repeat(out('supperseeded_by').simplePath()).until(out('supperseeded_by').count().is(0)).values('NewCode')
g.V().hasLabel('Session').has('OldCode', '000000001935').has('SessionId', '44').emit().repeat(out('supperseeded_from').simplePath()).until(out('supperseeded_from').count().is(0)).values('OldCode')

-- combined into 1 (without itself)
g.V()
 .hasLabel('Session')
 .has('OldCode', '000000001935')
 .has('SessionId', '44')
 .union(
   repeat(out('supperseeded_by').simplePath())
    .until(out('supperseeded_by').count().is(0))
    .values('NewCode'),

   repeat(out('supperseeded_from').simplePath())
    .until(out('supperseeded_from').count().is(0))
    .values('OldCode')
 )
 
 g.V()
 .hasLabel('Session')
 .has('OldCode', '3Q0614517NBEF')
 .has('SessionId', '48')
 .union(
   repeat(out('supperseeded_by').simplePath())
    .until(out('supperseeded_by').count().is(0))
    .values('NewCode'),

   repeat(out('supperseeded_from').simplePath())
    .until(out('supperseeded_from').count().is(0))
    .values('OldCode')
 )
 
 

declare @code varchar(50)='5303877AB';

WITH codeCte AS (
    SELECT distinct s.NewCode as Code, ManufacturerGroupID,
           CAST(s.OldCode + ',' + s.NewCode AS VARCHAR(MAX)) as Path
    FROM FrontierNet_PartData.dbo.PartData_SupperSession s
    WHERE s.OldCode = @code 
	union 
    SELECT distinct s.OldCode as Code, ManufacturerGroupID,
           CAST(s.OldCode + ',' + s.NewCode AS VARCHAR(MAX)) as Path
    FROM FrontierNet_PartData.dbo.PartData_SupperSession s
    WHERE s.NewCode = @code 
	union
	select s.OldCode,ManufacturerGroupID,''     FROM FrontierNet_PartData.dbo.PartData_SupperSession s
    WHERE s.OldCode = @code
	union
	select s.NewCode,ManufacturerGroupID,''     FROM FrontierNet_PartData.dbo.PartData_SupperSession s
    WHERE s.OldCode = @code 
    UNION ALL
    SELECT s.NewCode, s.ManufacturerGroupID,
           r.Path + ',' + s.NewCode
    FROM FrontierNet_PartData.dbo.PartData_SupperSession s
    JOIN codeCte r ON s.OldCode = r.Code
    WHERE CHARINDEX(s.NewCode, r.Path) = 0  
    AND CHARINDEX(s.OldCode, r.Path) = 0   
),
uniqueCodeCte as (
	select distinct code,ManufacturerGroupID --,Path 
	from codeCte
)

--select distinct code,ManufacturerGroupID from uniqueCodeCte

SELECT TOP 1000 Parts.FactorNumber,ManufacturerGroupID
  FROM [FrontierNet_UAT].[dbo].[Parts] 
  INNER JOIN uniqueCodeCte ss ON (Parts.FactorNumber = ss.Code)
  INNER JOIN SalvageClears sc ON Parts.SalvageVehicleID = sc.SalvageID
  WHERE Parts.PartConditionID IN (2,3,4)


GetPartImageByPartId

select  Id
	   ,AmazonURL
	   ,AzureID
from partsimages
where TagNo = @PartId 
	  and (AmazonURL is not null or AzureId is not null)
	  and issecure = 0
	  --11243418
	  
GetPartByFactorNumber

SELECT
P.Id
,P.FactorNumber
,SV.Mileage
,dbo.GetVehicleShortDescription(SV.ID) As 'VehicleDescription'
,PDC.Description as 'Colour'
,SC.HasVat
,SV.ManufacturerID
,SV.ModelGroupID
,SV.ModelID
,DD.Model
,DD.Manufacturer
,DD.ModelGroups
,SV.DerivativeID
,SS.Status
,P.DepotID
,D.Name as 'Depot'
,isnull( PL.Name , VL.Name + isnull(' (' + VLSL.Name + ')','') ) as 'Location'
,IsNull(PC.Name, 'Ungraded') As 'DismantledGrade'
,IsNull((select distinct 1 from PartsImages [PI] where TagNo = p.ID), 0) as HasImages
,pd.Description as 'PartDescription'
FROM [dbo].[Parts] P
Inner Join SalvageVehicles SV on P.SalvageVehicleID = SV.ID
Inner Join PartData_Colour PDC on SV.ColourID = PDC.DHSystemsID
Inner Join SalvageClears SC on SV.ID = SC.SalvageID
Inner Join SalvageRecoveries SR on SR.SalvageID = SC.SalvageID
inner join Depots D on D.Id =P.DepotID
left join PartsLocation PL on PL.Id = P.PartsLocationID
left join Locations VL on VL.Id = SR.LocationID
left join SubLocations VLSL on VLSL.Id = SR.SubLocation
inner join VW_DervativeDetails DD on DD.DHSystemsID = P.DerivativeID
Left join PartConditions PC on PC.Id = P.PartConditionID
inner join StockStatus SS on SS.id = P.StockStatus
inner join partdefaults pd on p.PartDescriptionID = pd.id
where sc.Active = 1 and PC.Id in (2,3,4)
and P.FactorNumber = @FactorNumber
order by pc.Id
