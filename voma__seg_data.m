function varargout = voma__seg_data(varargin)
% VOMA__SEG_DATA MATLAB code for voma__seg_data.fig
%      VOMA__SEG_DATA, by itself, creates a new VOMA__SEG_DATA or raises the existing
%      singleton*.
%
%      H = VOMA__SEG_DATA returns the handle to a new VOMA__SEG_DATA or the handle to
%      the existing singleton*.
%
%      VOMA__SEG_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOMA__SEG_DATA.M with the given input arguments.
%
%      VOMA__SEG_DATA('Property','Value',...) creates a new VOMA__SEG_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voma__seg_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voma__seg_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%       The VOMA version of 'seg_data' was adapted from
%       'seg_data_v5'
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voma__seg_data

% Last Modified by GUIDE v2.5 28-Aug-2017 12:53:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @voma__seg_data_OpeningFcn, ...
    'gui_OutputFcn',  @voma__seg_data_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before voma__seg_data is made visible.
function voma__seg_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voma__seg_data (see VARARGIN)

% Choose default command line output for voma__seg_data
handles.output = hObject;

% The following from subj_id to stim_intensity will be used to save the
% values entered in the boxes to make the file name
handles.params.subj_id = '';
handles.params.visit_number = '';
handles.params.date = '';
handles.params.exp_type = '';
handles.params.exp_condition = '';
handles.params.function_type = '';
handles.params.stim_axis = '';
handles.params.stim_type = '';
handles.params.stim_frequency = '';
handles.params.stim_intensity = '';

handles.params.system_code = 1;

handles.params.plot_MPUGyroData = 1;
handles.params.plot_MPUAccelData = 1;
handles.params.plot_IPR_flag = 1;
handles.params.plot_TrigLine = 1;
handles.params.plot_LEData = 1;
handles.params.plot_REData = 1;

handles.params.reloadflag = 0;

handles.params.trig_mult = 1;

handles.params.goggleID = 1;

handles.params.vog_data_acq_version = 1;

handles.params.Lasker_param1 = 1;
handles.params.Lasker_param2 = 1;

handles.Yaxis_MPU_Rot_theta = str2double(get(handles.Yaxis_Rot_Theta,'String'));

handles.params.gpio_trig_opt = 1;

set(handles.LaskerSystPanel,'Visible','Off')

set(handles.mpuoffsetpanel,'Visible','On')
handles.params.upper_trigLev = str2double(get(handles.upper_trigLev,'String'));
handles.params.lower_trigLev = str2double(get(handles.lower_trigLev,'String'));
[handles] = update_seg_filename(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voma__seg_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = voma__seg_data_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in new_segment.
function [handles] = new_segment_Callback(hObject, eventdata, handles,user_seg_flag)
% hObject    handle to new_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if user_seg_flag

set(handles.save_indicator,'String','UNSAVED')
set(handles.save_indicator,'BackgroundColor','r')

if user_seg_flag
    % Ask user to choose segmentation points
    uiwait(msgbox('Please align the vertical line of the crosshair with the starting point of the stimulus','Segment Eye Movement Data'));
    [x1,y1] = ginput(1);
    uiwait(msgbox('Please align the vertical line of the crosshair with the ending point of the stimulus','Segment Eye Movement Data'));
    [x2,y2] = ginput(1);
    time_cutout_s = [x1 ; x2];
    
    [a1,i_start_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(1,1)));
    [a2,i_end_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(2,1)));
    
    if isvector(handles.Segment.Time_Stim)
        
        [b1,i_start_stim] = min(abs(handles.Segment.Time_Stim - time_cutout_s(1,1)));
        [b2,i_end_stim] = min(abs(handles.Segment.Time_Stim - time_cutout_s(2,1)));
        
    else
        
        
        [b1,i_start_stim] = min(abs(handles.Segment.Time_Stim(:,1) - time_cutout_s(1,1)));
        [b2,i_end_stim] = min(abs(handles.Segment.Time_Stim(:,1) - time_cutout_s(2,1)));
        
        
    end
    
    handles.i_start_eye = i_start_eye;
    handles.i_end_eye = i_end_eye;
    handles.i_start_stim = i_start_stim;
    handles.i_end_stim = i_end_stim;
    
    handles.Segment.start_t = time_cutout_s(1);
    handles.Segment.end_t = time_cutout_s(2);
else
    i_start_eye = handles.i_start_eye;
    i_end_eye = handles.i_end_eye;
    i_start_stim = handles.i_start_stim;
    i_end_stim = handles.i_end_stim;
    
    time_cutout_s(1) =  handles.Segment.start_t;
    time_cutout_s(2) =  handles.Segment.end_t;
end
%


Segment.segment_code_version = mfilename;
Segment.raw_filename = handles.Segment.raw_filename;
Segment.start_t = time_cutout_s(1);
Segment.end_t = time_cutout_s(2);
Segment.LE_Position_X = handles.Segment.LE_Position_X(i_start_eye:i_end_eye);
Segment.LE_Position_Y = handles.Segment.LE_Position_Y(i_start_eye:i_end_eye);
Segment.LE_Position_Z = handles.Segment.LE_Position_Z(i_start_eye:i_end_eye);

Segment.RE_Position_X = handles.Segment.RE_Position_X(i_start_eye:i_end_eye);
Segment.RE_Position_Y = handles.Segment.RE_Position_Y(i_start_eye:i_end_eye);
Segment.RE_Position_Z = handles.Segment.RE_Position_Z(i_start_eye:i_end_eye);

Segment.LE_Velocity_X = handles.Segment.LE_Velocity_X(i_start_eye:i_end_eye);
Segment.LE_Velocity_Y = handles.Segment.LE_Velocity_Y(i_start_eye:i_end_eye);
Segment.LE_Velocity_LARP = handles.Segment.LE_Velocity_LARP(i_start_eye:i_end_eye);
Segment.LE_Velocity_RALP = handles.Segment.LE_Velocity_RALP(i_start_eye:i_end_eye);
Segment.LE_Velocity_Z = handles.Segment.LE_Velocity_Z(i_start_eye:i_end_eye);

Segment.RE_Velocity_X = handles.Segment.RE_Velocity_X(i_start_eye:i_end_eye);
Segment.RE_Velocity_Y = handles.Segment.RE_Velocity_Y(i_start_eye:i_end_eye);
Segment.RE_Velocity_LARP = handles.Segment.RE_Velocity_LARP(i_start_eye:i_end_eye);
Segment.RE_Velocity_RALP = handles.Segment.RE_Velocity_RALP(i_start_eye:i_end_eye);
Segment.RE_Velocity_Z = handles.Segment.RE_Velocity_Z(i_start_eye:i_end_eye);

Segment.Fs = handles.Segment.Fs;

Segment.Time_Eye = handles.Segment.Time_Eye(i_start_eye:i_end_eye);
if isvector(handles.Segment.Time_Stim) % This is kludge to process either MVI LD VOG files, or PJB Lasker system elec. stime data. This needs to be rewritten
    Segment.Time_Stim = handles.Segment.Time_Stim(i_start_stim:i_end_stim);
else
    Segment.Time_Stim = handles.Segment.Time_Stim(i_start_stim:i_end_stim,:);
end


switch handles.params.system_code
    case 1
        Segment.Stim_Trig = handles.Segment.Stim_Trig(i_start_eye:i_end_eye);
    case 2
        
        if isempty(handles.Segment.Stim_Trig)
            Segment.Stim_Trig = [];
        else
            Segment.Stim_Trig = handles.Segment.Stim_Trig(i_start_stim:i_end_stim);
        end
end

Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X(i_start_stim:i_end_stim);
Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y(i_start_stim:i_end_stim);
Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z(i_start_stim:i_end_stim);

Segment.HeadMPUAccel_X = handles.Segment.HeadMPUAccel_X(i_start_stim:i_end_stim);
Segment.HeadMPUAccel_Y = handles.Segment.HeadMPUAccel_Y(i_start_stim:i_end_stim);
Segment.HeadMPUAccel_Z = handles.Segment.HeadMPUAccel_Z(i_start_stim:i_end_stim);




handles.Segment = Segment;

% Update plots!
keep_plot_limit = false; % We do not want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)


guidata(hObject,handles)
end


function plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

