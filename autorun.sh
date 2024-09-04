#!/bin/bash

## global env vars
#source ~/.bashrc
source ../setenv_WRF_CMAQ.sh
export rundate=20220702
export runhour=00
export runlen=48

export SJDATE=$(date +%Y%j -d $rundate)
export SYYYY=${rundate:0:4}
export SMM=${rundate:4:2}
export SDD=${rundate:6:2}
export SHH=${runhour}

export enddate=$(date +%Y%m%d -d "$rundate $runhour $runlen hours")
export EJDATE=$(date +%Y%j -d $enddate)
export EYYYY=${enddate:0:4}
export EMM=${enddate:4:2}
export EDD=${enddate:6:2}
export EHH=${runhour}

echo $SYYYY
echo $SMM
echo $SDD

echo $EYYYY 
echo $EMM
echo $EDD

export M3SCRIPT=..../dylan/autorun_scripts # Revise!!

export LOGDIR=${M3SCRIPT}/logs
[[ ! -d $LOGDIR/$rundate$runhour ]] && mkdir -p $LOGDIR/$rundate$runhour

set -x 
#### model run
# step 1: check wrfout
cd ..../dylan/WRF/WRFV3/run # Revise!!
export wrfout=wrfout_d03_${SYYYY}-${SMM}-${SDD}_00:00:00
if [[ ! -f $wrfout ]]; then
  echo "# file $wrfout not found!"
  exit 1
else
  echo "# file $wrfout found:"
  ls -l $wrfout
fi

# step 2: mcip
cd ${M3SCRIPT}
time ./run_mcip.csh |& tee $LOGDIR/$rundate$runhour/run_mcip.log

# step 3: icon
time ./run_icon.csh |& tee $LOGDIR/$rundate$runhour/run_icon.log

# step 4: bcon
time ./run_bcon.csh |& tee $LOGDIR/$rundate$runhour/run_bcon.log

# step 5: emisproc
time ./run_emisproc.csh |& tee $LOGDIR/$rundate$runhour/run_emisproc.log

# step 6: cctm
time ./run_cctm.csh |& tee $LOGDIR/$rundate$runhour/run_cctm_${cdate}.log

exit 0
