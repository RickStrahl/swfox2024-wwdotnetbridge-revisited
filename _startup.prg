LPARAMETERS llCleanup

SET PATH TO

IF DIRECTORY("d:\swebconnection\fox\classes\")
	SET PATH TO "d:\webconnection\fox\classes\" ADDITIVE
ELSE
	SET PATH TO ".\classes\" ADDITIVE	
ENDIF

*** .NET Binaries
SET PATH TO ".\bin\" ADDITIVE
