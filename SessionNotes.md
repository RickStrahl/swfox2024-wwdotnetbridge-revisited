# FoxPro wwDotnetBridge Revisited

## Markdig Markdown Parser


### LINQPad and Markdig Sample

```cs
// ADD Markdig Nuget Reference - Query->Nuget Package Manager->Markdig
string markdown = """
# Session Notes

These are the notes for this particular session.

* Reference to Samples covered
* Sample code to paste into document
* 

**Let's go!**=
""";	

var html = Markdig.Markdown.ToHtml(markdown, null, null);
html.Dump();	
```	

### Markdown Sample

#### Front Matter Sample
```markdown
---
title: This is a FrontMatter Header
subTitle: FrontMatter is a pain in Markdown
---
# This is a Markdown Document
Some Markdown text goes here.
```

## OpenAI

Quotes for translation

> Own only what you can always carry with you: know languages, know countries, know people. Let your memory be your travel bag

> How did you go bankrupt? Two ways - Gradually, then suddenly