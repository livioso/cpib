import vm.CodeArray;
import vm.ICodeArray;
import vm.IVirtualMachine.*;
import vm.VirtualMachine;

public class Machine {

    public static void main(String[] args) {

        try {

            // read from system in: format as following:
            // 0: AllocBlock (1),
            // 1: Deref,
            // 2: Call (2)
            System.out.println("VirtualMachine $ ");
            final int size = 1000;

            ICodeArray code = new CodeArray(size);
            code.fromSystemIn();

            // load & run code
            new VirtualMachine(code, size);

        } catch (ExecutionError e) {
            e.printStackTrace();
        }

    }
}