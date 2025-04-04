#!/usr/bin/env bash
# Author: José M. C. Noronha

function toUpper {
    echo "$1" | awk '{print toupper($0)}'
    
}

function toLower {
    echo "$1" | awk '{print tolower($0)}'
}
