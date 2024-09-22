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

	string prompt = System.Windows.Forms.Clipboard.GetText();	
	string systemPrompt = "You are an technical editor that summarizes text. " +
	                      "Return only the summarized text in the response.";
	
	string result = await chat.Complete(prompt, systemPrompt, false);	
	if (chat.HasError)
	{
		chat.ErrorMessage.Dump();
		return;
	}
	
	result.Dump();	
}
