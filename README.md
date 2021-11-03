# AxionFileLoader

This repository contains Matlab loaders for Axion BioSystem's AxIS and AxIS Navigator files. It enables extraction of raw voltage, spike times and waveforms, viability, contractility data, and stimulation timing from Axion's .raw and .spk files. 

## Example usage

### Voltage data from a raw file 
Voltage data is loaded in as a 4-D channel array structure. Data is indexed as well row, well column, electrode column, electrode row.

```matlab
%load all voltage data
Data = AxisFile(‘Filename.raw’).RawVoltageData.LoadData; 
%Alternatively, load voltage data from Well A2 Electrode 31 from 10 s to 30 s
Data = AxisFile(‘Filename.raw’).RawVoltageData.LoadData(‘A2’,’31’,[10 30]); 
```

Then, isolate the properly scaled data of interest. 
```matlab
[time,voltage] = Data{1,2,3,1}.GetTimeVoltageVector; %well A2 electrode 31
```

### Contractility data from a raw file figure
Contractility data is loaded in as a 4-D channel array structure. Data is indexed as well row, well column, electrode column, electrode row.

```matlab
%load all voltage data
Data = AxisFile(‘Filename.raw’).RawContractilityData.LoadData; 
%Alternatively, load voltage data from Well E4 Electrode 12 from 120 s to 180 s
Data = AxisFile(‘Filename.raw’).RawContractilityData.LoadData(‘E4’,’12’,[120 180]); 
```

Then, isolate the properly scaled data of interest. 
```matlab
[time,contrac] = Data{5,4,3,1}.GetTimeVoltageVector; 
```

### Spike times and waveforms from a spk file 
Spike timing, channel location, and waveforms are all stored in .spk files. 
```matlab
%load all spike data
Data = AxisFile(‘Filename.spk’).SpikeData.LoadData; 
```

Then, isolate the properly scaled data of interest. 
```matlab
spikeTimes = [Data{3,2,2,1}(:).Start]; %all spike times in Well B2 Electrode 21
spikeWaveform = Data{3,2,2,1}(1).GetVoltageVector; %spike waveform of the 1st spike on Well B2 Electrode 21
```

### Stimulation tag timing 
Note that timestamps are only available if your stimulation included a tag (inverted triangle). A tag is automatically included for Brain and Heart pre-configured blocks. 
```matlab 
Data = AxisFile('Filename.raw'); 
evts = sort([Data.StimulationEvents(:).EventTime]); 
```

For more details, please refer to the Wiki. 

## Current Version

This initial release (1.0.0.0) is the first Open Source release of this code. It
supports the Axis Suite verison 3.5.

## Changelog

1.0.0.0 - Initial public release!
