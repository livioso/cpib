// Virtual Machine Java 2015, V01
// Edgar F.A. Lederer, FHNW and Uni Basel, 2015

package vm;

import java.io.BufferedReader;
import java.io.InputStreamReader;

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

    // format read from system.in as following:
    //
    // 0: AllocBlock (1),
    // 1: Deref,
    // 2: Call (2)
    public void fromSystemIn() {

        // delete old stuff
        code = new IInstructions.IInstr[size];

        try {
            String line;
            BufferedReader input = new BufferedReader(
                    new InputStreamReader(System.in));
            do {
                line = input.readLine();
                readInstruction(line);
            }
            while (line.substring(line.length() - 1, line.length()).equals(","));

            // make sure that we have
            // set the correct size
            this.resize();

        } catch (Exception e) {
           e.printStackTrace();
        }
    }

    private void readInstruction(String line) throws Exception {
        String[] cmdRaw = line.split(",");
        Integer loc = Integer.valueOf(cmdRaw[0]);
        String tmp = cmdRaw[1].trim();
        String[] cmd = tmp.split(" ");

        for (int i = 0; i < cmd.length; i++) {
            cmd[i] = cmd[i].replace(')', ' ');
            cmd[i] = cmd[i].replace('(', ' ');
            cmd[i] = cmd[i].trim();
        }

        try {
            switch (cmd[0]) {
                case "AddInt": put(loc, new IInstructions.AddInt()); break;
                case "AllocBlock": put(loc, new IInstructions.AllocBlock(Integer.valueOf(cmd[1]))); break;
                case "AllocStack": put(loc, new IInstructions.AllocStack(Integer.valueOf(cmd[1]))); break;
                case "Call": put(loc, new IInstructions.Call(Integer.valueOf(cmd[1]))); break;
                case "CondJump": put(loc, new IInstructions.CondJump(Integer.valueOf(cmd[1]))); break;
                case "Deref": put(loc, new IInstructions.Deref()); break;
                case "DivTruncInt": put(loc, new IInstructions.DivTruncInt()); break;
                case "Dup": put(loc, new IInstructions.Dup()); break;
                case "EqInt": put(loc, new IInstructions.EqInt()); break;
                case "GeInt": put(loc, new IInstructions.GeInt()); break;
                case "GtInt": put(loc, new IInstructions.GtInt()); break;
                case "InputBool": put(loc, new IInstructions.InputBool(cmd[1])); break;
                case "InputInt": put(loc, new IInstructions.InputInt(cmd[1])); break;
                case "LeInt": put(loc, new IInstructions.LeInt()); break;
                case "LoadAddrRel": put(loc, new IInstructions.LoadAddrRel(Integer.valueOf(cmd[1]))); break;
                case "LoadImInt": put(loc, new IInstructions.LoadImInt(Integer.valueOf(cmd[1]))); break;
                case "LtInt": put(loc, new IInstructions.LtInt()); break;
                case "ModTruncInt": put(loc, new IInstructions.ModTruncInt()); break;
                case "MultInt": put(loc, new IInstructions.MultInt()); break;
                case "NegInt": put(loc, new IInstructions.NegInt()); break;
                case "NeInt": put(loc, new IInstructions.NeInt()); break;
                case "OutputBool": put(loc, new IInstructions.OutputBool(cmd[1])); break;
                case "OutputInt": put(loc, new IInstructions.OutputInt(cmd[1])); break;
                case "Return": put(loc, new IInstructions.Return(Integer.valueOf(cmd[1]))); break;
                case "Stop": put(loc, new IInstructions.Stop()); break;
                case "Store": put(loc, new IInstructions.Store()); break;
                case "SubInt": put(loc, new IInstructions.SubInt()); break;
                case "UncondJump": put(loc, new IInstructions.UncondJump(Integer.valueOf(cmd[1]))); break;
                default: throw new Exception("unknown command " + cmd[0] + " found.");
            }
        } catch (IndexOutOfBoundsException e) {
            System.out.println(e.toString());
        } catch (ICodeArray.CodeTooSmallError codeTooSmallError) {
            codeTooSmallError.printStackTrace();
        }
    }
}
