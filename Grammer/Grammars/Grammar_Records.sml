datatype term
  = ADDOPR
  | IDENT
  | LPAREN
  | MULTOPR
  | RPAREN
  | RECORD
  | COLON
  | SEMICOLON
  | PROGRAM
  | DO
  | ENDPROGRAM
  | FLOWMODE
  | MECHMODE
  | CHANGEMODE
  | COMMA
  | TYPE
  | GLOBAL
  | BOOLOPR
  | RELOPR
  | DOTOPR
  | LITERAL
  | INIT
  | NOT
  | RETURNS
  | FUN
  | ENDFUN
  | PROC
  | ENDPROC
  | LOCAL
  | IF
  | THEN
  | ELSE
  | ENDIF
  | WHILE
  | ENDWHILE
  | CALL
  | BECOMES
  | SKIP
  | DEBUGIN
  | DEBUGOUT

val string_of_term =
  fn ADDOPR     => "ADDOPR"
   | IDENT      => "IDENT"
   | LPAREN     => "LPAREN"
   | MULTOPR    => "MULTOPR"
   | RPAREN     => "RPAREN"
   | RECORD     => "RECORD"
   | COLON      => "COLON"
   | SEMICOLON  => "SEMICOLON"
   | PROGRAM    => "PROGRAM"
   | DO         => "DO"
   | ENDPROGRAM => "ENDPROGRAM"
   | FLOWMODE   => "FLOWMODE"
   | MECHMODE   => "MECHMODE"
   | CHANGEMODE => "CHANGEMODE"
   | COMMA      => "COMMA"
   | TYPE       => "TYPE"
   | GLOBAL     => "GLOBAL"
   | BOOLOPR    => "BOOLOPR"
   | RELOPR     => "RELOPR"
   | DOTOPR     => "DOTOPR"
   | LITERAL    => "LITERAL"
   | INIT       => "INIT"
   | NOT        => "NOT"
   | RETURNS    => "RETURNS"
   | FUN        => "FUN"
   | ENDFUN     => "ENDFUN"
   | PROC       => "PROC"
   | ENDPROC    => "ENDPROC"
   | LOCAL      => "LOCAL"
   | IF         => "IF"
   | THEN       => "THEN"
   | ELSE       => "ELSE"
   | ENDIF      => "ENDIF"
   | WHILE      => "WHILE"
   | ENDWHILE   => "ENDWHILE"
   | CALL       => "CALL"
   | BECOMES    => "BECOMES"
   | SKIP       => "SKIP"
   | DEBUGIN    => "DEBUGIN"
   | DEBUGOUT   => "DEBUGOUT"

datatype nonterm
  = expression
  | factor
  | declarations
  | declaration
  | repeatingOptionalDeclarations
  | recordDeclaration
  | recordFieldList
  | optionalCHANGEMODE
  | optionalFLOWMODE
  | optionalMECHMODE
  | storageDeclaration
  | procedureDeclaration
  | functionDeclaration
  | optionalGlobalImports
  | globalImport
  | repeatingOptionalGlobalImports
  | program
  | progamParameterList
  | optionalProgramParameters
  | blockCmd
  | cmd
  | repeatingOptionalCmds
  | optionalGlobalInits
  | idents
  | repeatingOptionalIdents
  | typedIdent
  | typeDeclaration
  | repeatingOptionalProgramParameters
  | optionalGlobalDeclarations
  | globalDeclaration
  | repeatingOptionalGlobalDeclarations
  | optionalLocalStorageDeclarations
  | repeatingOptionalStorageDeclarations
  | term1
  | repBOOLOPRterm1
  | term2
  | repRELOPRterm2
  | term3
  | repADDOPRterm3
  | term4
  | repMULTOPRterm4
  | repDOTOPRfactor
  | optionalIdent
  | monadicOperator
  | expressionList
  | optionalExpressions
  | repeatingOptionalExpressions
  | parameterList
  | optionalParameters
  | parameter
  | repeatingOptionalParameters
  | recordFieldDeclaration
  | repeatingOptionalRecordFieldDeclarations

