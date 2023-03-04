function y = myfunction(voltage);

veryDry = 0; %3.7v
veryWet = 1; %2.9v

m = (veryDry - veryWet) / (3.7 - 2.9); %slope
b = 1+(-1*m*2.9); %y-intercept
y = (m * voltage) + b; %equation for soil mositure 