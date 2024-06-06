tic
clear all
clc

% NOTE: The code currently only works for images of sizes 512x512. Editing might
% be required for making it compatible with images of other sizes

% User inputs
% Apterous mask
apterous_exp = imread('ap_mask\Label_ap_7.png');
apterous_bw = imbinarize(apterous_exp);
% tissue mask
tissue_exp = imread('tissue_mask\Label_7.png');
tissue_bw = imbinarize(tissue_exp);
% Corrected EpYseg output for the E.Cadherin channel
dcad_exp = imread('dcad_mask\oe_corrected_7.png');
cell_membrane_bw = ((dcad_exp));

roi_dcad_bw = logical((tissue_bw).*cell_membrane_bw);
roi_dcad_bw = imcomplement(roi_dcad_bw);
roi_dcad_bw = bwareafilt(roi_dcad_bw,[5 800]);
cells_label = bwlabel(roi_dcad_bw);
props_roi = regionprops(cells_label,'centroid','Area');
centroids_cells = cat(1,props_roi.Centroid);

se = strel('disk',2);
for i = 1:max(max(cells_label))
    (i/(max(max(cells_label))))*100
    k = 1;
    neighbours = [];
    for j = 1:max(max(cells_label))
        if (norm(centroids_cells(i,:)-centroids_cells(j,:)) <= 50)
        dummy1 = [];
        dummy1_bw = [];
        dummy1_bw_label = [];
        dummy1 = cells_label;
        dummy1 (dummy1 == j) = i;
        dummy1 (dummy1 ~= i) = 0;
        dummy1 (dummy1 == i) = 1;
        dummy1_bw = logical(dummy1);
        dummy1_bw = imdilate(dummy1_bw, se);
        dummy1_bw_label = bwlabel(dummy1_bw);
        nbrCheck = max(max(dummy1_bw_label));
        if nbrCheck == 1
            neighbours(k) = j;
            k = k + 1;
        end
        end
    end
    master_neighbours{i} = neighbours;
    polygon_nature(i) = k - 2;
end

bdry_tissue = cell2mat(bwboundaries(tissue_bw));
x_tissue = bdry_tissue(:,1);
y_tissue = bdry_tissue(:,2);
for i = 1:max(max(cells_label))
    xp = centroids_cells(i,1)
    yp = centroids_cells(i,2)
    distances_cells_bdry = []
    distances_cells_bdry = sqrt((x_tissue-yp).^2 + (y_tissue-xp).^2);
    if min(distances_cells_bdry) < 30
        polygon_nature(i) = 1
    end
end

for i = 1:max(max(cells_label))
    xp = round(centroids_cells(i,1))
    yp = round(centroids_cells(i,2))
    if apterous_bw(yp,xp) == 1
        ap_label(i,1) = 1
    else
        ap_label(i,1) = 0
    end
end
for i = 1:512
    for j = 1:512
        if cells_label(i,j) ~= 0
            map_dorsal(i,j) = ap_label(cells_label(i,j),1);
        end
    end
end

for i = 1:512
    for j = 1:512
        if cells_label(i,j) ~= 0
            map_polygon(i,j) = polygon_nature(cells_label(i,j));
        end
    end
end

%1-3 white
colormaping(1,1:3) =[255 255 255];
colormaping(2,1:3) =[255 255 255];
colormaping(3,1:3) =[255 255 255];
% 4 yellow
colormaping(4,1:3) =[255 255 51];
% 5 orange
colormaping(5,1:3) = [255 128 0];
% 6 dark green
colormaping(6,1:3) = [0 153 0];
%7 skyblue
colormaping(7,1:3) = [0 128 255];
%8 purple
colormaping(8,1:3) = [51 0 102];
% 9 pink
colormaping(9,1:3) = [255 0 127];
% 10 red 11 white
colormaping(10,1:3) = [255 0 0];
colormaping(11,1:3) = [255 255 255];
colormaping(12,1:3) = [255 255 255];
colormaping(13,1:3) = [255 255 255];
colormaping(14,1:3) = [255 255 255];
colormaping(15,1:3) = [255 255 255];
figure(1)
imshow(label2rgb(map_polygon,colormaping/255,'k'))

ctr = 1;
for i = 1:length(polygon_nature)
    if ap_label(i,1) == 1
        polygon_nature_dorsal(ctr) = polygon_nature(i);
        ctr = ctr + 1;
    end
end
ctr = 1;
for i = 1:length(polygon_nature)
    if ap_label(i,1) == 0
        polygon_nature_ventral(ctr) = polygon_nature(i);
        ctr = ctr + 1;
    end
end

m = []; n = zeros(10,1);
m = polygon_nature;
n(1) = sum(m(:) == 1)
n(2) = sum(m(:) == 2)
n(3) = sum(m(:) == 3)
n(4) = sum(m(:) == 4)
n(5) = sum(m(:) == 5)
n(6) = sum(m(:) == 6)
n(7) = sum(m(:) == 7)
n(8) = sum(m(:) == 8)
n(9) = sum(m(:) == 9)
n(10) = sum(m(:) == 10)
excluded = n(1) + n(2)
poly_ratio_global = n / (length(m)-excluded);

m = []; n = zeros(10,1);
m = polygon_nature_dorsal;
n(1) = sum(m(:) == 1)
n(2) = sum(m(:) == 2)
n(3) = sum(m(:) == 3)
n(4) = sum(m(:) == 4)
n(5) = sum(m(:) == 5)
n(6) = sum(m(:) == 6)
n(7) = sum(m(:) == 7)
n(8) = sum(m(:) == 8)
n(9) = sum(m(:) == 9)
n(10) = sum(m(:) == 10)
excluded = n(1) + n(2)
poly_ratio_dorsal = n / (length(m)-excluded);

m = []; n = zeros(10,1);
m = polygon_nature_ventral;
n(1) = sum(m(:) == 1)
n(2) = sum(m(:) == 2)
n(3) = sum(m(:) == 3)
n(4) = sum(m(:) == 4)
n(5) = sum(m(:) == 5)
n(6) = sum(m(:) == 6)
n(7) = sum(m(:) == 7)
n(8) = sum(m(:) == 8)
n(9) = sum(m(:) == 9)
n(10) = sum(m(:) == 10)
excluded = n(1) + n(2)
poly_ratio_ventral = n / (length(m)-excluded);

