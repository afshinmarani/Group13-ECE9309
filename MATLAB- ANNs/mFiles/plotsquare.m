%-- Afshin Shaygani--%
clc;

% First, you should export results (u) and mesh (p e t). Then use p as (x and y) points. 
% data_second gives (u) and (p e t)of the triangle problem. 

load('square.mat');
x = p(1,:);
y = p(2,:);
temp = u(:,end);
normalt = (temp-min(temp))./(max(temp)-min(temp));
z = normalt;

figure(1)
for i = 1: size(p,2)
    
    plot(x(i),y(i),'O',  'MarkerFaceColor',normalt(i)*[1,1,1],'MarkerEdgeColor',normalt(i)*[1,1,1])
    hold on
end



figure(2)

resolution = 500;   % Picture resolution
xgrid = linspace(min(x),max(x),resolution);
ygrid = linspace(min(y),max(y),resolution);
[Xgrid,Ygrid]=meshgrid(xgrid,ygrid);
 Zgrid = griddata(x,y,z,Xgrid,Ygrid,'natural');
  contourf(Xgrid,Ygrid,Zgrid,20)
  colormap(parula(300)) 
  
axis equal  
xlabel("x"); ylabel("y");
title("Temperature Profile")
colorbar

  
  
figure(3)
s = surf(Xgrid,Ygrid,Zgrid);
colormap(gray(30))
  s.EdgeColor = 'none';
xlabel("x"); ylabel("y");
title("Temperature Profile")

figure(4)
imagesc(Zgrid)         % try this:   pcolor
colormap(gray(100))  
axis ij
axis square

figure(5)
scatter3(x,y,z,'oK')

