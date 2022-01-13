function [T,xlfile] = ImageMeasurements_final(s,sampledir,imfile)
% IMAGE ANALYSIS CODE
% INPUTS: s- number of image windows (sxs), sampledir- directory with
% images, imfile- image file

% OUTPUTS: T- matrix with mean measurments output per image, xlfile- excel
% file with fiber vectors per image window

cd(sampledir);image_og=imread(imfile); % read in image
image_og = imresize(image_og, [1024 1024]);
%% SET SLIDING WINDOW FOR LOCAL MEASUREMENTS 
        [i_h i_w g]=size(image_og); % height and width of original image
        iw_h=(1/s)*i_h; iw_w=(1/s)*i_w; % image window size
        c=1; % count
        m0=1;
        for m=1:s % fix column, slide down vertically
            n0=1;
            for n=1:s % sliding horizontally across columns 
            iw=image_og(n0:iw_h.*n,m0:iw_w.*m); % image window
            imbin=imbinarize(iw); % binarize
     
            % CALCULATE COLLAGEN AREA PERCENTAGE
            area_window(c)=sum(imbin,'all')./(iw_h*iw_w); % sum pixels where fiber (white=1)
           
            % CALCULATE PEAK RADON TRANSFORM IN EACH WINDOW TO MEASURE
            % COLLAGEN PREFFERED DIRECTION (CPD)
            theta=0:179; % range for radon transform (0-179 degrees)
            sensitivity=0.1; % sensitivity for canny edge detection
            edges=edge(imbin,'canny',sensitivity); % edge detection
            [R,xp] = radon(edges,theta); % compute radon transform at edges
                for j=1:length(theta)  % theta value (degrees)
                    maxR(j)=max(R(:,j)); % peak of radon transform
                end          
             tIndex = find(maxR == max(maxR),1); % location of geatest peak of radon transform
             [cpd(c)] = theta(tIndex); % theta at geatest peak of radon transform
             [Rpeak(c)]=max(maxR); % peak radon transform value
             if sum(edges,'all')==0 % if no fibers detected, cpd measurement is excluded
                 cpd(c)=NaN;
             end
             
             if (cpd(c) >=0) & (cpd(c) <=90)
                 cpd(c) =cpd(c)+90;
             elseif (cpd(c) >90) & (cpd(c) <=180)
                 cpd(c) =cpd(c)-90;
             end
             
             grid(n,m)=cpd(c); % convert vector of fiber directions into matrix (for FeBio model)
            
            n0=n0+iw_h;
            c=c+1;
            end
            m0=m0+iw_w;
        end
 %% AVERAGE VALUES ACROSS IMAGE WINDWOWS FOR IMAGE AND SAVE OUTPUTS 
cd('C:\Users\rs8te\OneDrive - University of Virginia\Documents\FinalSEMFEMCode\') % folder with circstats functions
% convert radon transform outputs for directions measured in FeBio
% calculate mean, resultant vector, and save cpd_rel vector (convert to radians)

% SAVE FIBER VECTOR FOR FEBIO MODELS
 cpd_rel=flipud(grid); %convert to element numbering in FeBio
 cpd_rel=cpd_rel(:); cpd_rel=deg2rad(cpd_rel); % convert to radian
 cpd_vect(:,1)=cos(cpd_rel); cpd_vect(:,2)=sin(cpd_rel); cpd_vect(:,3)=0; % set x, y, z components
 cpd_vect(isnan(cpd_vect)) = 0; % if no fiber detected in window, set vect to 0
 cpd_rel = cpd_rel(~isnan(cpd_rel)); %exclude NaN where no fibers were detected 
 
% IMAGE MEASURMENTS 
 R=circ_r(cpd_rel); % strength of alignment measurement
 cpd_rel_mean=rad2deg(circ_mean(cpd_rel)); % mean fiber direction in degrees
% convert mean fiber direction to acute angle     
        if cpd_rel_mean > 90
            cpd_rel_mean = 180-cpd_rel_mean;
        end        
cap_mean=mean(area_window); % mean collagen area percentage
rad_mean=mean(Rpeak); % mean peak of radon transform

T(1,1:5)= [s,R,cpd_rel_mean,cap_mean,rad_mean]; % table with mean image measurments (output from this function)

cd(sampledir)
xlfile=sprintf('%s',imfile); xlfile=erase(xlfile,'.tif'); % name excel file based on image name
writetable(table(cpd_vect),strcat(xlfile,'.xlsx')) % save fiber vectors in excel file 

end 




