#!/usr/bin/env bash

WTTR_PARAMS="${WTTR_PARAMS:-n}"

LOCATION=$(curl -s http://ip-api.com/csv/?fields=city,lat,lon)
CITY="${LOCATION%%,*}"
GEO="${LOCATION#*,}"

wttr() {
  local location params=() args=()

  for arg in "$@"; do
    if [[ "$arg" != -* && -z "$location" ]]; then
      location="${arg// /+}"
    else
      params+=("${arg#-}")
    fi
  done

  for p in $WTTR_PARAMS "${params[@]}"; do
    if [[ "$p" == "s" ]]; then
      args+=("--data-urlencode" "format=4")
    else
      args+=("--data-urlencode" "$p")
    fi
  done

  curl -fGsS -H "Accept-Language: ${LANG%_*}" "${args[@]}" --compressed "wttr.in/${location:-$GEO}"
}

echo -ne "$CITY: " && wttr "$@"
