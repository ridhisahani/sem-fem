function [data] = reformat_final(path,input_old)
% REFORMAT OUTPUTS FROM FEBIO SIMULATIONS INTO .MAT FORMAT FOR ANALYSIS

% reformat txt file
input_new=(strcat(input_old,'_new'));
rawdata=(strcat(input_old,'.txt')); newdata=(strcat(input_new,'.txt'));

rawfilefull = [path,rawdata];
txt = fileread(rawfilefull); txtCell = strsplit(txt, newline)'; 
hasPattern = regexp(txtCell, '*[S|D]'); % searching for * Steps and * Data lines
rowIdx = find(~cellfun(@isempty, hasPattern));  % row numbers that will be replaced
txtCell(rowIdx)=[]; % delete rows with pattern
fid = fopen([path,newdata], 'wt'); 
fprintf(fid, [txtCell{:}]); fclose(fid);

% convert to .mat
infilefull = [path,newdata];
buffer  = fileread(infilefull);
% find time and data tokens based on regular expressions
pattern = '*Time\s\s=\s(?<time>\S+)\s*(?<data>.*?)(?=($|*Time))';
blocks = regexp(buffer, pattern, 'names' );
% blocks = 1x10 struct array with fields:
%     time
%     data
%
% 'blocks' is string, so use textscan to read into cell
for k = 1:length(blocks) %for every timepoint in logfile
    tempdata = textscan(blocks(k).data,'%f %f %f %f %f %f %f');
    tempmat = cell2mat(tempdata);
    % filter nearly zero components to zero 
    data(k).time = str2double(blocks(k).time);
    data(k).loc = tempmat(:,2:6);
    clear tempdata tempF tempmat
end

 save([path,(strcat(input_old,'.mat'))],'data')
end

