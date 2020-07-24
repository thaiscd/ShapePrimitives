function varargout = input_path(varargin)
% input_path MATLAB code for input_path.fig
%      input_path, by itself, creates a new input_path or raises the existing
%      singleton*.
%
%      H = input_path returns the handle to a new input_path or the handle to
%      the existing singleton*.
%
%      input_path('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in input_path.M with the given input arguments.
%
%      input_path('Property','Value',...) creates a new input_path or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before input_path_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to input_path_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help input_path

% Last Modified by GUIDE v2.5 16-Aug-2019 17:45:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @input_path_OpeningFcn, ...
                   'gui_OutputFcn',  @input_path_OutputFcn, ...
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


% --- Executes just before input_path is made visible.
function input_path_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for input_path
    handles.output = hObject;
    % Initial Settings
    set(handles.Fix_Push_Button,'Enable','off');
    set(handles.delete_MP,'Enable','off');
    set(handles.delete_Obs,'Enable','off');
    set(handles.Delete_Rect_Push_Button, 'Enable', 'off');
    set(handles.Rectangle_Push_Button, 'Enable', 'on');
    set(handles.find_sol_button, 'Enable', 'off');
    set(handles.animate_button, 'Enable', 'off');
    set(handles.text_display, 'String', ['Instructions', newline, newline, 'Select a curve type']);
    set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'You are good for now'], 'ForegroundColor', 'g');
    % fix button
    global fix;
    fix = [];    
    % curve type
    global curve_type;
    curve_type = 0;
    % PMs with index, type, two coordinates       
    global pm;
    pm = [];
    % for saving pm in txt
    global pms;
    pms = [];
    % Obstacles - same for here and txt cause not used for pms 
    global obs;
    obs = [];
    % For calling diff bash file
    global axis_lim_update;
    axis_lim_update = 1;
    % For saving limits of origin
    global limitsO;
    limitsO = [];
    global nitermax; 
    nitermax = 100;
    
    handles.hplot = [];   
    hold(handles.workspace,'on');   
    grid(handles.workspace, 'on')
    hold on;
    axis([-1,1,-1,1]);
    axes(handles.workspace);
    xlabel(handles.workspace,'x(m)');
    ylabel(handles.workspace,'y(m)');
    title(handles.workspace,'Workspace');
    % Update handles structure
    guidata(hObject, handles);
    % UIWAIT makes input_path wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = input_path_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

% --- Executes on button press in Line_Push_Button.
function Line_Push_Button_Callback(hObject, eventdata, handles)
    global curve_type;
    global pm;
    curve_type = 1;
    if isempty(pm)
        set(handles.text_display, 'String', ['Instructions', newline, 'Click two points in the workspace', newline,...
            'After clicking the points, press fix button', newline, ...
            'You can delete only after you fix the motion primitive or obstacle you are currently creating.', newline, ...
            'Drag the blue circles to desired location', newline, newline, ...
            'Do NOT click more than the instructed points', newline, ...
            'Do NOT click on the blue circles - you might have to restart the process']);
    else
        set(handles.text_display, 'String', ['Instructions', newline, newline, 'Click one point in the workspace', newline,...
            'After clicking the point, press fix button', newline, ...
            'You can delete only after you fix the motion primitive or obstacle you are currently creating.', newline, ...
            'Drag the blue circle/circles to desired location', newline, newline, ...
            'Do NOT click more than the instructed point/points', newline, ...
            'Do NOT click on the blue circle/circles - you might have to restart the process']);
    end
    set(handles.Line_Push_Button, 'Enable', 'off');
    set(handles.Circle_Push_Button, 'Enable', 'off');
    set(handles.Arc_Push_Button, 'Enable', 'off');
    set(handles.Obstacle_Push_Button, 'Enable', 'off');
    set(handles.Fix_Push_Button,'Enable','on');
    set(handles.Delete_Rect_Push_Button, 'Enable', 'off');
    set(handles.Rectangle_Push_Button, 'Enable', 'off');
    guidata(hObject, handles);

% --- Executes on button press in Circle_Push_Button.
function Circle_Push_Button_Callback(hObject, eventdata, handles)
    global curve_type;
    curve_type = 2;
    global pm;
    if isempty(pm)
        set(handles.text_display, 'String', ['Instructions', newline, 'Click two points in the workspace', newline,...
            'After clicking the points, press fix button', newline, 'Do NOT click more than instructed points']);
    else
        set(handles.text_display, 'String', ['Instructions', newline, newline, 'Click one point in the workspace']);
    end
    set(handles.Line_Push_Button, 'Enable', 'off');
    set(handles.Circle_Push_Button, 'Enable', 'off');
    set(handles.Arc_Push_Button, 'Enable', 'off');
    set(handles.Obstacle_Push_Button, 'Enable', 'off');
    set(handles.Fix_Push_Button,'Enable','on');
    set(handles.Delete_Rect_Push_Button, 'Enable', 'off');
    set(handles.Rectangle_Push_Button, 'Enable', 'off');
    guidata(hObject, handles);

% --- Executes on button press in Arc_Push_Button.
function Arc_Push_Button_Callback(hObject, eventdata, handles)
    global curve_type;
    curve_type = 3;
    global pm;
    if isempty(pm)
        set(handles.text_display, 'String', ['Instructions', newline, 'Click two points in the workspace', newline,...
            'After clicking the points, press fix button', newline, 'Do NOT click more than instructed points']);
    else
        set(handles.text_display, 'String', ['Instructions', newline, newline, 'Click one point in the workspace']);
    end
    set(handles.Line_Push_Button, 'Enable', 'off');
    set(handles.Circle_Push_Button, 'Enable', 'off');
    set(handles.Arc_Push_Button, 'Enable', 'off');
    set(handles.Obstacle_Push_Button, 'Enable', 'off');
    set(handles.Fix_Push_Button,'Enable','on');
    set(handles.Delete_Rect_Push_Button, 'Enable', 'off');
    set(handles.Rectangle_Push_Button, 'Enable', 'off');
    guidata(hObject, handles);


% --- Executes on button press in Obstacle_Push_Button.
function Obstacle_Push_Button_Callback(hObject, eventdata, handles)
    global curve_type;
    curve_type = 4;
    
    set(handles.text_display, 'String', ['Instructions', newline, 'Click two points in the workspace', newline,...
            'After clicking the points, press fix button', newline, 'Do NOT click more than instructed points']);
    
    set(handles.Line_Push_Button, 'Enable', 'off');
    set(handles.Circle_Push_Button, 'Enable', 'off');
    set(handles.Arc_Push_Button, 'Enable', 'off');
    set(handles.Obstacle_Push_Button, 'Enable', 'off');
    set(handles.Fix_Push_Button,'Enable','on');
    set(handles.Delete_Rect_Push_Button, 'Enable', 'off');
    set(handles.Rectangle_Push_Button, 'Enable', 'off');
    guidata(hObject, handles);

function Rectangle_Push_Button_Callback(hObject, eventdata, handles)
% --- Executes on mouse press over axes background.
    global curve_type;
    curve_type = 5;
    set(handles.text_display, 'String', ['Instructions', newline, 'Click two points in the workspace', newline,...
            'After clicking the points, press fix button', newline, 'Do NOT click more than instructed points']);
    set(handles.Line_Push_Button, 'Enable', 'off');
    set(handles.Circle_Push_Button, 'Enable', 'off');
    set(handles.Arc_Push_Button, 'Enable', 'off');
    set(handles.Obstacle_Push_Button, 'Enable', 'off');
    set(handles.Rectangle_Push_Button, 'Enable', 'off');
    set(handles.Fix_Push_Button,'Enable','on');
        
function workspace_ButtonDownFcn(hObject, eventdata, handles)
    global fix;
    global h1;
    global h2;
    global h3; 
    global h5;
    global h6;
    global pm;
    global curve_type;
    global midpoint_on_arc;
    global new_th;
    global new_center;
    global new_radius;
    global end_point1;
    global end_point2;
    global initial_dir;
    global modified;
    modified = 0;
    handles.hplot = plot([0, 0], [0, 0], 'linewidth', 3, 'color', [0.6350, 0.0780, 0.1840]);
    guidata(hObject, handles);
    if curve_type ~= 0  && curve_type ~= 4 && curve_type ~= 5   
        if isempty(pm)
            [x1,y1] = ginput(1);

            hold(handles.workspace,'on');
            hold on;
            h1 = drawpoint('Position',[x1(1, 1), y1(1,1)]);
            [x,y] = ginput(1);
            h2 = drawpoint('Position',[x(1, 1), y(1,1)]);
            guidata(hObject, handles);  
            pp1 = [x1(1, 1), y1(1,1)];
            pp2 = [x(1, 1), y(1,1)]; 
        else
            [x,y] = ginput(1);
            hold(handles.workspace,'on');
            hold on;
            h2 = drawpoint('Position',[x(1, 1), y(1,1)]);       
            h1 = pm(end, 5:6);    
            guidata(hObject, handles);
            pp1 = [x(1, 1), y(1,1)];
            pp2 = pm(end, 5:6); 
        end
        if curve_type == 3       
            ini_center = (pp1 + pp2)/2;
            radius = norm(pp1-pp2)/2;            
            
            vect2 = ini_center-pp2;
            vect1 = ini_center-pp1;
            ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
            ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
            xs = radius* cosd(ang2-90) + ini_center(1,1);
            ys = radius* sind(ang2-90) + ini_center(1,2);               
            midpoint_on_arc = [xs, ys]; 
            h3 = drawpoint('Position', midpoint_on_arc); 
            Bx = pp2(1,1);
            By = pp2(1,2);
            Ax = pp1(1,1);
            Ay = pp1(1,2);
            X = xs;
            Y = ys;           
            initial_dir = sign((Bx - Ax) * (Y - Ay) - (By - Ay) * (X - Ax));
                        
            ang1 = mod(ang1-ang2,360)+ang2;
            new_th = linspace(ang2-180,ang1-180, 50);
            new_center = ini_center;
            new_radius = radius;
            end_point1 = pp1;
            end_point2 = pp2;
        end
        while 1
            plotnow(hObject, handles);
            guidata(hObject, handles);
            if ~isempty(fix) 
                if fix(end, 1) == 1 
                    fix = [fix; 0];
                    break
                end
            end
        end  
    elseif curve_type == 4 || curve_type == 5
        [x,y] = ginput(1);
        hold(handles.workspace,'on');
        hold on;
        h5 = drawpoint('Position',[x(1, 1), y(1,1)]);
        [x1,y1] = ginput(1);
        h6 = drawpoint('Position',[x1(1, 1), y1(1,1)]);
        guidata(hObject, handles); 
        while 1
            plotnow(hObject, handles);
            guidata(hObject, handles);
            if ~isempty(fix) 
                if fix(end, 1) == 1 
                    fix = [fix; 0];
                    break
                end
            end
        end
    end 

