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

% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
% |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



in_t = linspace(0,1,100);

aaa = figure('position',[0 0 2000 1000]);
for k = 1:100
    z = [];
    z = zz(:,k);

    %figure(k)
    s1 = subplot(1,3,1) ;
    

resolution = 600;  % Picture resolution (CONSIDER 8% CUT WHEN CHANGING IT!)
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);
Zgrid = griddata(x,y,z,Xgrid,Ygrid,'natural'); 


 contourf(Xgrid,Ygrid,Zgrid,20);   % To plot true T

%--------------------------
  axis equal  
  xlabel("x"); ylabel("y");
  title("True Temperature Profile")
  colorbar
%--------------------------


%---------------------------------------------------------------------
  
   s2 = subplot(1,3,2) ;

x_input_to_net = reshape(Xgrid,1,resolution^2);
y_input_to_net = reshape(Ygrid,1,resolution^2);
    % From this
t_input_to_net = in_t(k) .* ones(1,resolution^2);
givenetworkinput = [x_input_to_net; y_input_to_net;t_input_to_net];
readnetworkoutpt = network2(givenetworkinput);
Zgridnet = reshape(readnetworkoutpt,resolution,resolution);
   % To this,differs 


 contourf(Xgrid,Ygrid,Zgridnet,20);  % To plot predicted T


%--------------------------
  axis equal  
  xlabel("x"); ylabel("y");
  title("Predicted Temperature Profile")
  colorbar
%--------------------------

%---------------------------------------------------------------------



Zgriderror =abs( Zgrid - Zgridnet);
cut = 45;
Zgriderror_cut = Zgriderror(cut+1:end-cut,cut+1:end-cut);
Xgrid_cut = Xgrid(cut+1:end-cut,cut+1:end-cut);
Ygrid_cut = Ygrid(cut+1:end-cut,cut+1:end-cut);
  
% surf(Xgrid_cut,Ygrid_cut, Zgriderror_cut);    % To plot the error

  


  
s3 = subplot(1,3,3) ;


  imagesc(Zgriderror_cut)     % try this:   pcolor
  colormap(s3,gray(300))  
  title({'Temperature Error Profile';'(Away from the Boundaries)'})
  axis ij
  axis square
  colorbar
  xlabel("x"); ylabel("y");
  
  
  %M(k) = getframe(aaa,[0   0  1900  800]);
  M(k) = getframe(aaa);
end
figure(2);movie(M,2)
size(M(1).cdata)

% movie(M,20)

writerObj = VideoWriter('out3.avi');   
writerObj.FrameRate = 60;
open(writerObj);
writeVideo(writerObj, M);
close(writerObj);


%%
% to save only error as HQ video!





resolution = 1000;   % Picture resolution

in_t = linspace(0,1,100);
for k = 1:100
    z = [];
    z = zz(:,k);


    
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);
Zgrid = griddata(x,y,z,Xgrid,Ygrid,'natural');   % Zgrid is values of true T


%---------------------------------------------------------------------

x_input_to_net = reshape(Xgrid,1,resolution^2);
y_input_to_net = reshape(Ygrid,1,resolution^2);
    % From this
t_input_to_net = in_t(k) .* ones(1,resolution^2);
givenetworkinput = [x_input_to_net; y_input_to_net;t_input_to_net];
readnetworkoutpt = network2(givenetworkinput);
Zgridnet = reshape(readnetworkoutpt,resolution,resolution); % Zgrid is values of predicted T
   % To this,differs 


 %contourf(Xgrid,Ygrid,Zgridnet,20);  % To plot predicted T

%---------------------------------------------------------------------

Zgriderror = abs( Zgrid - Zgridnet);
cut = 80;
Zgriderror_cut = Zgriderror(cut+1:end-cut,cut+1:end-cut);  %  values of the error
Xgrid_cut = Xgrid(cut+1:end-cut,cut+1:end-cut);
Ygrid_cut = Ygrid(cut+1:end-cut,cut+1:end-cut);
  

  %normalZgriderror_cut = (  Zgriderror_cut  -  min(min(Zgriderror_cut))  ) ./  (   max(max(Zgriderror_cut))  -   min(min(Zgriderror_cut))   );


 imagesc(Zgriderror_cut) ;    % try this:   pcolor
  colormap(gray(500))  
  title({'Temperature Error Profile';'(Away from the Boundaries)'})
  axis ij
  axis square
  colorbar
  xlabel("x"); ylabel("y");
  
  
  %M(k) = getframe(aaa,[0   0  1900  800]);
  M(k) = getframe;
end
figure(2);movie(M,2)
size(M(1).cdata)

% movie(M,20)

writerObj = VideoWriter('out4.avi');   
writerObj.FrameRate = 60;
open(writerObj);
writeVideo(writerObj, M);
close(writerObj);
