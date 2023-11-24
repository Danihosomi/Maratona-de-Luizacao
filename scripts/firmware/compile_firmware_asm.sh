#!/bin/bash -eu

export TARGET=$1
export TARGET_FILENAME=$(basename ${TARGET})

# echo $TARGET_FILENAME

source scripts/venv/bin/activate
bronzebeard --include firmware/ --output temp/firmware.data firmware/${TARGET}
python3 scripts/firmware/compile_firmware.py --src temp/firmware.data --dest ROMMemory.v
