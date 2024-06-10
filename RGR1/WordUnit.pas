UNIT WordUnit;
INTERFACE
FUNCTION ReadWord(VAR FIn: TEXT): STRING;   {��������� ����� �� ������� �� ���������� �������}

IMPLEMENTATION
TYPE
  ReadingState = (Start, Letter, Dash, FoundWord);

CONST
  AvaibleLetters = ['A' .. 'Z', 'a' .. 'z', '�' .. '�', '�' .. '�', '�', '�', '-'];
  EngLetterTransformTable: ARRAY ['A' .. 'Z'] OF CHAR = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
  RusLetterTransformTable: ARRAY ['�' .. '�'] OF CHAR = ('�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�');


{����������� ������ Ch � ��� �������� �������������,
���� �� �������� ��������� ������� ��� ���������� ������}  
FUNCTION CharToLower(Ch: CHAR): CHAR;
BEGIN {CharToLower}
  CASE Ch OF 
    'A' .. 'Z': CharToLower := EngLetterTransformTable[Ch];
    '�' .. '�': CharToLower := RusLetterTransformTable[Ch];
    '�': CharToLower := '�'
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

BEGIN {WordUnit}

END.  {WordUnit}
