## Records in IML
### Compilerbau HS 2015, Team BB
*Team: Livio Bieri, Raphael Brunner*

#### Beschreibung der Erweiterung
Die Erweiterung soll sogenannte **Records** (auch bekannt als *struct* oder *compound data*)[^1] zur Verfügung stellen:

Eine **Deklaration** in IML sieht wie folgt aus:

- `var example: record(x: int64, b: boolean)`

Der **Zugriff** ist wie folgt möglich:

- `debugout example.x`

- Die Felder können vom Datentyp `boolean` oder `int64` sein. *Nested Records sind nicht möglich.*

#### Beispiel
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

#### Funktionalität und Typeinschränkung

##### Deklaration des Record in `global`
Die Deklaration eines Records muss im `global` vorgenommen werden:

``` javascript
...
global
	var position: record(x: int64, y: int64);
	const professor: record(id: int64, level: int64)
do
...
```

##### Eindeutigkeit des Record Identifier
Die Deklaration (der *Identifier*) eines Records muss eindeutig sein:

``` javascript
var position: record(x: int64 y: int64);
const position: record(z: int64, u: int64) // Fehler
      ^^^^^^^^
```

##### Eindeutigkeit der Record Felder Identifier
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

##### Operationen auf Record

``` javascript
var positionXY: record(x: int64, y: int64);
var student: record(id: int64, isGoodStudent: bool)
...

position.x := student.isGoodStudent + 1 // Fehler
              ^^^^^^^^^^^^^^^^^^^^^^^^^              
```

##### Typenchecking (`bool`, `int64`)
``` javascript
var point: record(x: int64, y: int64);

point.x := true; // Fehler
           ^^^^                        
```

##### Zugriff auf undefiniert Felder
``` javascript
var point: record(x: int64, y: int64);

point.z = 42; // Fehler
      ^  
```

##### Unterstützung von `CHANGEMODE` in Records
Records unterstützen `CHANGEMODE` (`var`, `const`):

- `CHANGEMODE` ist optional.
- Falls nicht angegeben wird `var` verwendet.

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

##### Operationen auf Records:
Records selbst haben _keine Operationen_. *Folgendes ist also nicht möglich / wird nicht unterstützt:*

``` javascript
pointZero: record(var x: int64, var y: int64);
pointOne: record(var x: int64, var y: int64)
...

pointZero = pointZero + pointOne // Fehler
                      ^
```

#### Vergleich mit anderen Sprachen

##### Haskell

Deklaration:

```haskell
data vector = vector ( 
	x .. Int,	y .. Int,	z..Int)
```

Initialisierung:

```haskell
v1 = vector 5 6 7
```

##### Pascal
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

##### C
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

**Einfluss auf unsere Lösung**:

- Unsere Implementation orientiert sich an der Pascal Implementation.
- Ziel: IML-ähnliche Syntax beibehalten.

#### Grammatik
```javascript
!!!
```

#### Sonstiges

- Sourcecode & Dokumentation: https://github.com/livioso/cpib

[^1]: https://en.wikipedia.org/wiki/Record_(computer_science)
