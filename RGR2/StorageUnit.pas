UNIT StorageUnit;
INTERFACE
USES
  WordUnit, MergeUnit;
  
PROCEDURE InsertWordToStorage(Word: STRING);   {Вставляет слово Word в Storage}
PROCEDURE PrintStorageToFile(VAR FOut: TEXT);  {Печатет содержиоме Storage в файл FOut}
PROCEDURE ClearStorage;                        {Полностью очищает Storage}

IMPLEMENTATION
CONST
  UniqueWordsToMerge = 10000;

TYPE
  Tree = ^NodeType;
  NodeType = RECORD
               WordCount: INTEGER;
               W: STRING;
               LLink, RLink: Tree
             END;

VAR
  Root: Tree;
  UniqueWordsRead: INTEGER;
  StorageFile: TEXT;


PROCEDURE ClearTree(VAR T: Tree);
BEGIN {ClearTree}
  IF T <> NIL
  THEN
    BEGIN
      ClearTree(T^.LLink);
      ClearTree(T^.RLink);
      DISPOSE(T)
    END;
  T := NIL
END;  {ClearTree}


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


PROCEDURE MergeTreeWithFile;
VAR
  F1, F2: TEXT;
BEGIN
  REWRITE(F1);
  PrintTree(Root, F1);
  ClearTree(Root);
  CopyFile(StorageFile, F2);
  MergeFiles(F1, F2, StorageFile)
END;

PROCEDURE InsertWord(VAR T: Tree; W2: STRING);
BEGIN {InsertWord}
  IF T = NIL
  THEN
    BEGIN
      NEW(T);
      T^.W := W2;
      T^.RLink := NIL;
      T^.LLink := NIL;
      T^.WordCount := 1;
      
      UniqueWordsRead := UniqueWordsRead + 1;
      IF UniqueWordsRead = UniqueWordsToMerge
      THEN
        BEGIN
          UniqueWordsRead := 0;
          MergeTreeWithFile
        END
    END
  ELSE
    CASE CompareStrings(W2, T^.W) OF
      Equal: T^.WordCount := T^.WordCount + 1;
      Bigger: InsertWord(T^.RLink, W2);
      Less: InsertWord(T^.LLink, W2)
    END
END; {InsertWord}


PROCEDURE InsertWordToStorage(Word: STRING);
BEGIN {InsertWordToTree}
  InsertWord(Root, Word)
END;  {InsertWordToTree}

PROCEDURE PrintStorageToFile(VAR FOut: TEXT);
BEGIN {PrintTreeToFile}
  IF Root <> NIL
  THEN
    BEGIN
      MergeTreeWithFile;
      ClearTree(Root)
    END;
  CopyFile(StorageFile, FOut)
END;  {PrintTreeToFile}

PROCEDURE ClearStorage;
BEGIN {ClearBinaryTree}
  UniqueWordsRead := 0;
  REWRITE(StorageFile);
  ClearTree(Root)
END;  {ClearBinaryTree}

BEGIN {BinaryTree}
  
  ClearStorage
END.  {BinaryTree}