if keep_plot_limit
    xLimits = get(gca,'XLim');  %# Get the range of the x axis
    yLimits = get(gca,'YLim');  %# Get the range of the y axis
end


% Reset and plot segment
axes(handles.data_plot)

cla reset

hold on


if handles.params.plot_MPUGyroData == 1
    try
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-GYRO-X')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-GYRO-Y')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':','DisplayName','MPU-GYRO-Z')
        
    catch
        
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUVel_X,'color',[1 0.65 0],'LineStyle',':','DisplayName','MPU-GYRO-X')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUVel_Y,'color',[0.55 0.27 0.07],'LineStyle',':','DisplayName','MPU-GYRO-Y')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUVel_Z,'color','r','LineStyle',':','DisplayName','MPU-GYRO-Z')
    end
end

if handles.params.plot_MPUAccelData == 1
    try
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUAccel_X,'color',[1 0.65 0],'LineStyle','--','DisplayName','MPU-ACCEL-X')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUAccel_Y,'color',[0.55 0.27 0.07],'LineStyle','--','DisplayName','MPU-ACCEL-Y')
        plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.HeadMPUAccel_Z,'color','r','LineStyle','--','DisplayName','MPU-ACCEL-Z')
    catch
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUAccel_X,'color',[1 0.65 0],'LineStyle','--','DisplayName','MPU-ACCEL-X')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUAccel_Y,'color',[0.55 0.27 0.07],'LineStyle','--','DisplayName','MPU-ACCEL-Y')
        plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.HeadMPUAccel_Z,'color','r','LineStyle','--','DisplayName','MPU-ACCEL-Z')
    end
end

if handles.params.plot_TrigLine == 1
    switch handles.params.system_code
        
        case 1 %NOTE: For the LD VOG system, we plot the GPIO line as a function of the EYE time stamps, since the GPIO line is sampled with the eye data
            plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.Stim_Trig*handles.params.trig_mult,'color','k','DisplayName','Stim - Trig')
        case 2
            
            if isempty(handles.Segment.Stim_Trig)
                %                 Stim = [];
            else
                
                if handles.params.plot_IPR_flag == 1
                    plot(handles.data_plot,handles.Segment.Time_Stim(:,1),handles.Segment.Stim_Trig,'color','k','Marker','*','DisplayName','Stim - Trig')
                else
                    Stim = handles.Segment.Time_Stim(:,1);
                    plot(handles.data_plot,Stim,ones(1,length(Stim))*handles.params.trig_mult,'color','k','Marker','*','DisplayName','Stim - Trig')
                end
            end
    end
end

if handles.params.plot_LEData == 1
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_X,'color',[255 140 0]/255,'DisplayName','LE-X')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_Y,'color',[128 0 128]/255,'DisplayName','LE-Y')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.LE_Position_Z,'color','r','DisplayName','LE-Z')
end

if handles.params.plot_REData == 1
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_X,'color',[255 255 0]/255,'DisplayName','RE-X')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_Y,'color',[138 43 226]/255,'DisplayName','RE-Y')
    plot(handles.data_plot,handles.Segment.Time_Eye,handles.Segment.RE_Position_Z,'color',[255,0,255]/255,'DisplayName','RE-Z')
end

xlabel('Time [s]')
ylabel('Stimulus Amplitude')

legend('show')

if keep_plot_limit
    set(gca,'XLim',xLimits);
    set(gca,'YLim',yLimits);
end

end

% --- Executes on button press in save_segment.
function save_segment_Callback(hObject, eventdata, handles)
% hObject    handle to save_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
segments = str2num(handles.segment_number.String);
segments = segments + 1;

    set(handles.worksheet_name,'String',[handles.visit_number.String,'-',handles.date.String,'-',handles.exp_type.String]);
    handles.experimentdata{segments,1} = handles.seg_filename.String;
    handles.experimentdata{segments,2} = [handles.date.String(5:6),'/',handles.date.String(7:8),'/',handles.date.String(1:4)];
    handles.experimentdata{segments,3} = handles.subj_id.String;
    handles.experimentdata{segments,4} = handles.implant.String;
    handles.experimentdata{segments,5} = handles.eye_rec.String;
    handles.experimentdata{segments,9} = [handles.exp_type.String,'-',handles.exp_condition.String,'-',handles.stim_type.String];
    handles.experimentdata{segments,10} = handles.stim_axis.String;
    stim_freq = handles.stim_frequency.String;
    hs = [find(stim_freq == 'H') find(stim_freq == 'h')];
    stim_freq(hs:end) = [];
    pt = find(stim_freq == 'p');
    stim_freq(pt) = '.';
    handles.experimentdata{segments,12} = str2double(stim_freq);
    stim_int = handles.stim_intensity.String;
    dps = find(handles.stim_intensity.String == 'd');
    stim_int(dps:end) = [];
    handles.experimentdata{segments,13} = str2num(stim_int);

handles.segment_number.String = num2str(segments);

folder_name = uigetdir('','Select Directory to Save the Segmented Data');

% folder_name = handles.folder_name;

cd(folder_name)
Data = handles.Segment;

% Note, there is an error in matlab if the first character of a file name
% is: '-'.
% This can happen if the user decides not to inlcude an input for the
% 'SubjectID' filename input.
if strcmp(handles.params.segment_filename(1),'-')
    uiwait(msgbox('You have attempted to save a file segment which has a filename leading with a ''-'' character. This will cause an error saving the file, so we are adding a ''_'' character infront of the filename.','Segment Eye Movement Data'));
    
    handles.params.segment_filename = ['_' handles.params.segment_filename];
    set(handles.seg_filename,'String',handles.params.segment_filename);
else
end

save(handles.params.segment_filename,'Data')

set(handles.save_indicator,'String','SAVED!')
set(handles.save_indicator,'BackgroundColor','g')

guidata(hObject,handles)
end

% --- Executes on button press in load_raw.
function [handles] = load_raw_Callback(hObject, eventdata, handles)
% hObject    handle to load_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt user for raw data file

set(handles.save_indicator,'String','UNSAVED')
set(handles.save_indicator,'BackgroundColor','r')

if handles.params.reloadflag == 0
    handles.segment_number.String = '0';

else
    
end
 
