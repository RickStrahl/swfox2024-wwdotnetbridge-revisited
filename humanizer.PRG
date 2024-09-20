CLEAR

*** Do this in your startup code
DO _Startup.prg
do wwDotNetBridge


loBridge = GetwwDotnetBridge()
loBridge.LoadAssembly("wwDotnetBridgeDemos.dll")

*!*	? "*** Raw Date to String"
*!*	*  public static string Humanize(this DateTime input, bool? utcDate = null, DateTime? dateToCompareAgainst = null, CultureInfo culture = null)      
*!*	ldDate = DATE() + 22
*!*	? loBridge.InvokeStaticMethod("Humanizer.DateHumanizeExtensions","Humanize",ldDate,null,null,null)  
?

*!*	? "*** Raw Number to String"
*!*	lnValue = 121233
*!*	* public static string ToWords(this int number, CultureInfo culture = null)       
*!*	? loBridge.InvokeStaticMethod("Humanizer.NumberToWordsExtension","ToWords",lnValue, null) + ;
*!*	"  (" + TRANSFORM(lnValue,"9,999,999") + ")"
*!*	?

*** Using a .NET Wrapper Class

LOCAL loHuman as wwDotnetBridge.FoxHumanizer
loHuman = loBridge.CreateInstance("wwDotnetBridgeDemos.FoxHumanizer")

? "*** Human Friendly Dates"
? loHuman.HumanizeDate(DATE()-1)
? loHuman.HumanizeDate(DATETime() + 86500)
? loHuman.HumanizeDate(DATE() + 2)
? loHuman.HumanizeDate(DATETIME() - 55)
? loHuman.HumanizeDate(DATETIME() - 3800)
?

? "*** Number to Words"
? loHuman.NumberToWords(10)
? loHuman.NumberToWords(1394)
?
? "*** Pluralize"
? loHuman.Pluralize("Building")
? loHUman.Pluralize("Mouse")
?

? "*** Numbers and Pluraize together"
? loHuman.ToQuantity("Car",3)
? loHuman.ToQuantity("Mouse",3)
?

? "*** Bytes, kb, megabytes etc. from bytes"
? loHuman.ToByteSize(13122)
? loHuman.ToByteSize(1221221)
? loHuman.ToByteSize(1221221312)

RETURN


