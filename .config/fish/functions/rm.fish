function rm --description "Move files and directories to the desktop trash"
    if test (count $argv) -eq 0
        echo "rm: missing operand" >&2
        return 1
    end

    set -l paths
    set -l force 0
    set -l end_options 0

    for arg in $argv
        if test $end_options -eq 1
            set -a paths "$arg"
        else if test "$arg" = "--"
            set end_options 1
        else if string match -qr '^-[fRr]+$' -- "$arg"
            if string match -q '*f*' -- "$arg"
                set force 1
            end
        else if string match -qr '^-' -- "$arg"
            echo "rm: unsupported option for the trash wrapper: $arg" >&2
            echo "Use 'command rm' only when permanent deletion is intended." >&2
            return 2
        else
            set -a paths "$arg"
        end
    end

    if test (count $paths) -eq 0
        echo "rm: missing operand" >&2
        return 1
    end

    set -l result 0
    for path in $paths
        if test -e "$path" -o -L "$path"
            command gio trash -- "$path"
            or set result $status
        else if test $force -ne 1
            echo "rm: cannot remove '$path': No such file or directory" >&2
            set result 1
        end
    end

    return $result
end
