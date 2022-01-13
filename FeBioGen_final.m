function [FEfile] = FeBioGen_final(xlfile,baselinemodel,sampledir,modeldir,codedir)
% FEBIO MODEL GENERATION CODE
% INPUTS: xlfile- name of file with fiber vectors, baselinemodel- FeBio
% model (.xml) where fiber vectors will be assigned, sampledir- directory with
% images, modeldir- directory to save models into, codedir- directory with
% code and baseline model

% LOAD IN VECTOR DIRECTIONS FOR EACH ELEMENT
cd(sampledir); cpd=xlsread(strcat(xlfile,'.xlsx'));

% LOAD BASELINE FEBIO MODEL(.xml)
cd(codedir); main_input_file = baselinemodel;

% READ INPUT XML FILE AND ASSIGN TO STRUCT e 
e = xml2struct2(main_input_file);

% REWRITE VECTOR DIRECTIONS
for k=1:length(e.febio_spec.MeshData.ElementData.elem);
e.febio_spec.MeshData.ElementData.elem{1, k}.a.Text=[num2str(cpd(k,1)),',',num2str(cpd(k,2)),',',num2str(cpd(k,3))]; % collagen
e.febio_spec.MeshData.ElementData.elem{1, k}.d.Text=[num2str(0),',',num2str(0),',',num2str(1)]; % muscle fiber
end

% SAVE NEW XML WITH CORRESPONDING VECTOR DIRECTIONS
FEfile=strcat(xlfile,'.xml');
struct2xml2(e,FEfile); 
movefile(FEfile,modeldir)% saving into model outputs folder

end

