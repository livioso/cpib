// Virtual Machine Java 2015, V01
// Edgar F.A. Lederer, FHNW and Uni Basel, 2015

package vm;

public class CodeArray implements ICodeArray {
    private IInstructions.IInstr[] code;
    private int size;

    public CodeArray(int size) {
        this.code= new IInstructions.IInstr[size];
        this.size= size;
    }

    public int getSize() {
        return size;
    }

    public void put(int loc, IInstructions.IInstr instr) throws CodeTooSmallError {
        if (loc < code.length) {
            code[loc]= instr;
        }
        else {
            throw new CodeTooSmallError();
        }
    }

    public IInstructions.IInstr get(int loc) {
        return code[loc];
    }

    public void resize() {
        int s= 0;
        while (s < code.length && code[s] != null) {
            s++;
        }
        IInstructions.IInstr[] c= new IInstructions.IInstr[s];
        for (int i= 0; i < s; i++) {
            c[i]= code[i];
        }
        code= c;
        size= s;
    }

    public String toString()
    {
        StringBuffer b= new StringBuffer();
        for (int i= 0; i < code.length; i++)
        {
            if (code[i] != null)
            {
                b.append(i + ": " + code[i] + "\n");
            }
        }
        return b.toString();
    }

    public void fromString() {
        // to be implemented
    }
}
