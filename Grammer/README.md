#Readme Grammar

###Installation SML
  
    $ brew install smlnj

###Use SML
Navigate to the src folder and start SML:

    $ sml

To use FixFoxi you have to use the "useNew.sml" file

    $ use "useNew.sml";

Then you need to navigate to the folder where your grammar skript is

    $ OS.FileSys.chDir "../Grammars";

After that you can use your grammar skript

    $ use „Grammar_Skript_Name.sml";

###FixFoxi usage

When your Grammar is loaded your result is saved in the result variable.
With this result, you can now generate different outputs:  

**Help:**

    $ ?();

This displays all possible commands.

**Diagnosis:**

    $ dispDiagnosis result;

This command is for checking if your grammar is okey. The output `val ist = () : unit` means everything is okey. Otherwise you see where the failures are.

**FIRST:**

    $ dispFIRST result;

This shows you the FIRST table of your Grammar. It also works with NULLABLE and FOLLOW the same way.

**Parstable:**

    $ dispMM result;

This generates the parstable. Empty lines represents the ε of your parsetable

**End:**  
To stop the application press `Ctrl + D`