#!/usr/bin/env bash
# Wirepas Oy

set -e

DEFAULT_CLANG_VERSION="9"

function clangformat_version
{
    _target_version=${1:-"${DEFAULT_CLANG_VERSION}"}
    CLANG_CMD="clang-format-${_target_version}"

    set +e
    rc=$(command -v "${CLANG_CMD}")
    set -e

    if [[ -z "${rc}" ]]
    then
      CLANG_CMD="clang-format"
    fi

    _major=$(eval "$CLANG_CMD -version" \
            | awk '{split($0,a," "); print a[3]}' \
            | awk '{split($0,a,"."); print a[1]}')

     if (( "${_major}" < "${_target_version}" ))
    then
        echo "You're using an unsupported version of clang-format!"
        echo "Please upgrade clang-format to version +${_target_version}"
    fi

    export CLANG_CMD
}

function clangformat_check
{
    _target_version=${1:-"${DEFAULT_CLANG_VERSION}"}
    clangformat_version "${_target_version}"

    _file_list=$(find . -type f \( -name "*.c" -o -name "*.h" \))

    ret=0
    for _file in ${_file_list}
    do
      #shellcheck disable=SC2094
      run="$CLANG_CMD -style=file < ${_file} | diff ${_file} - "
      _lines=$(eval "${run}" | wc -l)
      echo "${_file} : ${_lines}"
      if (( "${_lines}" > 0 ))
      then
        echo "please fix ${_lines} issues in ${_file} with:"
        eval "${run}" || true
        ((ret=ret+_lines))
        echo ""
      fi
    done

    echo "Found $ret issues"
    return "$ret"
}

function clangformat_apply
{
    _target_version=${1:-"${DEFAULT_CLANG_VERSION}"}
    clangformat_version "${_target_version}"
    _file_list=$(find . -type f \( -name "*.c" -o -name "*.h" \))

    for _file in ${_file_list}
    do
      echo "formatting $_file"
      eval "$CLANG_CMD -style=file -i $_file"
    done
}
