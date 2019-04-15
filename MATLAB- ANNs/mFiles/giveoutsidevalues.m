%-- Afshin Shaygani--%



clc;
clear;
%close all;
load('network2.mat')
%---------------------------------------------Start|  Loading the data
load('square.mat');
x = p(1,:);
y = p(2,:);
t = linspace(0,1,101);
temp = u;
normalt = (  temp  -  min(min(temp))  ) ./  (   max(max(temp))  -   min(min(temp))   );
z = normalt;
zz = z;       % To be on the safe side!!!
%---------------------------------------------Stop|  Loading the data

%---------------------------------------------Start| Collecting testing_training data!
m = 3000; %   Size of the test-train-val data
n = 30;   %   Size of the time set

indices   = randi([1 size(x,2)],1,m);   % pick m indices for samples as test-train-val data from the datsbase
indices_t = randi([1 size(z,2)],1,n); 

mtr = floor(1 * m); % Size of the train  data
mts = floor(0 * m); % Size of the test   data
mvl = floor(0 * m); % Size of the val    data

mtr_t = floor(1 * n); % Size of the train  data
mts_t = floor(0 * n); % Size of the test   data
mvl_t = floor(0 * n); % Size of the val    data


%---------------- Indices -----------------
training_data_indices    = indices(1:mtr);

training_data_indices_t    = indices_t(1:mtr_t);

%---------------- Train -----------------
x_training_data = x(training_data_indices);
y_training_data = y(training_data_indices);

t_training_data = t(training_data_indices_t);

z_training_data = z(training_data_indices,training_data_indices_t);

%------------------------------------------------------------


xy_training_data = [x_training_data' y_training_data']';
new_xy_training_data = repmat(xy_training_data,1,mtr_t);

new_t_training_data = repmat(t_training_data',1,mtr);
new_t_training_data = reshape(new_t_training_data',1,[]);

input_with_t = [new_xy_training_data;new_t_training_data];

output_with_t = reshape(z_training_data,1,[]);

%%
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
% Temporal Extrapolation
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

in_t = linspace(0,5,200); % It means in time (10-1)/100 second


aaa = figure('position',[0 0 2000 1000]);
for k = 1 : 200

%figure(k)
sgtitle('Temperature - Temporal Extrapolation')


p1 = subplot(1,2,1);    %  Plotting Predicted Temperature

resolution = 50;   % Picture resolution
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);

x_input_to_net = reshape(Xgrid,1,resolution^2);
y_input_to_net = reshape(Ygrid,1,resolution^2);

t_input_to_net = in_t(k) .* ones(1,resolution^2);
givenetworkinput = [x_input_to_net; y_input_to_net;t_input_to_net];

readnetworkoutpt = network2(givenetworkinput);

Zgridnet = reshape(readnetworkoutpt,resolution,resolution);
                                                        % To this,differs 
                                                         
  contourf(Xgrid,Ygrid,Zgridnet,20)
  colormap(p1,parula(300)) 
 
  axis equal  
  xlabel("x"); ylabel("y");
  colorbar
 

%---------------------------------------



p2 = subplot(1,2,2) ;


  imagesc(Zgridnet)     % try this:   pcolor
  colormap(p2,gray(300))  
  axis ij
  axis square
  colorbar
  xlabel("x"); ylabel("y");



%---------------------------------------

M(k) = getframe(aaa);
end
  


writerObj = VideoWriter('Extrapolateintime.avi');   
writerObj.FrameRate = 60;
open(writerObj);
writeVideo(writerObj, M);
close(writerObj);

%%
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
% Spatial Extrapolation
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

in_t = linspace(0,1,100); % It means in time (10-1)/100 second


aaa = figure('position',[0 0 2000 1000]);
for k = 1 : 100

%figure(k)
sgtitle('Temperature - Spatial Extrapolation')


p1 = subplot(1,2,1);    %  Plotting Predicted Temperature

resolution = 50;   % Picture resolution
xgrid = linspace(min(x)-1,max(x)+1,resolution);
ygrid = linspace(min(y)-1,max(y)+1,resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);

x_input_to_net = reshape(Xgrid,1,resolution^2);
y_input_to_net = reshape(Ygrid,1,resolution^2);

t_input_to_net = in_t(k) .* ones(1,resolution^2);
givenetworkinput = [x_input_to_net; y_input_to_net;t_input_to_net];

readnetworkoutpt = network2(givenetworkinput);

Zgridnet = reshape(readnetworkoutpt,resolution,resolution);
                                                        % To this,differs 
                                                         
  contourf(Xgrid,Ygrid,Zgridnet,20)
  colormap(p1,parula(300)) 
 
  axis equal  
  xlabel("x"); ylabel("y");
  colorbar
 

%---------------------------------------



p2 = subplot(1,2,2) ;


  imagesc(Zgridnet)     % try this:   pcolor
  colormap(p2,gray(300))  
  axis ij
  axis square
  colorbar
  xlabel("x"); ylabel("y");



%---------------------------------------

M(k) = getframe(aaa);
end
  
%%

writerObj = VideoWriter('Extrapolateinspace.avi');   
writerObj.FrameRate = 60;
open(writerObj);
writeVideo(writerObj, M);
close(writerObj);

