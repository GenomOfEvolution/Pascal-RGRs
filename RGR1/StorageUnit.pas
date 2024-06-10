UNIT StorageUnit;
INTERFACE

PROCEDURE InsertWordToStorage(Word: STRING);   {��������� ����� Word � Storage}
PROCEDURE PrintStorageToFile(VAR FOut: TEXT);  {������� ���������� Storage � ���� FOut}
PROCEDURE ClearStorage;                        {��������� ������� Storage}

IMPLEMENTATION
TYPE
  Tree = ^NodeType;
  NodeType = RECORD
               WordCount: INTEGER;
               W: STRING;
               LLink, RLink: Tree
             END;
 
  CompareType = (Bigger, Less, Equal);
 
CONST
  CompareWeightTable: ARRAY ['�' .. '�'] OF INTEGER = (1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33);
  LetterIoWeight = 7; 
 
VAR
  Root: Tree;

FUNCTION GetLetterPos(Ch: CHAR): INTEGER;
BEGIN {GetLetterPos}
  CASE Ch OF
    '�' .. '�': GetLetterPos := CompareWeightTable[Ch];
    '�': GetLetterPos := LetterIoWeight
  ELSE
    GetLetterPos := ORD(Ch)
  END
END; {GetLetterPos}
  
FUNCTION CompareStrings(Str1, Str2: STRING): CompareType;
VAR
  I: INTEGER;
  Compare: CompareType;
BEGIN {CompareStrings}
  I := 1;
  Compare := Equal;
  WHILE (I < LENGTH(Str1)) AND (I < LENGTH(Str2)) AND (Compare = Equal)
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


{��������� ������� ����� W2 � ������� ������ T
������������ �������� ����� �, � ����������� �� ����, ������
��� ������ ������� ��������, ���������� ������� � ����� �����}
PROCEDURE InsertWord(VAR T: Tree; W2: STRING);
BEGIN {InsertWord}
  IF T = NIL
  THEN
    BEGIN
      NEW(T);
      T^.W := W2;
      T^.RLink := NIL;
      T^.LLink := NIL;
      T^.WordCount := 1
    END
  ELSE
    CASE CompareStrings(W2, T^.W) OF
      Equal: T^.WordCount := T^.WordCount + 1;
      Bigger: InsertWord(T^.RLink, W2);
      Less: InsertWord(T^.LLink, W2)
    END
END; {InsertWord}

{����������������� ��������� ������� �����}
PROCEDURE InsertWordToStorage(Word: STRING);
BEGIN {InsertWordToTree}
  InsertWord(Root, Word)
END;  {InsertWordToTree}

{��������� ������ ��������� ������ T, � ���� FOut
����� � ���� FOut � ��������������� �������, ������� � ����� ������}
PROCEDURE PrintTree(T: Tree; VAR FOut: TEXT);
BEGIN {PrintTree}
  IF T <> NIL
  THEN
    BEGIN
      PrintTree(T^.LLink, FOut);
      WRITELN(FOut, T^.W, ' ', T^.WordCount);
      PrintTree(T^.RLink, FOut)
    END
END;  {PrintTree}

{����������������� ��������� ������ ��������� ������}
PROCEDURE PrintStorageToFile(VAR FOut: TEXT);
BEGIN {PrintTreeToFile}
  PrintTree(Root, FOut)
END;  {PrintTreeToFile}

{��������� ������� ��������� ������
����������� ������������ ������ �� ���� ������, ������� � �����}
PROCEDURE ClearTree(VAR T: Tree);
BEGIN {ClearTree}
  IF T <> NIL
  THEN
    BEGIN
      ClearTree(T^.LLink);
      ClearTree(T^.RLink);
      DISPOSE(T)
    END
END;  {ClearTree}

{����������������� ��������� �������}
PROCEDURE ClearStorage;
BEGIN {ClearBinaryTree}
  ClearTree(Root)
END;  {ClearBinaryTree}

BEGIN {BinaryTree}
  Root := NIL
END.  {BinaryTree}
