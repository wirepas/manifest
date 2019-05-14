#!/usr/bin/env bash
# Wirepas Oy

set -e

function clangformat_version
{
    _target_version="${1}"
    cmd="clang-format-${_target_version}"
    _major=$(eval "$cmd -version" \
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
    _target_version=${1:-"7"}
    clangformat_version "${_target_version}"

    cmd="clang-format-${_target_version}"
    _file_list=$(find . -type f \( -name "*.c" -o -name "*.h" \))

    ret=0
    for _file in ${_file_list}
    do
      #shellcheck disable=SC2094
      run="$cmd -style=file < ${_file} | diff ${_file} - "
      _lines=$(eval "${run}" | wc -l)
      echo "${_file} : ${_lines}"
      if (( "${_lines}" > 0 ))
      then
        echo "please fix ${_lines} issues in ${_file} with:"
        eval "${run}" || true
        ((ret=ret+_lines))
        echo -e "\n"
      fi
    done

    echo "Found $ret issues"
    exit "$ret"
}

function clangformat_apply
{
    _target_version=${1:-"7"}
    cmd="clang-format-${_target_version}"

    _file_list=$(find . -type f \( -name "*.c" -o -name "*.h" \))

    for _file in ${_file_list}
    do
      echo "formatting $_file"
      eval "$cmd -style=file -i $_file"
    done
}


