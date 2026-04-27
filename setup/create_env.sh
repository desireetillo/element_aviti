#!/usr/bin/env bash
set -euo pipefail

# -----------------------
# EDIT THESE BEFORE RUN:
CONDA_ROOT="/data/Seq37H/Element/conda"             # your shared conda install (from your message)
ENV_PREFIX="/data/Seq37H/Element/envs/element"   # where the environment will be created (prefix path)
ENV_YML="/data/Seq37H/Element/setup/environment.yml"      # path to environment.yml to use
# -----------------------

# helper
echo_stderr() { echo "$@" >&2; }

# 0) sanity checks
if [ ! -f "${CONDA_ROOT}/etc/profile.d/conda.sh" ]; then
  echo_stderr "ERROR: conda.sh not found at ${CONDA_ROOT}/etc/profile.d/conda.sh"
  echo_stderr "Please verify CONDA_ROOT and re-run."
  exit 1
fi

if [ ! -f "${ENV_YML}" ]; then
  echo_stderr "ERROR: environment.yml not found at ${ENV_YML}"
  echo_stderr "Please create or point ENV_YML to your environment.yml"
  exit 1
fi

# 1) source the shared conda shell hook so conda/mamba commands work in this shell
echo "Sourcing shared conda from: ${CONDA_ROOT}"
# shellcheck disable=SC1090
source "${CONDA_ROOT}/etc/profile.d/conda.sh"

# 2) ensure mamba is available in base; install it if it's not
if command -v mamba >/dev/null 2>&1; then
  echo "mamba already available: $(mamba --version 2>/dev/null || true)"
else
  echo "Installing mamba into the shared 'base' environment (conda install -n base -c conda-forge mamba)"
  conda install -n base -c conda-forge mamba --yes
  echo "mamba installed."
fi

# 3) create the environment using mamba if present, otherwise fallback to conda
echo "Creating environment at prefix: ${ENV_PREFIX}"
if command -v mamba >/dev/null 2>&1; then
  mamba env create --prefix "${ENV_PREFIX}" -f "${ENV_YML}" --yes
else
  conda env create --prefix "${ENV_PREFIX}" -f "${ENV_YML}" --yes
fi

# 4) upgrade pip inside the new environment (you requested pip upgrade)
if [ -x "${ENV_PREFIX}/bin/python" ]; then
  echo "Upgrading pip inside ${ENV_PREFIX}"
  "${ENV_PREFIX}/bin/python" -m pip install --upgrade pip
else
  echo_stderr "WARNING: ${ENV_PREFIX}/bin/python not found; skipping pip upgrade."
fi

# 5) print a short success and activation instructions
cat <<EOF

SUCCESS: environment created at:
  ${ENV_PREFIX}

To activate this environment for users, they can source the shared conda hook and activate by prefix:
  source ${CONDA_ROOT}/etc/profile.d/conda.sh
  conda activate ${ENV_PREFIX}

Or place the following small wrapper (one-liner) somewhere shared and have users 'source' it:
  echo 'source ${CONDA_ROOT}/etc/profile.d/conda.sh && conda activate ${ENV_PREFIX}' > /path/to/shared/activate_shared_env.sh

Notes:
 - This script does NOT change filesystem permissions; you stated group perms are already configured.
 - If creating the environment fails due to concurrent activity, re-run this script (or run mamba/conda create manually).
 - If your cluster forbids executing from this mount, let me know and I can provide a micromamba PATH-based variant.

EOF