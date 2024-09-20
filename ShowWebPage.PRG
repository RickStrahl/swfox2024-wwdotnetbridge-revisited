LPARAMETERS lcHtml, lcTitle


ShowHtmlLocal(lcHtml, "",  lcTitle)


************************************************************************
FUNCTION ShowHTMLLocal
**********************
***  Function: Takes an HTML string and displays it in the default
***            browser. 
***    Assume: Uses a file to store HTML temporarily.
***            For this reason there may be concurrency issues
***            unless you change the file for each use
***      Pass: lcHTML       -   HTML to display
***            lcFile       -   Temporary File to use (Optional)
***            loWebBrowser -   Web Browser control ref (Optional)
************************************************************************
LPARAMETERS lcHTML, lcFile,  lcTitle
PRIVATE pcBasePath, pcTitle, pcHtml, pcThemePath

lcHTML=IIF(EMPTY(lcHTML),"",lcHTML)
lcFile=IIF(EMPTY(lcFile),SYS(2023)+"\ww_HTMLView.htm",lcFile)
pcBasePath = ADDBS(SYS(5) + CURDIR())
pcThemePath = pcBasePath + "Assets\Westwind\"
pcTitle = IIF(EMPTY(lcTitle),"",lcTitle)
lcTemplate = "./Assets/Westwind/Theme.html"

IF !EMPTY(lcTemplate)
   lcT =  FILETOSTR(lcTemplate)
   pcHtml = lcHtml
   lcHtml = TEXTMERGE(lcT)
ENDIF

STRTOFILE(STRCONV(lcHTML,9),lcFile)

ShellExecute(lcFile)

RETURN

************************************************************************
*  ShellExecute
****************************************
***    Author: Rick Strahl
***            (c) West Wind Technologies, 1996
***   Contact: rstrahl@west-wind.com
***  Modified: 03/14/96
***  Function: Starts associated Web Browser
***            and goes to the specified URL.
***            If Browser is already open it
***            reloads the page.
***    Assume: Works only on Win95 and NT 4.0
***      Pass: tcUrl  - The URL of the site or
***                     HTML page to bring up
***                     in the Browser
***    Return: 2  - Bad Association (invalid URL)
***            31 - No application association
***            29 - Failure to load application
***            30 - Application is busy 
***
***            Values over 32 indicate success
***            and return an instance handle for
***            the application started (the browser) 
************************************************************************
FUNCTION ShellExecute(tcUrl, tcAction, tcDirectory, tcParms, tnShowWindow)

IF VARTYPE(tnShowWindow) # "N"
   tnShowWindow = 1
ENDIF

IF EMPTY(tcUrl)
   RETURN -1
ENDIF
IF EMPTY(tcAction)
   tcAction = "OPEN"
ENDIF
IF EMPTY(tcDirectory)
   tcDirectory = SYS(2023) 
ENDIF

DECLARE INTEGER ShellExecute  ;
    IN SHELL32.dll as ShellExec_1;
    INTEGER nWinHandle,;
    STRING cOperation,;
    STRING cFileName,;
    STRING cParameters,;
    STRING cDirectory,;
    INTEGER nShowWindow
    
IF EMPTY(tcParms)
   tcParms = ""
ENDIF

RETURN ShellExec_1( _Screen.HWnd,;
                    tcAction,tcUrl,;
                    tcParms,tcDirectory,tnShowWindow)
ENDFUNC
*   ShellExecute
