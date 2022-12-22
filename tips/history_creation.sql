-- History creation
DECLARE @Username NVARCHAR(100)

SELECT @Username = UserName
FROM ActiveIdentity..AspNetUsers
WHERE Id = @UserId

-- 10 add --20 edit
IF (@IsEdit = 0)
BEGIN
	INSERT INTO Assets..AssetHistory (
		ActivityType,
		ChangeDescription,
		AssetId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate
		)
	SELECT 10,
		'Sava Extract <span class="boldname">Created</span>',
		@AssetId,
		@Username,
		getDate(),
		@Username,
		getDate()
END
ELSE
BEGIN
	SELECT @TargetJSON = value
	FROM OPENJSON((
				SELECT @RRN AS RRN,
					@TenantRefusedRepair AS TenantRefusedRepair,
					SavaExtract.*
				FROM MasterReferenceData..SavaExtract
				WHERE [PropertyCode] = @PropertyCode
				FOR JSON PATH
				))

	INSERT INTO Assets..AssetHistory (
		ActivityType,
		ChangeDescription,
		AssetId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate
		)
	SELECT 20,
		'Sava Extract <span class="boldname">' + TheKey + '</span> changed from <span class="oldvalue">' + AssetsData.dbo.GetSavaMappingValue(TheKey, TheSourceValue) + '</span> to <span class="newvalue">' + AssetsData.dbo.GetSavaMappingValue(TheKey, TheTargetValue) + '</span>',
		@AssetId,
		@Username,
		getDate(),
		@Username,
		getDate()
	FROM AssetsData..Compare_JsonObject(@SourceJSON, @TargetJSON) AS Diff
	WHERE SideIndicator IN ('<>', '->', '<-')
		AND TheKey NOT IN ('CreatedOn', 'ModifiedOn')
END