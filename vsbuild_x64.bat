@echo off
mkdir build64 > nul 2> nul
cd build64
cmake -DCMAKE_CONFIGURATION_TYPES="Debug;Release" -G"Visual Studio 14 2015 Win64" ..
pause
