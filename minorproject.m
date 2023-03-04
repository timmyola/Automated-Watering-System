% clearing and closing all variables to avoid conflict
clear all; close all;
 
%declaring and initializing arduino 
a = arduino('/dev/cu.usbserial-0001', 'uno');
 
%Live Graph
figure %introduces the popup figure
h = animatedline; %animates the graph
ax = gca; %returns the current axes in the current figure
ax.YGrid = 'on'; %turns on the grid lines on the y-axis
ax.YLim = [-0.1 5]; %sets the min and max of the y-axis
%title and labels
title('Moisture Levels vs Time (Live)'); 
ylabel('Moisture Levels');
xlabel('Time [HH:MM:SS]');
 
stop = false; %variable used with the while loop
 
startTime = datetime('now'); % this inputs the current time into  variable

%declaring variables for the wet, dry and threshold values of the plant's
%voltage
moistureThreshold = 3.2;
reallyDryValue = 3.7;
saturatedValue = 2.9;
 

while ~ stop   

 % getting the current voltage and storing it in a variable 
voltage = readVoltage(a,'A1');
% Read current voltage value
    sprintf=('Signal received');

%us  ing if statement to determine if the plant needs more watering 
%this is done by getting 
   clap = readDigitalPin(a,'A2')

if voltage > reallyDryValue && clap >0
writeDigitalPin(a,'D2', 1); 
disp('The plant is dry, water it!')
% 
elseif voltage >= moistureThreshold && voltage < reallyDryValue &&  clap >0
    writeDigitalPin(a,'D2',1); 
    disp('The plant is wet, but still needs more water!')

elseif voltage <= saturatedValue 
    writeDigitalPin(a,'D2', 0);
    disp('The plant does not need anymore watering!')
end

%function to convert the voltage into moisture values 
   
% Get current time
t = datetime('now') - startTime;
% Add points to animation 
addpoints(h,datenum(t),voltage)
% Update axes
ax.XLim = datenum([t-seconds(15) t]); 
datetick('x','keeplimits')
drawnow

% Check stop condition 
end
stop = writeDigitalPin(a,'D2',0); 
