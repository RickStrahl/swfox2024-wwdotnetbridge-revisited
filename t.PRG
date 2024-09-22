CLEAR
DO _startup.prg

DO wwDotnetBRidge
loBridge = GetwwDotnetBridge()
? loBridge.LoadAssembly("foxInterop.dll")

loPerson = loBridge.CreateInstance("FoxInterop.Person")
? loPerson.Name
? loPerson.Entered
? loPerson.ToString()
?

loAddresses = loBridge.GetProperty(loPerson, "AlternateAddresses")

loAddress = loAddresses.CreateItem()
loAddress.Street = "3123123 Nowhere Lane"
loAddress.City = "Nowhere"

loAddresses.Add(loAddress)

loAddress = loAddresses.CreateItem()
loAddress.Street = "3123123 Somewhere Lane"
loAddress.City = "Somewhere"

loAddresses.Add(loAddress)

? loPerson.ToString()