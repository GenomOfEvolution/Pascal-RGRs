UNIT WordUnit;
INTERFACE
TYPE
  CompareType = (Bigger, Less, Equal);  

FUNCTION ReadWord(VAR FIn: TEXT): STRING;   {Считывает слово до первого не буквенного символа}
PROCEDURE ReadWordWithAmount(VAR FIn: TEXT; VAR Str: STRING; VAR Amount: INTEGER);
FUNCTION CompareStrings(Str1, Str2: STRING): CompareType;

IMPLEMENTATION
TYPE
  ReadingState = (Start, Letter, Dash, FoundWord);

CONST
  AvaibleLetters = ['A' .. 'Z', 'a' .. 'z', 'А' .. 'Я', 'а' .. 'я', 'Ё', 'ё', '-'];
  EngLetterTransformTable: ARRAY ['A' .. 'Z'] OF CHAR = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
  RusLetterTransformTable: ARRAY ['А' .. 'Я'] OF CHAR = ('а', 'б', 'в', 'г', 'д', 'е', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я');
  CompareWeightTable: ARRAY ['а' .. 'я'] OF INTEGER = (223, 224, 225, 226, 227, 228, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255);
  LetterIoWeight = 229;

{Возвращает номер символа Ch}
FUNCTION GetLetterPos(Ch: CHAR): INTEGER;
BEGIN {GetLetterPos}
  CASE Ch OF
    'а' .. 'я': GetLetterPos := CompareWeightTable[Ch];
    'ё': GetLetterPos := LetterIoWeight
  ELSE
    GetLetterPos := ORD(Ch)
  END
END; {GetLetterPos}

{Сравнивает Str1 и Str2, возвращая CompareType}  
FUNCTION CompareStrings(Str1, Str2: STRING): CompareType;
VAR
  I: INTEGER;
  Compare: CompareType;
BEGIN {CompareStrings}
  I := 1;
  Compare := Equal;
  WHILE (I <= LENGTH(Str1)) AND (I <= LENGTH(Str2)) AND (Compare = Equal)
  DO
    BEGIN
      IF GetLetterPos(Str1[I]) < GetLetterPos(Str2[I])
      THEN
        Compare := Less
      ELSE
        IF GetLetterPos(Str1[I]) > GetLetterPos(Str2[I])
        THEN
          Compare := Bigger;
      I := I + 1
    END;
    
   IF (Compare = Equal) AND (LENGTH(Str1) < LENGTH(Str2))
   THEN
     Compare := Less
   ELSE
     IF (Compare = Equal) AND (LENGTH(Str1) > LENGTH(Str2))
     THEN
       Compare := Bigger;
  CompareStrings := Compare 
END;  {CompareStrings}

{Преобразует символ Ch в его строчное представление,
если он является заглавной русской или английской буквой}  
FUNCTION CharToLower(Ch: CHAR): CHAR;
BEGIN {CharToLower}
  CASE Ch OF 
    'A' .. 'Z': CharToLower := EngLetterTransformTable[Ch];
    'А' .. 'Я': CharToLower := RusLetterTransformTable[Ch];
    'Ё': CharToLower := 'ё'
  ELSE
    CharToLower := Ch
  END 
END; {CharToLower}

FUNCTION ReadWord(VAR FIn: TEXT): STRING;
VAR
  Ch: CHAR;
  Res: STRING;
  State: ReadingState;
  
BEGIN {ReadWord}
  Res := "";
  State := Start;
  
  WHILE NOT EOF(FIn) AND (State <> FoundWord)
  DO
    BEGIN
      IF NOT EOLN(FIn)
      THEN
        READ(FIn, Ch)
      ELSE
        BEGIN
          READLN(FIn);
          State := FoundWord
        END;
      
      IF (Ch IN AvaibleLetters) AND (State <> FoundWord)
      THEN
        BEGIN
          IF (Ch <> '-') AND ((State = Start) OR (State = Letter))
          THEN
            BEGIN
              Res := Res + CharToLower(Ch);
              State := Letter
            END
          ELSE
            IF (Ch = '-') AND (State = Letter)
            THEN
              State := Dash
            ELSE
              IF (Ch = '-') AND (State = Dash)
              THEN
                State := FoundWord
              ELSE
                IF (Ch <> '-') AND (State = Dash)
                THEN
                  BEGIN
                    Res := Res + '-' + CharToLower(Ch);
                    State := Letter
                  END
        END
      ELSE
       State := FoundWord 
    END;
  ReadWord := Res
END;  {ReadWord}

PROCEDURE ReadWordWithAmount(VAR FIn: TEXT; VAR Str: STRING; VAR Amount: INTEGER);
BEGIN {ReadWordWithAmount}
  Str := ReadWord(FIn);
  READLN(FIn, Amount)
END;  {ReadWordWithAmount}

BEGIN {WordUnit}
END.  {WordUnit}
