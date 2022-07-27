#!/usr/bin/env bash

# Note: Use GNU Sed, BSD / macOS Sed does not behave as expected for this regex.
SED="sed"
which gsed 2>/dev/null 1>/dev/null
if [[ $? -eq 0 ]]; then
    SED=gsed
fi

for d in doc/*.md; do
    echo "[Info] Cleaning color escape sequences for ${d}"
    cat ${d} | gsed -e 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'\''()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g' > ${d}.clean
    rm ${d}
    mv ${d}.clean ${d}
done
