#!/bin/bash
# source this file to activate the shared environment
CONDA_ROOT="/data/Seq37H/Element/conda"        # must match where you installed conda
ENV_PREFIX="/data/Seq37H/Element/envs/element"

if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
  source "$CONDA_ROOT/etc/profile.d/conda.sh"
elif command -v conda >/dev/null 2>&1; then
  eval "$(conda shell.bash hook)"
else
  echo "ERROR: conda not found. Please check CONDA_ROOT in this script." >&2
  return 1
fi

# Activate by prefix so we don't depend on names
conda activate "$ENV_PREFIX"