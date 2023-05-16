
function MEA_process_spks(spk_file, output_folder, stim)
%   May 20223 by B Martin-Burgos
%   MEA_process(data_folder, wells2process)
%       spk_file: .spk file to be converted/processed 
%       output_folder: folder where resutls will be saved
%       stim: binary, determines whether there was stimulation in the file
%   MEA_process takes groups of Axion .spk files  and does the following:
%       - get spk times
%       - get stimulation event times and length (if stimulation was used)
%   spikes: bool
%       determines if spike detection is performed 
%   stim: bool
%       determines if stimulation event information is obtained 
warning('off')

% set up intake of spk data
if ~exist(output_folder)
    % if the folder doesn't exist, create and do conversion
    mkdir(output_folder);
end
% load the axion file into matlab
disp('Loading .spk file...')
file = AxisFile(spk_file);
all_spks = file.SpikeData.LoadData;



% compute plate dimension from file header
num_wells = length(unique([file.DataSets.ChannelArray.Channels.WellRow])) * ...
        length(unique([file.DataSets.ChannelArray.Channels.WellColumn])); 
disp(num_wells)


%parameters & loading data into MATLAB
if num_wells == 12
    %dimensions of the plate (# wells per row,col)
    plate_dim=[3,4];
    %number of channels per well
    num_chan=64;
    row = {'A','B','C'};
    col = {'1' '2' '3' '4'};
elseif num_wells==48
    %dimensions of the plate (# wells per row,col)
    plate_dim=[6,8]; %[6,8] or [3,4]
    %number of channels per well
    num_chan=16; %16 or 64
    chan_dim = [4,4];
    row = {'A','B','C' 'D','E','F'};
    col = {'1' '2' '3' '4' '5' '6' '7' '8'};
end

%get stimulation events for file if stim is True
if stim

    stim_events = sort([file.StimulationEvents(:).EventTime]); 
else
    stim_events = [];

end

%save stim data 
fileID_stim = fopen(sprintf([output_folder 'stim.txt']), 'a');
%print spike times for channel 
fprintf(fileID_stim, '%d\n',stim_events );
fclose(fileID_stim);


%gather wells & get spike times (and event times)
for i = 1:plate_dim(1)
   for j = 1:plate_dim(2)

      disp(sprintf('Well: (%i,%i)', i,j));  

     

      
      
      %loop through electrodes
      for c = 1:chan_dim(1)
        for k = 1:chan_dim(2)

            disp(sprintf('Channel: (%i,%i)', c,k));

            %load spike time data and check if electrode is empty 
            if length(all_spks{i,j,c,k}(:)) ~=0
                e_spks = [all_spks{i,j,c,k}(:).Start];
                
                



            else
                %if  empty - don't extract spikes 
                e_spks = [];
            end 
            fileID = fopen(sprintf([output_folder 'well_%i_%i_channel_%i_%i.txt'],i,j,c,k), 'a');
            %print spike times for channel 
            fprintf(fileID, '%d\n',e_spks );
            fclose(fileID);
            

            
            
        end
      end
      
   end
end

disp("done")


     
    
end