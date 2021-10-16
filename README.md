# EDFReader
## This respository is incomplete! Not intended for public use yet!

## System Requirements
You must be using MATLAB 2020b or greater and have the Signal Processing Toolbox to run this code.

## Details
This repository provides code to unpack, consolidate, and pre-process surgical case neuromonitoring data saved in a collection of EDF files.
Take a look at edf2mat.m, a script that provides a demonstration of how the functions included in this repository, in tandem with some additional processessing, can be used to fully unpack data from EDFs (currently focusing on EEG) so that it is ready for analysis.

To run edf2mat.m, first clone this repository. Modify the codePath, dataPath, and case_data variables (first section of code) appropriately to run on your machine. 
- codePath = path to directory containing all respository functions
- dataPath = path to directory that folder of case files is in (look at example in script)
- case_data = name of the folder of case files

