function [hist,tt] = updateSpdfsAdaptive(bc,roi,hist,ID,Mask,ml,tt)
% -------------------------------------------------------------------------
%   Explanation :  
%           This function updates the target model (spectral pdfs) by
%           averaging with the assigned blob's model
% -------------------------------------------------------------------------
rows = round(bc(ID,2)-bc(ID,4)):round(bc(ID,2)+bc(ID,4));
cols = round(bc(ID,1)-bc(ID,3)):round(bc(ID,1)+bc(ID,3));

% Filter the background pixels
roiTemp = reshape(roi,size(roi,1)*size(roi,2),size(roi,3));
Indexes = find(Mask==0);
roiTemp(Indexes,:) = 0;
roi = reshape(roiTemp,size(roi,1),size(roi,2),size(roi,3));

% Compute HSI Feature Vector for Each Band Subset
Inc_Index = 5;
for i = 1:ml.N_LMaps
   group_index = Inc_Index * (i - 1) + 1;
   for j = 1:3
        [sphist]=feval([ml.Feature_Extraction],roi(rows,cols,group_index:Inc_Index:group_index+4));
        hist.reference_first{j,i} =  (0.9 * hist.reference_first{j,i} + 0.1 * sphist);
   end
end
