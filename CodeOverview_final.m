tic
% SET WORKING DIRECTORIES AND INPUTS (SEM IMAGES AND BASELINE FE
% MODEL)
clear all; close all; clc; 
group='Test2'; % group files based on test group (ex: 3-month-old mdx)
baselinemodel='BaselineFeModel.xml'; % baseline FeBio model used for models 
sampledir=strcat('C:\Users\rs8te\OneDrive - University of Virginia\Documents\FinalSEMFEMCode\',group,'\Images\'); % input folder with images
modeldir=strcat('C:\Users\rs8te\OneDrive - University of Virginia\Documents\FinalSEMFEMCode\',group,'\Models\'); % output folder for models
outputdir=strcat('C:\Users\rs8te\OneDrive - University of Virginia\Documents\FinalSEMFEMCode\',group,'\Outputs\'); % output folder for image and model measurments
febiodir='C:\"Program Files"\FEBio2.9\bin\FEBio2.exe';
codedir='C:\Users\rs8te\OneDrive - University of Virginia\Documents\FinalSEMFEMCode\'; % folder with required matlab functions 

%% IMAGE ANALYSIS

cd(sampledir); files = dir(sampledir); dirFlags = [files.isdir]; folders=files(dirFlags); subFolders = files(dirFlags);    
files = dir(fullfile('*.tif')); % get all tif image files in folder
s=64; % set image window size (sxs)

% loop through each image in folder to the image analysis function
for k=1:max(size(files)) 
imfile=files(k).name; % select image
cd(codedir); [T(k,:) xlfile]=ImageMeasurements_final(s,sampledir,imfile); % outputs excel file with fiber vectors and table with mean image measurements 
rownames(k)={erase(imfile,'.tif')}; % save image name for table
end

% table with mean image measurments for all images in folder
varnames={'Sample','windowsize','R','cpd','caf','Rpeak'};
t=table(rownames',T(:,1),T(:,2),T(:,3),T(:,4),T(:,5),'VariableNames',varnames); 

save([outputdir,(strcat(group,'_imanalysis.mat'))],'t'); % .mat file with outputs
cd(outputdir); writetable(t,(strcat(group,'_imanalysis.xlsx'))); % . xlsx file with outputs

%% GENERATE AND RUN FEBIO MODELS

% loop through models for folder
 cd(sampledir); files = dir(sampledir); dirFlags = [files.isdir]; folders=files(dirFlags); subFolders = files(dirFlags);    
 files = dir(fullfile('*.xlsx')); % get all excel files in folder 

for k=1:max(size(files))
    xlfile=files(k).name; xlfile=erase(xlfile,'.xlsx');cd(codedir); 
    FEfile=FeBioGen_final(xlfile,baselinemodel,sampledir,modeldir,codedir); % generate FeBio file 
    
    % run model in FeBio
    cmd_cell = [febiodir,{' '},'-i',{' '},'"',modeldir,'\' FEfile,'"'];
    cmd_str = strjoin(cmd_cell,''); % format model name

    display('running febio main analysis');
    [result_flag] = system(cmd_str);
    display('febio run finished')

    if result_flag~=0
        display('error termination')
    end

    % convert .txt febio outputs to .mat and reformat
    cd(codedir); path=modeldir;
    input_old='elemstress'; reformat_final(path,input_old);
    input_old='elemstrains'; reformat_final(path,input_old);
    
    % calc avgerage element stress and strains for each model time step
    calcmeans_final(path,xlfile);

    terminations(1,k)=result_flag;

end

% display whether models ran sucessfully or any failures
display('Failed Models (termination=1)');
terminations

%% CALCULATE STIFFNESSES FROM FEBIO OUTPUTS

close all;
cd(modeldir); files = dir(sampledir); dirFlags = [files.isdir]; folders=files(dirFlags); subFolders = files(dirFlags);    
files = dir(fullfile('*_outputs.mat')); % get all .mat files in folder

for k=1:max(size(files))
    out=load(files(k).name); % load .mat file with average element values per time step
    [sample(k).name]=files(k).name; % create struct for calculations
    txt=erase(files(k).name,'_outputs.mat');
    [sample(k).data]=out.outputs;
    
    % save stress and strains from struct
    xstrain=[sample(k).data.xstrain]; xstress=[sample(k).data.xstress];
    ystrain=[sample(k).data.ystrain]; ystress=[sample(k).data.ystress];
   
    % interpolate stress at 20% strain
    Ex=0:0.01:0.2;  Ey=0:0.01:0.2; % strain in 1% increments to 20%
    Sx=interp1(xstrain,xstress,Ex); Sy=interp1(ystrain,ystress,Ey); % interpolate stress at 20% strain
    
    % calc stiffness at 20% strain with polyfit 
    p=polyfit(Ex(17:21),Sx(17:21),1); kx_20(k)= p(1); % longitudinal (x) stiffness
    p=polyfit(Ey(17:21),Sy(17:21),1); ky_20(k)= p(1); % transverse (y) stiffness
    kr_20(k)=ky_20(k)./kx_20(k); % stiffness ratio (y/x)

    % save stiffness values for table
    T(k,1:3)= [kx_20(k),ky_20(k),kr_20(k)];
    rownames(k)=cellstr(txt);   
end

% save stiffness values for all models in folder 
varnames={'Sample','kx','ky','kr'}; 
t=table(rownames',T(:,1),T(:,2),T(:,3),'VariableNames',varnames);
save([outputdir,(strcat(group,'_stiffness.mat'))],'t'); % .mat file with outputs
cd(outputdir); writetable(t,(strcat(group,'_stiffness.xlsx'))); % .xlsx file with outputs
toc

    