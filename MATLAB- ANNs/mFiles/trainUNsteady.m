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

%%
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
%testing_data_indices     = indices(mtr+1:mtr+mts);
%validation_data_indices  = indices(mtr+mts+1:end);

training_data_indices_t    = indices_t(1:mtr_t);
%testing_data_indices_t     = indices_t(mtr_t+1:mtr_t+mts_t);
%validation_data_indices_t  = indices_t(mtr_t+mts_t+1:end);

%---------------- Train -----------------
x_training_data = x(training_data_indices);
y_training_data = y(training_data_indices);

t_training_data = t(training_data_indices_t);

z_training_data = z(training_data_indices,training_data_indices_t);

%---------------- Test -----------------
% x_testing_data = x(testing_data_indices);
% y_testing_data = y(testing_data_indices);
% 
% 
% t_testing_data  = t(testing_data_indices_t);
% 
% z_testing_data  = z(testing_data_indices,testing_data_indices_t);


%---------------- Validate -----------------
% x_validation_data  = x(validation_data_indices);
% y_validation_data  = y(validation_data_indices);
% 
% t_validation_data  = t(validation_data_indices_t);
% 
% z_validation_data  = z(validation_data_indices,validation_data_indices_t);


%-- Putting to the form of Matlab toolboxes --

%input = [x_training_data' y_training_data']';

xy_training_data = [x_training_data' y_training_data']';
new_xy_training_data = repmat(xy_training_data,1,mtr_t);

new_t_training_data = repmat(t_training_data',1,mtr);
new_t_training_data = reshape(new_t_training_data',1,[]);

input_with_t = [new_xy_training_data;new_t_training_data];

%output = z_training_data';.
output_with_t = reshape(z_training_data,1,[]);


%---------------------------------------------Stop| Collecting testing_training data!

%%




% --------------------------------------------Start| Plotting test train validation
figure(1)
pot = 5;  %   Plot one time!  pick a number within min(mts_t,vl_t)

for i = 1: mtr
    plot(x_training_data(i),y_training_data(i),'O',  'MarkerFaceColor',z_training_data(i,pot)*[1,1,1],'MarkerEdgeColor',z_training_data(i,pot)*[1,1,1])
    hold on
end
for i = 1: mts
    plot(x_testing_data(i),y_testing_data(i),'O',  'MarkerFaceColor',z_testing_data(i,pot)*[1,1,1],'MarkerEdgeColor',[1 0 0])
    hold on
end
for i = 1: mvl
    plot(x_validation_data(i),y_validation_data(i),'O',  'MarkerFaceColor',z_validation_data(i,pot)*[1,1,1],'MarkerEdgeColor',[0 1 0])
    hold on
end

hold off

% --------------------------------------------Stop| Plotting test train validation

%%
% --------------------------------------------Start| Machine Learning Model

%
%  ML TYPE: ANNs (Shallow Network!)
%  Inputs                          "2"
%  Output                          "1"
%  Hidden Layers                   "2"
%  Neurons per hidden layer        "10"
%  Activation function             "Sigmoid"
%  Learning Mechanism:             "LM"
%  Quality Metrics:                "MSE" 
% 
% 
%  To generate code, "nntool" doesn't do that, use "nftool"! 
%  (it only generates the built model! Not the building and training process )
%  Furthermore, it is only one-hiddenlayer net with hidden activation
%  function of sigmoid and output layer of linear.


% --------------------------------------------Stop| Machine Learning Model



% -----------------------------------Start| Plotting test train validation
%-------------------------------------------------------------------------
% Putting arbitrary inputs on the grid in the form that ANNs accepts: 
% features*samples --->  network1(([[0.5;0.5] [0.15;0.15] [0.75;0.75]]))
%-------------------------------------------------------------------------

in_t = [10,20,40,70,100]; % It means in time (10-1)/100 second



for k = 1 : size(in_t,2)
   
    z = [];
    z = zz(:,in_t(k));









figure(1+k)
sgtitle(['Temperature in time ',num2str(in_t(k)/100),'s'],'Color', 'r')

p1 = subplot(2,3,1);    %  Plotting True Temperature

resolution = 50;   % Picture resolution
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);
Zgrid = griddata(x,y,z,Xgrid,Ygrid,'natural');    %%% CORE
 
  contourf(Xgrid,Ygrid,Zgrid,20)
  colormap(p1,parula(300)) 
  
  axis equal  
  xlabel("x"); ylabel("y");
  title("True Temperature Profile")
  colorbar


%---------------------------------------


p2 = subplot(2,3,4);    %  Plotting Predicted Temperature

resolution = 50;   % Picture resolution
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);
x_input_to_net = reshape(Xgrid,1,resolution^2);
y_input_to_net = reshape(Ygrid,1,resolution^2);

