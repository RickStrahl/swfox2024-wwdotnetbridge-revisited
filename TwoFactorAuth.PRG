
DO _Startup.prg
DO wwDotnetBridge
SET PROCEDURE TO TwoFactorAuth ADDITIVE

#IF .T.
CLEAR

*** For demo only (ShowHtml()/InputForm())
DO wwutils

*** Generate a Customer Secret key 
*** In an application this will be something that identifies the user
*** with a given account, but it needs to be something that is not known
*** typically a generated UniqueId stored in a customer record (TwoFactorKey in db for example)
lcSecret = GetUniqueId(12)    

loAuth = CREATEOBJECT("TwoFactorAuthentication")
loSetup  = loAuth.GenerateSetupCode("Westwind.Webstore",;
                                    "rick@test-my-site.com", lcSecret)

ShowHtml( loSetup.QrCodeHtml())

*** Test with a 'known' Customer Secret Key (from my site's test account)
lcSecret = GETENV("TWOFACTOR_KEY")

*** Capture Pin (lookup in 1Password, Authy, Google or Microsoft Authenticator, Yubikey etc.
lcPin = InputForm("","Enter generated two-factor pin")
IF EMPTY(lcPin)
   RETURN
ENDIF

If(loAuth.ValidatePin(lcSecret,lcPin))
   ? "Pin has been validated"
ELSE
   ? "Invalid Pin code"   
ENDIF


#ENDIF


*************************************************************
DEFINE CLASS TwoFactorAuthentication AS Custom
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2024
*:Contact: http://www.west-wind.com
*:Created: 09/09/2024
*************************************************************

oBridge = null
oAuth = null

************************************************************************
*  Init
****************************************
FUNCTION Init()

this.oBridge = GetwwDotnetBridge()

IF (!this.oBridge.LoadAssembly("Google.Authenticator.dll"))
   ERROR this.oBridge.cErrorMsg
ENDIF  
THIS.oAuth = this.oBridge.CreateInstance("Google.Authenticator.TwoFactorAuthenticator")
IF VARTYPE(THIS.oAuth) # "O"
   ERROR "Failed to load TwoFactorAuthenticator: " + this.oBridge.cErrorMsg
ENDIF

ENDFUNC

************************************************************************
*  GenerateSetupCode
****************************************
***  Function: Generates a structure that generates an object containing 
***            a QR code image and manual setup code
***    Assume: Application and Email have no effect on code/qr generation
***      Pass: lcApplicationName  - Name of application
***            lcEmail            - An email address to identify user
***            lcSecretKey        - Secret key tied to the user to identify
***            lnResolution       - larger numbers result in larger CR codes (10)
***    Return: TwoFactorSetup object or null
************************************************************************
FUNCTION GenerateSetupCode(lcApplicationName, lcEmail, lcSecretKey, lnResolution)
LOCAL loAuth

IF EMPTY(lnResolution)
   lnResolution = 10
ENDIF   

loSetupInfo = THIS.oAuth.GenerateSetupCode(lcApplicationName,;
   lcEmail, ;
   lcSecretKey, ;
   .F., lnResolution)
   
loResult = CREATEOBJECT("TwoFactorSetup")
loResult.cQrCodeImageData = loSetupInfo.QrCodeSetupImageUrl
loResult.cSetupKey  = loSetupInfo.ManualEntryKey
loResult.cCustomerSecret = lcSecretKey

RETURN loResult
ENDFUNC

************************************************************************
*  ValidatePin
****************************************
***  Function: Validates a two-factor pin code
************************************************************************
FUNCTION ValidatePin(lcSecretKey, lcPin)

*** Strip spaces
lcPin = STRTRAN(lcPin, " " ,"")
RETURN THIS.oAuth.ValidateTwoFactorPIN(lcSecretKey, lcPin)
ENDFUNC
*   ValidatePin

ENDDEFINE




*************************************************************
DEFINE CLASS TwoFactorSetup AS Custom
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2024
*:Contact: http://www.west-wind.com
*:Created: 09/09/2024
*************************************************************

*** Base64 Data Url that contains the image data that is embeddable into
*** an image control.
cQrCodeImageData = ""


*** Typable Version of the QrCode data
cSetupKey = ""

*** The Customer Key that's used to generate the Setup Key
*** This is what's used to generate the QrCode/SetupKey
*** and then also when generating the validation key
cCustomerSecret = ""

************************************************************************
*  QrCodeHtml
****************************************
***  Function: returns an HTML document that displays the image
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION QrCodeHtml(llImageOnly)

IF (llImageOnly)
   RETURN [<img src="] + this.cQrCodeImageData + [" />]
ENDIF

TEXT TO lcHtml NOSHOW TEXTMERGE
<html>
<body>
<div style="text-align: center; max-width: 500px">
	<img src="<<this.cQrCodeImageData>>" />
	<div style="font-size: 1.5em; font-weight: 600">
	<<this.cSetupKey>>
	</div>
</div>
</body>
</html>
ENDTEXT

RETURN lcHtml
* QrCodeHtml

ENDDEFINE
*EOC TwoFactorSetup 