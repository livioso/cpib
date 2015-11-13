### Grammar Notes

*Bootstrapping the grammar for IML records:*

First we need to add the following `T` and `NT` Symbols:

	// RECORD => "record"
	datatype term =
		...
		| RECORD
		
	datatype nonTerm = 
		...
		| recordField
		| optRecordFields
		
Where `recordField` is the very first mandatory field and `optRecordField` is the list of more optional `recordField` (separated by `T COMMA`).

	recordDeclarations := 
		[N optCHANGEMODE, T IDENT, T COLON, 
		 T RECORD,  N recordlist]
		 
	recordList   
		 
	
		 
	
	
		