@echo off
mkdir build64 > nul 2> nul
cd build64
set CMAKE_PREFIX_PATH=C:\Qt\Qt5.7.0\5.7\msvc2015_64
cmake -G"Visual Studio 14 2015 Win64" ..
pause
