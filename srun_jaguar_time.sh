#!/bin/bash -v

#SBATCH --job-name=jaguar-time   		# Job name
#SBATCH --output output-jaguar-time.%J  # Job output
#SBATCH --partition=SP2
#SBATCH --ntasks=20              		# number of tasks / mpi processes
#SBATCH --cpus-per-task=1       		# Number OpenMP Threads per process
#SBATCH --time=140:00:00
#SBATCH --mail-type=ALL                 # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=mario.neto@usp.br   # Email to which notifications will be sent

#OpenMP settings:
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread

echo $SLURM_JOB_ID              #ID of job allocation
echo $SLURM_SUBMIT_DIR          #Directory job where was submitted
echo $SLURM_JOB_NODELIST        #File containing allocated hostnames
echo $SLURM_NTASKS              #Total number of cores for job

# module swap gnu intel/18.0.2.199

# Run tasks:

for i in {1..27}; do
    if [[ "$i" == 21 ]]; then
		continue
	fi

    srun -n1 -N1 --job-name="Time${i}b" --exclusive ./docker_jaguar.sh Time "${i}b" &
    srun -n1 -N1 --job-name="Time${i}f" --exclusive ./docker_jaguar.sh Time "${i}f" &
done

wait

srun -n1 -N1 --job-name="Zip Time" --exclusive zip -r jacksondatabind.zip output/joda-time
srun -n1 -N1 --job-name="Clean Time" --exclusive rm -rf output/joda-time