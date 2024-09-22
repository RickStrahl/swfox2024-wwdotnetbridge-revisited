<Query Kind="Program">
  <Reference>&lt;RuntimeDirectory&gt;\System.Windows.Forms.dll</Reference>
  <NuGetReference>Westwind.AI</NuGetReference>
  <NuGetReference>Westwind.Utilities</NuGetReference>
  <Namespace>System.Threading.Tasks</Namespace>
  <Namespace>Westwind.AI.Configuration</Namespace>
  <Namespace>Westwind.AI.Images</Namespace>
  <Namespace>Westwind.Utilities</Namespace>
</Query>

async Task Main()
{
	var config = new OpenAiConnection()
	{
		 ApiKey = Environment.GetEnvironmentVariable("OPENAI_KEY")		
	};
	var chat = new Westwind.AI.Chat.GenericAiChatClient(config);

	string textToTranslate = System.Windows.Forms.Clipboard.GetText();	
	
	string prompt = "Translate the following from English to German:\n\n" + 
	                textToTranslate;
	string systemPrompt = "You are a translator that translates text from one language to another. " +
	                      "Return only the translated text in the response.";
	
	string result = await chat.Complete(prompt, systemPrompt, false);	
	if (chat.HasError)
	{
		chat.ErrorMessage.Dump();
		return;
	}
	
	result.Dump();	
}