switch handles.params.system_code
    
    case 1 % Labyrinth Devices 3D VOG
        
        % Check if the user requested to start segmenting a new file, or a
        % 'reload' of the same file.
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            [FileName,PathName,FilterIndex] = uigetfile('*.txt','Please choose the data file for analysis');
            
            handles.raw_PathName = PathName;
            handles.raw_FileName = FileName;
            
            set(handles.raw_name,'String',FileName);
        else
            % If we are reloading a file, don't prompt the user and reset
            % the 'reload' flag.
            FileName = handles.raw_FileName;
            PathName = handles.raw_PathName;
            handles.params.reloadflag = 0;
        end
        
        switch handles.params.vog_data_acq_version
            
            case {1,2}
                HLeftIndex = 40;
                VLeftIndex = 41;
                TLeftIndex = 42;
                HRightIndex = 43;
                VRightIndex = 44;
                TRightIndex = 45;
                
            case {3}
                
                % These are the column indices of the relevant parameters saved to file
                % NOTE! MVI001R019 Pre-Op data was acquired without the GPIO line,
                % and thus all of the data indices are decremented by 1.
                HLeftIndex = 39;
                VLeftIndex = 40;
                TLeftIndex = 41;
                HRightIndex = 42;
                VRightIndex = 43;
                TRightIndex = 44;
        end
        % Note we need to be careful with coordinate systems when analyzing
        % the VOG data collected with the Labyrinth Devices VOG system.
        
        % Based on the orientation of the MPU9250 module relative to the
        % patients head, a passive (coordinate system) -150deg rotation is
        % necesary to align the coordinate system of MPU to the coordinate
        % system of the patient's head with the VOG goggles on.
        
        % When the patient is tested with the Automatic Head Impulse Test
        % (aHIT) device, the individual's head is pitched down 20deg to
        % (roughly) align the patient's +LHRH SCC axis with the +Z 'world'
        % axis that the aHIT rotates about. This means we need to apply a
        % (-150deg + -20deg) to orient the +Z axis of the MPU9250 seated in
        % the VOG goggles with the +LHRH axis of SCC ccoordinate system.
        
        % Instead of hardcoding this rotation into this analysis code, we
        % have added a user input for the Y-axis rotation needed to correct
        % the MPU coordinates.
        phi = handles.Yaxis_MPU_Rot_theta;
        
        Rotation_Head = [
            cosd(phi) 0   sind(phi);
            0   1   0;
            -sind(phi)    0   cosd(phi)
            ];
        
        
        % Load Data
        data = dlmread([handles.raw_PathName handles.raw_FileName],' ',1,0);
        
        % Generate Time_Eye vector
        Time = data(:,2);
        % The time vector recorded by the VOG goggles resets after it
        % reaches a value of 128. We will find those transitions, and
        % correct the time value.
        inds =[1:length(Time)];
        overrun_inds = inds([false ; (diff(Time) < -20)]);
        Time_Eye = Time;
        % Loop over each Time vector reset and add '128' to all data points
        % following each transition.
        for k =1:length(overrun_inds)
            Time_Eye(overrun_inds(k):end) = Time_Eye(overrun_inds(k):end)+128;
        end
        % Subtract the first time point
        Time_Eye = Time_Eye - Time_Eye(1);
        
        % Generate the time vector for the MPU9250 Data
        Head_Sensor_Latency = 0.047; % From Mehdi Rahman bench tests, the data acquisition of the MPU9250 leads the LD VOG Goggles by 47ms
        
        Time_Stim = Time_Eye - Head_Sensor_Latency;
        
        
        % Load raw eye position data in Fick coordinates [degrees]
        Horizontal_LE_Position = data(:,HLeftIndex);
        Vertical_LE_Position = data(:,VLeftIndex);
        Torsion_LE_Position = data(:,TLeftIndex);
        Horizontal_RE_Position = data(:,HRightIndex);
        Vertical_RE_Position = data(:,VRightIndex);
        Torsion_RE_Position = data(:,TRightIndex);
        
        % We will use PJB's 'processeyemovements' routine to process the RAW
        % position data into 3D angular velocities. Note that this will be
        % an angular velocity calculation with NO filtering.
        
        FieldGains = []; % Input parameter for processing coil signals
        coilzeros = []; % Input parameter for processing coil signals
        ref = 0; % Input parameter for processing rotation vectors
        system_code = 1; % System code, in this case it tells the routine
        % NOT to apply and additional coordinate system trasnformation
        DAQ_code = 5; % Indicates we are processing Labyrinth Devices VOG Data
        
        [EyeVel] = voma__processeyemovements(PathName,FileName,FieldGains,coilzeros,ref,system_code,DAQ_code);
        
        
        switch handles.params.vog_data_acq_version
            
            case {1,2}
                % Index for the VOG GPIO line
                
                switch handles.params.gpio_trig_opt
                    
                    case 1 % The user has chosen to use the hardware trigger from the MVI PCU
                        
                        StimIndex = 35;
                        
                    case 2 % The user has chosen to use the software trigger from the MVI fitting software (toggled by the operator
                        
                        
                        StimIndex = 46;
                        
                end
                
                Stim = data(1:length(Time_Eye),StimIndex);
                
            case {3}
                
                Stim = zeros(1,length(Time_Eye));
                
        end
        
        
        gyroscale = 1;
        
        switch handles.params.vog_data_acq_version
            
            case {1}
                accelscale = 1;
                
            case {2,3}
                accelscale = 16384;
        end
        
        XvelHeadIndex = 30;
        YvelHeadIndex = 29;
        ZvelHeadIndex = 28;
        
        XaccelHeadIndex = 27;
        YaccelHeadIndex = 26;
        ZaccelHeadIndex = 25;
        
        
        % We need to correct each gyroscope signal by subtracting the
        % correct device-specifc MPU9250 gyroscope offset. Each offset for
        % each VOG goggle ID was measured by Mehdi Rahman and posted on the
        % Google Doc located here: https://docs.google.com/a/labyrinthdevices.com/document/d/1UlZpovNkwer608aswJWdkLhF0gF-frajAdu1qgMJt9Y/edit?usp=sharing
        switch handles.params.goggleID
            
            case {1}
                XvelHeadOffset = 2.7084;
                YvelHeadOffset = -0.5595;
                ZvelHeadOffset = 0.7228;
                
                
            case {2}
                XvelHeadOffset = 2.3185;
                YvelHeadOffset = -1.5181;
                ZvelHeadOffset = -1.0424;
                
                
            case {3}
                XvelHeadOffset = 1.9796;
                YvelHeadOffset = 0.1524;
                ZvelHeadOffset = -0.5258;
                
            case {4}
                XvelHeadOffset = 0;
                YvelHeadOffset = 0;
                ZvelHeadOffset = 0;
                
        end
        
        set(handles.Xoffset_txt,'String',num2str(XvelHeadOffset))
        set(handles.Yoffset_txt,'String',num2str(YvelHeadOffset))
        set(handles.Zoffset_txt,'String',num2str(ZvelHeadOffset))
        
        XvelHeadRaw = data(1:length(Time_Eye),XvelHeadIndex)*gyroscale + XvelHeadOffset;
        YvelHeadRaw = data(1:length(Time_Eye),YvelHeadIndex)*gyroscale + YvelHeadOffset;
        ZvelHeadRaw = data(1:length(Time_Eye),ZvelHeadIndex)*gyroscale + ZvelHeadOffset;
        
        %         XvelHead = data(1:length(Time_Eye),30)*accelscale - XvelHeadOffset;
        %         YvelHead = data(1:length(Time_Eye),29)*accelscale - YvelHeadOffset;
        %         ZvelHead = data(1:length(Time_Eye),28)*accelscale - ZvelHeadOffset;
        
        XaccelHeadRaw = data(1:length(Time_Eye),XaccelHeadIndex)*accelscale;
        YaccelHeadRaw = data(1:length(Time_Eye),YaccelHeadIndex)*accelscale;
        ZaccelHeadRaw = data(1:length(Time_Eye),ZaccelHeadIndex)*accelscale;
        
        % NOTE: We are transposing the rotation matrix in order to apply a
        % PASSIVE (i.e., a coordinate system) transformation
        A = Rotation_Head' * [XvelHeadRaw' ; YvelHeadRaw' ; ZvelHeadRaw'];
        
        XAxisVelHead = A(1,:);
        YAxisVelHead = A(2,:);
        ZAxisVelHead = A(3,:);
        
        B = Rotation_Head' * [XaccelHeadRaw' ; YaccelHeadRaw' ; ZaccelHeadRaw'];
        
        XAxisAccelHead = B(1,:);
        YAxisAccelHead = B(2,:);
        ZAxisAccelHead = B(3,:);
        
        
        
        
        Data.segment_code_version = mfilename;
        Data.raw_filename = handles.raw_FileName;
        Data.LE_Position_X = Torsion_LE_Position;
        Data.LE_Position_Y = Vertical_LE_Position;
        Data.LE_Position_Z = Horizontal_LE_Position;
        
        Data.RE_Position_X = Torsion_RE_Position;
        Data.RE_Position_Y = Vertical_RE_Position;
        Data.RE_Position_Z = Horizontal_RE_Position;
        
        
        Data.LE_Velocity_X = EyeVel.LE_Vel_X;
        Data.LE_Velocity_Y = EyeVel.LE_Vel_Y;
        Data.LE_Velocity_LARP = EyeVel.LE_Vel_LARP;
        Data.LE_Velocity_RALP = EyeVel.LE_Vel_RALP;
        Data.LE_Velocity_Z = EyeVel.LE_Vel_Z;
        
        Data.RE_Velocity_X = EyeVel.RE_Vel_X;
        Data.RE_Velocity_Y = EyeVel.RE_Vel_Y;
        Data.RE_Velocity_LARP = EyeVel.RE_Vel_LARP;
        Data.RE_Velocity_RALP = EyeVel.RE_Vel_RALP;
        Data.RE_Velocity_Z = EyeVel.RE_Vel_Z;
        
        
        Data.HeadMPUVel_X = XAxisVelHead';
        Data.HeadMPUVel_Y = YAxisVelHead';
        Data.HeadMPUVel_Z = ZAxisVelHead';
        
        Data.HeadMPUAccel_X = XAxisAccelHead';
        Data.HeadMPUAccel_Y = YAxisAccelHead';
        Data.HeadMPUAccel_Z = ZAxisAccelHead';
        
        Data.Fs = 100;
        
        Data.Time_Eye = Time_Eye;
        Data.Time_Stim = Time_Stim;
        
        Data.Stim_Trig = Stim;
        
        
        
        
    case 2 % Lasker System CED
        
        % Check if the user requested to start segmenting a new file, or a
        % 'reload' of the same file.
        if handles.params.reloadflag == 0
            % If requesting a new file, prompt the user to choose the file.
            [FileName,PathName,FilterIndex] = uigetfile('*.smr','Please choose the file to process');
            
            [FieldGainFile,FieldGainPath,FieldGainFilterIndex] = uigetfile('*.*','Please choose the field gains for this experiment');
            
            handles.raw_PathName = PathName;
            handles.raw_FileName = FileName;
            
            handles.raw_FieldGainPath = FieldGainPath;
            handles.raw_FieldGainFile = FieldGainFile;
            
            
            set(handles.raw_name,'String',FileName);
        else
            % If we are reloading a file, don't prompt the user and reset
            % the 'reload' flag.
            FileName = handles.raw_FileName;
            PathName = handles.raw_PathName;
            
            
            FieldGainPath = handles.raw_FieldGainPath;
            FieldGainFile = handles.raw_FieldGainFile;
            
            handles.params.reloadflag = 0;
        end
        
        %         % Import the data from the .smr file
        %         [d]=ImportSMR_PJBv2(FileName,PathName);
        
        
        
        
        % Import the Field Gain file, collected using the vordaq/showall
        % software
        fieldgainname = [FieldGainPath FieldGainFile];
        delimiter = '\t';
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        
        fileID = fopen(fieldgainname,'r');
        
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
        
        fclose(fileID);
        
        FieldGains = [dataArray{1:end-1}];
        
        % During my daily calibration procedure, I zero-out the fields to
        % have no offsets with a test coil.
        coilzeros = [0 0 0 0 0 0 0 0 0 0 0 0];
        % This will use the first data point as a reference position
        ref = 0;
        % Don't put a smapling rate param. in, we will extract it from the
        % CED file.
        Fs = [];
        % Mark the 'system_code'
        switch handles.params.Lasker_param2
            case 1 % Head is upright, but we still need to correct the coil signals into proper X, Y, Z coordinates
                system_code = 2;
                
            case 2
                system_code = 3;
            case 3
                system_code = 4;
        end
        % Indicate the DAQ code
        DAQ_code = 3; % Lasker System as recorded by a CED 1401 device
        
        
        [RawData] = voma__processeyemovements(PathName,FileName,FieldGains,coilzeros,ref,system_code,DAQ_code,1);
        
        % Attempt to
        
        Data.segment_code_version = mfilename;
        Data.raw_filename = handles.raw_FileName;
        Data.LE_Position_X = RawData.LE_Pos_X;
        Data.LE_Position_Y = RawData.LE_Pos_Y;
        Data.LE_Position_Z = RawData.LE_Pos_Z;
        
        Data.RE_Position_X = RawData.RE_Pos_X;
        Data.RE_Position_Y = RawData.RE_Pos_Y;
        Data.RE_Position_Z = RawData.RE_Pos_Z;
        
        Data.LE_Velocity_X = RawData.LE_Vel_X;
        Data.LE_Velocity_Y = RawData.LE_Vel_Y;
        Data.LE_Velocity_LARP = RawData.LE_Vel_LARP;
        Data.LE_Velocity_RALP = RawData.LE_Vel_RALP;
        Data.LE_Velocity_Z = RawData.LE_Vel_Z;
        
        Data.RE_Velocity_X = RawData.RE_Vel_X;
        Data.RE_Velocity_Y = RawData.RE_Vel_Y;
        Data.RE_Velocity_LARP = RawData.RE_Vel_LARP;
        Data.RE_Velocity_RALP = RawData.RE_Vel_RALP;
        Data.RE_Velocity_Z = RawData.RE_Vel_Z;
        
        Data.Fs = RawData.Fs;
        
        
        
        
        Data.Time_Eye = [0:length(RawData.LE_Vel_LARP)-1]/Data.Fs;
        Data.Time_Stim = RawData.ElecStimTrig';
        
        if isempty(RawData.ElecStimTrig)
            
            Data.Stim_Trig = [];
            Data.Time_Stim = Data.Time_Eye;
        else
            % We will calculate PR using a first order backwards difference
            % instantaneous rate approx. We are not using a central
            % difference, since it will smear/smooth the Pulse rate values
            PR = 1./diff(RawData.ElecStimTrig(:,1));
            % To have the same number of PR values as pulse times, we will
            % copy the first entry in the array, and append the PR array in
            % the front. The first value in the PR array is really
            % "PulseTime(2)-PulseTime(1)". The actual value plotted/saved
            % here is for graphical purposes only and the actual pulse
            % times themselves will be used for analysis.
            Data.Stim_Trig = [PR(1) PR'];
            
        end
        
        % Kludge for now!
        Data.HeadMPUVel_X = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUVel_Y = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUVel_Z = RawData.Var_x083;
        
        Data.HeadMPUAccel_X = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUAccel_Y = zeros(length(Data.Time_Eye),1);
        Data.HeadMPUAccel_Z = zeros(length(Data.Time_Eye),1);
        
    otherwise
        
        
        
end

% Check all saved data variables and make sure they are COLUMN vectors
if isrow(Data.LE_Position_X)
    Data.LE_Position_X = Data.LE_Position_X';
end
if isrow(Data.LE_Position_Y)
    Data.LE_Position_Y = Data.LE_Position_Y';
end
if isrow(Data.LE_Position_Z)
    Data.LE_Position_Z = Data.LE_Position_Z';
end
if isrow(Data.RE_Position_X)
    Data.RE_Position_X = Data.RE_Position_X';
end
if isrow(Data.RE_Position_Y)
    Data.RE_Position_Y = Data.RE_Position_Y';
end
if isrow(Data.RE_Position_Z)
    Data.RE_Position_Z = Data.RE_Position_Z';
end
if isrow(Data.LE_Velocity_X)
    Data.LE_Velocity_X = Data.LE_Velocity_X';
end
if isrow(Data.LE_Velocity_Y)
    Data.LE_Velocity_Y = Data.LE_Velocity_Y';
end
if isrow(Data.LE_Velocity_Z)
    Data.LE_Velocity_Z = Data.LE_Velocity_Z';
end
if isrow(Data.LE_Velocity_LARP)
    Data.LE_Velocity_LARP = Data.LE_Velocity_LARP';
end
if isrow(Data.LE_Velocity_RALP)
    Data.LE_Velocity_RALP = Data.LE_Velocity_RALP';
end
if isrow(Data.RE_Velocity_X)
    Data.RE_Velocity_X = Data.RE_Velocity_X';
end
if isrow(Data.RE_Velocity_Y)
    Data.RE_Velocity_Y = Data.RE_Velocity_Y';
end
if isrow(Data.RE_Velocity_Z)
    Data.RE_Velocity_Z = Data.RE_Velocity_Z';
end
if isrow(Data.RE_Velocity_LARP)
    Data.RE_Velocity_LARP = Data.RE_Velocity_LARP';
end
if isrow(Data.RE_Velocity_RALP)
    Data.RE_Velocity_RALP = Data.RE_Velocity_RALP';
end
if isrow(Data.HeadMPUVel_X)
    Data.HeadMPUVel_X = Data.HeadMPUVel_X';
end
if isrow(Data.HeadMPUVel_Y)
    Data.HeadMPUVel_Y = Data.HeadMPUVel_Y';
end
if isrow(Data.HeadMPUVel_Z)
    Data.HeadMPUVel_Z = Data.HeadMPUVel_Z';
end
if isrow(Data.HeadMPUAccel_X)
    Data.HeadMPUAccel_X = Data.HeadMPUAccel_X';
end
if isrow(Data.HeadMPUAccel_Y)
    Data.HeadMPUAccel_Y = Data.HeadMPUAccel_Y';
end
if isrow(Data.HeadMPUAccel_Z)
    Data.HeadMPUAccel_Z = Data.HeadMPUAccel_Z';
end
if isrow(Data.Time_Eye)
    Data.Time_Eye = Data.Time_Eye';
end
if ismatrix(Data.Time_Stim) % i.e., we are dealing with a stimulus timestamp that records an ONSET and OFFSET time (for example, if a pulsatile trigger is sent to an event channel on a CED that records the rising and falling edge of a pulse)
    a = size(Data.Time_Stim);
    if a(2) > a(1)
        Data.Time_Stim = Data.Time_Stim';
    end
else
    if isrow(Data.Time_Stim)
        Data.Time_Stim = Data.Time_Stim';
    end
end
if isrow(Data.Stim_Trig )
    Data.Stim_Trig  = Data.Stim_Trig';
end


% Save the whole data trace in the GUI handles.
handles.Data = Data;
% Then save the whole data trace as the 'segment' variable in the handles.
% This if a user decides they want to process the whole data trace, they
% can just export the data.
handles.Segment = Data;

handles.i_start_eye = 1;
handles.i_end_eye = length(Data.Time_Eye);
handles.i_start_stim = 1;
handles.i_end_stim = length(Data.Time_Stim);

handles.Segment.start_t = Data.Time_Eye(1);
handles.Segment.end_t = Data.Time_Eye(end);

% Update the GUI plot
keep_plot_limit = false; % Don't keep the plot limits, we are loading a new file
plot_segment_data(hObject, eventdata, handles,keep_plot_limit)


guidata(hObject,handles)
end


% --- Executes on selection change in eye_mov_system.
function eye_mov_system_Callback(hObject, eventdata, handles)
% hObject    handle to eye_mov_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

index_selected = get(hObject,'Value');

handles.params.system_code = index_selected;

switch handles.params.system_code
    % Maybe I should switch this to a series of 'if' statements, since I
    % will be shutting off every option box when the system code changes...
    
    case 1 % Labyrinth Devices VOG Goggles
        
        set(handles.LabDevVOG,'Visible','On')
        
        set(handles.LaskerSystPanel,'Visible','Off')
        
        set(handles.mpuoffsetpanel,'Visible','On')
        
    case 2 % Labyrinth Devices VOG Goggles
        
        set(handles.LaskerSystPanel,'Visible','On')
        set(handles.mpuoffsetpanel,'Visible','Off')
        set(handles.LabDevVOG,'Visible','Off')
        
    otherwise
        set(handles.LabDevVOG,'Visible','Off')
        set(handles.LaskerSystPanel,'Visible','Off')
        set(handles.mpuoffsetpanel,'Visible','Off')
end

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns eye_mov_system contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eye_mov_system
end

% --- Executes during object creation, after setting all properties.
function eye_mov_system_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eye_mov_system (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in reload_raw.
function [handles] = reload_raw_Callback(hObject, eventdata, handles)
% hObject    handle to reload_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.params.reloadflag = 1;

guidata(hObject,handles)

[handles] = load_raw_Callback(hObject, eventdata, handles)
end

function subj_id_Callback(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.subj_id = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of subj_id as text
%        str2double(get(hObject,'String')) returns contents of subj_id as a double
end

% --- Executes during object creation, after setting all properties.
function subj_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function visit_number_Callback(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.visit_number = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of subj_id as text
%        str2double(get(hObject,'String')) returns contents of subj_id as a double
end

% --- Executes during object creation, after setting all properties.
function visit_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over date.
% Enable is set to inactive for this text box
function date_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('DestinationUI',handles.date,'OutputDateFormat','yyyymmdd') % pulls up the uicalendar and designates the output destination and format
waitfor(handles.date,'String') % Waits for the string of the date textbox to be edited
handles.params.date = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
end

function date_Callback(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.date = get(hObject,'String')
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of date as text
%        str2double(get(hObject,'String')) returns contents of date as a double
end

% --- Executes during object creation, after setting all properties.
function date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function exp_type_Callback(hObject, eventdata, handles)
% hObject    handle to exp_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.exp_type = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of exp_type as text
%        str2double(get(hObject,'String')) returns contents of exp_type as a double
end

% --- Executes during object creation, after setting all properties.
function exp_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function exp_condition_Callback(hObject, eventdata, handles)
% hObject    handle to exp_condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.exp_condition = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of exp_condition as text
%        str2double(get(hObject,'String')) returns contents of exp_condition as a double
end

% --- Executes during object creation, after setting all properties.
function exp_condition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exp_condition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function stim_axis_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_axis = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_type as text
%        str2double(get(hObject,'String')) returns contents of stim_type as a double
end

% --- Executes during object creation, after setting all properties.
function stim_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function stim_type_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_type = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_type as text
%        str2double(get(hObject,'String')) returns contents of stim_type as a double
end

% --- Executes during object creation, after setting all properties.
function stim_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function stim_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_frequency = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_type as text
%        str2double(get(hObject,'String')) returns contents of stim_type as a double
end

% --- Executes during object creation, after setting all properties.
function stim_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function stim_intensity_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.params.stim_intensity = get(hObject,'String');
[handles] = update_seg_filename(hObject, eventdata, handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stim_intensity as text
%        str2double(get(hObject,'String')) returns contents of stim_intensity as a double
end

% --- Executes during object creation, after setting all properties.
function stim_intensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function [handles] = update_seg_filename(hObject, eventdata, handles)

handles.params.segment_filename = [handles.params.subj_id '-' handles.params.visit_number '-' handles.params.date '-' handles.params.exp_type '-' handles.params.exp_condition '-' handles.params.stim_axis '-' handles.params.stim_type '-' handles.params.stim_frequency '-' handles.params.stim_intensity '.mat'];

set(handles.seg_filename,'String',handles.params.segment_filename);
end

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in plot_MPUGyroData.
function plot_MPUGyroData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_MPUGyroData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_MPUGyroData = 1;
else
    handles.params.plot_MPUGyroData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits
plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MPUGyroData
end

% --- Executes on button press in plot_TrigLine.
function plot_TrigLine_Callback(hObject, eventdata, handles)
% hObject    handle to plot_TrigLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_TrigLine = 1;
else
    handles.params.plot_TrigLine = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits
plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_TrigLine
end

% --- Executes on button press in plot_LEData.
function plot_LEData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_LEData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_LEData = 1;
else
    handles.params.plot_LEData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_LEData
end

% --- Executes on button press in plot_REData.
function plot_REData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_REData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_REData = 1;
else
    handles.params.plot_REData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_REData
end


function trig_mult_Callback(hObject, eventdata, handles)
% hObject    handle to trig_mult_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.trig_mult = input;
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of trig_mult_text as text
%        str2double(get(hObject,'String')) returns contents of trig_mult_text as a double
end

% --- Executes during object creation, after setting all properties.
function trig_mult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trig_mult_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in labdev_goggleID.
function labdev_goggleID_Callback(hObject, eventdata, handles)
% hObject    handle to labdev_goggleID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.goggleID = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns labdev_goggleID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from labdev_goggleID
end

% --- Executes during object creation, after setting all properties.
function labdev_goggleID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labdev_goggleID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in vog_data_acq_version.
function vog_data_acq_version_Callback(hObject, eventdata, handles)
% hObject    handle to vog_data_acq_version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.vog_data_acq_version = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns vog_data_acq_version contents as cell array
%        contents{get(hObject,'Value')} returns selected item from vog_data_acq_version
end

% --- Executes during object creation, after setting all properties.
function vog_data_acq_version_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vog_data_acq_version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in Lasker_param1.
function Lasker_param1_Callback(hObject, eventdata, handles)
% hObject    handle to Lasker_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');
handles.params.Lasker_param1 = index_selected;

guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns Lasker_param1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Lasker_param1
end

% --- Executes during object creation, after setting all properties.
function Lasker_param1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lasker_param1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in Lasker_param2.
function Lasker_param2_Callback(hObject, eventdata, handles)
% hObject    handle to Lasker_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');
handles.params.Lasker_param1 = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns Lasker_param2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Lasker_param2
end

% --- Executes during object creation, after setting all properties.
function Lasker_param2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lasker_param2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Xaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Xaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents as double
handles.Xaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of Xaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Xaxis_Rot_Theta as a double
end

% --- Executes during object creation, after setting all properties.
function Xaxis_Rot_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Yaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Yaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Yaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of Yaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Yaxis_Rot_Theta as a double
end

% --- Executes during object creation, after setting all properties.
function Yaxis_Rot_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Zaxis_Rot_Theta_Callback(hObject, eventdata, handles)
% hObject    handle to Zaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Zaxis_MPU_Rot_theta = str2double(get(hObject,'String'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of Zaxis_Rot_Theta as text
%        str2double(get(hObject,'String')) returns contents of Zaxis_Rot_Theta as a double
end

% --- Executes during object creation, after setting all properties.
function Zaxis_Rot_Theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zaxis_Rot_Theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function LaskerSystPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LaskerSystPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


function Xoffset_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Xoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xoffset_txt as text
%        str2double(get(hObject,'String')) returns contents of Xoffset_txt as a double
end

% --- Executes during object creation, after setting all properties.
function Xoffset_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Yoffset_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Yoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Yoffset_txt as text
%        str2double(get(hObject,'String')) returns contents of Yoffset_txt as a double
end

% --- Executes during object creation, after setting all properties.
function Yoffset_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function Zoffset_txt_Callback(hObject, eventdata, handles)
% hObject    handle to Zoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zoffset_txt as text
%        str2double(get(hObject,'String')) returns contents of Zoffset_txt as a double
end

% --- Executes during object creation, after setting all properties.
function Zoffset_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zoffset_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','w++hite');
end
end

% --- Executes on button press in calc_mpu_offsets.
function calc_mpu_offsets_Callback(hObject, eventdata, handles)
% hObject    handle to calc_mpu_offsets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Ask user to choose segmentation points
uiwait(msgbox('Please align the vertical line of the crosshair with the starting point of the data segment used to calculate MPU offsets','Segment Eye Movement Data'));
[x1,y1] = ginput(1);
uiwait(msgbox('Please align the vertical line of the crosshair with the ending point of the data segment used to calculate MPU offsets','Segment Eye Movement Data'));
[x2,y2] = ginput(1);
time_cutout_s = [x1 ; x2];

[a1,i_start_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(1,1)));
[a2,i_end_eye] = min(abs(handles.Segment.Time_Eye - time_cutout_s(2,1)));

X_off = mean(handles.Segment.HeadMPUVel_X(i_start_eye:i_start_eye));
Y_off = mean(handles.Segment.HeadMPUVel_Y(i_start_eye:i_start_eye));
Z_off = mean(handles.Segment.HeadMPUVel_Z(i_start_eye:i_start_eye));

handles.Segment.HeadMPUVel_X = handles.Segment.HeadMPUVel_X - X_off;
handles.Segment.HeadMPUVel_Y = handles.Segment.HeadMPUVel_Y - Y_off;
handles.Segment.HeadMPUVel_Z = handles.Segment.HeadMPUVel_Z - Z_off;


set(handles.Xoffset_txt,'String',num2str(X_off))
set(handles.Yoffset_txt,'String',num2str(Y_off))
set(handles.Zoffset_txt,'String',num2str(Z_off))
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
end

% --- Executes on selection change in gpio_trigger_source.
function gpio_trigger_source_Callback(hObject, eventdata, handles)
% hObject    handle to gpio_trigger_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(hObject,'Value');

handles.params.gpio_trig_opt = index_selected;

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns gpio_trigger_source contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gpio_trigger_source
end

% --- Executes during object creation, after setting all properties.
function gpio_trigger_source_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gpio_trigger_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in auto_segment.
function auto_segment_Callback(hObject, eventdata, handles,upper_trigLev,lower_trigLev)
% hObject    handle to auto_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~exist('upper_trigLev','var')
    upper_trigLev = 0;
end
if ~exist('lower_trigLev','var')
    lower_trigLev = 0;
end
[choice] = auto_seg_dialog(hObject, eventdata, handles);

switch choice.stim
    
    case 1 % Pulse Trains
        
        % Let's detect the ON/OFF times based on the GPIO trigger line.
        inds = [1:length(handles.Segment.Stim_Trig)];
        on_samp = inds([false ; (diff(handles.Segment.Stim_Trig) > upper_trigLev)]);
        off_samp = inds([false ; (diff(handles.Segment.Stim_Trig) < lower_trigLev)]);
        
        % NOTE: I should check if there are unequal numbers of detected ON and
        % OFF triggers
        
        % Let's create a trigger level to determine the PAUSES between
        % stimuli levels. We will set this level to half of the interstimulus interval.
        % We will relaize this by adding half of the ISI to the ON+OFF
        % times.
        trig_level = ((choice.ontime + choice.offtime) + choice.ISI/2)*(handles.Segment.Fs/1000);
        
        stim_interval_startpoints = [ on_samp([false  (diff(on_samp) > trig_level)])];
        
        
        stim_interval_endpoints = [off_samp(diff(off_samp) > trig_level) ];
        
        % Create a 'start_val' variable that is either on_samp(1) - half of
        % the inter-stimulus-interval, or one (i.e., the first time inde)
        % if that value is negative.
        start_val = max(on_samp(1)-(choice.ISI/2)*(handles.Segment.Fs/1000),1);
        
        seg_times = [start_val round((stim_interval_startpoints(1)-stim_interval_endpoints(1))/2+stim_interval_endpoints(1))];
        for k=1:length(stim_interval_startpoints)
            
            if k==length(stim_interval_startpoints)
                seg_times = [seg_times ; round((stim_interval_startpoints(end)-stim_interval_endpoints(end))/2+stim_interval_endpoints(end)) on_samp(end)+(choice.ISI/2)*(handles.Segment.Fs/1000)];
                
            else
                seg_times = [seg_times ; seg_times(k,2) round((stim_interval_startpoints(k+1)-stim_interval_endpoints(k+1))/2+stim_interval_endpoints(k+1))];
                
                %                 seg_times = [seg_times ; round((stim_interval_startpoints(k-1)-stim_interval_endpoints(k-1))/2+stim_interval_endpoints(k-1)) round((stim_interval_startpoints(k)-stim_interval_endpoints(k))/2+stim_interval_endpoints(k))];
            end
            
        end
        
        seg_times(seg_times(:,2)>length(inds),2) = length(inds)*ones(size(seg_times(seg_times(:,2)>length(inds),2),2),1);
        
        stem(handles.Segment.Time_Eye(seg_times(:,1)),handles.params.trig_mult*ones(length(seg_times(:,1)),1))
        
        stem(handles.Segment.Time_Eye(seg_times(:,2)),handles.params.trig_mult*0.75*ones(length(seg_times(:,1)),1))
        
        % Now that we have our segmentation times, lets load the
        % user-generated excel sheet containing the file names, and begin
        % segmenting!
        
        [filename, pathname] = ...
            uigetfile('*.xlsx','Please load an Excel spreadsheet containing the segmented filenames in the first row of the first sheet.');
        
        [num,txt,raw] = xlsread([pathname filename]);
        
        pre_auto_i_start_eye =  handles.i_start_eye;
        pre_auto_i_end_eye =  handles.i_end_eye;
        pre_auto_i_start_stim =  handles.i_start_stim;
        pre_auto_i_end_stim =  handles.i_end_stim;
        
        pre_auto_Seg_start_t = handles.Segment.start_t;
        pre_auto_Seg_end_t = handles.Segment.end_t;
        
%         handles.folder_name = uigetdir('','Select Directory to Save the Segmented Data');

        
        for k=1:size(seg_times,1)
            
            handles.i_start_eye = seg_times(k,1);
            handles.i_end_eye = seg_times(k,2);
            handles.i_start_stim = seg_times(k,1);
            handles.i_end_stim = seg_times(k,2);
            
            
            handles.Segment.start_t = handles.Segment.Time_Eye(handles.i_start_eye);
            handles.Segment.end_t = handles.Segment.Time_Eye(handles.i_end_eye);
            
            
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
            
            handles.params.segment_filename = [raw{k,1} '.mat'];
            
            save_segment_Callback(hObject, eventdata, handles);
            
            
            
            
            [handles] = reload_raw_Callback(hObject, eventdata, handles);
            
            handles.i_start_eye = pre_auto_i_start_eye;
            handles.i_end_eye = pre_auto_i_end_eye;
            handles.i_start_stim = pre_auto_i_start_stim;
            handles.i_end_stim = pre_auto_i_end_stim;
            
            
            handles.Segment.start_t =  pre_auto_Seg_start_t;
            handles.Segment.end_t = pre_auto_Seg_end_t;
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
            
        end
        
    case 2 % Electrical only Sinusoids
        Time = handles.Segment.Time_Stim(:,1);
        
        % Let's detect the ON/OFF times based on the GPIO trigger line.
        inds = [1:length(handles.Segment.Stim_Trig)];
        on_samp = inds([(handles.Segment.Stim_Trig > upper_trigLev)])';
        off_samp = inds([(handles.Segment.Stim_Trig < lower_trigLev)])';
        
        % NOTE: I should check if there are unequal numbers of detected ON and
        % OFF triggers
        
        % Let's create a trigger level to determine the PAUSES between
        % stimuli levels. We will set this level to half of the interstimulus interval.
        % We will relaize this by adding half of the ISI to the ON+OFF
        % times.
%         trig_level = ((choice.ontime + choice.offtime) + choice.ISI/2)*(handles.Segment.Fs/1000);
        trig_level = ((choice.ontime + choice.offtime) + choice.ISI/2)/1000; %For CED trigger times, the data is time-stamped on arrival and NOT synchronously sampled.
        
        stim_interval_startpoints = [ on_samp([false  ;(diff(Time(on_samp)) > trig_level)])];
        
        
        stim_interval_endpoints = [off_samp([(diff(Time(off_samp)) > trig_level) ; false])];
        
        preposttime = choice.preposttime/1000;
        % Create a 'start_val' variable that is either on_samp(1) - half of
        % the inter-stimulus-interval, or one (i.e., the first time inde)
        % if that value is negative.
%         start_val = max(on_samp(1)-(choice.ISI/2)*(handles.Segment.Fs/1000),1);
        start_val = max(Time(on_samp(1))-(preposttime),Time(1));
        end_val = min(Time(off_samp(end))+(preposttime),Time(end));
%                 timedif = Time - start_val;
%                 timedif(timedif<0) = nan(length(timedif(timedif<0)),1);
%                 [a1,a2] = min(timedif);
%         seg_times = [start_val round((stim_interval_startpoints(1)-stim_interval_endpoints(1))/2+stim_interval_endpoints(1))];
        seg_times_a = [start_val ; Time(stim_interval_startpoints) - preposttime];
        seg_times_b = [Time(stim_interval_endpoints) + preposttime ; end_val];
        
        seg_times = [seg_times_a seg_times_b];
%         for k=1:length(stim_interval_startpoints)
%             
%             if k==length(stim_interval_startpoints)
%                 seg_times = [seg_times ; round((stim_interval_startpoints(end)-stim_interval_endpoints(end))/2+stim_interval_endpoints(end)) on_samp(end)+(choice.ISI/2)*(handles.Segment.Fs/1000)];
%                 
%             else
%                 seg_times = [seg_times ; seg_times(k,1)-preposttime seg_times(k,2)+preposttime];
%                 
%                 %                 seg_times = [seg_times ; round((stim_interval_startpoints(k-1)-stim_interval_endpoints(k-1))/2+stim_interval_endpoints(k-1)) round((stim_interval_startpoints(k)-stim_interval_endpoints(k))/2+stim_interval_endpoints(k))];
%             end
%             
%         end
        
%         seg_times(seg_times(:,2)>length(inds),2) = length(inds)*ones(size(seg_times(seg_times(:,2)>length(inds),2),2),1);
%         seg_times = round(seg_times);
        stem(seg_times(:,1),handles.params.trig_mult*ones(length(seg_times(:,1)),1))
        
        stem(seg_times(:,2),handles.params.trig_mult*0.75*ones(length(seg_times(:,1)),1))
        
        % Now that we have our segmentation times, lets load the
        % user-generated excel sheet containing the file names, and begin
        % segmenting!
        
        [filename, pathname] = ...
            uigetfile('*.xlsx','Please load an Excel spreadsheet containing the segmented filenames in the first row of the first sheet.');
        
        [num,txt,raw] = xlsread([pathname filename]);
        
        pre_auto_i_start_eye =  handles.i_start_eye;
        pre_auto_i_end_eye =  handles.i_end_eye;
        pre_auto_i_start_stim =  handles.i_start_stim;
        pre_auto_i_end_stim =  handles.i_end_stim;
        
        pre_auto_Seg_start_t = handles.Segment.start_t;
        pre_auto_Seg_end_t = handles.Segment.end_t;
        
        
        % Find Stim start times
        timedif1 = repmat(handles.Segment.Time_Eye(:,1),1,length(seg_times(:,1)')) - repmat(seg_times(:,1)',length(handles.Segment.Time_Eye(:,1)),1);
        timedif1(timedif1<0) = nan;
        [a1,a2] = min(timedif1);
        eye_startinds = a2;
        
        timedif2 = repmat(handles.Segment.Time_Eye(:,1),1,length(seg_times(:,2)')) - repmat(seg_times(:,2)',length(handles.Segment.Time_Eye(:,1)),1);
        timedif2(timedif2<0) = nan;
        [a1,a2] = min(timedif2);
        eye_endinds = a2;
        
        % Find Stim start times
        timedif3 = repmat(handles.Segment.Time_Stim(:,1),1,length(seg_times(:,1)')) - repmat(seg_times(:,1)',length(handles.Segment.Time_Stim(:,1)),1);
        timedif3(timedif3<0) = nan;
        [a1,a2] = min(timedif3);
        stim_startinds = a2;
        
        timedif4 = repmat(handles.Segment.Time_Stim(:,1),1,length(seg_times(:,2)')) - repmat(seg_times(:,2)',length(handles.Segment.Time_Stim(:,1)),1);
        timedif4(timedif4<0) = nan;
        [a1,a2] = min(timedif4);
        stim_endinds = a2;
        
        
        
        
        for k=1:size(seg_times,1)
            
            handles.i_start_eye = eye_startinds(k);
            handles.i_end_eye = eye_endinds(k);
            
            
           
            handles.i_start_stim = stim_startinds(k);
            handles.i_end_stim = stim_endinds(k);
            
            
            handles.Segment.start_t = handles.Segment.Time_Eye(handles.i_start_eye);
            handles.Segment.end_t = handles.Segment.Time_Eye(handles.i_end_eye);
            
            
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
            
            handles.params.segment_filename = [raw{k,1} '.mat'];
            
            save_segment_Callback(hObject, eventdata, handles);
            
            
            
            
            [handles] = reload_raw_Callback(hObject, eventdata, handles);
            
            handles.i_start_eye = pre_auto_i_start_eye;
            handles.i_end_eye = pre_auto_i_end_eye;
            handles.i_start_stim = pre_auto_i_start_stim;
            handles.i_end_stim = pre_auto_i_end_stim;
            
            
            handles.Segment.start_t =  pre_auto_Seg_start_t;
            handles.Segment.end_t = pre_auto_Seg_end_t;
            
            [handles] = new_segment_Callback(hObject, eventdata, handles,false);
        end
        
end
end



function [options] = auto_seg_dialog(hObject, eventdata, handles)


d = dialog('Position',[300 300 400 150],'Name','Select stimulus type');
txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 300 40],...
    'String','Please select the stimulus type for this file');

popup = uicontrol('Parent',d,...
    'Style','popup',...
    'Position',[75 70 225 25],...
    'String',{'Pulse Train';'Electric Only Sinusoid [CED]';'Mechanical Sinusoid'},...
    'Callback',@choose_stimuli_callback);
%             'Callback',{@popup_callback,hObject, eventdata, handles});

btn = uicontrol('Parent',d,...
    'Position',[89 20 70 25],...
    'String','Proceed',...
    'Callback','delete(gcf)');

%     'Callback',@popup_closefcn);

choice = 'Pulse Train';

% Wait for d to close before running to completion
uiwait(d);

    function choose_stimuli_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        
        choice = char(popup_items(idx,:));
        
        
        
    end

switch choice
    
    case 'Pulse Train'
        options = pulse_train_dialog(hObject, eventdata, handles);
        options.stim = 1;
    case 'Electric Only Sinusoid [CED]'
        options = elec_only_sine_CED_dialog(hObject, eventdata, handles);
        options.stim = 2;
    case 'Mechanical Sinusoid'
        
        
        
end



% analyze_new_voma_file_Callback(hObject, eventdata, handles)


end





function [options] = pulse_train_dialog(hObject, eventdata, handles)


d2 = dialog('Position',[300 300 400 400],'Name','Pulse Train Params');
txt1 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 300 350 40],...
    'String','Please enter the ON time of each pulse train cycle [ms]:');

in1 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 290 75 25],...
    'Units','normalized',...
    'Callback',@ontime_callback);

txt2 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 225 300 40],...
    'String','Please enter the OFF time of each pulse train cycle [ms]:');

in2 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 215 75 25],...
    'Units','normalized',...
    'Callback',@offtime_callback);

