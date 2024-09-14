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

![](https://markdownmonster.west-wind.com/Images/Icon_32.png) 

* List Item 1
* List Item 2
* List Item 3

Great it works!

> #### Examples are great
> This is a block quote with a header
ENDTEXT

***  Actual Markdown Conversion here - Invoke a Static Method
lcHtml = loBridge.InvokeStaticMethod("Markdig.Markdown","ToHtml",
                                     lcMarkdown,null)

*** UDF Function
* lchtml =  Markdown(lcMarkdown, 2)

? lcHtml
ShowHtml(lcHtml)  && from wwUtils show in browser unformatted




RETURN
#ENDIF

*** Using Markdown Parser Wrapper Class
#IF .F.
DO MarkdownParser
DO wwutils && For Html Preview

loParser = CREATEOBJECT("MarkdownParser")

TEXT TO lcMarkdown NOSHOW
This is some sample Markdown text. This text is **bold** and *italic*.

* List Item 1
* List Item 2
* List Item 3

Great it works!

> ### @icon-info-circle Examples are great
> This is a block quote with a header
ENDTEXT


lcHtml = loParser.Parse(lcMarkdown)
ShowHtml( lcHtml )
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
showHtml(lcHtml)

#ENDIF
