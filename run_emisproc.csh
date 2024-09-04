#!/bin/csh -f

set GRID_NAME = case1 
set EXEC = /home/test/models/CMAQ/scripts/emisproc/emis_update_datetime
set EMIS_DIR = ${CMAQ_DATA}/emis
set INPUT_DIR = ${CMAQ_DATA}/emis_bak

set COL = 85
set ROW = 85
set LEV = 37
set TIME = 25
set VAR = 48

echo $rundate $enddate

cd ${EMIS_DIR}
cp ${INPUT_DIR}/emis.case1.ncf EM_${GRID_NAME}
set cdate = $rundate  # current date yyyymmdd
while ( $cdate < $enddate )
  set ndate = `date +%Y%m%d -d "$cdate 1 days"`  # next date yyyymmdd
  echo $cdate $ndate
  set cjdate = `date +%Y%j -d $cdate`
  set njdate = `date +%Y%j -d $ndate`

  rm -rf emis_MEIC_${GRID_NAME}_${cjdate}.ncf
  ${EXEC} $cjdate $njdate
  cp EM_${GRID_NAME} emis_MEIC_${GRID_NAME}_${cjdate}.ncf

  set cdate = $ndate
end
rm -rf EM_${GRID_NAME}
