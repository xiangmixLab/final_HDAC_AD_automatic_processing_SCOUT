 function brushscatter(flag,labs)
%   BRUSHSCATTER    Scatterplot Brushing and Linking
%
%   BRUSHSCATTER(X,LABS)
%   X is an n x p matrix of data values. LABS is an optional input argument
%   containing the variable labels. This must be a p-dimensional cell array
%   of strings.

if nargin==2
    % First one contains data - initialize figure.
    X = flag;
    flag = 'init';
    [n,p] = size(X);
    if length(labs) ~= p
        error('Array of variable names is wrong dimensionality')
        return
    end
    if ~iscell(labs)
        error('Array of variable names must be a cell array of strings.')
        return
    end
elseif nargin==1 & isnumeric(flag)
    % Called only with the data. Initialize the figure and use generic
    % variable names.
    X = flag;
    flag = 'init';
    % Get some generic names.
    [n,p] = size(X);
    for i = 1:p
        labs{i} = ['Variable ' int2str(i)];
    end
end   

if strcmp(flag,'init')
    % Calling the function with the data.
    % then initialize figure
    H.data = X;
    H.labs = labs;
    % Set up figure that is maximized.
    H.fig = figure('units','normalized',...
        'position',  [0 0.0365 0.9678 0.8750],...
        'toolbar','none',...
        'menubar','none',...
        'numbertitle','off',...
        'Name','Scatterplot Brushing',...
        'RendererMode','manual',...
        'backingstore','off',...
        'renderer','painters',...
        'DoubleBuffer','on');
    % Set up handle for context menu associated with axes.
    H.cmenu = uicontextmenu;
    H.MenHigh = uimenu(H.cmenu,'Label','Highlight',...
        'checked','on',...
        'callback','brushscatter(''highlight'')');   % Default brushing mode.
    H.MenDel = uimenu(H.cmenu,'Label','Delete',...
        'checked','off',...
        'callback','');
%         'callback','brushscatter(''delete'')');
    H.operation = 'highlight';
    % Above are the operations. Below are the modes.
    % These callbacks should not activate anything. 
    % They should re-set a MODE FLAG and check/uncheck the item.
    % They MOVE BRUSH code will check to see what is
    % selected here. 
    H.MenTrans = uimenu(H.cmenu,'Label','Transient',...
        'separator','on',...
        'checked','on',...
        'callback','brushscatter(''transient'')');
    H.MenLast = uimenu(H.cmenu,'Label','Lasting',...
        'checked','off',...
        'callback','brushscatter(''lasting'')');
    H.MenUndo = uimenu(H.cmenu,'Label','Undo',...
        'checked','off',...
        'callback','brushscatter(''undo'')');
    H.mode = 'transient';
    H.MenBrushOff = uimenu(H.cmenu,'Label','Delete Brush',...
        'separator','on',...
        'callback','brushscatter(''delbrush'')');
    H.MenResetFig = uimenu(H.cmenu,'Label','Reset Figure',...
        'separator','on',...
        'callback','brushscatter(''resetfig'')');
    [n,p] = size(X);
    minx = min(X);
    maxx = max(X);
    rngx = range(X);
    % set up the axes
    H.IndX = zeros(p,p);    % X dim for data
    H.IndY = zeros(p,p);    % Y dim for data
    H.AxesLims = cell(p,p); % Axes limits.
    H.Haxes = zeros(p,p);   % Axes handles.
    H.HlineHigh = zeros(p,p);  % Line handles to highlighted data.
    H.HlineReg = zeros(p,p);    % Line handles to non-highlighted data.
    H.Inside = [];          % Indices to currently marked points. Need this for lasting mode.
    % Order of axes is left-right, top-bottom
    % Take up the entire figure area with axes.
    I = 0; J = 0;
    for j = (p-1):-1:0
        I = I + 1;
        for i = 0:(p-1)
            J = J + 1;
            pos = [i/p j/p 1/p 1/p];
            pos = floor(pos*100)/100;
            H.Haxes(I,J) = axes('pos',[i/p j/p 1/p 1/p]);
            box on
            if I~=J
                % The following is the column index (to data) for the X and Y
                % variables.
                H.IndX(I,J) = J;
                H.IndY(I,J) = I;
                set(gca,'yticklabel','','xticklabel','','ticklength',[0 0],...
                    'buttondown','brushscatter(''createbrush'')',...
                    'drawmode','fast')
                % Do the scatterplot.
                H.HlineReg(I,J) = line('xdata',X(:,J),'ydata',X(:,I),...
                    'markersize',3,'marker','o','linestyle','none');
                H.HlineHigh(I,J) = line('xdata',nan,'ydata',nan,...
                    'markersize',3,'marker','o','linestyle','none',...
                    'markerfacecolor','r');     % Placeholder for highlighted points.
                ax = axis;
                axis([ax(1)-rngx(J)*.05 ax(2)*1.05 ax(3)-rngx(I)*.05 ax(4)*1.05])
                H.AxesLims{I,J} = axis;
                axis manual
            else
                set(gca,'uicontextmenu',H.cmenu,...
                    'Yticklabel','','xticklabel','',...
                    'ticklength',[0 0])
                % This is a center axes - plot the variable name.
                text(0.35,0.45,labs{I})
                text(0.05,0.05,num2str(minx(I)))
                text(0.9,0.9,num2str(maxx(I)))
                axis([0 1 0 1])
                H.AxesLims{I,J} = [0 1 0 1];
            end  % if stmt
        end   % for j loop
        J = 0;
    end   % for i loop
    % Brush Information.
    H.Hbrush = [];
    H.BrushPrevX = [];
    H.BrushPrevY = [];
    
    H.CurrAxes = H.Haxes(1);
    
    set(gcf,'UserData',H)
    
