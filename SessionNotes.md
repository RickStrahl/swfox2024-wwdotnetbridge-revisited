# FoxPro wwDotnetBridge Revisited


#### Front Matter Sample
```markdown
---
title: This is a FrontMatter Header
subTitle: FrontMatter is a pain in Markdown
---
# This is a Markdown Document
Some Markdown text goes here.
```

## OpenAI

### Quotes for translation

> Own only what you can always carry with you: know languages, know countries, know people. Let your memory be your travel bag

> How did you go bankrupt? Two ways - Gradually, then suddenly

### Questions for Generic Completions

> Tell me about the history of Southwest Fox

> Tell me about the history of FoxPro

## FoxInterop Walk Through

### Add Alternate Addresses Property to C#

```cs
public List<Address> AlternateAddresses { get; set; } = new List<Address>();
```

### Person.ToString() implementation

```csharp
public override string ToString() 
{
    string output = $"{Name} ({Company})" + "\n" + Address.ToString();
    return output;
}
```

### Person.ToString Alternate Address

```csharp
if(AlternateAddresses.Count > 0)
{
    foreach(var addr in AlternateAddresses)
    {
        output += "\n" + addr.ToString();
    }
}
```



### Add an alternate address in FoxPro

```foxpro
*** Get ComArray of Address
loAddresses = loBridge.GetProperty(loPerson,"AlternateAddresses")
? loAddresses.Count && 0

*** Create a new detail items
loAddress = loAddresses.CreateItem()
loAddress.Street = "3123 Nowhere Lane"
loAddress.City = "Nowhere"

*** Add to the list of addresses
loAddresses.Add(loAddress)

*** Print - should include the new address
? loPerson.ToString()
```