val string_of_nonterm =
  fn expression                               => "expression"
   | factor                                   => "factor"
   | declarations                             => "declarations"
   | declaration	                          => "declaration"
   | repeatingOptionalDeclarations            => "repeatingOptionalDeclarations"
   | recordDeclaration                        => "recordDeclaration"
   | recordFieldList	                      => "recordFieldList"
   | optionalCHANGEMODE                       => "optionalCHANGEMODE"
   | optionalFLOWMODE                         => "optionalFLOWMODE"
   | optionalMECHMODE                         => "optionalMECHMODE"
   | storageDeclaration                       => "storageDeclaration"
   | procedureDeclaration                     => "procedureDeclaration"
   | functionDeclaration				      => "functionDeclaration"
   | optionalGlobalImports                    => "optionalGlobalImports"
   | globalImport                             => "globalImport"
   | repeatingOptionalGlobalImports           => "repeatingOptionalGlobalImports"
   | program                                  => "program"
   | progamParameterList                      => "progamParameterList"
   | optionalProgramParameters                => "optionalProgramParameters"
   | blockCmd                                 => "blockCmd"
   | cmd                                      => "cmd"
   | repeatingOptionalCmds                    => "repeatingOptionalCmds"
   | optionalGlobalInits                      => "optionalGlobalInits"
   | idents                                   => "idents"
   | repeatingOptionalIdents                  => "repeatingOptionalIdents"
   | typedIdent                               => "typedIdent"
   | typeDeclaration                          => "typeDeclaration"
   | repeatingOptionalProgramParameters       => "repeatingOptionalProgramParameters"
   | optionalGlobalDeclarations               => "optionalGlobalDeclarations"
   | globalDeclaration                        => "globalDeclaration"
   | repeatingOptionalGlobalDeclarations      => "repeatingOptionalGlobalDeclarations"
   | optionalLocalStorageDeclarations         => "optionalLocalStorageDeclarations"
   | repeatingOptionalStorageDeclarations     => "repeatingOptionalStorageDeclarations"
   | term1                                    => "term1"
   | repBOOLOPRterm1                          => "repBOOLOPRterm1"
   | term2                                    => "term2"
   | repRELOPRterm2                           => "repRELOPRterm2"
   | term3                                    => "term3"
   | repADDOPRterm3                           => "repADDOPRterm3"
   | term4                                    => "term4"
   | repMULTOPRterm4                          => "repMULTOPRterm4"
   | repDOTOPRfactor                          => "repDOTOPRfactor"
   | optionalIdent                            => "optionalIdent"
   | monadicOperator                          => "monadicOperator"
   | expressionList                           => "expressionList"
   | optionalExpressions                      => "optionalExpressions"
   | repeatingOptionalExpressions             => "repeatingOptionalExpressions"
   | parameterList                            => "parameterList"
   | optionalParameters                       => "optionalParameters"
   | parameter                                => "parameter"
   | repeatingOptionalParameters              => "repeatingOptionalParameters"
   | recordFieldDeclaration                   => "recordFieldDeclaration"
   | repeatingOptionalRecordFieldDeclarations => "repeatingOptionalRecordFieldDeclarations"
      

val string_of_gramsym = (string_of_term, string_of_nonterm)

local
  open FixFoxi.FixFoxiCore
in

