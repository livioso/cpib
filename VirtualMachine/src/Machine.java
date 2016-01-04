import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import vm.*;
import vm.IVirtualMachine.*;

public class Machine {

    static ICodeArray CODE_SIZE = new CodeArray(1000);
    static int STORE_SIZE = 1000;
    static IVirtualMachine vm;

    public Machine() throws ExecutionError{
        vm = new VirtualMachine(CODE_SIZE, STORE_SIZE);
    }

    public Machine(ICodeArray cs, int ss) throws ExecutionError {
        CODE_SIZE = cs;
        STORE_SIZE = ss;
        vm = new VirtualMachine(CODE_SIZE, STORE_SIZE);
    }

    /**
     * @param args
     */
    public static void main(String[] args) {
        try {
            Machine machine = new Machine();
            System.out.println("Enter code:");
            machine.run(new BufferedReader(new InputStreamReader(System.in)));
        } catch (IOException | ExecutionError | MachineError e) {
            e.printStackTrace();
        }
    }

    public void run(BufferedReader input) throws IOException, ExecutionError, MachineError {

        String s;

        do {
            s = input.readLine();
            doLine(s);
        } while (s.substring(s.length() -1, s.length()).equals(","));

        vm.execute();

    }

    public void doLine(final String input) throws MachineError {

        String[] cmdRaw = input.split(",");
        Integer line = Integer.valueOf(cmdRaw[0].substring(1));
        String tmp = cmdRaw[1].substring(0, cmdRaw[1].length() - 1);
        String[] cmd = tmp.split(" ");

        for (int i = 0; i < cmd.length; i++) {
            cmd[i] = cmd[i].replace(')', ' ');
            cmd[i] = cmd[i].replace('(', ' ');
            cmd[i] = cmd[i].trim();
        }

        try {
            switch (cmd[0]) {
                case "AddInt": CODE_SIZE.put(line, new IInstructions.AddInt()); break;
                case "AllocBlock": CODE_SIZE.put(line, new IInstructions.AllocBlock(Integer.valueOf(cmd[1]))); break;
                case "AllocStack": CODE_SIZE.put(line, new IInstructions.AllocStack(Integer.valueOf(cmd[1]))); break;
                case "Call": CODE_SIZE.put(line, new IInstructions.Call(Integer.valueOf(cmd[1]))); break;
                case "CondJump": CODE_SIZE.put(line, new IInstructions.CondJump(Integer.valueOf(cmd[1]))); break;
                case "Deref": CODE_SIZE.put(line, new IInstructions.Deref()); break;
                case "DivTruncInt": CODE_SIZE.put(line, new IInstructions.DivTruncInt()); break;
                case "Dup": CODE_SIZE.put(line, new IInstructions.Dup()); break;
                case "EqInt": CODE_SIZE.put(line, new IInstructions.EqInt()); break;
                case "GeInt": CODE_SIZE.put(line, new IInstructions.GeInt()); break;
                case "GtInt": CODE_SIZE.put(line, new IInstructions.GtInt()); break;
                case "InputBool": CODE_SIZE.put(line, new IInstructions.InputBool(cmd[1])); break;
                case "InputInt": CODE_SIZE.put(line, new IInstructions.InputInt(cmd[1])); break;
                case "LeInt": CODE_SIZE.put(line, new IInstructions.LeInt()); break;
                case "LoadAddrRel": CODE_SIZE.put(line, new IInstructions.LoadAddrRel(Integer.valueOf(cmd[1]))); break;
                case "LoadImInt": CODE_SIZE.put(line, new IInstructions.LoadImInt(Integer.valueOf(cmd[1]))); break;
                case "LtInt": CODE_SIZE.put(line, new IInstructions.LtInt()); break;
                case "ModTruncInt": CODE_SIZE.put(line, new IInstructions.ModTruncInt()); break;
                case "MultInt": CODE_SIZE.put(line, new IInstructions.MultInt()); break;
                case "NegInt": CODE_SIZE.put(line, new IInstructions.NegInt()); break;
                case "NeInt": CODE_SIZE.put(line, new IInstructions.NeInt()); break;
                case "OutputBool": CODE_SIZE.put(line, new IInstructions.OutputBool(cmd[1])); break;
                case "OutputInt": CODE_SIZE.put(line, new IInstructions.OutputInt(cmd[1])); break;
                case "Return": CODE_SIZE.put(line, new IInstructions.Return(Integer.valueOf(cmd[1]))); break;
                case "Stop": CODE_SIZE.put(line, new IInstructions.Stop()); break;
                case "Store": CODE_SIZE.put(line, new IInstructions.Store()); break;
                case "SubInt": CODE_SIZE.put(line, new IInstructions.SubInt()); break;
                case "UncondJump": CODE_SIZE.put(line, new IInstructions.UncondJump(Integer.valueOf(cmd[1]))); break;
                default: throw new MachineError("unknown command " + cmd[0] + " found.");
            }
        } catch (IndexOutOfBoundsException e) {
            System.out.println(e.toString());
        } catch (ICodeArray.CodeTooSmallError codeTooSmallError) {
            codeTooSmallError.printStackTrace();
        }
    }
}