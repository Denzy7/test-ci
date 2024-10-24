#!/bin/bash
prefix="$1"
ver="$2"
exe="$3"
dir="$(echo "$exe" | sed 's:[/\\][^/\\]*$::')"
projbindir="$4"

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

"$python" mingw-ldd/mingw-ldd.py "$exe" | grep -v "not found" | grep -vi "system32" | awk '{print $3}' | while read -r file; do
    if [[ -f "$file" ]]; then
        #cp "$file" "$TARGET_DIR"
        echo "Copied $file"
    fi
done

# special case ntldd depends on libssp
if [[ -f "$projbindir/ntldd/ntldd.exe" ]];then
    "$python" mingw-ldd/mingw-ldd.py "$projbindir/ntldd/ntldd.exe" | grep -v "not found" | grep -vi "system32" | awk '{print $3}' | while read -r file; do
    if [[ -f "$file" ]]; then
        cp "$file" "$projbindir/ntldd"
    fi
done
    echo "using ntldd"
    "$projbindir/ntldd/ntldd.exe" "$exe" | grep -v "not found" | grep -vi "system32" | awk '{print $3}' | while read -r file; do
    if [[ -f "$file" ]]; then
        echo "Copied $file"
        #cp "$file" "$projbindir/ntldd"
    fi
done

    "$projbindir/ntldd/ntldd.exe" "$exe"
fi

