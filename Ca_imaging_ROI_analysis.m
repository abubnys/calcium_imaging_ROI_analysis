%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Ca imaging analysis of CFP/GFP+ cultures
%
%   identify CFP+ and GFP+ cells and measure their calcium activity
%   
%   due to the overlap of CFP and GFP emission spectra, GFP+ cells tend to
%   show up on CFP channel along with CFP+ cells, CFP+ cells do not show up
%   on GFP+ channel
%
%   so, first identify GFP+ cells, then overlay GFP+ ROIs on CFP image and
%   identify CFP+ cells as ones that have not already been marked
%
%   the script saves the images of GFP+, CFP+, and Rhod3+ neurons and their
%   ROIs, and the plot of average ROI intensities colored by cell type
%   
%   also, saves the following variables:
%       1. gfp_roi_lst : coordinates for identified ROI bounds of GFP+
%       cells
%       2. gfp_legend_names : the corresponding numerical assignments for
%       each GFP+ ROI
%       3. cfp_roi_lst : coordinates for identified ROI bounds of CFP+
%       cells
%       4. cfp_legend_names : the corresponding numerical assignments for
%       each CFP+ ROI
%       5. ca_roi_lst : coordinates for identified ROI bounds of CFP-/GFP-
%       Rhod+ cells
%       6. ca_legend_names : the corresponding numberical assignments for
%       each Rhod+ ROI
%       7. mean_gfp_lst : the average fluorescence of each GFP+ ROI for
%       each frame of the recording
%       8. mean_cfp_lst : the average fluorescence for each CFP+ ROI for each frame
%       of the recording
%       9. mean_ca_lst : the average fluorescence for each Rhod+ ROI for
%       each frame of the recording
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data
close all
clear

fpath = '/Users/abubnys/Desktop/Pfaff_Lab/ca_imaging/Ca imaging data/on DP rig/chx_eMN_8-1-18/OxA/';
gfpnom = 'gfp2';
canom = 'rhod2';
cfpnom = 'cfp2';

% if the experiment contains GFP+ motor neurons, set is_gfp to 1, otherwise set it to 0
is_gfp = 1;
% if the experiment contains CFP+ hindbrain neurons, set is_cfp to 1, otherwise set it to 0
is_cfp = 1;

stack_size = 400;
tot_time = 39.845;
mkdir([fpath canom])

%% identify GFP+ ROIs
if is_gfp == 1
    figure
    gfp_img = imread([fpath gfpnom '.tif']);
    
    colormap gray
    imageHandle = imagesc(gfp_img);
    
    title('gfp')
    hold on
    
    cell_find = 0;
    gfp_roi_lst = [];
    gfp_cell_num = 1;
    
    identify_cell = 1;
    any_cells = input('cells to identify? (y=1)');
    if any_cells == 1
        while identify_cell ~= 0
            
            dcm_obj = datacursormode;
            
            datacursormode on
            
            disp('click top left corner of ROI, then return')
            % Wait while the user does this.
            pause
            c_info = getCursorInfo(dcm_obj);
            roi1 = c_info.Position;
            dcm_obj.removeAllDataCursors()
            
            disp('click bottom right corner of ROI, then return')
            % Wait while the user does this.
            pause
            c_info = getCursorInfo(dcm_obj);
            roi2 = c_info.Position;
            dcm_obj.removeAllDataCursors()
            
            line([roi1(1) roi2(1) roi2(1) roi1(1) roi1(1)],[roi1(2) roi1(2) roi2(2) roi2(2) roi1(2)],'Color','g')
            roi_ok = input('good roi? (y=1, n=0) ');
            if roi_ok == 1
                gfp_roi_lst = [gfp_roi_lst; roi1 roi2];
                text(mean([roi1(1) roi2(1)]),mean([roi1(2) roi2(2)]),num2str(gfp_cell_num),'Color','g','FontSize',14)
                gfp_cell_num = gfp_cell_num+1;
            else
                children = get(gca, 'children');
                delete(children(1));
            end
            identify_cell = input('find another cell? (y=1, n=0) ');
        end
        dcm_obj.removeAllDataCursors()
    end
end


