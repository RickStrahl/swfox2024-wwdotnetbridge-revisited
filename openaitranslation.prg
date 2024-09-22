LPARAMETERS lcTranslateText, lcLanguage

CLEAR
DO wwutils
do wwDotNetBridge

*** We have to keep the completions alive
loBridge = GetwwDotnetBridge()
? loBridge.LoadAssembly("Westwind.Ai.dll")

lcOpenAiKey = GETENV("OPENAI_KEY")

loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OpenAiConnection")
? loBridge.cErrorMsg
loConnection.ApiKey = lcOpenAiKey
loConnection.ModelId = "gpt-4o-mini"

*** Using Ollama SMLs Locally
*!*	loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OllamaOpenAiConnection")
*!*	? loBridge.cErrorMsg
*!*	loConnection.ModelId = "llama3"


IF EMPTY(lcTranslateText)
   lcTranslateText = "Genius is one percent inspiration, ninety-nine percent perspiration."
ENDIF
IF EMPTY(lcLanguage)
  lcLanguage = "German"
ENDIF  

loCompletions = loBridge.CreateInstance("Westwind.AI.Chat.GenericAiChatClient", loConnection)
lcSystem = "You are a translator and you translate text from one language to another. " +;
           "Return only the translated text"
lcPrompt = "Translate from English to " + lcLanguage + CHR(13) + CHR(13) + lcTranslateText

*** Set up the callback event handler - OnCompleted/OnError
loCallback = CREATEOBJECT("OpenAiCallback")
loCallback.oCompletions = loCompletions && pass so we can access in callback

*** Make the API call asynchronously - returns immediately
loBridge.InvokeTaskMethodAsync(loCallback, loCompletions,"Complete",lcPrompt, lcSystem, .F.)

? "*** Program completes. Async call continues in background."
?
? "Translating from English..."
? "--------------"
? lcTranslateText
?

RETURN

****************************************************************
DEFINE CLASS OpenAICallback as AsyncCallbackEvents
**************************************************

oCompletions = null

*** Returns the result of the method and the name of the method name
FUNCTION OnCompleted(lcResult,lcMethod)

IF (this.oCompletions.HasError)
    ? "Error: " + this.oCompletions.ErrorMessage
    RETURN
ENDIF

? "To German:"
? "----------"
? lcResult

ENDFUNC

* Returns an error message, a .NET Exception and the method name
FUNCTION OnError(lcMessage,loException,lcMethod)
? "Error: " + lcMethod,lcMessage
ENDFUNC

ENDDEFINE

