# **********************************************************************************************
# Breakpoint management 
# **********************************************************************************************

# ----------------------------------------------------------------------------------------------
# Breakpoint list
# ----------------------------------------------------------------------------------------------

define bpl
if $argc == 0
    info breakpoints
else
    help bpl
end
end

document bpl
List all breakpoints.
end

# ----------------------------------------------------------------------------------------------
# Standard breakpoints
# ----------------------------------------------------------------------------------------------

define bp
if $argc == 0
    break
else 
if $argc == 1
    break $arg0
else
    help bp
end
end
end

document bp
Set a breakpoint.
Usage: bp [LOCATION]
LOCATION may be a line number, a function name, or "*" followed by an address.

If the function name is prefixed with a "*", the breakpoint will be put before
the function prolog, otherwise it will be put at the end of the function prolog.

With no arg, the current execution address of the selected stack frame is used.

To break on a symbol you must enclose the symbol name inside quotes, e.g.
    bp "[NSControl stringValue]"

Do "help break" for more information.
end

# ----------------------------------------------------------------------------------------------
# Temporary breakpoints
# ----------------------------------------------------------------------------------------------

define bpt
if $argc == 0
    tbreak
else 
if $argc == 1
    tbreak $arg0
else
    help bpt
end
end
end

document bpt
Set a temporary breakpoint.
Usage: bpt [LOCATION]
LOCATION may be a line number, a function name, or "*" followed by an address.

If the function name is prefixed with a "*", the breakpoint will be put before
the function prolog, otherwise it will be put at the end of the function prolog.

With no arg, the current execution address of the selected stack frame is used.

To break on a symbol you must enclose the symbol name inside quotes, e.g.
    bpt "[NSControl stringValue]"

Do "help tbreak" for more information.
end

# ----------------------------------------------------------------------------------------------
# Memory breakpoints
# ----------------------------------------------------------------------------------------------
define bpm
if $argc == 1
    awatch $arg0
else 
    help bpm
end
end

document bpm
Set a read/write breakpoint on EXPRESSION.
Usage: bpm EXPRESSION
A memory breakpoint stops execution of your program whenever the value of an 
expression is either read or written.

Do "help awatch" for more information.
end

# ----------------------------------------------------------------------------------------------
# Hardware assisted breakpoints
# ----------------------------------------------------------------------------------------------
define bph
if $argc == 0
    hb
else 
if $argc == 1
    hb $arg0
else
    help bph
end
end
end

document bph
Set a hardware assisted breakpoint.
Usage: bph [LOCATION]
LOCATION may be a line number, a function name, or "*" followed by an address.

If the function name is prefixed with a "*", the breakpoint will be put before
the function prolog, otherwise it will be put at the end of the function prolog.

With no arg, the current execution address of the selected stack frame is used.

To break on a symbol you must enclose the symbol name inside quotes, e.g.
    bph "[NSControl stringValue]"

Do "help hb" for more information.
end

# ----------------------------------------------------------------------------------------------
# Clearing breakpoints
# ----------------------------------------------------------------------------------------------

define bpc
if $argc == 0
    clear
else 
if $argc == 1
    clear $arg0
else
    help bpc
end
end
end

document bpc
Clear a breakpoint.
Usage: bpc [LOCATION]
LOCATION may be a line number, a function name, or "*" followed by an address.

If the function name is prefixed with a "*", the breakpoint is searched before the
function prolog, otherwise at its end.

With no argument, clears all breakpoints in the line that the selected frame
is executing in.

To clear a breakpoint using its number (usually more convenient), use the delete (d) 
command instead.

Do "help clear" for more information.
end

# ----------------------------------------------------------------------------------------------
# Enabling breakpoints
# ----------------------------------------------------------------------------------------------

define bpe
if $argc == 0
    enable
else 
if $argc == 1
    enable $arg0
else 
if $argc == 2
    enable $arg0 $arg1
else 
if $argc == 3
    enable $arg0 $arg1 $arg2
else 
if $argc == 4
    enable $arg0 $arg1 $arg2 $arg3
else 
if $argc == 5
    enable $arg0 $arg1 $arg2 $arg3 $arg4
else 
if $argc == 6
    enable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5
else
if $argc == 7
    enable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6
else 
if $argc == 8
    enable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7
else 
if $argc == 9
    enable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8
else 
if $ argc == 10
    enable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9
else
    help bpe
end
end
end
end
end
end
end
end
end
end
end
end

document bpe
Enable breakpoints (all if none specified)
Usage: bpe [NUM1] [NUM2] ... [NUM10]

Do "help enable" for more information.
end

# ----------------------------------------------------------------------------------------------
# Disabling breakpoints
# ----------------------------------------------------------------------------------------------