txt3 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 150 300 40],...
    'String','Please enter the pause time between stimulus conditions [ms]');

in3 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 140 75 25],...
    'Units','normalized',...
    'Callback',@ISI_callback);


btn = uicontrol('Parent',d2,...
    'Position',[89 20 70 25],...
    'String','Proceed',...
    'Callback','delete(gcf)');


options.ontime = [];
options.offtime = [];
options.ISI = [];

% Wait for d to close before running to completion
uiwait(d2);


    function ontime_callback(popup,event)
        ontime = str2double(get(popup,'string'));
        
    end


    function offtime_callback(popup,event)
        offtime = str2double(get(popup,'string'));
    end

    function ISI_callback(popup,event)
        ISI = str2double(get(popup,'string'));
    end


options.ontime = ontime;
options.offtime = offtime;
options.ISI = ISI;

end


function [options] = elec_only_sine_CED_dialog(hObject, eventdata, handles)


d2 = dialog('Position',[300 300 400 400],'Name','Pulse Train Params');
txt1 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 300 350 40],...
    'String','Please enter the freq. of the sine tested [Hz]:');

in1 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 290 75 25],...
    'Units','normalized',...
    'Callback',@freq_callback);

txt2 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 225 300 40],...
    'String','Please enter the pre- and post- time added to each segment [ms]:');

