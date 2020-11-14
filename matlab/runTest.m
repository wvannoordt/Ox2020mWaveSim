clear
clc
close all
%Don't forget to have the so files on LD_LIBRARY_PATH !
dobuild = true;
if (dobuild)
    buildPackage
end
addpath("./mWaveSim");
clib.mWaveSim.Initialize(512, 512);