// Virtual Machine Java 2015, V01
// Edgar F.A. Lederer, FHNW and Uni Basel, 2015

package vm;

public interface IVirtualMachine { // into separate file
    // an InternalError indicates that the compiler itself is in error
    class InternalError extends RuntimeException
    {
        InternalError(String errorMessage)
        {
            super("Internal error: " + errorMessage);
        }
    }

    // an ExecutionError indicates that execution of the program is in error
    //  - example: division by zero
    class ExecutionError extends Exception
    {
        ExecutionError(String errorMessage)
        {
            super("Execution error: " + errorMessage);
        }
    }
}
