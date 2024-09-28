CLEAR
DO _startup.prg

DO wwDotnetBridge
SET PROCEDURE TO wwUtils additive
SET PROCEDURE TO SpellChecker ADDITIVE

#IF .T.   
*** RAW API Access


do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

loBridge.LoadAssembly("WeCantSpell.Hunspell.dll")

*** Location of Dictionary Files *.dic and *.aff
dictFolder = FULLPATH("bin\")
	
*** Creates a Spellchecker instance
loSpell = loBridge.InvokeStaticMethod("WeCantSpell.Hunspell.WordList",;
                                    "CreateFromFiles",;
                                    dictFolder +"en_US.dic",;
                                    dictFolder + "en_US.aff")

? "*** Check 'Colour' (en_US)"
? loSpell.Check("Colour")
?
? "*** Check 'Color' (en_US)"
? loSpell.Check("Color")
?

? "*** Suggestions for misspelled 'Colour'" 
loSuggestions = loBridge.InvokeMethod(loSpell,"Suggest","Colour")


*** loSuggestions is a  `ComArray` Instance (IEnumerable<string>)
? loSuggestions.Count

*** Iterate over array items
FOR lnX = 0 TO loSuggestions.Count -1
   ? loSuggestions.Item(lnX)
ENDFOR

RETURN
#ENDIF

#IF .T.
   *** Using the Wrapper Class
   CLEAR
   
   *** Loads library and dictionary - you can cache this for reuse
   loSpell = CREATEOBJECT("HunspellChecker","en_US",".\bin")   
   
   ? "*** Check spelling for:"
   ? "Testing: " + TRANSFORM( loSpell.Spell("Testing")  )

   ? "Tesdting: " + TRANSFORM(loSpell.Spell("Tesdting")      )
  
   
   lcWord = "aren'tt"
   ? "Suggest for " + lcWord
   loSug = loSpell.Suggest(lcWord)
   ? loSug.Count
   FOR EACH lcWord in loSug
      ? lcWord
   ENDFOR
   loSpell = null

   loSpell = CREATEOBJECT("HunspellChecker","de_DE",".\bin")
   
   ? "*** Using German Dictionary:"
   ? "Zahn: " + TRANSFORM(loSpell.Spell("Zahn"))
   ? "Zahnn: " + TRANSFORM(loSpell.Spell("Zahnn"))     
   ? "Zähne: " + TRANSFORM(loSpell.Spell("Zähne"))  
   ? "läuft: " + TRANSFORM(loSpell.Spell("läuft"))
   
   ? "***  Suggest for Zähjne"
   loSug = loSpell.Suggest("Zähjne")
   FOR EACH lcWord in loSug
      ? lcWord
   ENDFOR
         
   ? loSug.Count
   loSpell = null


? "*** Text to check:"
TEXT TO lcText
These ae somme of the worsd that are badly mispeled.

I cannot imaggine that somebody can spel so bad.

ENDTEXT


loSpell = CREATEOBJECT("HunspellChecker","en_US",".\bin")   
loWords = GetWords(lcText)

LOCAL lnX
? "*** Mispelled words:"
FOR lnX = 1 TO loWords.Count   
   lcWord = loWords.Item(lnX)
   lcSuggest = ""

   IF (!loSpell.Spell(lcWord))
      loSug = loSpell.Suggest(lcWord)
      IF (loSug.Count > 0)
      	  
          FOR lnY = 1 TO loSug.Count
			lcSuggest = lcSuggest + loSug.Item(lnY) + " "
	   	  ENDFOR
	  ENDIF
	  
	  ? lcWord + " - " + lcSuggest   
	ENDIF
	
ENDFOR


#ENDIF

*************************************************************
DEFINE CLASS HunspellChecker AS Custom
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2015
*:Contact: http://www.west-wind.com
*:Created: 08/07/15
*************************************************************
#IF .F.
*:Help Documentation
*:Topic:
Class HunspellChecker

*:Description:
Checks against a dictionary to see if a work is valid.
Can provide suggestions for misspelled words.

*:Example:
loSpell = CREATEOBJECT("HunspellChecker","en_US",".\Editors")
? loSpell.Spell("Testing")    && true
? loSpell.Spell("Tesdting")   && false

loSug = loSpell.Suggest("Tesdting")  && collection of suggestions


*:SeeAlso:


*:ENDHELP
#ENDIF

oBridge = null
oSpell = null
cLanguage = "en_US"
cDictionaryFolder = "" && root

************************************************************************
*  init
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION init(lcLang, lcDictFolder)

IF EMPTY(lcLang)
   lcLang = this.cLanguage
ENDIF
IF EMPTY(lcDictFolder)
   lcDictFolder = this.cDictionaryFolder
ENDIF
   
this.oBridge = GetwwDotnetBridge()
IF ISNULL(this.oBridge)
      ERROR "Failed to load HUnspell: " + this.oBridge.cErrorMsg
ENDIF

LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()
if(!loBridge.LoadAssembly("WeCantSpell.Hunspell.dll"))
  ERROR "Failed to load WeCantSpell.Hunspell.dll: " + this.oBridge.cErrorMsg
ENDIF

IF !EMPTY(lcDictFolder)
	lcDictFolder = ADDBS(lcDictFolder)
ELSE
    lcDictFolder = ""
ENDIF

lcDictFolder = FULLPATH(lcDictFolder)

THIS.oSpell = loBridge.InvokeStaticMethod("WeCantSpell.Hunspell.WordList",;
                                    "CreateFromFiles",;
                                  lcDictFolder + lcLang + ".dic",;
                                  lcDictFolder + lcLang + ".aff")

IF ISNULL(this.oSpell)
  ERROR "Failed to load HUnspell: " + this.oBridge.cErrorMsg
ENDIF
                                  

ENDFUNC
*   init

************************************************************************
*  Spell
****************************************
***  Function: Checks to see if a word is a known word in the dictionary
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Spell(lcWord)
LOCAL llResult

IF ISNULLOREMPTY(lcWord) OR LEN(lcWord) = 1
   RETURN .T.
ENDIF

llResult = this.oSpell.Check(lcWord)

RETURN llResult
ENDFUNC
*   Spell

************************************************************************
*  Suggest
****************************************
***  Function: Gives back a collection of word suggestions for 
***            the passed in word
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Suggest(lcWord)
LOCAL loWords, lnx

loCol = CREATEOBJECT("collection")

*** Returns a Collection of values (not an array)
loWords = this.obridge.InvokeMethod(this.oSpell,"Suggest",lcWord)

lnCount = loWords.Count

FOR lnX = 0 TO lnCount -1
    *** return indexed value (0 based) from the list collection
    lcWord = loWords.Item(lnX)
    loCol.Add( lcWord )
ENDFOR


RETURN loCol
ENDFUNC
*   Suggest


************************************************************************
*  AddWordToDictionary
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION AddWordToDictionary(lcWord, lcLang)

lcFile = "editors\" + lcLang + "_custom.txt"
AppendToFile(lcWord + CHR(13) + CHR(10),lcFile)
this.oSpell.Add(lcWord)

ENDFUNC
*   AddWordToDictionary

************************************************************************
*  Destroy
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Destroy()

*** MUST dispose to release memory for spell checker
*this.oSpell.Dispose()
this.oSpell = null

ENDFUNC
*   Destroy

ENDDEFINE
*EOC HunspellChecker 


FUNCTION GetWords(lcText)
LOCAL loWords, lnCount, lnX, lcWord

loWords = CREATEOBJECT("Collection")
lnCount = ALINES(laWords,lcText,1," ",CHR(13),CHR(10))
FOR lnX = 1 TO lnCount
   lcWord =  ALLTRIM(laWords[lnx])
   IF EMPTY(lcWord)
      LOOP
   ENDIF	   
   lcWord = CHRTRAN(lcWord,".,:!?","")
   loWords.Add(lcWord)
ENDFOR

RETURN loWords
