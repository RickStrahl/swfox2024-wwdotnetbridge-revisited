*** NOTE: Using an older version of Markdig 0.15.2 to minimize dependencies

*** Initialization (app startup)
DO _STARTUP.PRG
DO MarkdownParser
CLEAR

*** Straight Code
#IF .T.
DO wwutils && For Html Preview
do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

loBridge.LoadAssembly("markdig.dll")


TEXT TO lcMarkdown NOSHOW
# Raw Markdown Sample using the Markdig Parser

This is some sample Markdown text. This text is **bold** and *italic*.

* [Source Code for this sample on GitHub](https://github.com/RickStrahl/swfox2024-wwdotnetbridge-revisited/blob/master/markdownTest.PRG)

![](https://markdownmonster.west-wind.com/docs/images/logo.png) 

* List Item 1
* List Item 2
* List Item 3

Great it works!

> #### Examples are great
> This is a block quote with a header

## Code Blocks
Code blocks let you display source code in a formatted way and optionally - if templates are set up well - 
with optional syntax coloring

Here's some **C# code**:

```csharp
string text = ".NET Code and components are useful ";
text += "for expanding FoxPro functionality."

Console.WriteLine(text);
```

and here's some **FoxPro code**:

```foxpro
lcText = "FoxPro Rocks"
IF !EMPTY(lcText)
   lcText = lcText + " at Southwest Fox"
ENDIF	

? lcText
```

ENDTEXT

***  Actual Markdown Conversion here - Invoke a Static Method
lcHtml = loBridge.InvokeStaticMethod("Markdig.Markdown","ToHtml",;
                                     lcMarkdown,null)

*** UDF Function
* lchtml =  Markdown(lcMarkdown, 2)

? lcHtml
*ShowHtml(lcHtml)  && from wwUtils show in browser unformatted
ShowWebPage(lcHtml)

RETURN
#ENDIF

*** Using Markdown Parser Wrapper Class
#IF .T.
DO MarkdownParser
DO wwutils && For Html Preview

loParser = CREATEOBJECT("MarkdownParserExtended")

TEXT TO lcMarkdown NOSHOW
This is some sample Markdown text. This text is **bold** and *italic*.

* List Item 1
* List Item 2
* List Item 3

Great it works!

> #### @icon-info-circle Examples are great
> This is a block quote with a header


### Link Embedding is easy

* [Sample Repositor](https://github.com/RickStrahl/swfox2024-wwdotnetbridge-revisited)
* [Source Code for this sample on GitHub](https://github.com/RickStrahl/swfox2024-wwdotnetbridge-revisited/blob/master/markdownTest.PRG)

### Markdown Monster wants to eat your Markdown!

* [Download Markdown Monster](https://markdownmonster.west-wind.com)

![](https://markdownmonster.west-wind.com/Images/MarkdownMonsterLogo.jpg){style="max-width: 700px;"}

**The Markdown Editor for Windows**

## Code Blocks
Code blocks let you display source code in a formatted way and optionally - if templates are set up well - 
with optional syntax coloring

Here's some **C# code**:

```csharp
string text = ".NET Code and components are useful ";
text += "for expanding FoxPro functionality."

Console.WriteLine(text);
```

and here's some **FoxPro code**:

```foxpro
lcText = "FoxPro Rocks"

IF !EMPTY(lcText)
   lcText = lcText + " at Southwest Fox"
ENDIF

? lcText
```


ENDTEXT

lcHtml = loParser.Parse(lcMarkdown)
? lcHtml
ShowWebPage(lcHtml)

RETURN

#ENDIF



#IF .F.
DO wwutils && For Html Preview

TEXT TO lcMarkdown NOSHOW
This is some sample Markdown text. This text is **bold** and *italic*.

* List Item 1
* List Item 2
* List Item 3

Great it works!

> ### ![](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Commons-emblem-legal.svg/45px-Commons-emblem-legal.svg.png) Examples are great
> This is a block quote with a header
ENDTEXT

lcHtml = Markdown(lcMarkdown)
? lcHtml

lcHtml = Markdown(lcMarkdown)
ShowHtml(lcHtml)

#ENDIF
