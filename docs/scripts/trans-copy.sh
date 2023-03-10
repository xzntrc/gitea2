#!/usr/bin/env bash
set -e

#
# This script is used to copy the en-US content to our available locales as a
# fallback to always show all pages when displaying a specific locale that is
# missing some documents to be translated.
#
# Just execute the script without any argument and you will get the missing
# files copied into the content folder. We are calling this script within the CI
# server simply by `make trans-copy`.
#

declare -a LOCALES=(
  "fr-fr"
  "nl-nl"
  "pt-br"
  "zh-cn"
  "zh-tw"
)

ROOT=$(realpath $(dirname $0)/..)

for SOURCE in $(find ${ROOT}/content -type f -iname *.en-us.md); do
  for LOCALE in "${LOCALES[@]}"; do
    DEST="${SOURCE%.en-us.md}.${LOCALE}.md"

    if [[ ! -f ${DEST} ]]; then
      cp ${SOURCE} ${DEST}
      sed -i.bak "s/en\-us/${LOCALE}/g" ${DEST}
      rm ${DEST}.bak
    fi
  done
done