function [] = plotnow(hObject, handles)
    global h1;
    global h2;
    global h3;
    global h5;
    global h6;
    global curve_type;
    global pm;
    global midpoint_on_arc;
    global new_th;
    global new_center;
    global new_radius;
    global end_point1;
    global end_point2;
    global initial_dir;
    global modified;
    global obs_temp;
    global pms_temp;
    global limitsO_temp;
    if curve_type == 1
        pp2 = h2.Position;
        if isempty(pm)
            pp1 = h1.Position;
        else
            pp1 = h1;
        end
        xs = [pp1(1,1), pp2(1,1)];
        ys = [pp1(1,2), pp2(1,2)];
        h = handles.hplot;    
        h.XData = xs;
        h.YData = ys;
        set(h,'Color',[0.5, 0.5, 0.5]);
        pms_temp = [1, pp1(1,1), pp1(1,2), pp2(1,1),pp2(1,2), 0, 0];
        bool = checkCollisionAddNewMP(hObject, handles);
        if bool == 1
            set(h, 'LineStyle', '--');            
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'MOVE AWAY FROM OBSTACLES!'],'ForegroundColor', 'r');
        else
            set(h, 'LineStyle', '-');
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'You are good for now'],'ForegroundColor', 'g');
        end  
    elseif curve_type == 2
        pp2 = h2.Position;
        if isempty(pm)
            pp1 = h1.Position;
        else
            pp1 = h1;
        end
        center = (pp1 + pp2)/2;
        radius = norm(pp1-pp2)/2;
        th = 0:180/50:360;
        xs = radius* cosd(th) + center(1,1);
        ys = radius* sind(th) + center(1,2);
        h = handles.hplot;    
        h.XData = xs;
        h.YData = ys;
        set(h,'Color',[0.5, 0.5, 0.5]);
        pms_temp = [0, center(1,1), center(1,2), radius, 0, 0, 0];
        bool = checkCollisionAddNewMP(hObject, handles);
        if bool == 1
            set(h, 'LineStyle', '--');            
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'MOVE AWAY FROM OBSTACLES!'],'ForegroundColor', 'r');
        else
            set(h, 'LineStyle', '-');
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'You are good for now'],'ForegroundColor', 'g');
        end  
    elseif curve_type == 3  
        pp2 = h2.Position;
        if isempty(pm)
            pp1 = h1.Position;
        else
            pp1 = h1;
        end
        curr_midpoint_on_arc = h3.Position;
        pp3 = curr_midpoint_on_arc;
        
        if norm(midpoint_on_arc - curr_midpoint_on_arc) > 0
            midpoint = (pp1 + pp2)/2;
            ab_vector = pp1-pp2;
            v = pp3 - midpoint;
            om_unit = -[ab_vector(1,2), -ab_vector(1,1)];
            om_unit = om_unit/norm(om_unit);
            D = om_unit.*v;
            D = sum(D);
            pp4 = midpoint + om_unit*D;
            
            h = norm(midpoint - pp4);
            d = norm(pp1 - pp2);
            radius = ((d^2)/(8*h)) + (h/2);
            m = radius;
            n = h - radius;
            center = (m.*midpoint + n.*pp4)./(m+n);
            
            vect2 = center-pp2;
            vect1 = center-pp1;
            ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
            ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
            Bx = pp2(1,1);
            By = pp2(1,2);
            Ax = pp1(1,1);
            Ay = pp1(1,2);
            X = pp4(1,1);
            Y = pp4(1,2);           
            current_dir = sign((Bx - Ax) * (Y - Ay) - (By - Ay) * (X - Ax));
            
            if current_dir == initial_dir || current_dir == 0
                ang1 = mod(ang1-ang2,360)+ang2;                
                new_th = linspace(ang2-180,ang1-180, 50);
                modified = 0;
            else                
                ang2 = mod(ang2-ang1,360)+ang1;
                new_th = linspace(ang2-180,ang1-180, 50);
                modified = 1;
            end            
            new_center = center;   
            new_radius = radius;
            midpoint_on_arc = pp4;
            delete(h3);
            h3 = drawpoint('Position', midpoint_on_arc);
        elseif norm(end_point1 - pp1) > 0 
            d = norm(pp1 - pp2);
            theta = new_th(1,end) - new_th(1,1);   
            theta = wrapTo360(theta);
            radius = d/(2*sind(theta/2));
            x0 = pp1(1,1);
            y0 = pp1(1,2);
            x1 = pp2(1,1);
            y1 = pp2(1,2);
            dist = (radius^2) - ((d/2)^2);
            if theta > 180
                xc = ((x0+x1)/2) - ((y1-y0)*sqrt(dist)/d);
                yc = ((y0+y1)/2) + ((x1-x0)*sqrt(dist)/d);
            else
                xc = ((x0+x1)/2) + ((y1-y0)*sqrt(dist)/d);
                yc = ((y0+y1)/2) - ((x1-x0)*sqrt(dist)/d);
            end
            center = [xc, yc];
            radius = norm(center - pp1);
            
            new_center = center;
            new_radius = radius;
            end_point1 = pp1;           
            vect2 = center-pp2;
            vect1 = center-pp1;
            ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
            ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
            if modified == 0
                ang1 = mod(ang1-ang2,360)+ang2;
                new_th = linspace(ang2-180,ang1-180, 50);                
            end
            if modified == 1
                ang2 = mod(ang2-ang1,360)+ang1;
                new_th = linspace(ang2-180,ang1-180, 50);                
            end
            delete(h3);
            midpoint_on_arc = [radius*cosd((ang1+ang2-360)/2) + xc, radius*sind((ang1+ang2-360)/2) + yc];
            h3 = drawpoint('Position', midpoint_on_arc);
        elseif norm(end_point2 - pp2) > 0
            d = norm(pp1 - pp2);
            theta = new_th(1,end) - new_th(1,1);   
            theta = wrapTo360(theta);
            radius = d/(2*sind(theta/2));
            x0 = pp1(1,1);
            y0 = pp1(1,2);
            x1 = pp2(1,1);
            y1 = pp2(1,2);
            dist = (radius^2) - ((d/2)^2);            
            if theta > 180
                xc = ((x0+x1)/2) - ((y1-y0)*sqrt(dist)/d);
                yc = ((y0+y1)/2) + ((x1-x0)*sqrt(dist)/d);
            else
                xc = ((x0+x1)/2) + ((y1-y0)*sqrt(dist)/d);
                yc = ((y0+y1)/2) - ((x1-x0)*sqrt(dist)/d);
            end
            center = [xc, yc];
            radius = norm(center - pp2);
            
            new_center = center;
            new_radius = radius;
            end_point2 = pp2;           
            vect2 = center-pp2;
            vect1 = center-pp1;
            ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
            ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
            if modified == 0
                ang1 = mod(ang1-ang2,360)+ang2;
                new_th = linspace(ang2-180,ang1-180, 50);                
            end
            if modified == 1
                ang2 = mod(ang2-ang1,360)+ang1;
                new_th = linspace(ang2-180,ang1-180, 50);                
            end
            delete(h3);
            midpoint_on_arc = [radius*cosd((ang1+ang2-360)/2) + xc, radius*sind((ang1+ang2-360)/2) + yc];
            h3 = drawpoint('Position', midpoint_on_arc);
        end        
        xs = new_radius* cosd(new_th) + new_center(1, 1); 
        ys = new_radius* sind(new_th) + new_center(1, 2); 
        h = handles.hplot;    
        h.XData = xs;
        h.YData = ys;
        set(h,'Color',[0.5, 0.5, 0.5]);
        if modified == 1
            pms_temp = [-2, new_center(1, 1), new_center(1, 2), end_point1(1, 1), end_point1(1,2), end_point2(1,1),end_point2(1,2)]; 
        else
            pms_temp = [2, new_center(1, 1), new_center(1, 2), end_point1(1, 1), end_point1(1,2), end_point2(1,1),end_point2(1,2)];
        end
        bool = checkCollisionAddNewMP(hObject, handles);
        if bool == 1
            set(h, 'LineStyle', '--');            
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'MOVE AWAY FROM OBSTACLES!']);
        else
            set(h, 'LineStyle', '-');
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'You are good for now']);
        end 
    elseif curve_type == 4        
        pp1 = h5.Position;
        pp2 = h6.Position;
        center = (pp1 + pp2)/2;
        radius = norm(pp1-pp2)/2;
        th = 0:180/50:360;
        xs = radius* cosd(th) + center(1,1);
        ys = radius* sind(th) + center(1,2);
        h = handles.hplot;    
        h.XData = xs;
        h.YData = ys;
        set(h,'Color',[0.6350, 0.0780, 0.1840])
        obs_temp = [center(1, 1), center(1, 2), radius];
        bool = checkCollisionAddNewObs(hObject, handles);
        if bool == 1
            set(h, 'LineStyle', '--');
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'MOVE AWAY FROM SHAPE PRIMITIVES!'],'ForegroundColor', 'r');
        else
            set(h, 'LineStyle', '-');
            set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'You are good for now'],'ForegroundColor', 'g');
        end        
    elseif curve_type == 5      
        pp1 = h5.Position;
        pp2 = h6.Position;
        min_x = min(pp1(1, 1), pp2(1, 1));
        min_y = min(pp1(1, 2), pp2(1, 2));
        max_x = max(pp1(1, 1), pp2(1, 1));
        max_y = max(pp1(1, 2), pp2(1, 2));
        
        xs = [min_x, max_x, max_x, min_x, min_x];
        ys = [min_y, min_y, max_y, max_y, min_y];
        h = handles.hplot;    
        h.XData = xs;
        h.YData = ys;
        set(h, 'Color', 'k');
        set(h, 'linewidth', 3);
        set(h, 'LineStyle', '-');
%         limitsO_temp = [min_x, max_x, min_y, max_y];
%         bool = checkCollisionAddNewRect(hObject, handles);
%         if bool == 1
%             set(h, 'LineStyle', '--');
%             set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'MOVE AWAY FROM MPs and Obs!'],'ForegroundColor', 'r');
%         else
%             set(h, 'LineStyle', '-');
%             set(handles.warning_txt_collision, 'String', ['Warnings', newline, newline, 'You are good for now'],'ForegroundColor', 'g');
%         end 
        
    end
    t1 = text(pp1(1,1), pp1(1,2), 'P1', 'Parent', handles.workspace);
    set(t1,'String','P1')    
    t2 = text(pp2(1,1), pp2(1,2), 'P2', 'Parent', handles.workspace);
    set(t2,'String','P2')
    pause(0.5);
    delete(t1);
    delete(t2);
    drawnow;
    hold(handles.workspace,'on');
    hold on;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Instructions_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end    
    guidata(hObject, handles);

