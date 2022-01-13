function [outputs] = calcmeans_final(path,xlfile)
% CALCULATE AVERAGE STRESS AND STRAINS ACROSS ELEMENTS FOR EACH TIME STEP
% AND SAVE OUTPUTS 

 cd(path);
 elemstrains=load('elemstrains.mat'); elemstress=load('elemstress.mat');
 
 % add 0 time point
 outputs(1).time=0;outputs(1).xstrain=0;outputs(1).ystrain=0;
 outputs(1).xstress=0; outputs(1).ystress=0;
 
 % average strains and stresses for all elements
 for i=1:length(elemstrains.data)
     outputs(i+1).time=(elemstrains.data(i).time);
     outputs(i+1).xstrain=mean(elemstrains.data(i).loc(:,1));
     outputs(i+1).ystrain=mean(elemstrains.data(i).loc(:,2));
     outputs(i+1).xstress=mean(elemstress.data(i).loc(:,1));
     outputs(i+1).ystress=mean(elemstress.data(i).loc(:,2));
     
 end
 
 % only save data for specified time points
 tstps=[0;0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1];
 A=[outputs.time]; [LIA,LOCB] =ismember(A,tstps);
 outputs=outputs(LIA);

 save([path,(strcat(xlfile,'_outputs.mat'))],'outputs')
 
end