elseif strcmp(flag,'createbrush')
    H = get(gcf,'userdata');
    CreateBrushButtDwn(H)
    
elseif strcmp(flag,'CreateBrushButtUp')
    H = get(gcf,'userdata');
    CreateBrushButtUp(H)
    
elseif strcmp(flag,'delbrush')
    H = get(gcf,'userdata');
    if ~isempty(H.Hbrush)
        % kill the brush.
        set(H.Hbrush,'visible','off')
    end
    
elseif strcmp(flag,'BrushButtDwn')
    H = get(gcf,'userdata');
    BrushButtDwn(H);
    
elseif strcmp(flag,'movebrush')
    % When brush moves - call update function.   
    H = get(gcf,'userdata');
    MoveBrush(H)
    
elseif strcmp(flag,'movebrushbuttup')
    % User finished moving the brush - let up on the button.
    H = get(gcf,'userdata');
    MoveBrushButtUp(H)
    
elseif strcmp(flag,'delete')
    % Operation is to delete points. Need to reset the menu items.
    % Also need to re-do the axes, after the point(s) is deleted.
    % this operation only makes sense with the 'lasting' mode.
    % Delete won't really take into account the mode. 
    H = get(gcbf,'userdata');
    H.operation = 'delete';
    set(H.MenDel,'checked','on')
    set(H.MenHigh,'checked','off')
    set(H.fig,'userdata',H)
    
elseif strcmp(flag,'highlight')
    % Operation is to highlight points. Change the marker to filled 
    % and another color - maybe red. Adjust menu items. This operation
    % can be any of the 3 modes. 
    H = get(gcbf,'userdata');
    H.operation = 'highlight';
    set(H.MenHigh,'checked','on')
    set(H.MenDel,'checked','off')
    set(H.fig,'userdata',H)

elseif strcmp(flag,'transient')
    % Set the flag to transient.
    % Set the check in menu to transient.
    % Set the others to uncheck.
    H = get(gcf,'userdata');
    set(H.MenTrans,'checked','on')
    H.mode = 'transient';
    set([H.MenLast,H.MenUndo],'checked','off')
    set(gcf,'userdata',H)
  
elseif strcmp(flag,'lasting')
    % SAB, except for lasting.
    H = get(gcf,'userdata');
    set(H.MenLast,'checked','on')
    H.mode = 'lasting';
    set([H.MenTrans,H.MenUndo],'checked','off')
    set(gcf,'userdata',H)
    
elseif strcmp(flag,'undo')
    % SAB, except for undo.
    H = get(gcf,'userdata');
    set(H.MenUndo,'checked','on')
    H.mode = 'undo';
    set([H.MenTrans,H.MenLast],'checked','off')
    set(gcf,'userdata',H)
    
elseif strcmp(flag,'resetfig')
    % Reset the figure to initial state.
    H = get(gcf,'userdata');
    ResetFig(H)
    
end
%%%%%%      END OF MAIN FUNCTION    %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%     BrushButtDwn        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function BrushButtDwn(H)
% User has clicked on the brush.

% Set the function for brush motion.
set(H.fig,'WindowButtonMotionFcn','brushscatter(''movebrush'')')
% Set the function for when the user clicks up on the brush.
set(H.fig,'WindowButtonUpFcn','brushscatter(''movebrushbuttup'')')
set(H.fig,'Pointer','fleur');

