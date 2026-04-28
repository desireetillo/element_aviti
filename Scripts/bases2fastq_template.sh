#!/bin/bash
#SBATCH --job-name=bases2fastq
#SBATCH --output=bases2fastq.%j.out
#SBATCH --error=bases2fastq.%j.err
#SBATCH --cpus-per-task=20
#SBATCH --mem=80g
#SBATCH --time=02:00:00
#SBATCH --gres=lscratch:800
#SBATCH --partition=norm

# resource recommendations from https://docs.elembio.io/docs/bases2fastq/setup/

echo "Loading environment" 

# load environment, and multiqc
source /data/Seq37H/Element/Scripts/start_conda.sh
module load multiqc/1.34

# set up local scrath and tmpdir for bases2fastq

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
echo "Starting to process the directory $1"
echo "*************************************"
if [ -d $1/OUTPUT ]; then
   echo "OUTPUT directory exists."
else
   echo "Making OUTPUT directory"
   mkdir $1/OUTPUT
fi

./bin/bases2fastq $1 $1/OUTPUT -p $SLURM_CPUS_PER_TASK 
