<Query Kind="Program">
  <NuGetReference>Humanizer</NuGetReference>
  <Namespace>Humanizer</Namespace>
</Query>

void Main()
{
	var dt = DateTime.Now.AddDays(-10);	
	dt.Humanize(false, null,null).Dump();
	
	
	int val = 1322;
	val.ToWords(true, WordForm.Normal,null).Dump();
	
}

// Define other methods and classes here