%%%%%       MoveBrushButtUp     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MoveBrushButtUp(H)
% Reset the windows functions.
set(H.fig,'WindowButtonMotionFcn','')
set(H.fig,'WindowButtonUpFcn','')
set(H.fig,'Pointer','arrow')

%%%%%%      MoveBrush           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MoveBrush(H)
% The brush is in motion. Update the location of the brush.
% Then call the UpdateFunction.
if ishandle(H.Hbrush)
    Hax = get(H.Hbrush,'parent');
    cp = get(Hax,'CurrentPoint');
    
    if isempty(H.BrushPrevX);
        H.BrushPrevX = cp(1,1);
        H.BrushPrevY = cp(1,2);
    else
        % Update brush position.
        delx = cp(1,1) - H.BrushPrevX;
        dely = cp(1,2) - H.BrushPrevY;
        H.BrushPrevX = cp(1,1);
        H.BrushPrevY = cp(1,2);
        x = get(H.Hbrush,'xdata');
        y = get(H.Hbrush,'ydata');
        newx = x + delx;
        newy = y + dely;
        set(H.Hbrush,'xdata',newx,'ydata',newy);
    end
    % Call the update function to highlight points in the brush.
    if strcmp(H.operation,'highlight')
        UpdateHighlight(H)
    else
        UpdateDelete(H)
    end
end

set(H.fig,'userdata',H)

% %%%%%%%%    CreateBrushButtUp    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function CreateBrushButtUp(H)
% % User has finished creating the brush.
% set(H.fig,'WindowButtonUpFcn','');
% H.BrushPrevX = [];
% H.BrushPrevY = [];
% % Call the update function to highlight points in the brush.
% if strcmp(H.operation,'highlight')
%     UpdateHighlight(H)
% else
%     UpdateDelete(H)
% end
% set(H.fig,'userdata',H)

%%%%%%%     CreateBrushButtDwn  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CreateBrushButtDwn(H)
% User clicked on an axis. Create a brush.
H.CurrAxes = gca;
if ~isempty(H.Hbrush)
    % Delete the current brush.
    delete(H.Hbrush)
end
H.Hbrush = line('xdata',nan,'ydata',nan,'parent',gca,'visible','off',...
    'erasemode','xor',...
    'color','r','linewidth',2,'buttondown','brushscatter(''BrushButtDwn'')');
% Somethig like the following.
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = min(point1,point2);             % calculate locations
offset = abs(point1-point2);         % and dimensions
xx = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
yy = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
set(H.Hbrush,'xdata',xx,'ydata',yy,'visible','on','parent',gca)
H.BrushPrevX = [];
H.BrushPrevY = [];
if strcmp(H.operation,'highlight')
    UpdateHighlight(H)
else
    UpdateDelete(H)
end
set(gcf,'userdata',H)

%%%%%%      UpdateHighlight   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UpdateHighlight(H)

% In this sub-function - highlight the points according to the mode that is
% specified: transient, lasting, undo.
% First find the current axes.
Hcax = H.CurrAxes;
% Get the vertices of the brush.
if ~isempty(H.Hbrush)
    xv = get(H.Hbrush,'xdata');
    yv = get(H.Hbrush,'ydata');
else
    return
end
% Find the two dimensions plotted there.
[I,J] = find(Hcax == H.Haxes);  % Gives the indices to the current axes
XX = H.data(:,H.IndX(I,J));     % Get the corresponding X and Y coordinates.
YY = H.data(:,H.IndY(I,J));
[n,p] = size(H.data);
% Find the points inside the rectangle.
insidebrush = find(inpolygon(XX,YY,xv,yv));
outsidebrush = setdiff(1:n,insidebrush);