% --- Executes on button press in Fix_Push_Button.
function Fix_Push_Button_Callback(hObject, eventdata, handles)
    global h1;
    global h2;
    global fix;
    global curve_type;
    global pm;
    global h3;
    global h5;
    global h6;
    global obs;
    global new_radius;
    global new_th;
    global new_center;
    global modified;
    global pms;
    global obs_temp;
    global pms_temp;
    global limitsO;
    global limitsO_temp;
    fix = [fix; 1];
    guidata(hObject, handles);    
    
    if curve_type == 1
        if isempty(pm)
            pp1 = h1.Position;
            delete(h1); 
        else
            pp1 = h1;
        end
        pp2 = h2.Position;
        delete(h2);
        xs = [pp1(1,1), pp2(1,1)];
        ys = [pp1(1,2), pp2(1,2)];
        h = handles.hplot;   
        
        pm_element1 = [1, pp1(1,1), pp1(1,2), pp2(1,1),pp2(1,2), 0, 0, 0];
        pms_temp = pm_element1;
        bool = checkCollisionAddNewMP(hObject, handles);
        h = handles.hplot;  
        if bool == 1
            xs1 = [0, 0];
            ys1 = [0, 0];
            set(h,'XData',xs1,'YData',ys1);
        else
            set(h,'XData',xs,'YData',ys);
            set(h, 'LineStyle', '-');
            set(h,'Color',[0.5, 0.5, 0.5]);
            pm_element = [1, curve_type, pp1(1,1), pp1(1,2), pp2(1,1),pp2(1,2)];
            pm = [pm; pm_element];                  
            pms = [pms; pm_element1];
            set(handles.delete_MP,'Enable','on');
            set(handles.find_sol_button, 'Enable', 'on');
        end 
    elseif curve_type == 2
        if isempty(pm)
            pp1 = h1.Position;
            delete(h1); 
        else
            pp1 = h1;
        end
        pp2 = h2.Position;
        delete(h2);
        center = (pp1 + pp2)/2;
        radius = norm(pp1-pp2)/2;
        th = 0:180/50:360;
        xs = radius* cosd(th) + center(1,1);
        ys = radius* sind(th) + center(1,2);
        h = handles.hplot;  
        
        pm_element1 = [0, center(1,1), center(1,2), radius,  pp1(1,1), pp1(1,2), 0, 0];
        pms_temp = pm_element1;
        bool = checkCollisionAddNewMP(hObject, handles);
        h = handles.hplot;  
        if bool == 1
            xs1 = [0, 0];
            ys1 = [0, 0];
            set(h,'XData',xs1,'YData',ys1);
        else
            set(h,'XData',xs,'YData',ys);
            set(h, 'LineStyle', '-');
            set(h,'Color',[0.5, 0.5, 0.5]);
            pm_element = [1, curve_type, pp1(1,1), pp1(1,2), pp1(1,1),pp1(1,2)];
            pm = [pm; pm_element];                  
            pms = [pms; pm_element1];
            set(handles.delete_MP,'Enable','on');
            set(handles.find_sol_button, 'Enable', 'on');
        end 
    elseif curve_type == 3
        if isempty(pm)
            pp1 = h1.Position;
            delete(h1); 
        else
            pp1 = h1;
        end
        pp2 = h2.Position;
        delete(h2);
        delete(h3);
        xs = new_radius* cosd(new_th) + new_center(1, 1); 
        ys = new_radius* sind(new_th) + new_center(1, 2); 
        diff_ang = new_th(1, end) - new_th(1, 1);
        diff_ang = abs(diff_ang);
        diff_ang = deg2rad(diff_ang);
        if modified == 1
            pm_element1 = [2, new_center(1, 1), new_center(1, 2), pp1(1, 1), pp1(1,2), pp2(1,1),pp2(1,2), diff_ang];
        else
            pm_element1 = [-2, new_center(1, 1), new_center(1, 2), pp1(1, 1), pp1(1,2), pp2(1,1),pp2(1,2), diff_ang];
        end  
        pms_temp = pm_element1;
        bool = checkCollisionAddNewMP(hObject, handles);
        h = handles.hplot;  
        if bool == 1
            xs1 = [0, 0];
            ys1 = [0, 0];
            set(h,'XData',xs1,'YData',ys1);
        else
            set(h,'XData',xs,'YData',ys);
            set(h, 'LineStyle', '-');
            set(h,'Color',[0.5, 0.5, 0.5]);
            pm_element = [1, curve_type, pp1(1,1), pp1(1,2), pp2(1,1),pp2(1,2)];
            pm = [pm; pm_element];
                  
            pms = [pms; pm_element1];
            set(handles.delete_MP,'Enable','on');
            set(handles.find_sol_button, 'Enable', 'on');
        end 
    elseif curve_type == 4       
        pp1 = h5.Position;
        delete(h5)
        pp2 = h6.Position;
        delete(h6)
        center = (pp1 + pp2)/2;
        radius = norm(pp1-pp2)/2;
        th = 0:180/50:360;
        xs = radius* cosd(th) + center(1,1);
        ys = radius* sind(th) + center(1,2);
        obs_temp = [center(1,1), center(1,2), radius];
        bool = checkCollisionAddNewObs(hObject, handles);
        h = handles.hplot;  
        if bool == 1
            xs1 = [0, 0];
            ys1 = [0, 0];
            set(h,'XData',xs1,'YData',ys1);
        else
            set(h,'XData',xs,'YData',ys);
            set(h, 'LineStyle', '-');
            set(h,'Color',[0.6350, 0.0780, 0.1840]);
            obs_element = [center(1,1), center(1,2), radius];
            obs = [obs; obs_element];  
            set(handles.delete_Obs,'Enable','on');
        end  
    elseif curve_type == 5       
        pp1 = h5.Position;
        delete(h5)
        pp2 = h6.Position;
        delete(h6)
        min_x = min(pp1(1, 1), pp2(1, 1));
        min_y = min(pp1(1, 2), pp2(1, 2));
        max_x = max(pp1(1, 1), pp2(1, 1));
        max_y = max(pp1(1, 2), pp2(1, 2));        
        xs = [min_x, max_x, max_x, min_x, min_x];
        ys = [min_y, min_y, max_y, max_y, min_y];
        h = handles.hplot;  
        set(h,'XData',xs,'YData',ys);
        set(h,'Color','k');
        set(h, 'Linewidth', 3);
        set(h, 'LineStyle', '-');
        limitsO = [limitsO; min_x, max_x, min_y, max_y];
        set(handles.Delete_Rect_Push_Button,'Enable','on');
        set(handles.Rectangle_Push_Button, 'Enable', 'on')
%         limitsO_temp = [min_x, max_x, min_y, max_y];
%         bool = checkCollisionAddNewRect(hObject, handles);  
%         if bool == 1
%             xs1 = [0, 0];
%             ys1 = [0, 0];
%             set(h,'XData',xs1,'YData',ys1);
%         else
%             set(h,'XData',xs,'YData',ys);
%             set(h,'Color','k');
%             set(h, 'Linewidth', 3);
%             set(h, 'LineStyle', '-');
%             limitsO = [limitsO; min_x, max_x, min_y, max_y];
%             set(handles.Delete_Rect_Push_Button,'Enable','on');
%             set(handles.Rectangle_Push_Button, 'Enable', 'on');
%         end         
    end
    drawnow         
    set(handles.Line_Push_Button,'Enable','on');
    set(handles.Circle_Push_Button,'Enable','on');
    set(handles.Arc_Push_Button,'Enable','on');
    set(handles.Obstacle_Push_Button,'Enable','on');
    set(handles.Rectangle_Push_Button, 'Enable', 'on');
    set(handles.Fix_Push_Button,'Enable','off');
    guidata(hObject, handles);
    set(handles.text_display, 'String', ['Instructions', newline, 'Choose a curve or rectangle or press find solution.', newline, ...
        'Feel free to modify the settings too.']);
    curve_type = 0;
    

function maxlength_Callback(hObject, eventdata, handles)
global max_length;
max_length = get(handles.maxlength,'String');
set(handles.maxlength, 'String', max_length);
set(handles.maxlength, 'Value', str2double(max_length));

% --- Executes during object creation, after setting all properties.
function maxlength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_max_length_push_button.
function save_max_length_push_button_Callback(hObject, eventdata, handles)
global max_length_value;
val = get(handles.maxlength, 'Value');
if val > 0 && ~isnan(val)
    dlmwrite('maxlength.txt', val);
    max_length_value = val;
else
    dlmwrite('maxlength.txt', 0.5);
    max_length_value = 0.5;
end

% --- Executes on button press in update_axes_push_button.
function update_axes_push_button_Callback(hObject, eventdata, handles)
axes(handles.workspace);
axis_val = get(handles.axis_txt, 'Value');
axis([-axis_val, axis_val, -axis_val, axis_val]);

function axis_txt_Callback(hObject, eventdata, handles)
global axis_lim_update;
axis_lim = get(handles.axis_txt,'String');
set(handles.axis_txt, 'String', axis_lim);
set(handles.axis_txt, 'Value', str2double(axis_lim));
axis_lim_update = str2double(axis_lim);

% --- Executes during object creation, after setting all properties.
function axis_txt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function num_iter_Callback(hObject, eventdata, handles)
global nitermax;
nitermax_str = get(handles.num_iter,'String');
set(handles.num_iter, 'String', nitermax_str);
set(handles.num_iter, 'Value', str2double(nitermax_str));
nitermax = nitermax_str;

% --- Executes during object creation, after setting all properties.
function num_iter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in save_iter_push_button.
function save_iter_push_button_Callback(hObject, eventdata, handles)
global nitermax; 
val = get(handles.num_iter, 'Value');
if val > 0 && ~isnan(val)
    dlmwrite('nitermax.txt', val);
    nitermax = val;
else
    dlmwrite('nitermax.txt', 100);
    nitermax = 100;
end

% --- Executes on button press in find_sol_button.
function find_sol_button_Callback(hObject, eventdata, handles)     
    set(handles.warning_txt_collision, 'String', ['Info', newline, newline, 'Finding Solution...'],...
         'ForegroundColor', [0, 0.4470, 0.7410]);
      set(handles.animate_button,'Enable','off');
    global pms;
    global obs;
    global max_length_value;
    global limitsO;
    global nitermax;    
    
    global bool_result;
    global nL;
    global o;
    global r0;
    global rm;
    global r1;
    global r2;
    global theta;
    
    
    
    dlmwrite('MP.txt',pms);
    dlmwrite('MPs1.txt',pms);
    dlmwrite('MPs2.txt',[])
    dlmwrite('Obs.txt',obs);
    
    if isempty(obs)
        num_obs = 0;
    else
        [num_obs, ~] = size(obs);
    end
    dlmwrite('nobs.txt',num_obs);
    dlmwrite('nObs.txt',num_obs); 
    dlmwrite('limitsO.txt',limitsO);
%     nitermax = 100;
    val = get(handles.maxlength, 'Value');
    if val > 0 && ~isnan(val)
        dlmwrite('maxlength.txt', val);
        max_length_value = val;
    else
        dlmwrite('maxlength.txt', 0.5);
        max_length_value = 0.5;
    end
    [bool_result, nL, o, r0, rm, r1, r2, theta] = CalculateDesign(nitermax, pms, obs, limitsO, max_length_value);
    
    pause(0.5);
    if bool_result == 1
        set(handles.warning_txt_collision, 'String', ['Info', newline, newline, 'Click Animation Button Now'],...
             'ForegroundColor', [0, 0.4470, 0.7410]);
        set(handles.animate_button,'Enable','on');
    
    else
        set(handles.warning_txt_collision, 'String', ['Output Info', newline, newline, 'No solution obtained with 2 or 3 DOF! =('], ...
            'ForegroundColor', [0, 0.4470, 0.7410]);
        set(handles.animate_button,'Enable','off');
    end
      