%% identify CFP+ ROIs
if is_cfp == 1
    figure
    cfp_img = imread([fpath cfpnom '.tif']);
    
    colormap gray
    imageHandle = imagesc(cfp_img);
    
    title('cfp')
    hold on
    
    % draw ROIs of GFP+ cells
    if is_gfp == 1
        for e = 1:size(gfp_roi_lst,1)
            line([gfp_roi_lst(e,1) gfp_roi_lst(e,3) gfp_roi_lst(e,3) gfp_roi_lst(e,1) gfp_roi_lst(e,1)],[gfp_roi_lst(e,2) gfp_roi_lst(e,2) gfp_roi_lst(e,4) gfp_roi_lst(e,4) gfp_roi_lst(e,2)],'Color','g')
            text(mean([gfp_roi_lst(e,1) gfp_roi_lst(e,3)]),mean([gfp_roi_lst(e,2) gfp_roi_lst(e,4)]),num2str(e),'Color','g','FontSize',14)
        end
    end
    
    % identify new ROIs
    cell_find = 0;
    cfp_roi_lst = [];
    cfp_cell_num = 1;
    
    identify_cell = 1;
    any_cells = input('cells to identify? (y=1)');
    if any_cells == 1
        while identify_cell ~= 0
            
            dcm_obj = datacursormode;
            datacursormode on
            
            disp('click top left corner of ROI, then return')
            % Wait while the user does this.
            pause
            c_info = getCursorInfo(dcm_obj);
            roi1 = c_info.Position;
            dcm_obj.removeAllDataCursors()
            
            disp('click bottom right corner of ROI, then return')
            % Wait while the user does this.
            pause
            c_info = getCursorInfo(dcm_obj);
            roi2 = c_info.Position;
            dcm_obj.removeAllDataCursors()
            
            line([roi1(1) roi2(1) roi2(1) roi1(1) roi1(1)],[roi1(2) roi1(2) roi2(2) roi2(2) roi1(2)],'Color','c')
            roi_ok = input('good roi? (y=1, n=0) ');
            if roi_ok == 1
                cfp_roi_lst = [cfp_roi_lst; roi1 roi2];
                text(mean([roi1(1) roi2(1)]),mean([roi1(2) roi2(2)]),num2str(cfp_cell_num),'Color','c','FontSize',14)
                cfp_cell_num = cfp_cell_num+1;
            else
                children = get(gca, 'children');
                delete(children(1));
            end
            identify_cell = input('find another cell? (y=1, n=0) ');
        end
        dcm_obj.removeAllDataCursors()
    end
end
%% identify CFP-/GFP- cells

figure
ca_img = imread([fpath canom '.tif']);

colormap gray
imageHandle = imagesc(ca_img);
%axis image;
title('rhod')
hold on

% draw ROIs of GFP+ cells
if is_gfp == 1
    for e = 1:size(gfp_roi_lst,1)
        line([gfp_roi_lst(e,1) gfp_roi_lst(e,3) gfp_roi_lst(e,3) gfp_roi_lst(e,1) gfp_roi_lst(e,1)],[gfp_roi_lst(e,2) gfp_roi_lst(e,2) gfp_roi_lst(e,4) gfp_roi_lst(e,4) gfp_roi_lst(e,2)],'Color','g')
        text(mean([gfp_roi_lst(e,1) gfp_roi_lst(e,3)]),mean([gfp_roi_lst(e,2) gfp_roi_lst(e,4)]),num2str(e),'Color','g','FontSize',14)
    end
end
% draw ROIs of CFP+ cells
if is_cfp == 1
    for e = 1:size(cfp_roi_lst,1)
        line([cfp_roi_lst(e,1) cfp_roi_lst(e,3) cfp_roi_lst(e,3) cfp_roi_lst(e,1) cfp_roi_lst(e,1)],[cfp_roi_lst(e,2) cfp_roi_lst(e,2) cfp_roi_lst(e,4) cfp_roi_lst(e,4) cfp_roi_lst(e,2)],'Color','c')
        text(mean([cfp_roi_lst(e,1) cfp_roi_lst(e,3)]),mean([cfp_roi_lst(e,2) cfp_roi_lst(e,4)]),num2str(e),'Color','c','FontSize',14)
    end
end

% identify new ROIs
cell_find = 0;
ca_roi_lst = [];
ca_cell_num = 1;

identify_cell = 1;
any_cells = input('cells to identify? (y=1)');
if any_cells == 1
    while identify_cell ~= 0
        
        dcm_obj = datacursormode;
        datacursormode on
        
        disp('click top left corner of ROI, then return')
        % Wait while the user does this.
        pause
        c_info = getCursorInfo(dcm_obj);
        roi1 = c_info.Position;
        dcm_obj.removeAllDataCursors()
        
        disp('click bottom right corner of ROI, then return')
        % Wait while the user does this.
        pause
        c_info = getCursorInfo(dcm_obj);
        roi2 = c_info.Position;
        dcm_obj.removeAllDataCursors()
        
        line([roi1(1) roi2(1) roi2(1) roi1(1) roi1(1)],[roi1(2) roi1(2) roi2(2) roi2(2) roi1(2)],'Color','r')
        roi_ok = input('good roi? (y=1, n=0) ');
        if roi_ok == 1
            ca_roi_lst = [ca_roi_lst; roi1 roi2];
            text(mean([roi1(1) roi2(1)]),mean([roi1(2) roi2(2)]),num2str(ca_cell_num),'Color','r','FontSize',14)
            ca_cell_num = ca_cell_num+1;
        else
            children = get(gca, 'children');
            delete(children(1));
        end
        identify_cell = input('find another cell? (y=1, n=0) ');
    end
dcm_obj.removeAllDataCursors()
end

%% calculate mean fluorescence intensity of CFP and GFP ROIs
if is_gfp == 1   
    mean_gfp_lst = zeros(gfp_cell_num-1,stack_size);
    gfp_legend_names = cell(1, gfp_cell_num-1);
    
