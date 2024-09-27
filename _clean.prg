CLEAR ALL
CLOSE ALL
RELEASE ALL
CLEAR PROGRAM


ERASE *.bak
ERASE classes\*.bak
TRY
  ERASE *.fxp
  ERASE classes\*.fxp  
CATCH
ENDTRY

CLEAR
? "*** Done cleaning up files..."