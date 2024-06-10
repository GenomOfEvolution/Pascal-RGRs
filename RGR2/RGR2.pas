PROGRAM CountWordsV2(INPUT, OUTPUT);
USES
  StorageUnit, WordUnit;

{Создает файл встречаемости слов из FIn, сохраняя его в FOut}
PROCEDURE MakeStatistics(VAR FIn, FOut: TEXT);
VAR
  Word: STRING;

BEGIN {MakeStatistics}
  Word := "";
  WHILE NOT EOF(FIn)
  DO
    BEGIN
      Word := ReadWord(FIn);
      IF Word <> ""
      THEN
        InsertWordToStorage(Word)
    END;
  PrintStorageToFile(FOut)
END;  {MakeStatistics}
    
BEGIN {CountWordsV2}
  MakeStatistics(INPUT, OUTPUT)
END.  {CountWordsV2}
