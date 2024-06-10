UNIT MergeUnit;
INTERFACE
USES
  WordUnit;

{Соединяет 2 файла в 1, попутно сортируя строки}
PROCEDURE MergeFiles(VAR F1, F2, MergeTo: TEXT);
{Копирует содержимое из InFile в OutFile}
PROCEDURE CopyFile(VAR InFile, OutFile: TEXT);

IMPLEMENTATION
{Соединяет файлы F1 и F2 в Res, 
попутно сравнивая строки в формате <слово><пробел><число>
и объединяя их значения, если необходимо}
PROCEDURE MergeFiles(VAR F1, F2, MergeTo: TEXT);
VAR
  W1, W2: STRING;
  AmountFirst, AmountSecond: INTEGER;
  Compare: CompareType;
BEGIN {MergeFiles}
  RESET(F1);
  RESET(F2);
  REWRITE(MergeTo);
  
  W1 := "";
  W2 := "";
                  
  WHILE NOT EOF(F1) OR NOT EOF(F2)
  DO
    BEGIN
      IF (W1 = "") AND (NOT EOF(F1))
      THEN
        ReadWordWithAmount(F1, W1, AmountFirst);
        
      IF (W2 = "") AND (NOT EOF(F2))
      THEN
        ReadWordWithAmount(F2, W2, AmountSecond);  
           
      Compare := CompareStrings(W1, W2);
            
      IF (Compare = Equal) AND (W1 <> "") AND (W2 <> "")
      THEN
        BEGIN
          WRITELN(MergeTo, W1, ' ', AmountFirst + AmountSecond);
          W1 := "";
          W2 := ""
        END
      ELSE  
        IF ((Compare = Less) AND (W1 <> "") AND (W2 <> "")) OR ((W1 <> "") AND EOF(F2))
        THEN
          BEGIN
            WRITELN(MergeTo, W1, ' ', AmountFirst);
            W1 := ""
          END
        ELSE
          IF (Compare = Bigger) AND (W1 <> "") AND (W2 <> "") OR ((W2 <> "") AND EOF(F1))
          THEN
            BEGIN
              WRITELN(MergeTo, W2, ' ', AmountSecond);
              W2 := ""
            END         
    END;
    
  IF W1 <> ""
  THEN
    WRITELN(MergeTo, W1, ' ', AmountFirst);
    
  IF W2 <> ""
  THEN
    WRITELN(MergeTo, W2, ' ', AmountSecond)    
END;  {MergeFiles}

{Копирует содержимое из InFile в OutFile}
PROCEDURE CopyFile(VAR InFile, OutFile: TEXT);
VAR
  Ch: CHAR;
BEGIN {CopyFile}
  RESET(InFile);
  REWRITE(OutFile);
  WHILE NOT EOF(InFile)
  DO
    BEGIN
      WHILE NOT EOLN(InFile)
      DO
        BEGIN
          READ(InFile, Ch);
          WRITE(OutFile, Ch)  
        END;
      READLN(InFile);
      WRITELN(OutFile) 
    END
END;  {CopyFile}

BEGIN {MergeUnit}
END.  {MergeUnit}