val productions =
[
(program,
	[[T PROGRAM, T IDENT, N progamParameterList, N optionalGlobalDeclarations, T DO, N blockCmd, T ENDPROGRAM]]),
(blockCmd,
	[[N cmd, N repeatingOptionalCmds]]),
(cmd,
	[[T SKIP],
	 [N expression, T BECOMES, N expression],
	 [T IF, N expression, T THEN, N blockCmd, T ELSE, N blockCmd, T ENDIF],
	 [T WHILE, N expression, T DO, N blockCmd, T ENDWHILE],
	 [T CALL, T IDENT, N expressionList, N optionalGlobalInits],
	 [T DEBUGIN, N expression],
	 [T DEBUGOUT, N expression]]),
(optionalGlobalInits,
	[[],
	 [T INIT, N idents]]),
(idents,
	[[T IDENT, N repeatingOptionalIdents]]),
(repeatingOptionalIdents,
	[[],
	 [T COMMA, T IDENT, N idents]]),
(repeatingOptionalCmds,
	[[],
	 [T SEMICOLON, N cmd, N repeatingOptionalCmds]]),
(declaration,
	[[N storageDeclaration],
	 [N functionDeclaration],
	 [N procedureDeclaration],
	 [N recordDeclaration]]),
(storageDeclaration,
	[[ N optionalCHANGEMODE, N typedIdent ]]),
(recordFieldDeclaration,
	[[ N optionalCHANGEMODE, N typedIdent ]]),
(optionalCHANGEMODE,
	[[],
	 [T CHANGEMODE]]),
(optionalFLOWMODE,
	[[],
	 [T FLOWMODE]]),
(optionalMECHMODE,
	[[],
	 [T MECHMODE]]),
(typedIdent,
	[[T IDENT, T COLON, N typeDeclaration]]),
(typeDeclaration,
	[[T TYPE],
	 [T IDENT]]),
(functionDeclaration,
	[[T FUN, T IDENT, N parameterList, T RETURNS, N storageDeclaration, N optionalGlobalImports, N optionalLocalStorageDeclarations, T DO, N blockCmd, T ENDFUN]]),
(procedureDeclaration,
	[[T PROC, T IDENT, N parameterList, N optionalGlobalImports, N optionalLocalStorageDeclarations, T DO, N blockCmd, T ENDPROC]]),
(optionalGlobalImports,
	[[],
	 [T GLOBAL, N globalImport, N repeatingOptionalGlobalImports]]),
(globalImport,
	[[N optionalFLOWMODE, N optionalCHANGEMODE, T IDENT]]),
(repeatingOptionalGlobalImports,
	[[],
	 [T COMMA, N globalImport, N repeatingOptionalGlobalImports]]),
(progamParameterList,
	[[T LPAREN, N optionalProgramParameters, T RPAREN]]),
(optionalProgramParameters,
	[[],
	 [N optionalFLOWMODE, N optionalCHANGEMODE, N typedIdent, N repeatingOptionalProgramParameters]]),
(repeatingOptionalProgramParameters,
	[[],
	 [T COMMA, N optionalFLOWMODE, N optionalCHANGEMODE, N typedIdent, N repeatingOptionalProgramParameters]]),
(optionalGlobalDeclarations,
	[[],
	 [T GLOBAL, N declarations]]),
(declarations,
	[[N declaration, N repeatingOptionalDeclarations]]),
(repeatingOptionalDeclarations,
	[[],
	 [T SEMICOLON, N declaration, N repeatingOptionalDeclarations]]),
(optionalLocalStorageDeclarations,
	[[],
	 [T LOCAL, N storageDeclaration, N repeatingOptionalStorageDeclarations]]),
(repeatingOptionalStorageDeclarations,
	[[],
	 [T SEMICOLON, N storageDeclaration, N repeatingOptionalStorageDeclarations]]),
(parameterList,
	[[T LPAREN, N optionalParameters, T RPAREN]]),
(optionalParameters,
	[[],
	 [N parameter, N repeatingOptionalParameters]]),
(parameter,
	[[N optionalFLOWMODE, N optionalMECHMODE, N storageDeclaration]]),
(repeatingOptionalParameters,
	[[],
	 [T COMMA, N parameter, N repeatingOptionalParameters]]),
(recordDeclaration,
	[[T RECORD, T IDENT, N recordFieldList]]),
(recordFieldList,
	[[T LPAREN, N storageDeclaration, N repeatingOptionalRecordFieldDeclarations, T RPAREN]]),
(repeatingOptionalRecordFieldDeclarations,
	[[],
	 [T SEMICOLON, N recordFieldDeclaration, N repeatingOptionalRecordFieldDeclarations]]),
(expressionList,
	[[T LPAREN, N optionalExpressions, T RPAREN]]),
(optionalExpressions,
	[[],
	 [N expression, N repeatingOptionalExpressions]]),
(expression,
    [[N term1, N repBOOLOPRterm1]]),
(repeatingOptionalExpressions,
	[[],
	 [T COMMA, N expression, N repeatingOptionalExpressions]]),
(repBOOLOPRterm1,
	[[],
	 [T BOOLOPR, N term1, N repBOOLOPRterm1]]),
(term1,
	[[N term2, N repRELOPRterm2]]),
(repRELOPRterm2,
	[[],
	 [T RELOPR, N term2, N repRELOPRterm2]]),
(term2,
	[[N term3, N repADDOPRterm3]]),
(repADDOPRterm3,
    [[T ADDOPR, N term3, N repADDOPRterm3],
     []]),
(term3,
	[[N term4, N repMULTOPRterm4]]),
(repMULTOPRterm4,
    [[],
	 [T MULTOPR, N term4, N repMULTOPRterm4]]),
(term4,
    [[N factor, N repDOTOPRfactor]]),
(repDOTOPRfactor,
	[[],
	 [T DOTOPR, N factor, N repDOTOPRfactor]]),
(factor,
    [[T LITERAL],
	 [T IDENT, N optionalIdent],
	 [N monadicOperator, N factor],
     [T LPAREN, N expression, T RPAREN]]),
(optionalIdent,
	[[],
	 [T INIT],
	 [N expressionList]]),
(monadicOperator,
	[[T NOT],
	 [T ADDOPR]])
]

val S = program

val result = fix_foxi productions S string_of_gramsym

end (* local *)
