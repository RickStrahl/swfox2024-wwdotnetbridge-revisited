LPARAMETERS lcTextToSummarize

CLEAR
DO wwutils
do wwDotNetBridge

LOCAL loBridge as wwDotNetBridge, loCompletions

loBridge = GetwwDotnetBridge()
? loBridge.LoadAssembly("Westwind.Ai.dll")

*** Using OpenAI API
loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OpenAiConnection")
loConnection.ApiKey = GETENV("OPENAI_KEY")
loConnection.ModelId = "gpt-4o-mini"  && "gpt-3-turbo"

*** Using Ollama SMLs Locally
loConnection = loBridge.CreateInstance("Westwind.AI.Configuration.OllamaOpenAiConnection")
? loBridge.cErrorMsg
loConnection.ModelId = "llama3"


IF EMPTY(lcTextToSummarize)
    ? "Please provide some text to summarize."
	RETURN
ENDIF

loCompletions = loBridge.CreateInstance("Westwind.AI.Chat.GenericAiChatClient", loConnection)

lcSystem = "You are a technical writer and are tasked to summarize input text succinctly in no more than 4 sentences. Return only the result summary text."
lcPrompt = lcTextToSummarize

loCallback = CREATEOBJECT("OpenAiCallback")
loCallback.oCompletions = loCompletions  

*** Async call starts here - returns immediately
loBridge.InvokeTaskMethodAsync(loCallback, loCompletions,"Complete",lcPrompt, lcSystem, .F.)

? "*** Program completes. Async call continues in background."
?
? "Summarizing..."
?

RETURN


DEFINE CLASS OpenAICallback as AsyncCallbackEvents


oCompletions = null

*** Returns the result of the method and the name of the method name
FUNCTION OnCompleted(lcResult,lcMethod)

IF (this.oCompletions.HasError)
    ? "Error: " + THIS.oCompletions.ErrorMessage
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

