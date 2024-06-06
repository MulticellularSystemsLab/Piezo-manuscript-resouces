tic
clear all
clc
% Input data
% Mask for apterous or dorsal compartment
apterous_exp = imread('ap_mask\Label_ap_9.png');
apterous_bw = imbinarize(apterous_exp);
% Tissue mask (ROI for analysis)
tissue_exp = imread('tissue_mask\Label_9.png');
tissue_bw = imbinarize(tissue_exp);
% Corrected EpySeg output
dcad_exp = imread('dcad_mask\oe_corrected_9.png');
cell_membrane_bw = ((dcad_exp));

dorsal_bw = logical(apterous_bw.*cell_membrane_bw);
dorsal_bw = imcomplement(dorsal_bw);
dorsal_bw = bwareafilt(dorsal_bw,[5 800]);

ventral_bw = logical((imcomplement(apterous_bw)).*cell_membrane_bw);
ventral_bw = imcomplement(ventral_bw);
ventral_bw = bwareafilt(ventral_bw,[5 800]);

cells_label_dorsal = bwlabel(dorsal_bw);
props_dorsal = regionprops(cells_label_dorsal,'centroid','Area','Circularity','MajorAxisLength','MinorAxisLength');
area_dorsal_cells = cat(1,props_dorsal.Area);
circulariy_dorsal_cells = cat(1,props_dorsal.Circularity);
ma_dorsal = cat(1,props_dorsal.MajorAxisLength);
mi_dorsal = cat(1,props_dorsal.MinorAxisLength);
anisotropy_dorsal_cells = (ma_dorsal - mi_dorsal) ./ (ma_dorsal + mi_dorsal);

mean_area_dorsal = mean(area_dorsal_cells);
mean_circ_dorsal = mean(circulariy_dorsal_cells);
mean_anis_dorsal = mean(anisotropy_dorsal_cells);

cells_label_ventral = bwlabel(ventral_bw);
props_ventral = regionprops(cells_label_ventral,'centroid','Area','Circularity','MajorAxisLength','MinorAxisLength');
area_ventral_cells = cat(1,props_ventral.Area);
circulariy_ventral_cells = cat(1,props_ventral.Circularity);
ma_ventral = cat(1,props_ventral.MajorAxisLength);
mi_ventral = cat(1,props_ventral.MinorAxisLength);
anisotropy_ventral_cells = (ma_ventral - mi_ventral) ./ (ma_ventral + mi_ventral);

mean_area_ventral = mean(area_ventral_cells);
mean_circ_ventral = mean(circulariy_ventral_cells);
mean_anis_ventral = mean(anisotropy_ventral_cells);

mean_area_global = mean(vertcat(area_dorsal_cells,area_ventral_cells));
mean_circ_global = mean(vertcat(circulariy_dorsal_cells,circulariy_ventral_cells));
mean_anis_global = mean(vertcat(anisotropy_dorsal_cells,anisotropy_ventral_cells));

map_area = zeros(512,512);
for i = 1:512
    for j = 1:512
        if cells_label_dorsal(i,j) ~= 0
            map_area(i,j) = area_dorsal_cells(cells_label_dorsal(i,j));
        end
    end
end
for i = 1:512
    for j = 1:512
        if cells_label_ventral(i,j) ~= 0
            map_area(i,j) = area_ventral_cells(cells_label_ventral(i,j));
        end
    end
end

figure()
imagesc(map_area)
title('Cell Area (in pixels*pixels)')
colorbar

%Printing statistics
fprintf('Mean dorsal cell area is %.2f\n', mean_area_dorsal);
fprintf('Mean ventral cell area is %.2f\n', mean_area_ventral);
fprintf('Mean global cell area is %.2f\n', mean_area_global);

fprintf('Mean dorsal anisotropy is %.2f\n', mean_anis_dorsal);
fprintf('Mean ventral anisotropy is %.2f\n', mean_anis_ventral);
fprintf('Mean global anisotropy is %.2f\n', mean_anis_global);

fprintf('Mean dorsal circularity is %.2f\n', mean_circ_dorsal);
fprintf('Mean ventral circularity is %.2f\n', mean_circ_ventral);
fprintf('Mean global circularity is %.2f\n', mean_circ_global);