define bpd
if $argc == 0
    disable
else 
if $argc == 1
    disable $arg0
else 
if $argc == 2
    disable $arg0 $arg1
else 
if $argc == 3
    disable $arg0 $arg1 $arg2
else
if $argc == 4
    disable $arg0 $arg1 $arg2 $arg3
else 
if $argc == 5
    disable $arg0 $arg1 $arg2 $arg3 $arg4
else 
if $argc == 6
    disable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5
else 
if $argc == 7
    disable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6
else 
if $argc == 8
    disable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7
else 
if $argc == 9
    disable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8
else 
if $ argc == 10
    disable $arg0 $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9
else
    help bpd
end
end
end
end
end
end
end
end
end
end
end
end

document bpd
Disable breakpoints (all if none specified)
Usage: bpd [NUM1] [NUM2] ... [NUM10]

Do "help disable" for more information.
end


# **********************************************************************************************
# Objective-C
# **********************************************************************************************

# Some usual references:
#     http://www.clarkcox.com/blog/2009/02/04/inspecting-obj-c-parameters-in-gdb/
#     http://developer.apple.com/library/ios/#technotes/tn2239/_index.html

# ----------------------------------------------------------------------------------------------
# Globals
# ----------------------------------------------------------------------------------------------

set unwindonsignal on

# ----------------------------------------------------------------------------------------------
# Retrieving arguments before a function prolog
# ----------------------------------------------------------------------------------------------

# TODO: Currently only i386 (& iOS simulator). Must deal with 64 bits & iOS device as well!

define _getfunargbp
if $argc == 2
    set $$arg0 = *(long *)($esp+4+4*$arg1)
else 
if $argc == 3
    set $$arg0 = *($arg1 *)($esp+4+4*$arg2)
else
    help _getfunargbp
end
end
end

document _getfunargbp
Fetch function arguments (to be called before a function prolog)
Usage: _getfunargbp NAME [TYPE] INDEX
Sets the variable $NAME to the INDEX-th argument of the function we're about to call
Uses type TYPE if present, otherwise 'long'
<index> is 0-based
end

# ----------------------------------------------------------------------------------------------
# Retrieving arguments after a function prolog
# ---------------------------------------------------------------------------------------------

# TODO: Currently only i386 (& iOS simulator). Must deal with 64 bits & iOS device as well!

define _getfunargap
if $argc == 2
    set $$arg0 = *(long *)($ebp+8+4*$arg1)
else 
if $argc == 3
    set $$arg0 = *($arg1 *)($ebp+8+4*$arg2) 
else
    help _getfunargap
end
end
end

document _getfunargap
Fetch function arguments (to be called after a function prolog)
Usage: _getfunargap NAME [TYPE] INDEX
Sets the variable $NAME to the INDEX-th argument of the function we're about to call
Uses type TYPE if present, otherwise 'long'
INDEX is 0-based
end

# ----------------------------------------------------------------------------------------------
# Selector call information (only meant to be used when breaking on objc_msgSend)
# ----------------------------------------------------------------------------------------------

define sci
if $argc == 0
    _getfunargbp _sci_self id 0
    _getfunargbp _sci_selector SEL 1
else
if ($argc == 1 && (int)strcmp("$arg0", "*") == 0)
    _getfunargap _sci_self id 0
    _getfunargap _sci_selector SEL 1    
else
    help sci
end
end

# Must be careful enough here NOT to use message sending (would be recursive!)
printf "Message %s sent to <%s: %p>\n", $_sci_selector, (const char *)object_getClassName($_sci_self), $_sci_self
end

document sci
Print information about the message and object passed to objc_msgSend. 
Usage: sci [*]
This command is only meant to be used when breaking on objc_msgSend. Append a star to the it 
after the objc_msgSend prolog, or nothing before it
end

# TODO: mci (method call information, x/y/z/w for argument types, up to 10), fci (function call information, x/y/z/w for argument types, up to 10)

# ----------------------------------------------------------------------------------------------
# Single argument extraction (only meant to be used when breaking on a function or method)
# ----------------------------------------------------------------------------------------------

define xa
# Check the first argument
if ($argc >= 1 && "$arg0"[0] != '/')
    help xa
else
if $argc == 2
    x $arg0 *(long *)($esp+4+4*$arg1)
else
if ($argc == 3 && (int)strcmp("$arg1", "*") == 0)
    x $arg0 *(long *)($ebp+8+4*$arg2)
else
    help xa
end
end
end
end

document xa
Fetch a specific function argument, displaying it with the specified type. Add a * if you are
looking at arguments after the prolog
Usage: xa/TYPE [*] INDEX
INDEX is 0-based. Do "help x" for more information about the types you can use.
end