% for GFP+ cells
    for f = 1:gfp_cell_num-1
        for e = 1:stack_size
            x = imread([fpath canom '.tif'],e);
            gfp_roi = x(gfp_roi_lst(f,2):gfp_roi_lst(f,4),gfp_roi_lst(f,1):gfp_roi_lst(f,3));
            mean_gfp_roi = mean(mean(gfp_roi));
            mean_gfp_lst(f,e) = mean_gfp_roi;
        end
        gfp_legend_names{f} = sprintf('cell %0.0f',f);
    end
end

% for CFP+ cells
if is_cfp == 1
    mean_cfp_lst = zeros(cfp_cell_num-1,stack_size);
    cfp_legend_names = cell(1, cfp_cell_num-1);
    
    for f = 1:cfp_cell_num-1
        for e = 1:stack_size
            x = imread([fpath canom '.tif'],e);
            cfp_roi = x(cfp_roi_lst(f,2):cfp_roi_lst(f,4),cfp_roi_lst(f,1):cfp_roi_lst(f,3));
            mean_cfp_roi = mean(mean(cfp_roi));
            mean_cfp_lst(f,e) = mean_cfp_roi;
        end
        cfp_legend_names{f} = sprintf('cell %0.0f',f);
    end
end

% for CFP-/GFP- cells
mean_ca_lst = zeros(ca_cell_num-1,stack_size);
ca_legend_names = cell(1, ca_cell_num-1);

for f = 1:ca_cell_num-1
    for e = 1:stack_size
        x = imread([fpath canom '.tif'],e);
        ca_roi = x(ca_roi_lst(f,2):ca_roi_lst(f,4),ca_roi_lst(f,1):ca_roi_lst(f,3));
        mean_ca_roi = mean(mean(ca_roi));
        mean_ca_lst(f,e) = mean_ca_roi;
    end
    ca_legend_names{f} = sprintf('cell %0.0f',f);
end

%% plot normalized Rhod3 fluorescence for CFP+,GFP+, CFP-/GFP- ROIs

x_time = linspace(1,tot_time,stack_size);

figure
hold on
e = 0;
f = 0;
g = 0;

if is_cfp == 1 && isempty(mean_cfp_lst) == 0
    for e = 1:size(mean_cfp_lst,1)
        trc = mean_cfp_lst(e,:);
        trc_zero = trc-min(trc);
        trc_norm = trc_zero./max(trc_zero);
        
        plot(x_time,trc_norm+e,'b')
    end
end

if is_gfp == 1 && isempty(mean_gfp_lst) == 0
    for f = 1:size(mean_gfp_lst,1)
        trc = mean_gfp_lst(f,:);
        trc_zero = trc-min(trc);
        trc_norm = trc_zero./max(trc_zero);
        
        plot(x_time,trc_norm+f+e,'g')
    end
end

if isempty(mean_ca_lst) == 0
    for g = 1:size(mean_ca_lst,1)
        trc = mean_ca_lst(g,:);
        trc_zero = trc-min(trc);
        trc_norm = trc_zero./max(trc_zero);
        
        plot(x_time,trc_norm+f+e+g,'r')
    end
end

set(gca,'YTick',1:7)
set(gca,'YTickLabel','')
ax = gca;
ax.YGrid = 'on';
xlabel('time (s)')

%% save output
if is_cfp == 1 && is_gfp == 1
    save([fpath canom '/data'],'gfp_roi_lst','cfp_roi_lst','ca_roi_lst','mean_gfp_lst','mean_cfp_lst','mean_ca_lst','gfp_legend_names','cfp_legend_names','ca_legend_names')
    saveas(1,[fpath canom '/identified_GFP_cells'],'tiff')
    saveas(2,[fpath canom '/identified_CFP_cells'],'tiff')
    saveas(3,[fpath canom '/identified_nonCFP_GFP_cells'],'tiff')
    saveas(4,[fpath canom '/mean fluorescence'],'tiff')
elseif is_gfp == 1 && is_cfp == 0
    save([fpath canom '/data'],'gfp_roi_lst','ca_roi_lst','mean_gfp_lst','mean_ca_lst','gfp_legend_names','ca_legend_names')
    saveas(1,[fpath canom '/identified_GFP_cells'],'tiff')
    saveas(2,[fpath canom '/identified_nonCFP_GFP_cells'],'tiff')
    saveas(3,[fpath canom '/mean fluorescence'],'tiff')
elseif is_gfp == 0 && is_cfp == 1
    save([fpath canom '/data'],'cfp_roi_lst','ca_roi_lst','mean_cfp_lst','mean_ca_lst','cfp_legend_names','ca_legend_names')
    saveas(1,[fpath canom '/identified_CFP_cells'],'tiff')
    saveas(2,[fpath canom '/identified_nonCFP_GFP_cells'],'tiff')
    saveas(3,[fpath canom '/mean fluorescence'],'tiff')
end
