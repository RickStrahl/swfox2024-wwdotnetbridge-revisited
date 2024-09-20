LPARAMETERS lcUrl,  lcOutputFile

DO wwutils
do wwDotNetBridge

*** Has to be persist after program ends 
PUBLIC loCallbacks

IF EMPTY(lcUrl)
   lcUrl = "Assets/HtmlSampleFile-SelfContained.html"
ENDIF
IF EMPTY(lcOutputFile)
   lcOutputFile = "c:\temp\htmltopdf.pdf"
ENDIF   
IF !StartsWith(lcUrl, "http")  
   *** Assume it's a path - fix it up
   lcUrl = GetFullPath(lcUrl)
ENDIF

CLEAR 
? "*** Generating PDF from " + lcUrl
? "*** To " + lcOutputFile

LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

*** Load library and create the .NET Class
loBridge.LoadAssembly("Westwind.WebView.HtmlToPdf.dll")
loPdf = loBridge.CreateInstance("Westwind.WebView.HtmlToPdf.HtmlToPdfHost")

*** Create the Callback Handler Object
loCallbacks = CREATEOBJECT("PdfCallbacks")
loCallbacks.cOutputFile = lcOutputFile
ERASE (lcOutputFile)

loSettings = null
loSettings = loBridge.CreateInstance("Westwind.WebView.HtmlToPdf.WebViewPrintSettings")
*!*	loSettings.ScaleFactor = 0.75
*!*	loSettings.MarginTop = 1
*!*	loSettings.ShouldPrintHeaderAndFooter = .T.
*!*	loSettings.HeaderTitle = "Fox Rocks!"

*** Async PDF Generation Method: Exits immediately
loBridge.InvokeTaskmethodAsync(loCallbacks, loPdf,"PrintToPdfAsync", lcUrl, lcOutputFile, loSettings)

? "*** Converting to PDF - this may take a few seconds..."
?

GoUrl(lcUrl)

RETURN

DEFINE CLASS PdfCallbacks as AsyncCallbackEvents

*** Capture output file 
cOutputFile = ""

FUNCTION OnCompleted(lvResult,lcMethod)

IF !lvResult.IsSuccess
   ? "ERROR: " + lvResult.Message
   RETURN
ENDIF

GoUrl(THIS.cOutputFile)
? "*** PDF Output Generated!"

ENDFUNC

FUNCTION OnError(lcMessage, loException, lcMethod)

? "Error: " + lcMethod,lcMessage

ENDFUNC

ENDDEFINE


*!*	 var htmlFile = Path.GetFullPath("HtmlSampleFileLonger-SelfContained.html");
*!*	 var outputFile = Path.GetFullPath(@".\test2.pdf");
*!*	 File.Delete(outputFile);

*!*	 var host = new HtmlToPdfHost(); // or new HtmlToPdfHostExtended()
*!*	 var result = await host.PrintToPdfAsync(htmlFile, outputFile);

*!*	 Assert.IsTrue(result.IsSuccess, result.Message);
*!*	 ShellUtils.OpenUrl(outputFile);  // display the Pdf file you specified

*!*	        public virtual Task<PdfPrintResult> PrintToPdfAsync(string url, 
*!*	            string outputFile,            
*!*	            WebViewPrintSettings webViewPrintSettings = null)