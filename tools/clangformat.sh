#!/usr/bin/env bash
# Wirepas Oy

set -e

function clangformat_version
{
    _target_version="${1}"
    _major=$(clang-format -version \
            | awk '{split($0,a," "); print a[3]}' \
            | awk '{split($0,a,"."); print a[1]}')

     if (( "${_major}" < "${_target_version}" ))
    then
        echo "Please upgrade clang-format to version +${_target_version}"
        exit 0
    fi
}

function clangformat_check
{
    TARGET_CLANG_FORMAT=${1:-"7"}
    clangformat_version "${TARGET_CLANG_FORMAT}"

    _file_list=$(find . -type f \( -name "*.c" -o -name "*.h" \))

    ret=0
    for _file in ${_file_list}
    do
        #shellcheck disable=SC2094
      _lines=$(clang-format -style=file < "${_file}" | diff "${_file}" - | wc -l)
      echo "$_file : $_lines"

      if (( "${_lines}" > 0 ))
      then
        ((ret=ret+_lines))
      fi
    done

    echo "Found $ret issues"
    exit "$ret"
}

function clangformat_apply
{
    TARGET_CLANG_FORMAT=${1:-"7"}

    _file_list=$(find . -type f \( -name "*.c" -o -name "*.h" \))

    for _file in ${_file_list}
    do
      echo "formatting $_file"
      clang-format -style=file -i "$_file"
    done
}


