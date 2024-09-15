<Query Kind="Program">
  <NuGetReference Version="0.15.2">Markdig</NuGetReference>
  <NuGetReference>Westwind.Utilities</NuGetReference>
  <Namespace>Markdig</Namespace>
  <Namespace>Westwind.Utilities</Namespace>
</Query>

void Main()
{
	string md = @"
# Markdown Sample
This is a test of **markdown parsing**.

* Item 1
* Item 2
* item 3	
	";
	
	var html = Markdown.ToHtml(md, null);	
	
	html.Dump();
	
	ShellUtils.ShowHtml(html);		
}

// Define other methods and classes here
