<Query Kind="Program">
  <NuGetReference>Westwind.Utilities</NuGetReference>
  <NuGetReference>Westwind.WebView.HtmlToPdf</NuGetReference>
  <Namespace>System.Threading.Tasks</Namespace>
  <Namespace>Westwind.WebView.HtmlToPdf</Namespace>
  <Namespace>Westwind.Utilities</Namespace>
</Query>

async Task Main()
{
	var pdf = new HtmlToPdfHost();
	
	var settings = new WebViewPrintSettings() 
	{		 	 
		 ScaleFactor = 1, MarginTop = 20
	};
	
	var result = await pdf.PrintToPdfAsync(
		"https://microsoft.com",
		@"c:\temp\westwind.pdf", 
		settings);
		
	if (!result.IsSuccess) 
	{
		Console.WriteLine("ERROR: "+result.Message);
		return;
	}
	
	Console.WriteLine("Done!");
		
	ShellUtils.GoUrl(@"c:\temp\westwind.pdf");		
}

// Define other methods and classes here