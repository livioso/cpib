
public class MachineError extends Exception {

    /**
     * Serial id for serialization (used for deep copy).
     */
    private static final long serialVersionUID = 7579885743779527204L;

    /**
     * Message of the exception.
     */
    private final String message;

    /**
     * Creates a new MachineError error exception.
     *
     * @param message error message
     * @param lineNumber corresponding line number in source code
     */
    public MachineError(String message) {
        super();
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message + ".";
    }
}
