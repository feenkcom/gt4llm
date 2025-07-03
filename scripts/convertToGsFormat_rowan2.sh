#! /usr/bin/env bash
### Export gt4llm to a .gs file.
### Requires loginSystemUser.topaz be configured with the correct credentials,
### and the environmental variable STONE to indicate the target stone name.
### Exits with 0 if success, topaz status if failed.

set -e

if [ -z "$ROWAN_PROJECTS_HOME" ]
then
	echo "ROWAN_PROJECTS_HOME must be defined"
	exit 1
fi

if [ -z "$STONE" ]
then
	echo "STONE must be defined"
	exit 1
fi

gt4llmHome=${ROWAN_PROJECTS_HOME}/gt4llm
## Topaz refuses to exit from script if input is stdin, so redirect from /dev/null
topaz -l -I ${gt4llmHome}/scripts/loginSystemUser.topaz  -S ${gt4llmHome}/scripts/convertToGsFormat.topaz < /dev/null
status=$?
if [ $status != 0 ]
then
        echo !!!!!!!!!!!!!!!!
        echo Failed to export gt4llm
        echo !!!!!!!!!!!!!!!!
        exit $status
fi

exit 0
