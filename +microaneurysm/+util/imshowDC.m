function imshowDC(img, dataMatrix, dataLabels, varargin)
% Imshow displays an image with custom data for the datacursor
% @param img: An `mxnxd` image to be displayed (d=3 for colour, 1 for
% greyscale)
% @param dataMatrix: An `mxnxf` matrix of features to display. Where we have
% f rows to display for each pixel
% @param labels: A cell array of string labels, for use in 

fh = figure; 
imshow(img);

dcm = datacursormode(fh);

datacursormode on;
set(dcm, 'updatefcn', @(obj, event_obj) featureview_customDataCursor(obj, event_obj, dataMatrix, dataLabels) );


function output_txt = myfunction(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
output_txt = {['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end

function output_txt = featureview_customDataCursor(obj, event_obj, dataMatrix, dataLabels)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

% pos = get(event_obj,'Position');

output_txt = {};
pos = get(event_obj,'Position');
colpos = pos(1);
rowpos = pos(2);

for d=1:size(dataMatrix, 3)
    output_txt = [ output_txt, [ dataLabels{d}, ': ', num2str( dataMatrix(rowpos,colpos,d),4)]];
end

