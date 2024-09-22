LPARAMETERS lcPrompt, lcSystemPrompt

CLEAR
DO wwutils
do wwDotNetBridge
DO markdownParser

LOCAL loBridge as wwDotNetBridge, loCompletions
loBridge = GetwwDotnetBridge()
loBridge.LoadAssembly("Westwind.Ai.dll")

lcOpenAiKey = GETENV("OPENAI_KEY")

*** Open AI Connection with gpt-4o-mini
loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OpenAiConnection")
? loBridge.cErrorMsg
loConnection.ApiKey = lcOpenAiKey

*** Using Ollama SMLs Locally
*!*	loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OllamaOpenAiConnection")
*!*	? loBridge.cErrorMsg
*!*	loConnection.ModelId = "llama3"
*loConnection.ModelId = "phi3.5"

IF EMPTY(lcPrompt)
   lcPrompt = "How do I make an Http call in FoxPro with wwHttp?"
ENDIF
IF EMPTY(lcSystemPrompt)
  lcSystemPrompt = "You are a helpful assistant"
ENDIF  

loCompletions = loBridge.CreateInstance("Westwind.AI.Chat.GenericAiChatClient", loConnection)

loCallback = CREATEOBJECT("OpenAiCallback")
loCallback.oCompletions = loCompletions
loBridge.InvokeTaskMethodAsync(loCallback, loCompletions,"Complete",lcPrompt, lcSystemPrompt, .F.)

? "*** Program completes. Async call continues in background."
?
? "Thinking..."
? "--------------"
? lcPrompt
?

RETURN


DEFINE CLASS OpenAICallback as AsyncCallbackEvents

oCompletions = null

*** Returns the result of the method and the name of the method name
FUNCTION OnCompleted(lcResult,lcMethod)

IF (This.oCompletions.HasError)
    ? "Error: " + THIS.oCompletions.ErrorMessage
    RETURN
ENDIF

lcHtml = Markdown(lcResult)

? "Done!"
ShowWebPage(lcHtml)

ENDFUNC

* Returns an error message, a .NET Exception and the method name
FUNCTION OnError(lcMessage,loException,lcMethod)
? "Error: " + lcMethod,lcMessage
ENDFUNC

ENDDEFINE

