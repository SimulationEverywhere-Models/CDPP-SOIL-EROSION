simu -mErosion.ma -t00:00:025:000 -loutput.log 

cd \eclipse\workspace\test\
remdim -d2 -lerosion.log

drawlog -mErosion.ma -lerosion0.log -cErosion -d0 > erosion0.drw
drawlog -mErosion.ma -lerosion1.log -cErosion -d1 > erosion1.drw
pause