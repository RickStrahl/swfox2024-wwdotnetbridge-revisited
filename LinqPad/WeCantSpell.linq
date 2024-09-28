<Query Kind="Program">
  <NuGetReference>WeCantSpell.Hunspell</NuGetReference>
  <Namespace>WeCantSpell.Hunspell</Namespace>
</Query>

void Main()
{	
	string dictFile = @"d:\wwapps\conf\wwdotnetbridgerevisited\bin\en_US";
	var spell = WordList.CreateFromFiles(dictFile + ".dic", dictFile + ".aff");
	
	Console.WriteLine("*** Check Colour");
	spell.Check("Colour").Dump();

	Console.WriteLine("*** Check Color");
	spell.Check("Color").Dump();

	Console.WriteLine("*** Suggest Colour");
	var suggestions = spell.Suggest("Colour");
	suggestions.Dump();
}