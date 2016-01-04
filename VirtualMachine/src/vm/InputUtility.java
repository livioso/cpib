// Virtual Machine Java 2015, V01
// Edgar F.A. Lederer, FHNW and Uni Basel, 2015

package vm;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class InputUtility {

    private static BufferedReader reader=
            new BufferedReader(new InputStreamReader(System.in));

    public static boolean readBool() throws IVirtualMachine.ExecutionError {
        String s;
        try {
            s= reader.readLine();
        } catch (IOException e) {
            throw new IVirtualMachine.ExecutionError("Input failed.");
        }
        if (s.equals("false")) {
            return false;
        }
        else
        if (s.equals("true")) {
            return true;
        }
        else {
            throw new IVirtualMachine.ExecutionError("Not a boolean.");
        }
    }

    public static int readInt() throws IVirtualMachine.ExecutionError {
        String s;
        try {
            s= reader.readLine();
        } catch (IOException e) {
            throw new IVirtualMachine.ExecutionError("Input failed.");
        }
        try {
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            throw new IVirtualMachine.ExecutionError("Not an integer.");
        }
    }
}
