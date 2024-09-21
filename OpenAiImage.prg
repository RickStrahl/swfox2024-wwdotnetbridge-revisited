LPARAMETERS lcPrompt, lcImageFile

CLEAR
DO wwutils
do wwDotNetBridge
DO markdownParser

PUBLIC   loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()
loBridge.LoadAssembly("Westwind.Ai.dll")

lcOpenAiKey = GETENV("OPENAI_KEY")

loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OpenAiConnection")
? loBridge.cErrorMsg
loConnection.ApiKey = lcOpenAiKey
loConnection.ModelId = "dall-e-3"
loConnection.OperationMode = 1  && AiOperationModes.ImageGeneration=1

IF EMPTY(lcPrompt)
   lcPrompt = "A Fox that is dressed as a grungy punk rocker, rocking out agressively on a Bass guitar." + ;
              "Use golden rod colors on a black background in classic poster style format"	 
ENDIF


loPrompt = loBridge.CreateInstance("Westwind.AI.Images.ImagePrompt")
loPrompt.Prompt = lcPrompt

loImageGen = loBridge.CreateInstance("Westwind.AI.Images.OpenAiImageGeneration", loConnection)

loEventHandler = CREATEOBJECT("OpenAICallback")

*** Pass these so they stay alive and can be accessed in the event handler
loEventHandler.oPrompt = loPrompt
loEventHandler.oImageGen = loImageGen

*** Here we need to match the signature EXACTLY which means ACTUAL enum object
enumOutputFormat = loBridge.GetEnumValue("Westind.AI.Images.ImageGenerationOutputFormats","Url")
loBridge.InvokeTaskMethodAsync(loEventHandler, loImageGen, "Generate", loPrompt, .F., enumOutputFormat) && ImageGenerationOutputFormats.Url

? "*** Program completes. Async call continues in background."
?
? "Generating Image..."
? "--------------"
? lcPrompt
?

RETURN


DEFINE CLASS OpenAICallback as AsyncCallbackEvents

oPrompt = null
oImageGen = null

*** Returns the result of the method and the name of the method name
FUNCTION OnCompleted(llResult,lcMethod)

IF (!llResult)
    ? "Error: " + this.oImageGen.cErrorMsg
    RETURN
ENDIF

lcUrl = this.oPrompt.FirstImageUrl
? lcUrl
?

GoUrl(lcUrl)

*** Download the image
lcImageFile = "d:\temp\imagegen.png"
DO wwhttp
loHttp = CREATEOBJECT("wwHttp")
loHttp.Get(lcUrl,  lcImageFile)

GoUrl(lcImageFile)

? "Done!"

ENDFUNC

* Returns an error message, a .NET Exception and the method name
FUNCTION OnError(lcMessage,loException,lcMethod)
? "Error: " + lcMethod,lcMessage
ENDFUNC

ENDDEFINE

