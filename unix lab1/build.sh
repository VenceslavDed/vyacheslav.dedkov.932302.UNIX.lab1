#!/bin/sh -e

File="program.cpp"

if [ -z "$File" ]; then  
    echo "Error: no source file specified"  
    exit 1  
fi  

if [ ! -f "$File" ]; then  
    echo "Error: file '$File' not found"  
    exit 2  
fi  

Output=$(grep '&&Output:' "$File" | cut -d: -f2- | xargs)

if [ -z "$Output" ]; then  
    echo "Error: &&Output: not found in file"  
    exit 3  
fi  

ImpDir=$(mktemp -d)  
Path=$(pwd)

cleanup() { rm -rf "$ImpDir"; }  
trap cleanup EXIT HUP INT PIPE TERM  

cp "$File" "$ImpDir/"  
cd "$ImpDir"  
g++ "$(basename "$File")" -o "$Output"  

mv "$Output" "$Path/"  

echo "Success: $Path/$Output"