% --- Executes on button press in animate_button.
function animate_button_Callback(hObject, eventdata, handles)
    global bool_result;
    global nL;
    global r0;
    global rm;
    global r1;
    global r2;
    global o;
    global obs;
    Obs1 = obs;
    a = o;
    if isempty(obs)
        nobs = 0;
    else
        [nobs, ~] = size(obs);
    end
    global axis_lim_update;
    cla(handles.workspace); 
    if bool_result == 1
        if nL == 2       
            
            if nobs > 0  
                xmin = min(Obs1(:,3).*cosd(180) + Obs1(:,1));
                ymin = min(Obs1(:,3).*sind(270) + Obs1(:,2));
                xmax = max(Obs1(:,3).*cosd(0) + Obs1(:,1));
                ymax = max(Obs1(:,3).*sind(90) + Obs1(:,2));
                xy_max = max([abs(xmin), abs(ymin), abs(xmax), abs(ymax)]);
                axis_lim = max([abs(-(r1+r2)+a(1, 1)), abs(r1+r2+a(1, 1)), abs(-(r1+r2)+a(1, 2)), abs(r1+r2+a(1, 2))]);
                axis_lim_fin = max([xy_max, axis_lim]);
                axis([-axis_lim_fin, axis_lim_fin, -axis_lim_fin, axis_lim_fin]);
            else                                                                      
                axis_lim = max([abs(-(r1+r2)+a(1, 1)), abs(r1+r2+a(1, 1)), abs(-(r1+r2)+a(1, 2)), abs(r1+r2+a(1, 2))]);
                axis([-axis_lim, axis_lim, -axis_lim, axis_lim]);                                                           
            end  
            
            set(handles.warning_txt_collision, 'String', ['Output Info', newline, newline, 'Solution obtained with 2 DOF!', newline, newline, ...
            'Link Lengths:', newline, 'r1: ',num2str(r1),', r2: ', num2str(r2), newline,newline,...
            'Origin of manipulator: (', num2str(a), ')'], 'ForegroundColor', [0, 0.4470, 0.7410]);
       
            animationMPs2DOF_func(hObject, handles);
        elseif nL == 3
            if nobs > 0  
                xmin = min(Obs1(:,3).*cosd(180) + Obs1(:,1));
                ymin = min(Obs1(:,3).*sind(270) + Obs1(:,2));
                xmax = max(Obs1(:,3).*cosd(0) + Obs1(:,1));
                ymax = max(Obs1(:,3).*sind(90) + Obs1(:,2));
                xy_max = max([abs(xmin), abs(ymin), abs(xmax), abs(ymax)]);
                axis_lim = max([abs(-(r1+r2+r0)+a(1, 1)), abs(r1+r2+r0+a(1, 1)), abs(-(r1+r2+r0)+a(1, 2)), abs(r1+r2+r0+a(1, 2))]);
                axis_lim_fin = max([xy_max, axis_lim]);
                axis([-axis_lim_fin, axis_lim_fin, -axis_lim_fin, axis_lim_fin]);
            else                                                                      
                axis_lim = max([abs(-(r1+r2+r0)+a(1, 1)), abs(r1+r2+r0+a(1, 1)), abs(-(r1+r2+r0)+a(1, 2)), abs(r1+r2+r0+a(1, 2))]);
                axis([-axis_lim, axis_lim, -axis_lim, axis_lim]);                                                           
            end  
            set(handles.warning_txt_collision, 'String', ['Output Info', newline, newline, 'Solution obtained with 3 DOF!', newline, newline, ...
            'Link Lengths:', newline, 'r1: ',num2str(r0),', r2: ',num2str(r1),', r3: ', num2str(r2), newline,newline,...
            'Origin of manipulator: (', num2str(o), ')'], 'ForegroundColor', [0, 0.4470, 0.7410]);
        
            animationMPs3DOF_func(hObject, handles);
            
        else
            if nobs > 0  
                xmin = min(Obs1(:,3).*cosd(180) + Obs1(:,1));
                ymin = min(Obs1(:,3).*sind(270) + Obs1(:,2));
                xmax = max(Obs1(:,3).*cosd(0) + Obs1(:,1));
                ymax = max(Obs1(:,3).*sind(90) + Obs1(:,2));
                xy_max = max([abs(xmin), abs(ymin), abs(xmax), abs(ymax)]);
                axis_lim = max([abs(-(r1+r2+r0+rm)+a(1, 1)), abs(r1+r2+r0+a(1, 1)+rm), abs(-(r1+r2+r0+rm)+a(1, 2)), abs(r1+r2+r0+a(1, 2)+rm)]);
                axis_lim_fin = max([xy_max, axis_lim]);
                axis([-axis_lim_fin, axis_lim_fin, -axis_lim_fin, axis_lim_fin]);
            else                                                                      
                axis_lim = max([abs(-(r1+r2+r0+rm)+a(1, 1)), abs(r1+r2+r0+a(1, 1)+rm), abs(-(r1+r2+r0+rm)+a(1, 2)), abs(r1+r2+r0+a(1, 2)+rm)]);
                axis([-axis_lim, axis_lim, -axis_lim, axis_lim]);                                                           
            end  
            set(handles.warning_txt_collision, 'String', ['Output Info', newline, newline, 'Solution obtained with 4 DOF!', newline, newline, ...
            'Link Lengths:', newline, 'r1: ',num2str(r0),', r2: ',num2str(rm),', r3: ', num2str(r1),', r4: ', num2str(r2), newline,newline,...
            'Origin of manipulator: (', num2str(o), ')'], 'ForegroundColor', [0, 0.4470, 0.7410]);
        
            animationMPs4DOF_func(hObject, handles);
        end
    end
    axis([-axis_lim_update, axis_lim_update, -axis_lim_update, axis_lim_update]);
    cla(handles.workspace); 
    plot_all(hObject, handles); 
    