switch H.mode
    case 'transient'
        % Find all of the points that are in the polygon given by the
        % brush. Should be able to do this for all axes handles with data.
        % Make those inside the brush red - those outside black.
        if ~isempty(insidebrush)
            for i = 1:p
                for j = (i+1):p
                    axes(H.Haxes(i,j))
                    % Plot the highlighted points.
                    set(H.HlineHigh(i,j),'xdata',H.data(insidebrush,H.IndX(i,j)),...
                        'ydata',H.data(insidebrush,H.IndY(i,j)));
                    % Now do the transpose axes.
                    axes(H.Haxes(j,i))
                    set(H.HlineHigh(j,i), 'xdata',H.data(insidebrush,H.IndX(j,i)),...
                        'ydata',H.data(insidebrush,H.IndY(j,i)));
                end
            end
        end % if isempty 
    case 'lasting'
        % Once points are brushed, they stay brushed. Just take the inside
        % points and make them red. Those outside stay the same.
        if ~isempty(insidebrush)
            % Add these to the currently marked points.
            for i = 1:p
                for j = (i+1):p
                    axes(H.Haxes(i,j))
                    % Plot the highlighted points.
                    % Get the currently highlighted points.
                    cmpX = get(H.HlineHigh(i,j),'xdata');
                    cmpY = get(H.HlineHigh(i,j),'ydata');
                    % Add these to the points in the brush.
                    nmpX = [H.data(insidebrush,H.IndX(i,j));cmpX(:)];
                    nmpY = [H.data(insidebrush,H.IndY(i,j));cmpY(:)];
                    set(H.HlineHigh(i,j),'xdata',nmpX,...
                        'ydata',nmpY);
                    % Now do the transpose axes.
                    axes(H.Haxes(j,i))
                    cmpX = get(H.HlineHigh(j,i),'xdata');
                    cmpY = get(H.HlineHigh(j,i),'ydata');
                    % Add these to the points in the brush.
                    nmpX = [H.data(insidebrush,H.IndX(j,i));cmpX(:)];
                    nmpY = [H.data(insidebrush,H.IndY(j,i));cmpY(:)];
                    set(H.HlineHigh(j,i),'xdata',nmpX,...
                        'ydata',nmpY);
                end
            end
        end % if isempty 
        
    case 'undo'
        % Points inside are unbrushed - make them black. Those outside stay 
        % the same.
        % Find the indices to the currently marked points that are inside
        % the brush. Remove these from the highlighted points and add onto
        % the unhighlighted points.
%         keyboard
        if ~isempty(insidebrush)
            % Add these to the currently marked points.
            for i = 1:p
                for j = (i+1):p
                    axes(H.Haxes(i,j))
                    % Plot the highlighted points.
                    % Get the currently highlighted points.
                    cmpX = get(H.HlineHigh(i,j),'xdata');
                    cmpY = get(H.HlineHigh(i,j),'ydata');
                    % Take the points inside the brush and find their
                    % intersection with the currently marked points.
                    [C] = intersect(cmpX,H.data(insidebrush,H.IndX(i,j)));
                    for k = 1:length(C)
                        % Find all of the vals equal to the brushed ones.
                        it = find(cmpX==C(k));
                        cmpX(it) = [];
                        cmpY(it) = [];
                    end
                    set(H.HlineHigh(i,j),'xdata',cmpX,...
                        'ydata',cmpY);
                    % Now do the transpose axes.
                    axes(H.Haxes(j,i))
                    % Plot the highlighted points.
                    % Get the currently highlighted points.
                    cmpX = get(H.HlineHigh(j,i),'xdata');
                    cmpY = get(H.HlineHigh(j,i),'ydata');
                    % Take the points inside the brush and find their
                    % intersection with the currently marked points.
                    [C] = intersect(cmpX,H.data(insidebrush,H.IndX(j,i)));
                    for k = 1:length(C)
                        % Find all of the vals equal to the brushed ones.
                        it = find(cmpX==C(k));
                        cmpX(it) = [];
                        cmpY(it) = [];
                    end
                    set(H.HlineHigh(j,i),'xdata',cmpX,...
                        'ydata',cmpY);
                end % end j loop
            end     % end i loop
        end % if isempty 

end

%%%%%       UpdateDelete    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UpdateDelete(H)
% In this sub-function - delete the points. Only works in lasting mode.
% Will not really take into account what mode is chosen.
% BE SURE TO CHANGE AXIS TO Auto - then back to manual!

% BESURE TO CHANGE THE RANGES IN THE DIAGONAL BOXES.


%%%%%%      ResetFigure     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ResetFig(H)
% In this function, reset the entire figure back to the initial state. This
% will just affect the plots - not the choices in the menu items. 

[n,p] = size(H.data);
X = H.data;
for i = 1:p
    for j = (i+1):p
        % Do the I,J ones first.
        axes(H.Haxes(i,j))
        axis auto
        set(H.HlineReg(i,j),'xdata',X(:,j),'ydata',X(:,i),...
            'markersize',3,'marker','o','linestyle','none');
        set(H.HlineHigh(i,j),'xdata',nan,'ydata',nan)
        axis(H.AxesLims{i,j})
        axis manual
        % Do the J,I one next.
        axes(H.Haxes(j,i))
        axis auto
        set(H.HlineReg(j,i),'xdata',X(:,i),'ydata',X(:,j),...
            'markersize',3,'marker','o','linestyle','none');
        set(H.HlineHigh(j,i),'xdata',nan,'ydata',nan)
        axis(H.AxesLims{j,i})
        axis manual
    end   % for j loop
end   % for i loop

    