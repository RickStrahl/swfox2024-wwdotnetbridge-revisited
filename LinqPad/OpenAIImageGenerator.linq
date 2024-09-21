<Query Kind="Program">
  <NuGetReference>Westwind.AI</NuGetReference>
  <NuGetReference>Westwind.Utilities</NuGetReference>
  <Namespace>System.Threading.Tasks</Namespace>
  <Namespace>Westwind.Utilities</Namespace>
  <Namespace>Westwind.AI.Images</Namespace>
  <Namespace>Westwind.AI.Configuration</Namespace>
</Query>

async Task Main()
{
	var config = new OpenAiConnection()
	{
		 ApiKey = Environment.GetEnvironmentVariable("OPENAI_KEY"),
		 OperationMode = AiOperationModes.ImageGeneration,		 
		 ModelId="dall-e-3"
	};
	var imageGen = new OpenAiImageGeneration(config);
	
		
	var prompt = new ImagePrompt() {
	  Prompt = "A Fox that is dressed as a grungy punk rocker, rocking out on a Bass guitar", 
	  
	};
	
	bool result = await imageGen.Generate(
							prompt,false,ImageGenerationOutputFormats.Url);
	
	imageGen.ErrorMessage.Dump();
	prompt.Dump();

	ShellUtils.GoUrl(prompt.FirstImageUrl);	
	
	var filename = @"d:\temp\generatedImage.png";
	await prompt.DownloadImageToFile(prompt.FirstImageUrl, filename);
	ShellUtils.GoUrl(filename);
}

// Define other methods and classes here