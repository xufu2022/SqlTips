CREATE TABLE EmployeeOrganization
(
 EmpNode hierarchyid PRIMARY KEY CLUSTERED,
 EmpLevel AS EmpNode.GetLevel(),
 EmpID int UNIQUE NOT NULL,
 EmpName nvarchar(25) NOT NULL,
 EmpTitle nvarchar(25) NOT NULL
) ;

INSERT EmployeeOrganization (EmpNode, EmpID, EmpName, 
EmpTitle)
VALUES (hierarchyid::GetRoot(), 0, 'John', 'Manager');

SELECT EmpNode, EmpNode.ToString() AS Text_EmpNode, EmpLevel, 
EmpID, EmpName, EmpTitle FROM EmployeeOrganization;

DECLARE @vEmpNode hierarchyid, @mx hierarchyid;
SELECT @vEmpNode = EmpNode FROM EmployeeOrganization WHERE EmpID = '0';

-- Add Jim
SELECT @mx = max(EmpNode) FROM EmployeeOrganization WHERE 
EmpNode.GetAncestor(1) = @vEmpNode;
INSERT EmployeeOrganization (EmpNode, EmpID, EmpName, 
EmpTitle)
 VALUES(@vEmpNode.GetDescendant(@mx, NULL), '17', 'Jim', 
'Assistant Manager');

-- Add Kim
SELECT @mx = max(EmpNode) FROM EmployeeOrganization WHERE 
EmpNode.GetAncestor(1) = @vEmpNode;
INSERT EmployeeOrganization (EmpNode, EmpID, EmpName, 
EmpTitle)
 VALUES(@vEmpNode.GetDescendant(@mx, NULL), '24', 'Kim', 
'Assistant Manager');

SELECT EmpNode, EmpNode.ToString() AS Text_EmpNode, EmpLevel, 
EmpID, EmpName, EmpTitle
FROM EmployeeOrganization;

-------------------------------------------------------------
-- Adding subordinate nodes under root node - Jim
---------------------------------------------------------
SELECT @vEmpNode = EmpNode FROM EmployeeOrganization  WHERE EmpID = '17';
-- Add Jack
SELECT @mx = max(EmpNode) FROM EmployeeOrganization WHERE EmpNode.GetAncestor(1) = @vEmpNode;
INSERT EmployeeOrganization (EmpNode, EmpID, EmpName, EmpTitle)
 VALUES(@vEmpNode.GetDescendant(@mx, NULL), '32', 'Jack', 'Team Member');
-- Add Frank
SELECT @mx = max(EmpNode) FROM EmployeeOrganization WHERE 
EmpNode.GetAncestor(1) = @vEmpNode;
INSERT EmployeeOrganization (EmpNode, EmpID, EmpName, 
EmpTitle)
 VALUES(@vEmpNode.GetDescendant(@mx, NULL), '25', 'Frank', 
'Team Member');

-- two very commonly used functions, GetAncestor() and GetDescendent(), to pull organization data from the hierarchyid data structure.