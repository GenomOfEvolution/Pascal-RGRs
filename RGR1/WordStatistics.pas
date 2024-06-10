UNIT WordStatistics;
INTERFACE 
USES
  StorageUnit, WordUnit;

PROCEDURE MakeStatistics(VAR FIn, FOut: TEXT); {Создает файл встречаемости слов} 

IMPLEMENTATION
CONST
  MaxWordRead = 1000000;

{Создает файл встречаемости слов из FIn, сохраняя его в FOut}
PROCEDURE MakeStatistics(VAR FIn, FOut: TEXT);
VAR
  Word: STRING;
  WordsRead: INTEGER;
  
BEGIN {MakeStatistics}
  Word := "";
  WordsRead := 0;
  
  WHILE NOT EOF(FIn) AND (WordsRead < MaxWordRead)
  DO
    BEGIN
      Word := ReadWord(FIn);
      IF Word <> ""
      THEN
        BEGIN
          InsertWordToStorage(Word);
          WordsRead := WordsRead + 1
        END
    END;
    
  PrintStorageToFile(FOut)
END;  {MakeStatistics}

BEGIN {WordStatistics}
END.  {WordStatistics}
