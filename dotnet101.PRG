CLEAR
DO _STARTUP.prg

do wwDotNetBridge                 && Load library
LOCAL loBridge as wwDotNetBridge  && for Intellisense
loBridge = GetwwDotnetBridge()    && instance

*** Load an Assembly
loBridge.LoadAssembly("wwDotnetBridgeDemos.dll")

*** Create an class Instance
loPerson = loBridge.CreateInstance("wwDotnetBridgeDemos.Person")

*? loBridge.ToJson(loPerson, .T.)  && Commercial only


*** Access simple Properties
? "*** Simple Properties:" 
? loPerson.Name
? loPerson.Company
? loPerson.Entered

*** Access a nested object
? loPerson.PrimaryAddress.Street + "  " + loPerson.PrimaryAddress.City

*** Call a Method
? "*** Method call: Formatted Person Record (ToString):"
? loPerson.ToString()  && Formatted\ Person with Address
?

	SET STEP ON 

? "*** Adding  a new address via AddAddress Method"
loAddress =  loPerson.AddAddress("1 Main","Fairville","CA","12345")


*** This ends BADLY! Because: Generic Type inaccessible in Fox
*** loAddresses = loPerson.Addresses   && List<Address>
*** ? loAddress  		&& (Object)
*** ? loAddress.Count   && BOOM! (crashes FoxPro)


*** Retrieve a ComArray for the Addresses[] array
loAddresses = loBridge.GetProperty(loPerson,"Addresses")

? "There are now " + TRANSFORM(loAddresses.Count) + " Addresses"     && Number of items in array
?

? "*** First Address"
loAddress = loAddresses.Item(0)
? "Street: " + loAddress.Street
? "Full Address (ToString): " + CHR(13) + CHR(10) + loAddress.ToString()
? 

? "*** All Addresses"
FOR lnX = 0 TO loAddresses.Count-1
	loAddress = loAddresses.Item(lnX)
	? loAddress.ToString()
	?
ENDFOR

*** Retrieve a single address (0 based)
loAddress1 = loAddresses.Item(0)

*** Loop through all addresses
FOR lnX = 0 to loAddresses.Count -1 
    loAddress = loAddresses.Item(lnX)
    * ? loAddress.Street + "  " + loAddress.City
    ? loAddress.ToString()
ENDFOR





? "*** Explicitly add another item to the array"
* loNewAddress = loBridge.CreateInstance("wwDotnetBridgeDemos.Address")
loNewAddress = loAddresses.CreateItem()
loNewAddress.Street = "122 Newfound Landing"
loNewAddress.City = "NewFoundLanding"
loAddresses.Add(loNewAddress)


? TRANSFORM(loAddresses.Count) + " Addresses"  && 3 Addresses now
FOR lnX = 0 to loAddresses.Count -1 
    loAddress = loAddresses.Item(lnX)
    ? loAddress.ToString()
    ? 
ENDFOR