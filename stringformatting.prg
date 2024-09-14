* Date Formats:   https://msdn.microsoft.com/en-us/library/8kb3ddd4(v=vs.110).aspx
* Number formats: https://msdn.microsoft.com/en-us/library/dwhawy9k(v=vs.110).aspx
CLEAR

do _startup.prg

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? "*** Date formatting"
?

? "Plain FormatValue on Date: "  + FormatValue(DATETIME())
* 6/6/2016 7:49:26 PM

lcFormat = "MMM d, yyyy"
? lcFormat + ": " +  FormatValue(DATETIME(),lcFormat)
* Jun 10, 2016

lcFormat = "MMMM d, yyyy"
? lcFormat + ": " + FormatValue(DATETIME(),lcFormat)
* August 1, 2016

lcFormat = "HH:mm:ss"
? lcFormat + ": " + FormatValue(DATETIME(),lcFormat)
* 20:15:10

cFormat = "h:m:s tt"
? lcFormat + ": " +  FormatValue(DATETIME(),lcFormat)
* 8:5:10 PM

lcFormat = "MMM d @ HH:mm"
? lcFormat + ": " +  FormatValue(DATETIME(),lcFormat)
* Aug 1 @ 20:44

lcFormat = "r"  && Mime Date Time
? lcFormat + ": " +  FormatValue(DATETIME(),lcFormat)
* Mon, 06 Jun 2016 22:41:33 GMT

lcFormat = "u"  
? lcFormat + ": " +  FormatValue(DATETIME(),lcFormat)
* 2016-06-06 22:41:44Z

lcFormat = "ddd, dd MMM yyyy HH:mm:ss zzz"
? "MimeDateTime: " +  STUFF(FormatValue(DATETIME(),lcFormat),30,1,"")
* 2016-06-06 22:41:44Z
?

 
? "*** Numberformats"
*** Number formats
? "Unformatted number: " + FormatValue(1233.22)



lcFormat = "00"
? lcFormat + ": " + FormatValue(2,"00")
* 02

? lcFormat + ": " + FormatValue(12,"00")
* 12

lcFormat = "c"
? lcFormat + ": " +  FormatValue(1233.22,lcFormat)
* $1,233.22

lcFormat = "n2"
? lcFormat + ": " +  FormatValue(1233.2255,lcFormat)
* $1,233.23

lcFormat = "n0"
? lcFormat + ": " +  FormatValue(1233.2255,lcFormat)
* $1,233
?

? "*** String Formatting"
? FormatString("Hey {0}, the date and time is: {1:MMM dd, yyyy - h:mm tt}","Rick",DATETIME())
?

? "*** Brackets need to be double escaped"
? FormatString("This should escape {{braces}} and format the date: {0:MMM dd, yyyy}",DATE())


? "*** Also works with ToString for .NET"

*** Load loPerson .NET Object
? loBridge.LoadAssembly("wwDotnetBridgeDemos.dll")
? loBridge.cErrorMsg

loPerson = loBridge.CreateInstance("wwDotnetBridgeDemos.Person")
loPerson.Name = "Rick Strahl"

loAddresses = loBridge.GetProperty(loPerson,"Addresses")

? loAddresses
? loBridge.cErrorMsg
? loAddresses.Count

loType =  loBridge.GetType(loAddresses)
? loType.FullName

loAddress = loAddresses.Item(0)
loAddress.City = "SomeTown Ugly Town USA"


? FormatString("Person Object:\r\n{0} and the time is: {1:t}", loPerson, DATETIME())

RETURN

************************************************************************
*  FormatValue
****************************************
***  Function: Formats a value using .NET ToString() formatting
***            for whatever the text ends up with
***      Pass:  Pass in any .NET value and call it's ToString()
***             method of the underlying type. This 
***    Return:
************************************************************************
FUNCTION FormatValue(lvValue,lcFormatString)
LOCAL loBridge 

IF ISNULL(lvValue)
   RETURN "null"
ENDIF   

loBridge = GetwwDotnetBridge()

IF EMPTY(lcFormatString)	
	RETURN loBridge.InvokeMethod(lvValue,"ToString")
ENDIF  

RETURN loBridge.InvokeMethod(lvValue,"ToString",lcFormatString)
ENDFUNC
*   FormatValue

************************************************************************
*  FormatString
****************************************
***  Function: Uses a string template to embed formatted values
***            into a string.
***    Assume:
***      Pass: lcFormat    -  Format string use {0} - {10} for parameters
***            lv1..lv10   -  Up to 10 parameters
***    Return:
************************************************************************
FUNCTION FormatString(lcFormat, lv1,lv2,lv3,lv4,lv5,lv6,lv7,lv8,lv9,lv10)
LOCAL lnParms, loBridge
lnParms = PCOUNT()
loBridge = GetwwDotnetBridge()

lcFormat = EscapeCSharpString(lcFormat)

DO CASE 
	CASE lnParms = 2
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1)
	CASE lnParms = 3
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2)
	CASE lnParms = 4
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3)
	CASE lnParms = 5
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3,lv4)
	CASE lnParms = 6
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3,lv4,lv5)
	CASE lnParms = 7
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3,lv4,lv5,lv6)
	CASE lnParms = 8
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3,lv4,lv5,lv6,lv7)
	CASE lnParms = 9
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3,lv4,lv5,lv6,lv7,lv8)
	CASE lnParms = 10
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3,lv4,lv5,lv6,lv7,lv8,lv9)
	CASE lnParms = 11
		RETURN loBridge.InvokeStaticMethod("System.String","Format",lcFormat,lv1,lv2,lv3,lv4,lv5,lv6,lv7,lv8,lv10)
	OTHERWISE
	    THROW "Too many parameters for FormatString"
ENDCASE


ENDFUNC
*   StringFormat

************************************************************************
*  EscapeCSharpString
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION EscapeCSharpString(lcValue)

lcValue = STRTRAN(lcValue, "\r", CHR(13))
lcValue = STRTRAN(lcValue, "\n", CHR(10))
lcValue = STRTRAN(lcValue, "\t", CHR(9))
lcValue = STRTRAN(lcValue, "\0", CHR(0))

RETURN lcValue
ENDFUNC
*   EscapeCSharpString



