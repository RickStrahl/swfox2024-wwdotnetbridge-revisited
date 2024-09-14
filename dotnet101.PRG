CLEAR
DO _STARTUP.prg

do wwDotNetBridge                 && Load library
LOCAL loBridge as wwDotNetBridge  && for Intellisense
loBridge = GetwwDotnetBridge()    && instance

*** Load an Assembly
loBridge.LoadAssembly("wwDotnetBridgeDemos.dll")

*** Create an class Instance
loPerson = loBridge.CreateInstance("wwDotnetBridgeDemos.Person")

*** Access simple Properties
? "*** Simple Properties:" 
? loPerson.Name
? loPerson.Company
? loPerson.Entered
?

*** Call a Method
? "*** Method call: Formatted Person Record (ToString):"
? loPerson.ToString()  && Formatted Person with Address
?

*** Add a new address
loAddress =  loPerson.AddAddress("1 Main","Fairville","CA","12345")

*** Special Properties - returns a ComArray instance
loAddresses = loBridge.GetProperty(loPerson, "Addresses")  
*? loBridge.ToJson(loAddresses, .T.)  && Commercial only

? TRANSFORM(loAddresses.Count) + " Addresses"     && Number of items in array

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


*** Returns a ComArray instance
loAddresses = loBridge.GetProperty(loPerson,"Addresses")

? loAddresses.Count   && 2
loAddress1 = loAddresses.Item(0)

FOR lnX = 0 to loAddresses.Count -1 
    loAddress = loAddresses.Item(lnX)
    * ? loAddress.Street + "  " + loAddress.City
    ? loAddress.ToString()
ENDFOR

*!*	? "*** Add another item to the array"

*!*	* loNewAddress = loBridge.CreateInstance("wwDotnetBridgeDemos.Address")
*!*	loNewAddress = loAddresses.CreateItem()
*!*	loNewAddress.Street = "122 Newfound Landing"
*!*	loNewAddress.City = "NewFoundLanding"
*!*	loAddresses.Add(loNewAddress)


*!*	? TRANSFORM(loAddresses.Count) + " Addresses"  && 3
*!*	FOR lnX = 0 to loAddresses.Count -1 
*!*	    loAddress = loAddresses.Item(lnX)
*!*	    ? loAddress.ToString()
*!*	    ? 
*!*	ENDFOR