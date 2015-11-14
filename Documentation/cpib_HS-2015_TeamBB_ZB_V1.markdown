## Records in IML
**Compilerbau HS 2015, Team BB**   
*Team: Livio Bieri, Raphael Brunner*  

***Zwischenbericht 1***

### Abstract
Zwischenbericht im Modul Compilerbau. Das Dokument beschreibt die Erweiterung **Records in IML** die wir im Rahmen des Moduls vornehmen.

### Beschreibung der Erweiterung
Die Erweiterung soll sogenannte **Records** (auch bekannt als *struct* oder *compound data*)[^1] zur Verfügung stellen. Ein Record soll dabei als neuer Datentyp zur Verfügung stehen. Er soll beliebig viele Felder beinhalten können. Felder können vom Datentyp Integer oder Boolean sein. Definierte Records sind im ganzen Programm verfügbar *(in global zu definieren).*

Eine **Deklaration** in IML sieht wie folgt aus:

- `var example: record(x: int64, b: boolean)`

Der **Zugriff** ist wie folgt möglich:

- `debugout example.x`

- Die Felder können vom Datentyp `boolean` oder `int64` sein. *Nested Records sind nicht möglich.*

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
- Falls nicht angegeben, wird `var` verwendet.

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
data vector = vector ( 
	x..Int,	y..Int,	z..Int)
```

Initialisierung:

```haskell
v1 = vector 5 6 7
```

### Pascal
Deklaration:

```pascal
type TVector = record
	x : Integer ;	y : Integer ;	z : Integer ;
end ;
```

Initialisierung:

```pascal
var	v1 : TVector
begin
	v1.x := 42;
	v1.y := 50;
	v1.z := 20;
end ;
```

### C
Deklaration:

```c
struct vector {
	int x;
	int y;
	int z;
};
```

Initialisierung:

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
- Unsere Implementation orientiert sich an der Pascal Implementation.
- Wir fanden eine einfache Initialisierung wichtig *(in einer Zeile).*

## Lexikalische und Grammatikalische Syntax
Unser Ziel ist es, das Record ähnlich wie die anderen Variabeln in IML zu behandeln. Daher wird die Initialisierung eines Records analog zur Initialisierung der Standardvariabeln stattfinden.

Die Grundgrammatik-Idee eines Records für die Initialisierung:

```javascript
recordDeclaration   ::=optional CHANGEMOD IDENT COLON RECORD recordFieldList
recordFieldList     ::= LPAREN recordFields RPAREN
recordFields        ::= recordField optionalRecordField
recordField         ::= IDENT COLON TYPE
optionalRecordField ::= COMMA recordField optionalRecordField | ε
optionalCHANGEMODE  ::= CHANGEMODE | ε
```

Um nun ein Record in der Grammatik mit dem Rest unserer Programmiersprache zu verwenden, müssen wir die Produktion `recordDeclaration` anders angehen, da wir sonst einen Konflikt mit der Produktion `storageDeclaration`erhalten.

Initialisierung eingebunden in `storageDeclaration`:

```javascript
storageDeclaration  ::= optionalCHANGEMOD typeIdent
typeIdent           ::= IDENT COLON typeDeclaration
typeDeclaration     ::= TYPE | RECORD recordFieldList
recordFieldList     ::= LPAREN recordFields RPAREN
recordFields        ::= recordField optionalRecordField
recordField         ::= IDENT COLON TYPE
optionalRecordField ::= COMMA recordField optionalRecordField | ε
optionalCHANGEMODE  ::= CHANGEMODE | ε
```
`storageDeclaration` wird im globalen Raum deklariert und somit werden Records gleich wie die normalen Variabeln behandelt. Sie sind jedoch kein eigener TYPE und haben einen eigenen RECORD Token.

Nun möchten wir die Records in einer einzigen Zeile initialisieren, um Zugriffe auf undefined values von einem Record zu vermeiden.
Die Grammatik würde etwa so aussehen:

```javascript
recordInit         ::= IDENT LPAREN recordInit RPAREN
recordInit         ::= IDENT INIT BECOMES LITERAL optinalRecordInit
optionalRecordInit ::= COMMA recordInit | ε
```

Hier haben wir jedoch noch einen Konflikt, da der Grammatikteil in den `cmd` Teil eingefügt werden soll, und da die Expressions auch mit IDENT beginnen können. Das Problem konnten wir bisher noch nicht lösen. Eventuell müssen wir es auch als Expression definieren.

```javascript
//undefined so far
```

Zugriffe auf die Werte in einem Record sollen in die Expression Grammatik eingefügt werden, damit wir uns nicht separat mit den Problemen wie `Debugin` oder `Debugout` beschäftigen müssen.

```javascript
expression                   ::= term1 BOOLOPRterm1
BOOLOPRterm1                 ::= BOOLOPR term1 BOOLOPRterm1 | ε
term1                        ::= term 2 RELOPRterm2
RELOPRterm2                  ::= RELOPR term2 RELOPRterm2 | ε
term2                        ::= term3 ADDOPRterm3
ADDOPRterm3                  ::= ADDOPR term3 ADDOPRterm3 | ε
term3                        ::= term4 MULTOPRterm4
MULTOPRterm4                 ::= MULTOPR term4 MULTOPRterm4 | ε
term4                        ::= factor DOTOPRfactor
DOTOPRfactor                 ::= DOTOPR factor | ε
factor                       ::= LITERAL | IDENT optionalIInitFuncSpec | LPAREN expression RPAREN
optionalIInitFuncSpec        ::= INIT | expressionList | ε
expressionList               ::= LPAREN optionalExpressions RPAREN
optionalExpressions          ::= expression repeatingOptionalExpressions | ε
repeatingOptionalExpressions ::= COMMA expression repeatingOptionalExpressions | ε
```

Eine eher unwichtige Frage, die wir haben, ist die Verwendung von `COMMA`oder `SEMICOLON` für die Trennung der einzelnen Felder in einem Record, da Kommas bei anderen Programmiersprachen üblich sind, hingegen Semicolon sonst in IML auch als "und" zwischen zwei Commands interpretiert wird.

## Sonstiges

- Sourcecode & Dokumentation: https://github.com/livioso/cpib
- Arbeitsteilung: Wir haben die Arbeiten wie folgt im Team verteilt. *Bieri: Scanner, Zwischenbericht* / *Brunner: Grammatik (SML), Zwischenbericht*. 

[^1]: https://en.wikipedia.org/wiki/Record_(computer_science)
