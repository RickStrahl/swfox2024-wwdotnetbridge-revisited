# Session Notes: FoxPro wwDotnetBridge Revisited


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

> Tell me how to implement a quick sort in C#

### Image AI Prompt

> A bear Holding on to a snowy mountain peak, waving a beer glass in the air. Poster style, with a black background in goldenrod line art

> Create an image of the Golden Gate bridge from the base that shows the span extending into the fog

> Visualize a poster-style image of a bear agressively playing a bass guitar in the style of a metal musician stomping around a stage. The bear should be completely absorbed in its music, rocking out with full passion and dedication. The scene is to be conveyed through line art in goldenrod color contrasted against a deep black background. Exert effort on crafting and emphasizing the bear's distinct features and the intricate details of the entire bass instrument to intensify the overall image and vividly display the bear's energetic performance. Zoom out wide to capture the entire bear's body and the full bass on a black background.

## FoxInterop Walk Through

### Initial Person Class

```csharp
public class Person
{
   public string Name { get; set; } =  "Jane Doe";
   public string Company { get; set; } = "Acme Inc.";
   public DateTime Entered { get; set; } = DateTime.UtcNow;
   public Address Address { get; set; } = new Address();

   public override string ToString() 
   {
       return $"{Name} ({Company})\n{Address}";
   }
}

public class Address
{
   public string Street { get; set; }  =  "123 Main St.";
   public string City { get; set; }    =  "Anytown";
   public string State { get; set; }   =  "CA";
   public string PostalCode { get; set; }  =  "12345";

   public override string ToString() 
   {
       return $"{Street}, {City}, {State} {PostalCode}";
   }
}

```

### Add alternate path

```xml
<OutputPath>..\..\bin</OutputPath>
<AppendTargetFrameworkToOutputPath>false</AppendTargetFrameworkToOutputPath>	
```


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