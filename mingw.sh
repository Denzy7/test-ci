#!/bin/bash
prefix="$1"
ver="$2"
exe="$3"
dir="$(echo "$exe" | sed 's:[/\\][^/\\]*$::')"
projbindir="$4"
ldd=$(command -v ldd)

if [ -n "$ldd" ]; then
    echo "using system ldd"
    "$ldd" "$exe" |  grep -Evi "not found|system32|linux-vdso|ld-linux" | sed 's/(0x[0-9a-fA-F]*)//g' | sed 's/.*=> //g' | while read -r file; do
    if [[ -f "$file" ]]; then
        cp "$file" "$dir"
        echo "Copied $file"
    fi
done
    exit 0
fi

python3 -m venv venv

if [[ -f ".\\venv\\Scripts\\pip" ]]; then
    pip=".\\venv\\Scripts\\pip"
    python=".\\venv\\Scripts\\python"
elif [[ -f "./venv/bin/pip" ]]; then
    pip="./venv/bin/pip"
    python="./venv/bin/python"
else
    echo "pip and python not found in either path."
    exit 1
fi

echo "info: p:$prefix v:$ver e:$exe d:$dir"
"$pip" install pefile
echo "using mingw-ldd"
"$python" mingw-ldd/mingw-ldd.py "$exe"

"$python" mingw-ldd/mingw-ldd.py "$exe" |  grep -Evi "not found|system32|linux-vdso|ld-linux" | sed 's/(0x[0-9a-fA-F]*)//g' | sed 's/.*=> //g' | while read -r file; do
    if [[ -f "$file" ]]; then
        cp "$file" "$dir"
        echo "Copied $file"
    fi
done



# special case ntldd depends on libssp
if [[ -f "$projbindir/ntldd/ntldd.exe" ]];then
    "$python" mingw-ldd/mingw-ldd.py "$projbindir/ntldd/ntldd.exe" | grep -Evi "not found|system32|linux-vdso|ld-linux" | sed 's/(0x[0-9a-fA-F]*)//g' | sed 's/.*=> //g' | while read -r file; do
    if [[ -f "$file" ]]; then
        cp "$file" "$projbindir/ntldd"
    fi
done
    echo "using ntldd"
    "$projbindir/ntldd/ntldd.exe" "$exe" | grep -Evi "not found|system32|linux-vdso|ld-linux" | sed 's/(0x[0-9a-fA-F]*)//g' | sed 's/.*=> //g' | while read -r file; do
    if [[ -f "$file" ]]; then
        cp "$file" "$dir"
        echo "Copied $file"
    fi
done

    "$projbindir/ntldd/ntldd.exe" "$exe"
fi