in2 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 215 75 25],...
    'Units','normalized',...
    'Callback',@preposttime_callback);

txt3 = uicontrol('Parent',d2,...
    'Style','text',...
    'Position',[20 150 300 40],...
    'String','Please enter the pause time between stimulus conditions [ms]');

in3 = uicontrol('Parent',d2,...
    'Style','edit',...
    'Position',[140 140 75 25],...
    'Units','normalized',...
    'Callback',@ISI_callback);




btn = uicontrol('Parent',d2,...
    'Position',[89 20 70 25],...
    'String','Proceed',...
    'Callback','delete(gcf)');


options.ontime = [];
options.offtime = [];
options.ISI = [];
options.preposttime = [];
% Wait for d to close before running to completion
uiwait(d2);


    function freq_callback(popup,event)
        freq = str2double(get(popup,'string'));
        ontime = ((1/freq)/2) * 1000; % This parameter is saved in [ms]
        offtime = (1/freq)/2 * 1000; % This parameter is saved in [ms]
    end

    function preposttime_callback(popup,event)
        preposttime = str2double(get(popup,'string'));
       
    end
    function ISI_callback(popup,event)
        ISI = str2double(get(popup,'string'));
    end


options.ontime = ontime;
options.offtime = offtime;
options.ISI = ISI;
options.preposttime = preposttime;
end

