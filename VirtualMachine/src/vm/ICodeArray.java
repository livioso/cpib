// Virtual Machine Java 2015, V01
// Edgar F.A. Lederer, FHNW and Uni Basel, 2015

package vm;

public interface ICodeArray {
    // for the COMPILER:
    // a CodeTooSmallError indicates that the code is too small
    // to hold the complete program
    class CodeTooSmallError extends Exception {}
    void put(int loc, IInstructions.IInstr instr) throws CodeTooSmallError;
    void resize();
    String toString();

    // for the VM:
    int getSize();
    IInstructions.IInstr get(int loc);
    void fromString();
}
