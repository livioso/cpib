### Records in IML, Compilerbau HS 2015, Team BB
*Team: Livio Bieri, Raphael Brunner*

#### Beschreibung der Erweiterung
Die Erweiterung soll sogenannte **Records** (auch bekannt als *struct* oder *compound data*)[^1] zur Verfügung stellen:

`record example(var x: int32, var u: boolean)`

- Die Felder können vom Datentyp `boolean` oder `int32` sein.

- Die Felder *(Identifier)* müssen eindeutig sein. Das folgende Beispiel ist daher nicht gültig, da der Identifier `x` nicht eindeutig ist: `record example(var x: int32, var x: boolean)`.

- Die Felder verhalten sich wie Variablen (`CHANGEMODE, VAR`), d.h. es gibt _keine_ Möglichkeit Felder konstant zu machen.

- Die Definition des Records muss 

#### Beispiel
```javascript
program prog()
global
	record point(var x: int32, var y: int32);
	record student(var id: int32, var grade: int32);
	
	var position: point;
	var seppblatter: student;
do
	//debugin v1.x init;
	//debugin v2.x init;
	//c init := 1;
	//while c < 5 do
	//	v1.x := v1.x + 1;
	//	c := c + 1
	//endwhile;
	//if v1.x < 10 then
	//	debugout v1.x
	//else
	//	debugout v2.x
	//endif
endprogram
```

#### Compilezeit Uberprüfungen

##### Eindeutigkeit des Record Identifier
Die Definition eines Records muss eindeutig sein:

``` javascript
record vector(var x: int32, var y: int32)
...
record vector(var x: int32, var y: int32, var z: int32)
       ^^^^^^
```

##### Eindeutigkeit der Record Felder Identifier
Die Definition eines Record Felder muss eindeutig sein:

``` javascript
record vector(var x: int32, var x: int32)
                                ^
```

##### Operationen auf Record möglich?

##### Typenchecking (bool assign to integer or such)

##### Zugriff auf undefiniert Felder


#### Kontext und Typeinschränkung

#### Vergleich mit anderen Sprachen

#### Entscheidungen

##### Syntax

##### Grammatik

#### Syntax: Lexikalisch

#### Syntax: Grammatikalisch


[^1]: https://en.wikipedia.org/wiki/Record_(computer_science)