% --- Executes on button press in plot_MPUAccelData.
function plot_MPUAccelData_Callback(hObject, eventdata, handles)
% hObject    handle to plot_MPUAccelData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_MPUAccelData = 1;
else
    handles.params.plot_MPUAccelData = 0;
end

% Update plots!
keep_plot_limit = true; % We want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MPUGyroData
end


% --- Executes on button press in plot_IPR_flag.
function plot_IPR_flag_Callback(hObject, eventdata, handles)
% hObject    handle to plot_IPR_flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.params.plot_IPR_flag = 1;
else
    handles.params.plot_IPR_flag = 0;
end

% Update plots!
keep_plot_limit = false; % We do not want to keep the same plot limits

plot_segment_data(hObject, eventdata, handles,keep_plot_limit)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of plot_MPUGyroData
end


% --- Executes on button press in auto_seg_lasker.
function auto_seg_lasker_Callback(hObject, eventdata, handles)
% hObject    handle to auto_seg_lasker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

upper_trigLev = handles.params.upper_trigLev;
lower_trigLev = handles.params.lower_trigLev;

auto_segment_Callback(hObject, eventdata, handles,upper_trigLev,lower_trigLev)

end



function upper_trigLev_Callback(hObject, eventdata, handles)
% hObject    handle to upper_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.upper_trigLev = input;

guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of upper_trigLev as text
%        str2double(get(hObject,'String')) returns contents of upper_trigLev as a double

end
% --- Executes during object creation, after setting all properties.
function upper_trigLev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function lower_trigLev_Callback(hObject, eventdata, handles)
% hObject    handle to lower_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = str2double(get(hObject,'String'));
handles.params.lower_trigLev = input;

guidata(hObject,handles)

end
% Hints: get(hObject,'String') returns contents of lower_trigLev as text
%        str2double(get(hObject,'String')) returns contents of lower_trigLev as a double


% --- Executes during object creation, after setting all properties.
function lower_trigLev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_trigLev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in load_excel_sheet.
function load_spread_sheet_Callback(hObject, eventdata, handles)
% hObject    handle to load_excel_sheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Prompt user for experimental file
[FileName,PathName,FilterIndex] = uigetfile('*.xlsx','Please choose the experimental batch spreadsheet where the data will be exported');
            
handles.ss_PathName = PathName;
handles.ss_FileName = FileName;
            
set(handles.exp_spread_sheet_name,'String',FileName);
guidata(hObject,handles)
end

% --- Executes on button press in export_data.
% Exports temporarily saved data from text boxes to spreadsheet
% Compares filenames if worksheet is already present and replaces old data
% with new if match is found
function export_data_Callback(hObject, eventdata, handles)
% hObject    handle to export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd(handles.ss_PathName);
[status,sheets,xlFormat] = xlsfinfo(handles.ss_FileName);
if ismember(handles.worksheet_name.String, sheets)
    segs = size(handles.experimentdata);
    [num1, txt1, raw1] = xlsread(handles.exp_spread_sheet_name.String, handles.worksheet_name.String,'A:A');
    oldVals = size(txt1);
    newEntry = 0;
    for rs = 1:segs(1)
        if ismember([handles.experimentdata(rs,1)],txt1) 
            replaceInd = [find(ismember(txt1,[handles.experimentdata(rs,1)]))];
        xlswrite(handles.ss_FileName, [handles.experimentdata(rs,:)], handles.worksheet_name.String, ['A',num2str(replaceInd(1)),':Q',num2str(replaceInd(1))]);
        
        else
        xlswrite(handles.ss_FileName, [handles.experimentdata(rs,:)], handles.worksheet_name.String, ['A',num2str(oldVals(1)+1+newEntry),':Q',num2str(oldVals(1)+1+newEntry)]);
        newEntry = newEntry+1;
        end
    end
else
    labels = {'File Name','Date','Subject','Implant','Eye Recorded','Compression','Max PR [pps]','Baseline [pps]','Function','Mod Canal','Mapping Type','Frequency [Hz]','Max Velocity [dps]','Phase [degrees]','Cycles','Phase Direction','Notes'};
    xlswrite(handles.exp_spread_sheet_name.String, labels, handles.worksheet_name.String,'A1:Q1')
    segs = size(handles.experimentdata);
    xlswrite(handles.exp_spread_sheet_name.String, [handles.experimentdata], handles.worksheet_name.String, ['A2:Q',num2str(segs(1)+1)]);
end
handles.export_data.BackgroundColor = [0    1    0];
pause(1);
handles.export_data.BackgroundColor = [0.9400    0.9400    0.9400];
guidata(hObject,handles)
end

function implant_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes during object creation, after setting all properties.
function implant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function eye_rec_Callback(hObject, eventdata, handles)
% hObject    handle to stim_intensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
    
% --- Executes during object creation, after setting all properties.
function eye_rec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subj_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