function [] = animationMPs2DOF_func(hObject, handles)
    global o;
    global r1;
    global r2;
    global theta;
    global pms;
    global obs;
    axes(handles.workspace);
    plot_all(hObject, handles);
    config = [r1 r2];
    t = theta;
    dlmwrite('theta.txt',theta);
    MPs = pms;
    Obs = obs;
    origin = o;
    a = [0 0];
    r = config(1,:);
    [n, ~] = size(t);
    [nMPs, ~] = size(MPs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     config = [0.2539    0.1891];
%     r1 = config(1);
%     r2 = config(2);
%     r=[r1,r2];
%     origin = [-0.0783   -0.3136];
%     a = [0 0];
%     t = dlmread('~/ShapePrimitives/examples/rose/2DOFcorrected/theta.txt');
%     Obs = dlmread('~/ShapePrimitives/examples/rose/Obs.txt');
%     MPs = dlmread('~/ShapePrimitives/examples/rose/MP.txt');
%     [n, ~] = size(t);
%     [nMPs, ~] = size(MPs);
%     
%     for i = 1:nMPs
%         if MPs(i,1)==0
%             ci = MPs(i,2:3);
%             r = MPs(i,4);
%             p = MPs(i,5:6);
%             cangp = (p(1) - ci(1))/r;
%             sangp = (p(2) - ci(2))/r;
%             angp = wrapTo2Pi(atan2(sangp, cangp));
%             ang = linspace(angp, angp + 2*pi, n);
%             p_x = ci(1) + r*cos(ang);
%             p_y = ci(2) + r*sin(ang);
%             
%             
%         elseif MPs(i,1)==2 || MPs(i,1)==-2
%             direction = MPs(i,1);
%             ca = MPs(i,2:3);
%             p1 = MPs(i,4:5);
%             p2 = MPs(i,6:7);
%             ra = sqrt((p1(1) - ca(1))^2 + (p1(2) - ca(2))^2);
%             angp1p2 = MPs(i,8);
%             nt = abs(round(2*pi*n/angp1p2));
%             cangp1 = (p1(1) - ca(1))/ra;
%             sangp1 = (p1(2) - ca(2))/ra;
%             angp1 = wrapTo2Pi(atan2(sangp1, cangp1));
%             ang = linspace(angp1, angp1 + 2*pi, nt);
%             p_x_aux = ca(1) + ra*cos(ang');
%             p_y_aux = ca(2) + ra*sin(ang');
%             v1 = [p1(1) - ca(1), p1(2) - ca(2)];
%             v2 = [p_x_aux(2) - ca(1), p_y_aux(2) - ca(2)];
%             v1xv2 = v1(1)*v2(2) - v1(2)*v2(1);
%             if direction*v1xv2 > 0
%                 dists = sum(([p_x_aux,p_y_aux] - p2).^2,2);
%                 [~,indx] = min(dists);
%                 p_x = [p_x_aux(1:indx(1));p2(1)];
%                 p_y = [p_y_aux(1:indx(1));p2(2)];
%             else
%                 p_x_aux = [p1(1); flipud(p_x_aux(2:end))];
%                 p_y_aux = [p1(2); flipud(p_y_aux(2:end))];
%                 dists = sum(([p_x_aux,p_y_aux] - p2).^2,2);
%                 [~,indx] = min(dists);
%                 p_x = [p_x_aux(1:indx(1));p2(1)];
%                 p_y = [p_y_aux(1:indx(1));p2(2)];
%             end
%             
%         end
%         axes(handles.workspace);
%         plot(p_x, p_y,'Color', [0.5, 0.5, 0.5], 'Linewidth', 3);
%         hold on;
%     end
    
    if ~isempty(Obs)
        axes(handles.workspace);
        viscircles(Obs(:,1:2), Obs(:,3), 'Color', [0.6350, 0.0780, 0.1840], 'Linewidth', 3);
        hold on;
    end
    for i = 1:nMPs    
        if MPs(i,1) == 1
            axes(handles.workspace);
            plot([MPs(i,2) MPs(i,4)], [MPs(i,3) MPs(i,5)],'Color', [0.5, 0.5, 0.5], 'Linewidth', 3);
            hold on;
        else
            axes(handles.workspace);
            plot(MPs(i,2), MPs(i,3), 'o', 'MarkerSize',5,...
                'MarkerEdgeColor',[0.5, 0.5, 0.5],...
                'MarkerFaceColor',[0.5, 0.5, 0.5]);
            hold on;
        end    
    end
%     config = [0.2539    0.1891];
%     r1 = config(1);
%     r2 = config(2);
%     r=[r1,r2];
%     origin = [-0.0783   -0.3136];
    grid on;
    hold on;   
    P0 = origin;
    P1 = [P0(1) + r(1)*cos(t(1,1)), P0(2) + r(1)*sin(t(1,1))];
    P2 = [P0(1) + r(1)*cos(t(1,1)) + r(2)*cos(t(1,1))*cos(t(1,2)) - r(2)*cos(a(1))*sin(t(1,1))*sin(t(1,2)),...
        P0(2) + r(1)*sin(t(1,1)) + r(2)*cos(t(1,2))*sin(t(1,1)) + r(2)*cos(a(1))*cos(t(1,1))*sin(t(1,2))];
    EF = zeros(n,2);
    for j = 1:n
        P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        EF(j,1) = P2(1);
        EF(j,2) = P2(2);
    end
    axes(handles.workspace);
    h1 = plot([P0(1) P1(1)], [P0(2), P1(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h2 = plot([P1(1) P2(1)], [P1(2), P2(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h5 = plot([P0(1) P1(1)], [P0(2) P1(2)], 'o','MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'MarkerSize',4);
    hold on;
    grid on;
    j = 2;
    while j <= n
        P0 = origin;
        P1 = [P0(1) + r(1)*cos(t(j,1)), P0(2) + r(1)*sin(t(j,1))];
        P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
            P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        axes(handles.workspace);   
        h1.XData = [P0(1), P1(1)];
        axes(handles.workspace);
        h1.YData = [P0(2), P1(2)];
        axes(handles.workspace);
        h2.XData = [P1(1), P2(1)];
        axes(handles.workspace);
        h2.YData = [P1(2), P2(2)];
        axes(handles.workspace);
        h5.XData = [P0(1), P1(1)];
        axes(handles.workspace);
        h5.YData = [P0(2), P1(2)];    
        axes(handles.workspace);
        plot(EF(1:j,1), EF(1:j,2), '-','Color',[0 0 0.7],'LineWidth', 1);
        hold on;
        grid on;
        drawnow;
        j=j+1;
    end
    
function [] = animationMPs3DOF_func(hObject, handles)
    global o;
    global r0;
    global r1;
    global r2;
    global theta;
    global pms;
    global obs;
    axes(handles.workspace);
    plot_all(hObject, handles);
    config = [r0 r1 r2];
    t = theta;
    dlmwrite('theta.txt',theta);
    t = t(2:end-1,:);
    MPs = pms;
    Obs = obs;
    origin = o;
    a = [0 0 0];
    r = config(1,:);
    [n, ~] = size(t);
    [nMPs, ~] = size(MPs);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     config = [0.10014,0.33642,0.14998];
%     r0 = config(1);
%     r1 = config(2);
%     r2=config(3);
%     r=[r0,r1,r2];
%     a = [0 0,0];
%     origin = [-0.12865,-0.25033];
%     t = dlmread('~/ShapePrimitives/examples/table/theta.txt');
%     Obs = dlmread('~/ShapePrimitives/examples/table/Obs.txt');
%     MPs = dlmread('~/ShapePrimitives/examples/table/MP.txt');
%     [n, ~] = size(t);
%     [nMPs, ~] = size(MPs);
    if ~isempty(Obs)
        axes(handles.workspace);
        viscircles(Obs(:,1:2), Obs(:,3), 'Color', [0.6350, 0.0780, 0.1840], 'Linewidth', 3);
        hold on;
    end
    for i = 1:nMPs    
        if MPs(i,1) == 1
            axes(handles.workspace);
            plot([MPs(i,2) MPs(i,4)], [MPs(i,3) MPs(i,5)],'Color', [0.5, 0.5, 0.5], 'Linewidth', 3);
            hold on;
        else
            axes(handles.workspace);
            plot(MPs(i,2), MPs(i,3), 'o', 'MarkerSize',5,...
                'MarkerEdgeColor',[0.5, 0.5, 0.5],...
                'MarkerFaceColor',[0.5, 0.5, 0.5]);
            hold on;
        end
    end
%     config = [0.10014,0.33642,0.14998];
%     r0 = config(1);
%     r1 = config(2);
%     r2=config(3);
%     r=[r0,r1,r2];
%     a = [0 0,0];
%     origin = [-0.12865,-0.25033];
    grid on;
    hold on;
    j=1;
    P0 = origin;
    P1 = [P0(1) + r(1)*cos(t(j,1)), P0(2) + r(1)*sin(t(j,1))];
    P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
    P3n = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
    
    EF = zeros(n,2);
    for j = 1:n
        P3 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        EF(j,1) = P3(1);
        EF(j,2) = P3(2);
    end
    axes(handles.workspace);
    h1 = plot([P0(1) P1(1)], [P0(2), P1(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h2 = plot([P1(1) P2(1)], [P1(2), P2(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h3 = plot([P2(1) P3n(1)], [P2(2), P3n(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h5 = plot([P0(1) P1(1) P2(1)], [P0(2) P1(2) P2(2)], 'o','MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'MarkerSize',4);
    hold on;
    grid on;
    j = 2;
    while j <= n   
        P0 = origin;
        P1 = [P0(1) + r(1)*cos(t(j,1)), P0(2) + r(1)*sin(t(j,1))];
        P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
            P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        P3 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
            P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        axes(handles.workspace);
        h1.XData = [P0(1), P1(1)];
        axes(handles.workspace);
        h1.YData = [P0(2), P1(2)];
        axes(handles.workspace);
        h2.XData = [P1(1), P2(1)];
        axes(handles.workspace);
        h2.YData = [P1(2), P2(2)];
        axes(handles.workspace);
        h3.XData = [P2(1), P3(1)];
        axes(handles.workspace);
        h3.YData = [P2(2), P3(2)];
        axes(handles.workspace);
        h5.XData = [P0(1), P1(1), P2(1)];
        axes(handles.workspace);
        h5.YData = [P0(2), P1(2), P2(2)];
        axes(handles.workspace);
        plot(EF(1:j,1), EF(1:j,2), '-','Color',[0 0 0.7],'LineWidth', 1);            
        hold on;
        grid on;
        drawnow;
        j=j+1;
    end
    
function [] = animationMPs4DOF_func(hObject, handles)
    global o;
    global r0;
    global rm;
    global r1;
    global r2;
    global theta;
    global pms;
    global obs;
    axes(handles.workspace);
    plot_all(hObject, handles);
    config = [r0 rm r1 r2];
    t = theta;
    dlmwrite('theta.txt',theta);
    MPs = pms;
    Obs = obs;
    origin = o;
    a = [0 0 0 0];
    r = config(1,:);

    [n, ~] = size(t);
    [nMPs, ~] = size(MPs);
    if ~isempty(Obs)
        axes(handles.workspace);
        viscircles(Obs(:,1:2), Obs(:,3), 'Color', [0.6350, 0.0780, 0.1840], 'Linewidth', 3);
        hold on;
    end
    for i = 1:nMPs    
        if MPs(i,1) == 1
            axes(handles.workspace);
            plot([MPs(i,2) MPs(i,4)], [MPs(i,3) MPs(i,5)],'Color', [0.5, 0.5, 0.5], 'Linewidth', 3);
            hold on;
        else
            axes(handles.workspace);
            plot(MPs(i,2), MPs(i,3), 'o', 'MarkerSize',5,...
                'MarkerEdgeColor',[0.5, 0.5, 0.5],...
                'MarkerFaceColor',[0.5, 0.5, 0.5]);
            hold on;
        end
    end
    grid on;
    hold on;
    j = 1;
    P0 = origin;
    P1 = [P0(1) + r(1)*cos(t(j,1)), P0(2) + r(1)*sin(t(j,1))];
    P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
    P3 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
    P4 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) - r(4)*sin(t(j,4))*(cos(a(3))*sin(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + cos(a(3))*cos(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1)))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(4)*cos(t(j,4))*(sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2)))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
    P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(4)*sin(t(j,4))*(cos(a(3))*sin(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) + cos(a(3))*cos(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2)))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) - r(4)*cos(t(j,4))*(sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) - cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2)))) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];

    EF = zeros(n,2);
    EF(1,1) = P4(1);
    EF(1,2) = P4(2);
    for j = 2:n
        P4 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) - r(4)*sin(t(j,4))*(cos(a(3))*sin(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + cos(a(3))*cos(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1)))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(4)*cos(t(j,4))*(sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2)))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
            P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(4)*sin(t(j,4))*(cos(a(3))*sin(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) + cos(a(3))*cos(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2)))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) - r(4)*cos(t(j,4))*(sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) - cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2)))) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];

        EF(j,1) = P4(1);
        EF(j,2) = P4(2);
    end
    
    axes(handles.workspace);
    h1 = plot([P0(1) P1(1)], [P0(2), P1(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h2 = plot([P1(1) P2(1)], [P1(2), P2(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h3 = plot([P2(1) P3(1)], [P2(2), P3(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h4 = plot([P3(1) P4(1)], [P3(2), P4(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
    hold on;
    axes(handles.workspace);
    h5 = plot([P0(1) P1(1) P2(1) P3(1)], [P0(2) P1(2) P2(2) P3(2)], 'o','MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'MarkerSize',4);
    hold on;
    grid on;
    j = 2;
    while j <= n   
        P0 = origin;
        P1 = [P0(1) + r(1)*cos(t(j,1)), P0(2) + r(1)*sin(t(j,1))];
        P2 = [P0(1) + r(1)*cos(t(j,1)) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
            P0(2) + r(1)*sin(t(j,1)) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        P3 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
            P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        P4 = [P0(1) + r(1)*cos(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) - r(4)*sin(t(j,4))*(cos(a(3))*sin(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2))) + cos(a(3))*cos(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1)))) + r(2)*cos(t(j,1))*cos(t(j,2)) - r(3)*sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - r(4)*cos(t(j,4))*(sin(t(j,3))*(cos(a(2))*cos(t(j,1))*sin(t(j,2)) + cos(a(1))*cos(a(2))*cos(t(j,2))*sin(t(j,1))) - cos(t(j,3))*(cos(t(j,1))*cos(t(j,2)) - cos(a(1))*sin(t(j,1))*sin(t(j,2)))) - r(2)*cos(a(1))*sin(t(j,1))*sin(t(j,2)),...
        P0(2) + r(1)*sin(t(j,1)) + r(3)*cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) - r(4)*sin(t(j,4))*(cos(a(3))*sin(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2))) + cos(a(3))*cos(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2)))) - r(3)*sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) + r(2)*cos(t(j,2))*sin(t(j,1)) - r(4)*cos(t(j,4))*(sin(t(j,3))*(cos(a(2))*sin(t(j,1))*sin(t(j,2)) - cos(a(1))*cos(a(2))*cos(t(j,1))*cos(t(j,2))) - cos(t(j,3))*(cos(t(j,2))*sin(t(j,1)) + cos(a(1))*cos(t(j,1))*sin(t(j,2)))) + r(2)*cos(a(1))*cos(t(j,1))*sin(t(j,2))];
        
        axes(handles.workspace);
        h1.XData = [P0(1), P1(1)];
        axes(handles.workspace);
        h1.YData = [P0(2), P1(2)];
        axes(handles.workspace);
        h2.XData = [P1(1), P2(1)];
        axes(handles.workspace);
        h2.YData = [P1(2), P2(2)];
        axes(handles.workspace);
        h3.XData = [P2(1), P3(1)];
        axes(handles.workspace);
        h3.YData = [P2(2), P3(2)];
        axes(handles.workspace);
        h4.XData = [P3(1), P4(1)];
        axes(handles.workspace);
        h4.YData = [P3(2), P4(2)];
        axes(handles.workspace);
        h5.XData = [P0(1), P1(1), P2(1), P3(1)];
        axes(handles.workspace);
        h5.YData = [P0(2), P1(2), P2(2), P3(2)];
        axes(handles.workspace);
        plot(EF(1:j,1), EF(1:j,2), '-','Color',[0 0 0.7],'LineWidth', 1);            
        hold on;
        grid on;
        drawnow;
        j=j+1;

    end
    
% function [] = animationMPs2DOF_2designs_func(hObject, handles)
%     global configA;
%     global thetaA;
%     global MPsA;
%     global aA;
%     global configB;
%     global thetaB;
%     global MPsB;
%     global aB;
%     global Obs1;
% 
%     Obs = Obs1;
%     tA = thetaA;
%     tB = thetaB;
%     originA = aA;
%     originB = aB;
%     a = configA(1,:);
%     rA = configA(2,:);
%     rB = configB(2,:);
%     [nA, ~] = size(tA);
%     [nMPsA, ~] = size(MPsA);
%     [nB, ~] = size(tB);
%     [nMPsB, ~] = size(MPsB);
%     if ~isempty(Obs)
%         axes(handles.workspace);
%         viscircles(Obs(:,1:2), Obs(:,3), 'Color', [0.6350, 0.0780, 0.1840]);
%         hold on;
%     end
%     for i = 1:nMPsA
%         if MPsA(i,1) == 1
%             axes(handles.workspace);
%             plot([MPsA(i,2) MPsA(i,4)], [MPsA(i,3) MPsA(i,5)],'Color', [0.5, 0.5, 0.5], 'Linewidth', 3);
%             hold on;      
%        elseif MPsA(i,1) == 0
%             th = 0:180/50:360;                    
%             radius = MPsA(i, 4);
%             center = MPsA(i, 2:3);
%             xs = radius*cosd(th) + center(1,1);
%             ys = radius*sind(th) + center(1,2); 
%             axes(handles.workspace);
%             plot(xs, ys, 'Color',[0.5, 0.5, 0.5], 'Linewidth', 3);
%             plot(MPsA(i,2), MPsA(i,3), 'o', 'MarkerSize',3,...
%                 'MarkerEdgeColor',[0.5, 0.5, 0.5],...
%                 'MarkerFaceColor',[0.5, 0.5, 0.5]);
%             hold on;
%         elseif MPsA(i,1) == -2 %modified == 0  
%             pp1 = MPsA(i, 4:5);
%             pp2 = MPsA(i, 6:7);
%             center = MPsA(i, 2:3);
%             vect2 = center-pp2;
%             vect1 = center-pp1;
%             ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
%             ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
%             ang1 = mod(ang1-ang2,360)+ang2;
%             th = linspace(ang2-180,ang1-180, 50); 
%             radius = norm(MPsA(i, 2:3)- MPsA(i, 4:5));                    
%             xs = radius*cosd(th) + center(1,1);
%             ys = radius*sind(th) + center(1,2);  
%             plot(xs, ys, 'Color',[0.5, 0.5, 0.5], 'Linewidth', 3);
%             plot(MPsA(i,2), MPsA(i,3), 'o', 'MarkerSize',3,...
%                 'MarkerEdgeColor',[0.5, 0.5, 0.5],...
%                 'MarkerFaceColor',[0.5, 0.5, 0.5]);
%             hold on;
%         elseif MPsA(i,1) == 2 %modified == 1
%             pp1 = MPsA(i, 4:5);
%             pp2 = MPsA(i, 6:7);
%             center = MPsA(i, 2:3);
%             vect2 = center-pp2;
%             vect1 = center-pp1;
%             ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
%             ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
%             ang2 = mod(ang2-ang1,360)+ang1;
%             th = linspace(ang2-180,ang1-180, 50); 
%             radius = norm(MPsA(i, 2:3)- MPsA(i, 4:5));                    
%             xs = radius*cosd(th) + center(1,1);
%             ys = radius*sind(th) + center(1,2);
%             plot(xs, ys, 'Color',[0.5, 0.5, 0.5], 'Linewidth', 3);
%             plot(MPsA(i,2), MPsA(i,3), 'o', 'MarkerSize',3,...
%                 'MarkerEdgeColor',[0.5, 0.5, 0.5],...
%                 'MarkerFaceColor',[0.5, 0.5, 0.5]);
%             hold on;
%         end
%     end
% 
%     for i = 1:nMPsB
%         if MPsB(i,1) == 1
%             axes(handles.workspace);
%             plot([MPsB(i,2) MPsB(i,4)], [MPsB(i,3) MPsB(i,5)],'Color', [0, 0.4470, 0.7410], 'Linewidth', 3);
%             hold on;
%  
%         elseif MPsB(i,1) == 0
%             th = 0:180/50:360;                    
%             radius = MPsB(i, 4);
%             center = MPsB(i, 2:3);
%             xs = radius*cosd(th) + center(1,1);
%             ys = radius*sind(th) + center(1,2); 
%             axes(handles.workspace);
%             plot(xs, ys, 'Color',[0, 0.4470, 0.7410], 'Linewidth', 3);
%             plot(MPsB(i,2), MPsB(i,3), 'o', 'MarkerSize',3,...
%                 'MarkerEdgeColor',[0, 0.4470, 0.7410],...
%                 'MarkerFaceColor',[0, 0.4470, 0.7410]);
%             hold on;
%         elseif MPsB(i,1) == -2 %modified == 0  
%             pp1 = MPsB(i, 4:5);
%             pp2 = MPsB(i, 6:7);
%             center = MPsB(i, 2:3);
%             vect2 = center-pp2;
%             vect1 = center-pp1;
%             ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
%             ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
%             ang1 = mod(ang1-ang2,360)+ang2;
%             th = linspace(ang2-180,ang1-180, 50); 
%             radius = norm(MPsB(i, 2:3)- MPsB(i, 4:5));                    
%             xs = radius*cosd(th) + center(1,1);
%             ys = radius*sind(th) + center(1,2);  
%             plot(xs, ys, 'Color',[0, 0.4470, 0.7410], 'Linewidth', 3);
%             plot(MPsB(i,2), MPsB(i,3), 'o', 'MarkerSize',3,...
%                 'MarkerEdgeColor',[0, 0.4470, 0.7410],...
%                 'MarkerFaceColor',[0, 0.4470, 0.7410]);
%             hold on;
%         elseif MPsB(i,1) == 2 %modified == 1
%             pp1 = MPsB(i, 4:5);
%             pp2 = MPsB(i, 6:7);
%             center = MPsB(i, 2:3);
%             vect2 = center-pp2;
%             vect1 = center-pp1;
%             ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
%             ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
%             ang2 = mod(ang2-ang1,360)+ang1;
%             th = linspace(ang2-180,ang1-180, 50); 
%             radius = norm(MPsB(i, 2:3)- MPsB(i, 4:5));                    
%             xs = radius*cosd(th) + center(1,1);
%             ys = radius*sind(th) + center(1,2);
%             plot(xs, ys, 'Color',[0, 0.4470, 0.7410], 'Linewidth', 3);
%             plot(MPsB(i,2), MPsB(i,3), 'o', 'MarkerSize',3,...
%                 'MarkerEdgeColor',[0, 0.4470, 0.7410],...
%                 'MarkerFaceColor',[0, 0.4470, 0.7410]);
%             hold on;
%         end
%     end
% 
%     grid on;
%     hold on;
% 
%     P0A = originA;
%     P1A = [P0A(1) + rA(1)*cos(tA(1,1)), P0A(2) + rA(1)*sin(tA(1,1))];
%     P2A = [P0A(1) + rA(1)*cos(tA(1,1)) + rA(2)*cos(tA(1,1))*cos(tA(1,2)) - rA(2)*cos(a(1))*sin(tA(1,1))*sin(tA(1,2)),...
%         P0A(2) + rA(1)*sin(tA(1,1)) + rA(2)*cos(tA(1,2))*sin(tA(1,1)) + rA(2)*cos(a(1))*cos(tA(1,1))*sin(tA(1,2))];
%     EFA = zeros(nA,2);
%     for j = 1:nA
%         P2A = [P0A(1) + rA(1)*cos(tA(j,1)) + rA(2)*cos(tA(j,1))*cos(tA(j,2)) - rA(2)*cos(a(1))*sin(tA(j,1))*sin(tA(j,2)),...
%         P0A(2) + rA(1)*sin(tA(j,1)) + rA(2)*cos(tA(j,2))*sin(tA(j,1)) + rA(2)*cos(a(1))*cos(tA(j,1))*sin(tA(j,2))];
% 
%         EFA(j,1) = P2A(1);
%         EFA(j,2) = P2A(2);
%     end
% 
%     axes(handles.workspace);
%     h1A = plot([P0A(1) P1A(1)], [P0A(2), P1A(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
%     hold on;
%     axes(handles.workspace);
%     h2A = plot([P1A(1) P2A(1)], [P1A(2), P2A(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
%     hold on;
%     axes(handles.workspace);
%     h5A = plot([P0A(1) P1A(1)], [P0A(2) P1A(2)], 'o','MarkerEdgeColor','r',...
%         'MarkerFaceColor','r',...
%         'MarkerSize',4);
%     hold on;
%     grid on;
% 
%     j = 2;
%     while j <= nA
% 
%         P0A = originA;
%         P1A = [P0A(1) + rA(1)*cos(tA(j,1)), P0A(2) + rA(1)*sin(tA(j,1))];
%         P2A = [P0A(1) + rA(1)*cos(tA(j,1)) + rA(2)*cos(tA(j,1))*cos(tA(j,2)) - rA(2)*cos(a(1))*sin(tA(j,1))*sin(tA(j,2)),...
%             P0A(2) + rA(1)*sin(tA(j,1)) + rA(2)*cos(tA(j,2))*sin(tA(j,1)) + rA(2)*cos(a(1))*cos(tA(j,1))*sin(tA(j,2))];
%         axes(handles.workspace);
%         h1A.XData = [P0A(1), P1A(1)];
%         axes(handles.workspace);
%         h1A.YData = [P0A(2), P1A(2)];
%         axes(handles.workspace);
%         h2A.XData = [P1A(1), P2A(1)];
%         axes(handles.workspace);
%         h2A.YData = [P1A(2), P2A(2)];
%         axes(handles.workspace);
%         h5A.XData = [P0A(1), P1A(1)];
%         axes(handles.workspace);
%         h5A.YData = [P0A(2), P1A(2)];
%         axes(handles.workspace);
%         plot(EFA(1:j,1), EFA(1:j,2), '-','Color',[0 0 0.7],'LineWidth', 1);
%         hold on;
%         grid on;
%         drawnow;
%         j=j+1;
%         %pause(.001);
%     end
%     axes(handles.workspace);
%     h1A.XData = [100, 100];
%     axes(handles.workspace);
%     h1A.YData = [100, 100];
%     axes(handles.workspace);
%     h2A.XData = [100, 100];
%     axes(handles.workspace);
%     h2A.YData = [100, 100];
%     axes(handles.workspace);
%     h5A.XData = [100, 100];
%     axes(handles.workspace);
%     h5A.YData = [100, 100];
% %     pause(1);
%     P0B = originB;
%     P1B = [P0B(1) + rB(1)*cos(tB(1,1)), P0B(2) + rB(1)*sin(tB(1,1))];
%     P2B = [P0B(1) + rB(1)*cos(tB(1,1)) + rB(2)*cos(tB(1,1))*cos(tB(1,2)) - rB(2)*cos(a(1))*sin(tB(1,1))*sin(tB(1,2)),...
%         P0B(2) + rB(1)*sin(tB(1,1)) + rB(2)*cos(tB(1,2))*sin(tB(1,1)) + rB(2)*cos(a(1))*cos(tB(1,1))*sin(tB(1,2))];
%     EFB = zeros(nB,2);
%     for j = 1:nB
%         P2B = [P0B(1) + rB(1)*cos(tB(j,1)) + rB(2)*cos(tB(j,1))*cos(tB(j,2)) - rB(2)*cos(a(1))*sin(tB(j,1))*sin(tB(j,2)),...
%         P0B(2) + rB(1)*sin(tB(j,1)) + rB(2)*cos(tB(j,2))*sin(tB(j,1)) + rB(2)*cos(a(1))*cos(tB(j,1))*sin(tB(j,2))];
%         EFB(j,1) = P2B(1);
%         EFB(j,2) = P2B(2);
%     end
%     axes(handles.workspace);
%     h1B = plot([P0B(1) P1B(1)], [P0B(2), P1B(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
%     hold on;
%     axes(handles.workspace);
%     h2B = plot([P1B(1) P2B(1)], [P1B(2), P2B(2)], '-','Color',[0 0 0],'LineWidth', 4); % link
%     hold on;
%     axes(handles.workspace);
%     h5B = plot([P0B(1) P1B(1)], [P0B(2) P1B(2)], 'o','MarkerEdgeColor','r',...
%         'MarkerFaceColor','r',...
%         'MarkerSize',4);
%     hold on;
% 
%     j = 2;
%     while j <= nB
%         P0B = originB;
%         P1B = [P0B(1) + rB(1)*cos(tB(j,1)), P0B(2) + rB(1)*sin(tB(j,1))];
%         P2B = [P0B(1) + rB(1)*cos(tB(j,1)) + rB(2)*cos(tB(j,1))*cos(tB(j,2)) - rB(2)*cos(a(1))*sin(tB(j,1))*sin(tB(j,2)),...
%             P0B(2) + rB(1)*sin(tB(j,1)) + rB(2)*cos(tB(j,2))*sin(tB(j,1)) + rB(2)*cos(a(1))*cos(tB(j,1))*sin(tB(j,2))];
%         axes(handles.workspace);
%         h1B.XData = [P0B(1), P1B(1)];
%         axes(handles.workspace);
%         h1B.YData = [P0B(2), P1B(2)];
%         axes(handles.workspace);
%         h2B.XData = [P1B(1), P2B(1)];
%         axes(handles.workspace);
%         h2B.YData = [P1B(2), P2B(2)];
%         axes(handles.workspace);
%         h5B.XData = [P0B(1), P1B(1)];
%         axes(handles.workspace);
%         h5B.YData = [P0B(2), P1B(2)];
%         axes(handles.workspace);
%         plot(EFB(1:j,1), EFB(1:j,2), '-','Color',[0 0 0.7],'LineWidth', 1);
%         hold on;
%         grid on;
%         drawnow;
%         j=j+1;
%         %pause(.001);
%     end
    

% --- Executes on button press in delete_MP.
function delete_MP_Callback(hObject, eventdata, handles)
    global pm;
    global pms;
    if isempty(pm)
        set(handles.delete_MP,'Enable','off');
        set(handles.find_sol_button, 'Enable', 'off');
        set(handles.animate_button, 'Enable', 'off');
    else
        set(handles.delete_MP,'Enable','on');
        set(handles.find_sol_button, 'Enable', 'on');
        cla(handles.workspace); 
        [r, ~] = size(pm);
        if r == 1
            pm = [];
            pms = [];                       
            handles.hplot = plot([0, 0], [0, 0], 'linewidth', 3, 'color', [0.5, 0.5, 0.5]);    
            hold(handles.workspace,'on');   
            grid(handles.workspace, 'on')
            hold on;
            axis([-1,1,-1,1]);
            axes(handles.workspace);
            xlabel(handles.workspace,'x(m)');
            ylabel(handles.workspace,'y(m)');
            title(handles.workspace,'Workspace');
            drawnow;
            set(handles.delete_MP,'Enable','off');
            set(handles.find_sol_button, 'Enable', 'off');
            set(handles.animate_button, 'Enable', 'off');
            guidata(hObject, handles);
            plot_all(hObject, handles);
        else
            pm = pm(1:r-1, :);  
            pms = pms(1:r-1, :);            
            handles.hplot = [];   
            hold(handles.workspace,'on');   
            grid(handles.workspace, 'on')
            hold on;
            axis([-1,1,-1,1]);
            axes(handles.workspace);            
            xlabel(handles.workspace,'x(m)');
            ylabel(handles.workspace,'y(m)');
            title(handles.workspace,'Workspace');
            handles.hplot = plot([0, 0], [0, 0], 'linewidth', 3, 'color', [0.5, 0.5, 0.5]);  
            hold(handles.workspace,'on');
            hold on;            
            plot_all(hObject, handles);
        end
    end   
    guidata(hObject, handles);
    
% --- Executes on button press in delete_Obs.
function delete_Obs_Callback(hObject, eventdata, handles)
    global obs;
    if isempty(obs)
        set(handles.delete_Obs,'Enable','off');        
    else
        set(handles.delete_Obs,'Enable','on');    
        cla(handles.workspace); 
        [r, ~] = size(obs);
        if r == 1
            obs = [];                       
            handles.hplot = plot([0, 0], [0, 0], 'linewidth', 3, 'color', 'g');    
            hold(handles.workspace,'on');   
            grid(handles.workspace, 'on')
            hold on;
            axis([-1,1,-1,1]);
            axes(handles.workspace);
            xlabel(handles.workspace,'x(m)');
            ylabel(handles.workspace,'y(m)');
            title(handles.workspace,'Workspace');
            drawnow;
            set(handles.delete_Obs,'Enable','off');
            guidata(hObject, handles);    
            plot_all(hObject, handles);
        else  
            obs = obs(1:r-1, :);
            plot_all(hObject, handles);
        end                   
    end   
    guidata(hObject, handles);

% --- Executes on button press in Delete_Rect_Push_Button.
function Delete_Rect_Push_Button_Callback(hObject, eventdata, handles)
    global limitsO;
    if isempty(limitsO)
        set(handles.Delete_Rect_Push_Button,'Enable','off');        
    else
        set(handles.Delete_Rect_Push_Button,'Enable','on');    
        cla(handles.workspace); 
        [r, ~] = size(limitsO);
        if r == 1
            limitsO = [];                       
            handles.hplot = plot([0, 0], [0, 0], 'linewidth', 3, 'color', 'g');    
            hold(handles.workspace,'on');   
            grid(handles.workspace, 'on')
            hold on;
            axis([-1,1,-1,1]);
            axes(handles.workspace);
            xlabel(handles.workspace,'x(m)');
            ylabel(handles.workspace,'y(m)');
            title(handles.workspace,'Workspace');
            drawnow;
            set(handles.Delete_Rect_Push_Button,'Enable','off');
            guidata(hObject, handles);    
            plot_all(hObject, handles);
        else  
            limitsO = limitsO(1:r-1, :);
            plot_all(hObject, handles);
        end                   
    end   
    guidata(hObject, handles);


function [bool] = checkCollisionAddNewObs(hObject, handles)
    bool = 0;
    global obs_temp;
    global pms;
    global limitsO;
    xc = obs_temp(1);
    yc = obs_temp(2);
    rc = obs_temp(3);
    if ~isempty(pms) 
        [rp, ~] = size(pms);
        for i = 1:rp        
            mp = pms(i,:);
            if mp(1) == 1 %line
                x1 = mp(1,2);
                y1 = mp(1,3);
                x2 = mp(1,4);
                y2 = mp(1,5);
                t = ((x2 - x1)*(xc - x1) + (y2 - y1)*(yc - y1))/((x2 - x1)^2 + (y2 - y1)^2);
                if t >= 0 && t <= 1
                    xl = x1 + (x2 - x1)*t;
                    yl = y1 + (y2 - y1)*t;
                    dist = sqrt((xl - xc)^2 + (yl - yc)^2);
                else
                    xla = x1;
                    yla = y1;
                    dista = sqrt((xla - xc)^2 + (yla - yc)^2);
                    xlb = x2;
                    ylb = y2;
                    distb = sqrt((xlb - xc)^2 + (ylb - yc)^2);
                    if dista > distb
                        dist = distb;
                    else
                        dist = dista;
                    end
                end            
                if dist < rc
                    bool = 1;
                    return;
                end
            else
                if mp(1) == 0
                    xcirc = mp(1,2);
                    ycirc = mp(1,3);
                    rcirc = mp(1,4);
                else
                    x1 = mp(1,6);
                    y1 = mp(1,7);
                    xcirc = mp(1,2);
                    ycirc = mp(1,3);
                    rcirc = sqrt((x1 - xcirc)^2 + (y1 - ycirc)^2);         
                end
                dist = sqrt((xc - xcirc)^2 + (yc - ycirc)^2);  
                if dist < rcirc + rc
                    bool = 1;
                    return;
                end
            end
        end
    end
%     if ~isempty(limitsO)        
%         circ_x = obs_temp(1,1);
%         circ_y = obs_temp(1,2);
%         circ_r = obs_temp(1,3);
%         [rl, ~] = size(limitsO);
%         for i = 1:rl
%             rect_x = (limitsO(i, 1) + limitsO(i, 2))/2;
%             rect_y = (limitsO(i, 3) + limitsO(i, 4))/2;
%             circ_dist_x = abs(circ_x - rect_x);
%             circ_dist_y = abs(circ_y - rect_y);
%             rect_width = abs(limitsO(i, 2) - limitsO(i, 1));
%             rect_height = abs(limitsO(i, 4) - limitsO(i, 3));
%             corner_dist_sq = (circ_dist_x - (rect_width/2))^2 + (circ_dist_y - (rect_height/2))^2;
%             if (circ_dist_x > ((rect_width/2) + circ_r))
%                 bool = bool || 0;        
%             elseif (circ_dist_y > ((rect_height/2) + circ_r))
%                 bool = bool || 0;                
%             elseif (circ_dist_x <= (rect_width/2))
%                 bool = 1;
%                 return;
%             elseif (circ_dist_y <= (rect_height/2))
%                 bool = 1;                
%             elseif (corner_dist_sq <= circ_r^2)
%                 bool = 1;
%                 return;           
%             end
%         end
%     end

function [bool] = checkCollisionAddNewMP(hObject, handles)
    bool = 0;
    global obs;
    global pms_temp;
    global limitsO;
    global x1; global y1; global x2; global y2; global x3; global y3; global x4; global y4; 

    mp = pms_temp;
    if ~isempty(obs)
        [ro, ~] = size(obs);
        for i = 1:ro        
            xc = obs(i,1);
            yc = obs(i,2);
            rc = obs(i,3);        
            if mp(1) == 1 %line
                x1 = mp(1,2);
                y1 = mp(1,3);
                x2 = mp(1,4);
                y2 = mp(1,5);
                t = ((x2 - x1)*(xc - x1) + (y2 - y1)*(yc - y1))/((x2 - x1)^2 + (y2 - y1)^2);
                if t >= 0 && t <= 1
                    xl = x1 + (x2 - x1)*t;
                    yl = y1 + (y2 - y1)*t;
                    dist = sqrt((xl - xc)^2 + (yl - yc)^2);
                else
                    xla = x1;
                    yla = y1;
                    dista = sqrt((xla - xc)^2 + (yla - yc)^2);
                    xlb = x2;
                    ylb = y2;
                    distb = sqrt((xlb - xc)^2 + (ylb - yc)^2);
                    if dista > distb
                        dist = distb;
                    else
                        dist = dista;
                    end
                end            
                if dist < rc
                    bool = 1;
                    return;
                end
            else
                if mp(1) == 0
                    xcirc = mp(1,2);
                    ycirc = mp(1,3);
                    rcirc = mp(1,4);
                else
                    x1 = mp(1,4);
                    y1 = mp(1,5);
                    xcirc = mp(1,2);
                    ycirc = mp(1,3);
                    rcirc = sqrt((x1 - xcirc)^2 + (y1 - ycirc)^2);         
                end
                dist = sqrt((xc - xcirc)^2 + (yc - ycirc)^2);  
                if dist < rcirc + rc
                    bool = 1;
                    return;
                end
            end
        end
    end    
%     if ~isempty(limitsO) 
%         [rl, ~] = size(limitsO);
%         for i = 1:rl    
%             curvetype = mp(1,1);
%             if curvetype == 1
%                 x1 = mp(1, 2); y1 = mp(1, 3); x2 = mp(1, 4); y2 = mp(1, 5);
%                 isect = 0;
%                 xmin = limitsO(i,1);
%                 xmax = limitsO(i,2);
%                 ymin = limitsO(i,3);
%                 ymax = limitsO(i,4);
%                 x3 = xmin; y3 = ymin; x4 = xmax; y4 = ymin; 
%                 [isect1, ~, ~, ~]= intersectPoint(hObject, handles);
%                 x3 = xmax; y3 = ymin; x4 = xmax; y4 = ymax; 
%                 [isect2, ~, ~, ~]= intersectPoint(hObject, handles);
%                 x3 = xmax; y3 = ymax; x4 = xmin; y4 = ymax; 
%                 [isect3, ~, ~, ~]= intersectPoint(hObject, handles);
%                 x3 = xmin; y3 = ymax; x4 = xmin; y4 = ymin; 
%                 [isect4, ~, ~, ~]= intersectPoint(hObject, handles);
%                 xlin1 = x1; ylin1 = y1; xlin2 = x2; ylin2 = y2;
%                 if (xmin < xlin1 && xlin1 < xmax && ymin < ylin1 && ylin1 < ymax)
%                     isect5 = 1;
%                 else   
%                     isect5 = 0;
%                 end
%                 isect = isect1 || isect2 || isect3 || isect4 || isect5;
%                 if isect == 1
%                     bool = 1;
%                     return;
%                 else
%                     bool = bool || 0;
%                 end
%             elseif curvetype == 0
%                 radius = mp(1, 4);
%                 center = mp(1, 2:3);
%                 circ_x = center(1,1);
%                 circ_y = center(1,2);
%                 circ_r = radius;
%                 rect_x = (limitsO(1, 1) + limitsO(1, 2))/2;
%                 rect_y = (limitsO(1, 3) + limitsO(1, 4))/2;
%                 circ_dist_x = abs(circ_x - rect_x);
%                 circ_dist_y = abs(circ_y - rect_y);
%                 rect_width = abs(limitsO(1, 2) - limitsO(1, 1));
%                 rect_height = abs(limitsO(1, 4) - limitsO(1, 3));
%                 corner_dist_sq = (circ_dist_x - (rect_width/2))^2 + (circ_dist_y - (rect_height/2))^2;
%                 if (circ_dist_x > ((rect_width/2) + circ_r))
%                     bool = bool || 0;        
%                 elseif (circ_dist_y > ((rect_height/2) + circ_r))
%                     bool = bool || 0;                
%                 elseif (circ_dist_x <= (rect_width/2))
%                     bool = 1;
%                     return;
%                 elseif (circ_dist_y <= (rect_height/2))
%                     bool = 1;                
%                 elseif (corner_dist_sq <= circ_r^2)
%                     bool = 1;
%                     return;           
%                 end
%             elseif curvetype == -2 ||curvetype == 2 %arc
%                 center = mp(1, 2:3);                
%                 radius = norm(mp(1, 2:3)- mp(1, 4:5));                    
%                 circ_x = center(1,1);
%                 circ_y = center(1,2);
%                 circ_r = radius;
%                 rect_x = (limitsO(i, 1) + limitsO(i, 2))/2;
%                 rect_y = (limitsO(i, 3) + limitsO(i, 4))/2;
%                 circ_dist_x = abs(circ_x - rect_x);
%                 circ_dist_y = abs(circ_y - rect_y);
%                 rect_width = abs(limitsO(i, 2) - limitsO(i, 1));
%                 rect_height = abs(limitsO(i, 4) - limitsO(i, 3));
%                 corner_dist_sq = (circ_dist_x - (rect_width/2))^2 + (circ_dist_y - (rect_height/2))^2;
%                 if (circ_dist_x > ((rect_width/2) + circ_r))
%                     bool = bool || 0;                
%                 elseif (circ_dist_y > ((rect_height/2) + circ_r))
%                     bool = bool || 0;                
%                 elseif (circ_dist_x <= (rect_width/2))
%                     bool = 1;
%                     return;
%                 elseif (circ_dist_y <= (rect_height/2))
%                     bool = 1;                
%                 elseif (corner_dist_sq <= circ_r^2)
%                     bool = 1;
%                     return;           
%                 end
%             end
%         end
    

function [bool] = checkCollisionAddNewRect(hObject, handles)
    global limitsO_temp;
    global obs;
    global pm;
    global pms;
    global x1; global y1; global x2; global y2; global x3; global y3; global x4; global y4;
    bool = 0;
    % limitsO_temp with MPs
    if ~isempty(pm)
        [rp, ~] = size(pm);
        for i = 1:rp
            curvetype = pms(i, 1);
            if curvetype == 1
                x1 = pm(i, 3); y1 = pm(i, 4); x2 = pm(i, 5); y2 = pm(i, 6);
                isect = 0;
                xmin = limitsO_temp(1,1);
                xmax = limitsO_temp(1,2);
                ymin = limitsO_temp(1,3);
                ymax = limitsO_temp(1,4);
                x3 = xmin; y3 = ymin; x4 = xmax; y4 = ymin; 
                [isect1, ~, ~, ~]= intersectPoint(hObject, handles);
                x3 = xmax; y3 = ymin; x4 = xmax; y4 = ymax; 
                [isect2, ~, ~, ~]= intersectPoint(hObject, handles);
                x3 = xmax; y3 = ymax; x4 = xmin; y4 = ymax; 
                [isect3, ~, ~, ~]= intersectPoint(hObject, handles);
                x3 = xmin; y3 = ymax; x4 = xmin; y4 = ymin; 
                [isect4, ~, ~, ~]= intersectPoint(hObject, handles);
                xlin1 = x1; ylin1 = y1; xlin2 = x2; ylin2 = y2;
                if (xmin < xlin1 && xlin1 < xmax && ymin < ylin1 && ylin1 < ymax)
                    isect5 = 1;
                else   
                    isect5 = 0;
                end
                isect = isect1 || isect2 || isect3 || isect4 || isect5;
                if isect == 1
                    bool = 1;
                    return;
                else
                    bool = 0;
                end
            elseif curvetype == 0
                radius = pms(i, 4);
                center = pms(i, 2:3);
                circ_x = center(1,1);
                circ_y = center(1,2);
                circ_r = radius;
                rect_x = (limitsO_temp(1, 1) + limitsO_temp(1, 2))/2;
                rect_y = (limitsO_temp(1, 3) + limitsO_temp(1, 4))/2;
                circ_dist_x = abs(circ_x - rect_x);
                circ_dist_y = abs(circ_y - rect_y);
                rect_width = abs(limitsO_temp(1, 2) - limitsO_temp(1, 1));
                rect_height = abs(limitsO_temp(1, 4) - limitsO_temp(1, 3));
                corner_dist_sq = (circ_dist_x - (rect_width/2))^2 + (circ_dist_y - (rect_height/2))^2;
                if (circ_dist_x > ((rect_width/2) + circ_r))
                    bool = bool || 0;        
                elseif (circ_dist_y > ((rect_height/2) + circ_r))
                    bool = bool || 0;                
                elseif (circ_dist_x <= (rect_width/2))
                    bool = 1;
                    return;
                elseif (circ_dist_y <= (rect_height/2))
                    bool = 1;                
                elseif (corner_dist_sq <= circ_r^2)
                    bool = 1;
                    return;           
                end
            elseif curvetype == -2 ||curvetype == 2 %arc
                center = pms(i, 2:3);                
                radius = norm(pms(i, 2:3)- pms(i, 4:5));                    
                circ_x = center(1,1);
                circ_y = center(1,2);
                circ_r = radius;
                rect_x = (limitsO_temp(1, 1) + limitsO_temp(1, 2))/2;
                rect_y = (limitsO_temp(1, 3) + limitsO_temp(1, 4))/2;
                circ_dist_x = abs(circ_x - rect_x);
                circ_dist_y = abs(circ_y - rect_y);
                rect_width = abs(limitsO_temp(1, 2) - limitsO_temp(1, 1));
                rect_height = abs(limitsO_temp(1, 4) - limitsO_temp(1, 3));
                corner_dist_sq = (circ_dist_x - (rect_width/2))^2 + (circ_dist_y - (rect_height/2))^2;
                if (circ_dist_x > ((rect_width/2) + circ_r))
                    bool = bool || 0;                
                elseif (circ_dist_y > ((rect_height/2) + circ_r))
                    bool = bool || 0;                
                elseif (circ_dist_x <= (rect_width/2))
                    bool = 1;
                    return;
                elseif (circ_dist_y <= (rect_height/2))
                    bool = 1;                
                elseif (corner_dist_sq <= circ_r^2)
                    bool = 1;
                    return;           
                end
            end
        end
    end
    % limitsO_temp with Obs
    if ~isempty(obs)
        [ro, ~] = size(obs);
        for i = 1:ro
            circ_x = obs(i,1);
            circ_y = obs(i,2);
            circ_r = obs(i,3);
            rect_x = (limitsO_temp(1, 1) + limitsO_temp(1, 2))/2;
            rect_y = (limitsO_temp(1, 3) + limitsO_temp(1, 4))/2;
            circ_dist_x = abs(circ_x - rect_x);
            circ_dist_y = abs(circ_y - rect_y);
            rect_width = abs(limitsO_temp(1, 2) - limitsO_temp(1, 1));
            rect_height = abs(limitsO_temp(1, 4) - limitsO_temp(1, 3));
            corner_dist_sq = (circ_dist_x - (rect_width/2))^2 + (circ_dist_y - (rect_height/2))^2;

            if (circ_dist_x > ((rect_width/2) + circ_r))
                bool = bool || 0;                
            
            elseif (circ_dist_y > ((rect_height/2) + circ_r))
                bool = bool || 0;                
            
            elseif (circ_dist_x <= (rect_width/2))
                bool = 1;
                return;
            
            elseif (circ_dist_y <= (rect_height/2))
                bool = 1;                
            
            elseif (corner_dist_sq <= circ_r^2)
                bool = 1;
                return;            
                
            end
        end
    end

function [] = plot_all(hObject, handles)
    global pm;
    global pms;
    global obs;
    global limitsO;
    axes(handles.workspace);
    if isempty(pm)
        set(handles.delete_MP,'Enable','off');
        set(handles.find_sol_button, 'Enable', 'off');
        set(handles.animate_button, 'Enable', 'off');
    else
        set(handles.delete_MP,'Enable','on');
        set(handles.find_sol_button, 'Enable', 'on');
                                  
        [r, ~] = size(pms);
        for i = 1:r
            curvetype = pms(i, 1);
            if curvetype == 1
                xs = [ pm(i, 3), pm(i, 5)];            
                ys = [ pm(i, 4), pm(i, 6)];
                plot(xs, ys, 'Color',[0.5, 0.5, 0.5], 'Linewidth', 3);
            elseif curvetype == 0
                th = 0:180/50:360;                    
                radius = pms(i, 4);
                center = pms(i, 2:3);
                xs = radius*cosd(th) + center(1,1);
                ys = radius*sind(th) + center(1,2); 
                plot(xs, ys, 'Color',[0.5, 0.5, 0.5], 'Linewidth', 3);
            elseif curvetype == -2 %modified == 0  
                pp1 = pms(i, 4:5);
                pp2 = pms(i, 6:7);
                center = pms(i, 2:3);
                vect2 = center-pp2;
                vect1 = center-pp1;
                ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
                ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
                ang1 = mod(ang1-ang2,360)+ang2;
                th = linspace(ang2-180,ang1-180, 50); 
                radius = norm(pms(i, 2:3)- pms(i, 4:5));                    
                xs = radius*cosd(th) + center(1,1);
                ys = radius*sind(th) + center(1,2);  
                plot(xs, ys, 'Color',[0.5, 0.5, 0.5], 'Linewidth', 3);
            elseif curvetype == 2 %modified == 1
                pp1 = pms(i, 4:5);
                pp2 = pms(i, 6:7);
                center = pms(i, 2:3);
                vect2 = center-pp2;
                vect1 = center-pp1;
                ang1 = rad2deg(atan2(vect1(1,2), vect1(1,1)));
                ang2 = rad2deg(atan2(vect2(1,2), vect2(1,1)));
                ang2 = mod(ang2-ang1,360)+ang1;
                th = linspace(ang2-180,ang1-180, 50); 
                radius = norm(pms(i, 2:3)- pms(i, 4:5));                    
                xs = radius*cosd(th) + center(1,1);
                ys = radius*sind(th) + center(1,2);
                plot(xs, ys, 'Color',[0.5, 0.5, 0.5], 'Linewidth', 3);
            end
        end
    end    
    if ~isempty(obs)
        [ro, ~] = size(obs);
        for i = 1:ro
            th = 0:180/50:360;
            radius = obs(i, 3);
            center = obs(i, 1:2);
            xs = radius*cosd(th) + center(1,1);
            ys = radius*sind(th) + center(1,2); 
            plot(xs, ys, 'Color',[0.6350, 0.0780, 0.1840], 'Linewidth', 3);               
        end                   
        guidata(hObject, handles);
    end
    if ~isempty(limitsO)
        [rl, ~] = size(limitsO);
        for i = 1:rl  
            xmin = limitsO(i, 1);
            xmax = limitsO(i, 2);
            ymin = limitsO(i, 3);
            ymax = limitsO(i, 4);
            xs = [xmin, xmax, xmax, xmin, xmin];
            ys = [ymin, ymin, ymax, ymax, ymin]; 
            plot(xs, ys, 'Color', 'k', 'Linewidth', 3);               
        end                   
        guidata(hObject, handles);
    end
    guidata(hObject, handles);
    
function [isect,x,y,ua] = intersectPoint(hObject, handles)
    global x1; global y1; global x2; global y2; global x3; global y3; global x4; global y4;
    x = [];
    y = [];
    ua = [];
    denom = (y4-y3)*(x2-x1)-(x4-x3)*(y2-y1);
    if denom == 0
        isect = 0;
        return;
    else
        ua = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3))/denom;
        ub = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3))/denom;
        if ua >= 0 && ub >= 0 && ua <= 1 && ub <= 1
            isect = 1;
            x = x1 + ua*(x2-x1);
            y = y1 + ua*(y2-y1);
        else
            isect = 0;
            return;
        end
    end
