clear
clc
close all
system('rm -f definemWaveSim.m  definemWaveSim.mlx  mWaveSimData.xml');
system('rm -rf mWaveSim');
clibgen.generateLibraryDefinition('../lib/src/cInterface/WaveSim.hpp',...
    'IncludePath', '../lib/include/',...
    'PackageName', 'mWaveSim',...
    'Libraries', '../lib/lib/libmCuWaveD.so');
build(definemWaveSim)
%[notfound,warnings] = loadlibrary('../lib/lib/libmCuWaveD.so', '../lib/src/cInterface/WaveSim.h');
%data = libfunctions('libmCuWaveD')
%unloadlibrary('libmCuWaveD');