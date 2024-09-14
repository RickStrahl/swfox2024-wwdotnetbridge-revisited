LPARAMETERS lcPrompt, lcSystemPrompt

CLEAR
DO wwutils
do wwDotNetBridge
DO markdownParser

PUBLIC   loBridge as wwDotNetBridge, poCompletions
loBridge = GetwwDotnetBridge()
loBridge.LoadAssembly("Westwind.Ai.dll")

lcOpenAiKey = GETENV("OPENAI_KEY")

loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OpenAiConnection")
? loBridge.cErrorMsg
loConnection.ApiKey = lcOpenAiKey

IF EMPTY(lcPrompt)
   lcPrompt = "How do I make an Http call in FoxPro with wwHttp?"
ENDIF
IF EMPTY(lcSystemPrompt)
  lcSystemPrompt = "You are a helpful assistant"
ENDIF  

poCompletions = loBridge.CreateInstance("Westwind.AI.Chat.GenericAiChatClient", loConnection)


loCallback = CREATEOBJECT("OpenAiCallback")
loBridge.InvokeTaskMethodAsync(loCallback, poCompletions,"Complete",lcPrompt, lcSystemPrompt, .F.)

? "*** Program completes. Async call continues in background."
?
? "Thinking..."
? "--------------"
? lcPrompt
?

RETURN


DEFINE CLASS OpenAICallback as AsyncCallbackEvents

*** Returns the result of the method and the name of the method name
FUNCTION OnCompleted(lcResult,lcMethod)

IF (poCompletions.HasError)
    ? "Error: " + poCompletions.ErrorMessage
    RETURN
ENDIF

lcHtml = Markdown(lcResult)

ShowHtml(lcHtml)

ENDFUNC

* Returns an error message, a .NET Exception and the method name
FUNCTION OnError(lcMessage,loException,lcMethod)
? "Error: " + lcMethod,lcMessage
ENDFUNC

ENDDEFINE

