LPARAMETERS lcTextToSummarize

CLEAR
DO wwutils
do wwDotNetBridge

PUBLIC loBridge as wwDotNetBridge, poCompletions

loBridge = GetwwDotnetBridge()
*loBridge = GetwwDotnetCoreBridge()


? loBridge.LoadAssembly("Westwind.Ai.dll")


*** Using OpenAI API
loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OpenAiConnection")
? loBridge.cErrorMsg
loConnection.ApiKey = GETENV("OPENAI_KEY")
loConnection.ModelId = "gpt-4o-mini"  && "gpt-3-turbo"

*** Using Ollama SMLs Locally
*!*	loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OllamaOpenAiConnection")
*!*	? loBridge.cErrorMsg
*!*	loConnection.ModelId = "llama3"


IF EMPTY(lcTextToSummarize)
    ? "Please provide some text to summarize."
	RETURN
ENDIF

poCompletions = loBridge.CreateInstance("Westwind.AI.Chat.GenericAiChatClient", loConnection)

lcSystem = "You are a technical writer and are tasked to summarize input text succinctly in no more than 4 sentences. Return only the result summary text."
lcPrompt = lcTextToSummarize

loCallback = CREATEOBJECT("OpenAiCallback")
loBridge.InvokeTaskMethodAsync(loCallback, poCompletions,"Complete",lcPrompt, lcSystem, .F.)

? "*** Program completes. Async call continues in background."
?
? "Summarizing..."
?

RETURN


DEFINE CLASS OpenAICallback as AsyncCallbackEvents

*** Returns the result of the method and the name of the method name
FUNCTION OnCompleted(lcResult,lcMethod)

IF (poCompletions.HasError)
    ? "Error: " + poCompletions.ErrorMessage
    RETURN
ENDIF

? "Summary:"
? "----------"
? lcResult

ENDFUNC

* Returns an error message, a .NET Exception and the method name
FUNCTION OnError(lcMessage,loException,lcMethod)
? "Error: " + lcMethod,lcMessage
ENDFUNC

ENDDEFINE

