## Records in IML
**Compilerbau HS 2015, Team BB**   
*Team: Livio Bieri, Raphael Brunner*  

***Schlussbericht vom 09.01.2015***

### Abstract
Die Erweiterung **Records in IML** wurden als eigener Typ `record` umgesetzt.  
*Der Compiler ist in [Swift](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html#//apple_ref/doc/uid/TP40014097-CH2-ID1) geschrieben. Den Sourcecode findet man auf [Github](https://github.com/livioso/cpib).*

### Beschreibung der Erweiterung
Die Erweiterung soll sogenannte **Records** (auch bekannt als *struct* oder *compound data*)[^1] zur Verfügung stellen. Ein Record soll dabei als neuer Datentyp zur Verfügung stehen. Er soll beliebig viele Felder beinhalten können *(mindestens jedoch eins)*. Felder können vom Datentyp Integer, Boolean oder Record sein. ~~RFC! Deklarierte Records sind im ganzen Programm verfügbar *(in global zu definieren).*~~

Eine **Deklaration** in IML sieht wie folgt aus:

- `var example: record(x: int64, b: boolean)`

Der **Zugriff** ist wie folgt möglich:

- `debugout example.x`

- Die Felder können vom Datentyp `boolean`, `int64` oder `record` sein. *Nested Records sind möglich. Es gibt keine Limitierung der Tiefe des Nestlings.*

\pagebreak

### Beispiel
```javascript
program prog
global
	var position: record(x: int64, y: int64);
	const professor: record(id: int64, level: int64)
do
	// all fields must be initialised!
	position(x init := 4, y init := 5);
	professor(id init := 1007, level: 19);
	
	// fields can be changed
	debugin position.y;
	position.x := 42;
	
	// field 'id' is const => can not be changed
	// professor.id := 423;
	
	offsetInY init := 5;
	position.y := position.y + offsetInY
	
endprogram
```

## Funktionalität und Typeinschränkung

### Deklaration des Record in `global`
Die Deklaration eines Records muss im `global` vorgenommen werden:

``` javascript
...
global
	var position: record(x: int64, y: int64);
	const professor: record(id: int64, level: int64)
do
...
```

### Eindeutigkeit des Record Identifier
Die Deklaration (der *Identifier*) eines Records muss eindeutig sein:

``` javascript
var position: record(x: int64, y: int64);
const position: record(z: int64, u: int64) // Fehler
      ^^^^^^^^
```

Zu beachten ist, dass dies aber natürlich generell gilt:

``` javascript
var position: int64;
var position: record(x: int64, y: int64);
```

### Eindeutigkeit der Record Felder Identifier
Die Deklaration eines Record Felds muss eindeutig sein:

``` javascript
var position: record(x: int64, x: int64) // Fehler
                               ^
```
*Felder Eindeutigkeit muss aber _nur innerhalb_ eines Records gegeben sein:*

``` javascript
var positionXY: record(x: int64, y: int64);
var positionXYZ: record(x: int64, y: int64, z: int64)                                 
```

### Typenchecking (`bool`, `int64`)
Der zugewiesene Wert muss vom Typ sein, der in der Deklaration angegeben wurde (`bool` oder `int64`):

``` javascript
var point: record(x: int64, y: int64);

point.x := true; // Fehler
           ^^^^                        
```

### Zugriff auf undefinierte Felder
Der Zugriff auf Felder, die nicht definiert wurden, ist nicht möglich:

``` javascript
var point: record(x: int64, y: int64);

point.z = 42; // Fehler
      ^  
```

\pagebreak

### Unterstützung von `CHANGEMODE` in Records
Records unterstützen `CHANGEMODE` (`var`, `const`):

- `CHANGEMODE` ist optional.
- Falls nicht angegeben, wird `const` verwendet.

``` javascript
point: record(x: int64, y: int64)
```

Wird interpretiert als:

``` javascript
var point: record(x: int64, y: int64)
```

Felder unterstützen _kein_ `CHANGEMODE`:

``` javascript
point: record(const x: int64, y: int64) // Fehler
              ^^^^^
```

### Operationen auf Records:
Records selbst haben _keine Operationen_. *Folgendes ist also nicht möglich / wird nicht unterstützt:*

``` javascript
pointZero: record(var x: int64, var y: int64);
pointOne: record(var x: int64, var y: int64)
...

pointZero = pointZero + pointOne // Fehler
                      ^
```

\pagebreak

## Vergleich mit anderen Sprachen
*Wir haben uns unterschiedliche Lösungsansätze angeschaut. Dazu haben wir uns vor allem angeschaut, was andere Sprachen konkret machen:*

### Haskell
Deklaration:

```haskell
data vector = vector { 
	x::Int,	y::Int,	z::Int}
```

*Value Constructor (Function)*

```haskell
v1 = vector 5 6 7
```

### Pascal
Deklaration eines Types `TVector`:

```pascal
type TVector = record
	x : Integer ;	y : Integer ;	z : Integer ;
end ;
```

Initialisierung einer Variable vom Type `TVector`:

```pascal
var	v1 : TVector
begin
	v1.x := 42;
	v1.y := 50;
	v1.z := 20;
end ;
```

### C
Deklaration eines `struct` `vector`:

```c
struct vector {
	int x;
	int y;
	int z;
};
```

Initialisierung einer Variable vom Type `vector`:

```c
vector v1;
v1.x = 42;
v1.y = 50;
v1.z = 20;
```

### IML
Deklaration:

```javascript
var v1: record(x: int64, y: int64, z: int64)
```

Initialisierung:

```javascript
v1(x init := 42, y init := 42, z init := 42)
```

**Einfluss auf unsere Lösung**:

- Unser Ziel war es eine IML-ähnliche Syntax beizubehalten.
- Unsere Spezifikation orientiert sich lose an der Pascal Spezifikation.
- Wir fanden eine einfache Initialisierung wichtig *(in einem Kommando).*

\pagebreak

## Lexikalische und grammatikalische Syntax
- Unser Ziel ist es, das Record ähnlich wie die anderen Variablen in IML zu behandeln. 
- Daher wird die Initialisierung eines Records analog zur Initialisierung der Variablen stattfinden.

Die Grundgrammatik-Idee eines Records für die Initialisierung:

```
Im Folgenden gilt:  Esp = Epsilon
```

```haskell
recordDeclaration   ::= optional CHANGEMOD IDENT COLON
                        RECORD recordFieldList
recordFieldList     ::= LPAREN recordFields RPAREN
recordFields        ::= recordField optionalRecordField
recordField         ::= IDENT COLON TYPE
optionalRecordField ::= COMMA recordField 
                        optionalRecordField | Eps
optionalCHANGEMODE  ::= CHANGEMODE | Eps
```

*Um nun ein Record in der Grammatik mit dem Rest unserer Programmiersprache zu verwenden, müssen wir die Produktion `recordDeclaration` anders angehen, da wir sonst einen Konflikt mit der Produktion `storageDeclaration`erhalten.*

Initialisierung eingebunden in `storageDeclaration`:

```haskell
storageDeclaration  ::= optionalCHANGEMOD typeIdent
typeIdent           ::= IDENT COLON typeDeclaration
typeDeclaration     ::= TYPE | RECORD recordFieldList
recordFieldList     ::= LPAREN recordFields RPAREN
recordFields        ::= recordField optionalRecordField
recordField         ::= IDENT COLON TYPE
optionalRecordField ::= COMMA recordField 
                        optionalRecordField | Eps
optionalCHANGEMODE  ::= CHANGEMODE | Eps
```
*`storageDeclaration` wird im globalen Raum deklariert und somit werden Records gleich wie die normalen Variabeln behandelt. Sie sind jedoch kein eigener TYPE und haben einen eigenen RECORD Token.*

*Nun möchten wir die Records in einer einzigen Zeile initialisieren, um Zugriffe auf undefined values von einem Record zu vermeiden.*

Die Grammatik würde etwa so aussehen:

```javascript
recordInit         ::= IDENT LPAREN recordInit RPAREN
recordInit         ::= IDENT INIT BECOMES 
                       LITERAL optinalRecordInit
optionalRecordInit ::= COMMA recordInit | Eps
```

*Hier haben wir jedoch noch einen Konflikt, da der Grammatikteil in den `cmd` Teil eingefügt werden soll, und da die Expressions auch mit IDENT beginnen können. Das Problem konnten wir bisher noch nicht lösen. Eventuell müssen wir es auch als Expression definieren.*

```javascript
recordInitialisation     ::= IDENT LPAREN 
                             recordInitialisationList RPAREN
recordInitialisationList ::= recordInit optionalRecordInit
recordInit               ::= IDENT INIT BECOMES factor
optionalRecordInit       ::= COMMA recordInit 
                             optionalRecordInit | Eps
```

*Zugriffe auf die Werte in einem Record sollen in die Expression Grammatik eingefügt werden, damit wir uns nicht separat mit den Problemen wie `Debugin` oder `Debugout` beschäftigen müssen.*

```javascript
expression                   ::= term1 BOOLOPRterm1
BOOLOPRterm1                 ::= BOOLOPR term1 BOOLOPRterm1 | Eps
term1                        ::= term 2 RELOPRterm2
RELOPRterm2                  ::= RELOPR term2 RELOPRterm2 | Eps
term2                        ::= term3 ADDOPRterm3
ADDOPRterm3                  ::= ADDOPR term3 ADDOPRterm3 | Eps
term3                        ::= term4 MULTOPRterm4
MULTOPRterm4                 ::= MULTOPR term4 MULTOPRterm4 | Eps
term4                        ::= factor DOTOPRfactor
DOTOPRfactor                 ::= DOTOPR factor | Eps
factor                       ::= LITERAL 
                                 | IDENT optionalIInitFuncSpec  
                                 | LPAREN expression RPAREN
optionalIInitFuncSpec        ::= INIT | expressionList | Eps
expressionList               ::= LPAREN optionalExpressions RPAREN
optionalExpressions          ::= expression 
                                 repeatingOptionalExpressions | Eps
repeatingOptionalExpressions ::= COMMA expression 
                                 repeatingOptionalExpressions | Eps
```

\pagebreak

## Compiler
*Wir haben unseren IML Compiler in [Swift](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/GuidedTour.html#//apple_ref/doc/uid/TP40014097-CH2-ID1) programmiert. Insgesamt waren wir sehr zufrieden mit unserer Entscheidung. Vor allem das Konzept der Optionals / bzw. des [Optional Chaining](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/OptionalChaining.html) aber auch Pattern Matching stellte sich als äusserst praktisch heraus. Einzig die Anbindung an die Virtuelle Maschine gestaltete sich schwierig (da in Java).*

### Scanner

Grundsätzlich war die nötige Erweiterung für Records im Scanner sehr einfach. Es musste lediglich ein neues 'Keyword' definiert werden in `keywords.swift`. Es handelt sich dabei um einen `Type`.

```haskell
...
"record": Token(
	terminal: 
		Terminal.TYPE,
	attribute: 
		Token.Attribute.Type(Token.TypeIdentifier.RECORD)
),
...
```

### CST

Die Erweiterung im CST war hauptsächlich, dass die `Typedeclaration` um ein optionales Feld `optionalRecordDecl` erweitert wurde, welches falls es sich um Record handelt (anhand des `type` erkennbar) dieses Feld gesetzt hat.

```haskell
	class TypeDeclaration: ASTConvertible {
		let type : Token.Attribute
		let optionalRecordDecl : OptionalRecordDeclaration?
		...
	}
```

Der Record selbst enthält dann die RecordFields:

```	haskell
	class RecordDecl: ASTConvertible {
		let storageDeclartion: StorageDeclaraction
		let repeatingRecordFields: RepeatingRecordFields?
		...
	}
```
	
### AST

Beim AST verhält es sich ähnlich wie beim CST, da wurde lediglich das RecordDecl weg reduziert:

```haskell
	class DeclarationStore: Declaration {
		let changeMode: ChangeMode?
		let typedIdent: TypeDeclaration
		let nextDecl: Declaration?
		...
```

```haskell
	class TypeDeclaration: Declaration {
        let ident: String
        let type: Token.Attribute
        let optionalRecordDecl: DeclarationStore?
        ...
```
Wir bauen dann die Record Felder rekursiv über DeclarationStore auf, da TypeDeclaration auch ein Kind von DeclarationStore ist, kann man so theoretisch beliebig viele nested Records in Records deklarieren.
### Checker
Beim Context check mussten wir für die Records einige Ausnahmen bilden. Mit dem eingeführtem Dot-Operator müssen wir ebenfalls speziel verfahren im Gegensatz zu den standart Operatoren:

```haskell
class DyadicExpr: AST.Expression {
func check(side:Side) throws -> (ValueType, ExpressionType) {
...
if(typeL == ValueType.RECORD) {
	if(oldScope != nil) {
		AST.scope = oldScope?.recordTable[(expression as! StoreExpr).identifier]!.scope
	} else {
		AST.scope = AST.globalRecordTable[(expression as! StoreExpr).identifier]!.scope
	}
}
if let r = term as? StoreExpr {
	if(typeL == ValueType.RECORD && side == Side.LEFT) {
		checkR = try! r.check(.LEFT)
	} else {
		checkR = try! r.check(.RIGHT)
	}
} else if let r = term as? DyadicExpr {
	checkR = try! r.check(.RIGHT)
} else {
	checkR = try! term.check()
}
...
case .DotOperator:
	valueSide = .L_Value
	if(typeL == ValueType.RECORD){
		let lhs = expression as! StoreExpr
		let rhs = term as! StoreExpr
		
		let leftIdent: String = lhs.identifier
		let rightIdent: String = rhs.identifier
		
		let identifier: String = leftIdent + "." + rightIdent
		
		if(AST.scope != nil){
			guard let type = AST.scope!.storeTable[identifier]?.type else {
				throw ContextError.SomethingWentWrong
			}
			expressionType = type
		} else {
			guard let type = AST.globalStoreTable[identifier]?.type else {
				throw ContextError.SomethingWentWrong
			}
			expressionType = type
		}
	} else {
		throw ContextError.TypeErrorInOperator
	}
case _:
	throw ContextError.SomethingWentWrong
}
...
```
Hier setzen wir dann die linke und rechte Seite vom operator zu einem neuen Identifier zusammen, der jeweils die Seiten mit einem "." trennt. Da Punkte in der normalen Namen nicht erlaubt sind, müssen wir so keine Kollisionen mit anderen Identifier rechnen. Auch müssen wir ein init auf der Rechten Seite eines Operators zulassen, da die Syntax folgendes unterstützen muss: `recordName.recordField init := 4`  
Bei der `StoreExpr`müssen wir darauf achten, dass der Recordidentifier nicht direkt initializiert werden kann, sondern dass dies nur mit seinen Feldern geht:

```haskell
class StoreExpr: Expression {
...
func check(side:Side) throws -> (ValueType, ExpressionType) {
...
if(initToken != nil) {
	if(side == Side.RIGHT){
		throw ContextError.InitialisationInTheRightSide
	}
	if(expressionType == ValueType.RECORD) {
		throw ContextError.RecordCanNotBeInitializedDirectly
	}
	if(store.initialized) {
		throw ContextError.IdentifierAlreadyInitialized
	}
	store.initialized = true
} else if(side == Side.LEFT && !store.initialized && expressionType != ValueType.RECORD){
	throw ContextError.IdentifierNotInitialized
} else if(side == Side.LEFT && store.isConst) {
	throw ContextError.NotWriteable
} else if(side == Side.RIGHT && !store.initialized) {
	throw ContextError.IdentifierNotInitialized
}
...
```

Weiter unterscheiden wir in `DeclarationStore` ob es sich um ein Record oder nicht handelt. Falls es ein Record ist, Erstellen wir einen Record im Context und prüfen alle Felder über deren Type nach und speichern die entsprechend in aktuellen Scope ab, dabei wird wieder der identifier mit Feld und Record namen gebildet:

```haskell
if(type == ValueType.RECORD){
	let record = Record(ident: typedIdent.ident)
	let recordStore = Store(ident: record.ident, type: type, isConst: isConst)
	recordStore.initialized = true
	
	var decl:DeclarationStore? = typedIdent.optionalRecordDecl!
	
	if(AST.scope != nil){
		let check = AST.scope!.recordTable[record.ident]
		if(check != nil) {
			throw ContextError.IdentifierAlreadyDeclared
		} else {
			AST.scope!.recordTable[record.ident] = record
			AST.scope!.storeTable[record.ident] = recordStore
		}
	} else {
		let check = AST.globalRecordTable[record.ident]
		if(check != nil) {
			throw ContextError.IdentifierAlreadyDeclared
		} else {
			AST.globalRecordTable[record.ident] = record
			AST.globalStoreTable[record.ident] = recordStore
		}
	}
	while(decl != nil){
		let store:Store = try! decl!.check()
		
		record.scope.storeTable[store.ident] = Store(ident: store.ident, type: store.type, isConst: store.isConst)
		store.ident = recordStore.ident + "." + store.ident
		
		if(isConst && store.isConst != isConst){
			throw ContextError.RecordIsConstButNotTheirFields
		}
		if(AST.scope != nil){
			let check = AST.scope!.storeTable[store.ident]
			if(check != nil) {
				throw ContextError.IdentifierAlreadyDeclared
			} else {
				AST.scope!.storeTable[store.ident] = store
				record.recordFields[store.ident] = store
			}
		} else {
			let check = AST.globalStoreTable[store.ident]
			if(check != nil) {
				throw ContextError.IdentifierAlreadyDeclared
			} else {
				AST.globalStoreTable[store.ident] = store
				record.recordFields[store.ident] = store
			}
		}
		store.adress = AST.allocBlock++
		print("alloc: \(store.ident), adress: \(store.adress)")
		
		decl = decl!.nextDecl as? AST.DeclarationStore
	}
...
```

### Codegeneration

### Virtualmachine
Da wir nicht direkt von Swift mit unserer Virtuellen Machine kommunizieren können, haben wir ein kleines CLI Interface programmiert, welches uns erlaubt die Virtuelle Maschine (das `CodeArray`) via `System.in` zu steuern. Das sieht dann etwa so aus:

```javascript
# pipes code generated by compiler to vm
cat code.intermediate | java virtualmachine

```

Wobei der Code in `code.intermediate` wie folgt vorliegt:

```javascript
...
2, AllocBlock 4,
3, LoadImInt 0,
4, InputInt m,
...
```

Siehe auch:

- `VirtualMachine/src/Machine.java`, *CLI Interface*
- `VirtualMachine/src/vm/CodeArray.java`, `fromSystemIn(...)`

### Offene Punkte
Die folgenden Punkte konnten wir bis zur Abgabe leider nicht komplett lösen:

- Nested Records konnte leider nicht implementiert werden.

## Appendix

- **Sourcecode & Dokumentation: https://github.com/livioso/cpib**
- *Arbeitsteilung: Wir haben die Arbeiten wie folgt im Team verteilt.* *Bieri: Scanner, Zwischenbericht, CST, AST, VM, Schlussbericht* / *Brunner: Grammatik (SML), Zwischenbericht, AST, Checker, Codegeneration*. 

[^1]: https://en.wikipedia.org/wiki/Record_(computer_science)

## Feedback Sonstiges

- v1 := v2: Möglich?
- v1.y := v1.x + 5?

## Ehrlichkeitserklärung

*Hiermit erklären wir, dass wir die vorliegenden Bericht und den Compiler selbständig verfasst bzw. programmiert haben. Wir haben die Grundstruktur der Grammatik (sml) von einer Gruppe (Manuel Jenny) aus dem letzen Jahr verwendet und entsprechend angepasst (Records Grammatik hinzugefügt). Eine sonstige Zusammenarbeit mit anderen Teams fand nicht statt.*

*Ort / Datum / Unterschrift*

\bigskip
\bigskip

*Livio Bieri*

\bigskip
\bigskip

*Raphael Brunner*