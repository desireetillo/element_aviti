#!/bin/bash
#SBATCH --job-name=bases2fastq
#SBATCH --output=bases2fastq.%j.out
#SBATCH --error=bases2fastq.%j.err
#SBATCH --cpus-per-task=20
#SBATCH --mem=80g
#SBATCH --time=02:00:00
#SBATCH --gres=lscratch:800
#SBATCH --partition=norm

IN=$1
OUT=$2
shift 2
EXTRA_ARGS="$@"

echo "Loading environment" 

# load environment, and multiqc
source /data/Seq37H/Element/Scripts/start_conda.sh
module load multiqc/1.34

# set up local scratch and tmpdir for bases2fastq
if [ -n "${SLURM_TMPDIR-}" ]; then
    LOCAL_SCRATCH="$SLURM_TMPDIR"
else
    LOCAL_SCRATCH="/lscratch/$SLURM_JOB_ID"
fi

mkdir -p "$LOCAL_SCRATCH"

# Bases2Fastq recommendation:
export TMPDIR="$LOCAL_SCRATCH"

echo "Using LOCAL_SCRATCH: $LOCAL_SCRATCH"
echo "TMPDIR set to: $TMPDIR"

echo "*************************************"
echo "Starting to process the directory $IN"
echo "*************************************"

if [ -d "$IN/$OUT" ]; then
   echo "$OUT directory exists."
else
   echo "Making $OUT directory"
   mkdir -p "$IN/$OUT"
fi

./bin/bases2fastq "$IN" "$IN/$OUT" \
    -p "$SLURM_CPUS_PER_TASK" \
    --no-projects \
    --group-fastq \
    $EXTRA_ARGS