givenetworkinput = [x_input_to_net; y_input_to_net];     % From this

t_input_to_net = 0.01*in_t(k) .* ones(1,resolution^2);
givenetworkinput = [x_input_to_net; y_input_to_net;t_input_to_net];

readnetworkoutpt = network2(givenetworkinput);
%readnetworkoutpt = myNeuralNetworkFunction1(givenetworkinput);
%readnetworkoutpt = myNeuralNetworkFunction2(givenetworkinput);
%readnetworkoutpt = myNeuralNetworkFunction3(givenetworkinput);


Zgridnet = reshape(readnetworkoutpt,resolution,resolution);

                                                        % To this,differs 
                                                          

  contourf(Xgrid,Ygrid,Zgridnet,20)
  colormap(p2,parula(300)) 
 
  axis equal  
  xlabel("x"); ylabel("y");
  title("Predicted Temperature Profile")
  colorbar
 

%---------------------------------------




p3 = subplot(2,3,3);     %  Plotting The Error

resolution = 50;   % Picture resolution
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);
Zgriderror = Zgrid - Zgridnet;
 
cut = 4;
Zgriderror_cut = Zgriderror(cut+1:end-cut,cut+1:end-cut);
Xgrid_cut = Xgrid(cut+1:end-cut,cut+1:end-cut);
Ygrid_cut = Ygrid(cut+1:end-cut,cut+1:end-cut);
  
  s = surf(Xgrid_cut,Ygrid_cut, Zgriderror_cut);
  %s.EdgeColor = 'none';
  colormap(p3,hot(500)) 
  
 
  xlabel("x"); ylabel("y");
  title({'Temperature Error Profile';'(Away from the Boundaries)'})


%---------------------------------------



p4 = subplot(2,3,2) ;


  imagesc(Zgriderror_cut)     % try this:   pcolor
  colormap(p4,gray(300))  
  title({'Temperature Error Profile';'(Away from the Boundaries)'})
  axis ij
  axis square
  colorbar
  xlabel("x"); ylabel("y");


  
  
%  p3 and p4 are the same plots as before but without cut, 
%     to see and compare the effect of being close to BCs!
  

p3 = subplot(2,3,6);     %  Plotting The Error

resolution = 50;   % Picture resolution
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);
Zgriderror = Zgrid - Zgridnet;
 
cut = 0;
Zgriderror_cut = Zgriderror(cut+1:end-cut,cut+1:end-cut);
Xgrid_cut = Xgrid(cut+1:end-cut,cut+1:end-cut);
Ygrid_cut = Ygrid(cut+1:end-cut,cut+1:end-cut);
  
  s = surf(Xgrid_cut,Ygrid_cut, Zgriderror_cut);
  %s.EdgeColor = 'none';
  colormap(p3,hot(500)) 
  
 
  xlabel("x"); ylabel("y");
  title("Temperature Error Surface")


%---------------------------------------



p4 = subplot(2,3,5) ;


  imagesc(Zgriderror_cut)     % try this:   pcolor
  colormap(p4,gray(300))  
  title("Temperature Error Profile")
  axis ij
  axis square
  colorbar
  xlabel("x"); ylabel("y");


  % -----------------------------------Stop| Plotting test train validation

end
  
  



