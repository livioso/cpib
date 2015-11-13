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
  | recordFieldList
  | optionalCHANGEMODE
  | optionalMECHMODE
  | storageDeclaration
  | procedureDeclaration
  | functionDeclaration
  | program
  | blockCmd
  | cmd
  | repeatingOptionalCmds
  | typedIdent
  | typeDeclaration
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
  | expressionList
  | optionalExpressions
  | repeatingOptionalExpressions
  | parameterList
  | optionalParameters
  | parameter
  | repeatingOptionalParameters
  | recordFields
  | recordField
  | optionalRecordFields


val string_of_nonterm =
  fn expression                               => "expression"
   | factor                                   => "factor"
   | declarations                             => "declarations"
   | declaration	                            => "declaration"
   | repeatingOptionalDeclarations            => "repeatingOptionalDeclarations"
   | recordFieldList	                        => "recordFieldList"
   | optionalCHANGEMODE                       => "optionalCHANGEMODE"
   | optionalMECHMODE                         => "optionalMECHMODE"
   | storageDeclaration                       => "storageDeclaration"
   | procedureDeclaration                     => "procedureDeclaration"
   | functionDeclaration				              => "functionDeclaration"
   | program                                  => "program"
   | blockCmd                                 => "blockCmd"
   | cmd                                      => "cmd"
   | repeatingOptionalCmds                    => "repeatingOptionalCmds"
   | typedIdent                               => "typedIdent"
   | typeDeclaration                          => "typeDeclaration"
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
   | expressionList                           => "expressionList"
   | optionalExpressions                      => "optionalExpressions"
   | repeatingOptionalExpressions             => "repeatingOptionalExpressions"
   | parameterList                            => "parameterList"
   | optionalParameters                       => "optionalParameters"
   | parameter                                => "parameter"
   | repeatingOptionalParameters              => "repeatingOptionalParameters"
   | recordFields         => "recordFields"
   | recordField          => "recordField"
   | optionalRecordFields => "optionalRecordFields"
      

val string_of_gramsym = (string_of_term, string_of_nonterm)

local
  open FixFoxi.FixFoxiCore
in

val productions =
[
(program,
	[[T PROGRAM, T IDENT, N optionalGlobalDeclarations, T DO, N blockCmd, T ENDPROGRAM]]),

(blockCmd,
	[[N cmd, N repeatingOptionalCmds]]),

(cmd,
	[[T SKIP],
	 [N expression, T BECOMES, N expression],
	 [T IF, N expression, T THEN, N blockCmd, T ELSE, N blockCmd, T ENDIF],
	 [T WHILE, N expression, T DO, N blockCmd, T ENDWHILE],
	 [T CALL, T IDENT, N expressionList],
	 [T DEBUGIN, N expression],
	 [T DEBUGOUT, N expression]]),

(repeatingOptionalCmds,
	[[],
	 [T SEMICOLON, N cmd, N repeatingOptionalCmds]]),

(declaration,
	[[N storageDeclaration],
	 [N functionDeclaration],
	 [N procedureDeclaration]]),

(storageDeclaration,
	[[ N optionalCHANGEMODE, N typedIdent ]]),

(optionalCHANGEMODE,
	[[],
	 [T CHANGEMODE]]),

(optionalMECHMODE,
	[[],
	 [T MECHMODE]]),

(typedIdent,
	[[T IDENT, T COLON, N typeDeclaration]]),

(typeDeclaration,
	[[T TYPE],
	 [T IDENT],
   [T RECORD, N recordFieldList]]),

(functionDeclaration,
	[[T FUN, T IDENT, N parameterList, T RETURNS, N storageDeclaration, N optionalLocalStorageDeclarations, T DO, N blockCmd, T ENDFUN]]),

(procedureDeclaration,
	[[T PROC, T IDENT, N parameterList, N optionalLocalStorageDeclarations, T DO, N blockCmd, T ENDPROC]]),

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
	[[N optionalMECHMODE, N storageDeclaration]]),

(repeatingOptionalParameters,
	[[],
	 [T COMMA, N parameter, N repeatingOptionalParameters]]),

(recordFieldList,
	[[T LPAREN, N recordFields, T RPAREN]]),

(recordFields,
	[[N recordField, N optionalRecordFields]]),

(recordField,
  [[T IDENT, T COLON, T TYPE]]),

(optionalRecordFields,
  [[],
   [T COMMA, N recordField, N optionalRecordFields]]),

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
     [T LPAREN, N expression, T RPAREN]]),

(optionalIdent,
	[[],
	 [T INIT],
	 [N expressionList]])

]

val S = program

val result = fix_foxi productions S string_of_gramsym

end (* local *)
