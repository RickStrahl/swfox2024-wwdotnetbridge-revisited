LPARAMETERS lcFileList, lcFolder, lcFolderExclusions
LOCAL loBridge as wwDotnetBridge, loEventHandler as FileWatcherEventHandler, ;
      loSubscription, lcNotificationFile
CLEAR

*** Files that have changed 
IF EMPTY(lcFileList)
   lcFileList = "*.prg,*.ini,*.fpw,*.bak,"
ENDIF

IF EMPTY(lcFolder)
   lcFolder = SYS(5) + CurDir()
ENDIF

*** Allow for auto-compilation
SET DEVELOPMENT ON

do wwDotNetBridge
loBridge = GetwwDotnetBridge()

*** Create an instance of the file watcher: MUST PERSIST!!!
PUBLIC __WWC_FILEWATCHER
__WWC_FILEWATCHER = loBridge.CreateInstance("System.IO.FileSystemWatcher",lcFolder)
__WWC_FILEWATCHER.EnableRaisingEvents = .T.
__WWC_FILEWATCHER.IncludeSubDirectories = .T.

*** Create the Handler Object that responds to events
loEventHandler = CREATEOBJECT("FileWatcherEventHandler")
loEventHandler.cFileList = lcFileList

IF !EMPTY(lcFolderExclusions)
   loEventHandler.cFolderExclusions = lcFolderExclusions
ENDIF

*** Create a subscription to the events
loSubscription = loBridge.SubscribeToEvents(__WWC_FILEWATCHER, loEventHandler)
loEventHandler.oSubscription = loSubscription  && so we can unsubscribe

? "Watching for file changes in: " + lcFolder + " for  " + lcFileList

RETURN

*************************************************************
DEFINE CLASS FileWatcherEventHandler AS Custom
*************************************************************

*** File extensions to monitor
cFileList = "*.prg,*.vcx,*.exe,*.app,*.ini"

*** Optional comma list of folders to exclude (ie: \temp\,\web\)
cFolderExclusions = ""

*** File watcher subscription
oSubscription = null

nLastAccess = 0

************************************************************************
FUNCTION HasFileChanged(lcFilename as String)
*********************************************
* This is a helper to determine which files we need to look at
************************************************************************

LOCAL lcFileList, lnX, lnFiles, lcExtension, lnExclusions
LOCAL ARRAY laExtensions[1]
LOCAL ARRAY laExclusions[1]

IF EMPTY(lcFileName)
   RETURN .F.
ENDIf


IF ATC("\temp\",lcFileName) > 0
   RETURN .F.
ENDIF

lnExclusions = 0
IF !EMPTY(THIS.cFolderExclusions)
	lnExclusions = ALINES(laExclusions,this.cFolderExclusions,1 + 4, ",")
	FOR lnX = 1 TO lnExclusions
	    IF ATC(LOWER(laExclusions[lnX]),lcFileName) > 0
	       RETURN .F.
	    ENDIF
	ENDFOR
ENDIF

lcFileList = STRTRAN(THIS.cFileList,"*.","")
lnFiles =  ALINES(laExtensions,lcFileList,1 + 4,",")
        
FOR lnX = 1 TO lnFiles
    lcExtension = LOWER(JUSTEXT(lcFileName))
    IF lcExtension == LOWER(laExtensions[lnX])
       this.nLastAccess = SECONDS()
       RETURN .T.
    ENDIF
ENDFOR

RETURN .F.
ENDFUNC
*   HasFileChanged

************************************************************************
FUNCTION OnChanged(sender,ev)
*****************************
LOCAL lcFile 

lcFile = THIS.GetFilename(ev)

IF THIS.HasFileChanged(lcFile)
	? "File has been changed: " + lcFile
ENDIF

ENDFUNC


************************************************************************
FUNCTION OnCreated(sender,ev)
****************************************
LOCAL lcFile 

lcFile = THIS.GetFilename(ev)
IF THIS.HasFileChanged(lcFile)
   ? "File has been created: " +lcFile
ENDIF
	
ENDFUNC


************************************************************************
FUNCTION OnDeleted(sender, ev)
******************************
LOCAL lcFile 

lcFile = THIS.GetFilename(ev)
IF THIS.HasFileChanged(lcFile)
	? "File has been deleted: " + lcFile
ENDIF

ENDFUNC

************************************************************************
FUNCTION OnRenamed(sender, ev)
******************************
LOCAL lcFile, loBridge

IF VARTYPE(ev) # "O"
   RETURN
ENDIF

loBridge = GetwwDotnetBridge()
lcOldFile = loBridge.GetProperty(ev,"OldFullPath")
IF EMPTY(lcOldFile)
   RETURN
ENDIF
lcNewFile = loBridge.GetProperty(ev,"FullPath")
IF EMPTY(lcNewFile)
   RETURN
ENDIF

? "File has been renamed: " + lcOldFile + " to " + lcNewFile

ENDFUNC

FUNCTION GetFileName(ev)
LOCAL lcFile

TRY
   lcFile = ev.FullPath   
CATCH TO ex 
   lcFile = ""
ENDTRY

RETURN lcFile

************************************************************************
FUNCTION Destroy()
******************

IF THIS.oSubscription != null
	THIS.oSubscription.UnSubscribe()
	THIS.oSubscription = null
ENDIF
   
IF VARTYPE(__WWC_FILEWATCHER) = "O"
   __WWC_FILEWATCHER.Dispose()
   __WWC_FILEWATCHER = .F.
ENDIF

ENDFUNC

ENDDEFINE
