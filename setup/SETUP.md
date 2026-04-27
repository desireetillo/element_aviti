# Setup steps for conda environment for bases2fastq from element

1. Miniforge install

```
    cd setup
    wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
    bash Miniforge3-Linux-x86_64.sh -p /data/Seq37H/Element/conda -b
```


2. Create *environment.yml* file given dependencies from [setup instructions](https://docs.elembio.io/docs/bases2fastq/setup/)

3.  Create environment 

    `bash create_env.sh`

4.  Load environment
    
         source /data/Seq37H/Element/start_conda.sh

