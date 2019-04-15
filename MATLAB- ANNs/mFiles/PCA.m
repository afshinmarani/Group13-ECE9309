%-- Afshin Shaygani--%
clc;
clear;
data = load('C:\Users\Afshin\Downloads\Machine Learning Shami Course\Equation with Python or Matlab\Matlab\PDEtool\Square\u100.mat');
M = data.u;
COV_spatial  = M * M';
COV_Temporal = M' * M;


% [U_t,S_t,V_t] = svd(COV_Temporal);
%S_s = svd(COV_spatial); This is tha same as S_t but computationally intense
S_t = svd(COV_Temporal);



figure(1)
bar( log(S_t(1:12))); grid on;
title('Sorted Singular Values for The Covariance Matrix')
ylabel('Log Values')



figure(2)
subplot(2,1,1);
M1 = M(1:10609,:);
M2 = reshape(M1(:,20),[],103);
COV_M2 = M2' * M2;
S_COV_M2 = svd(COV_M2);
bar(log(S_COV_M2)); grid on;
title('Sorted Singular Values for The Spatial Covariance Matrix in time 0.2s: Cov(T(0.2s))')
ylabel('Log Values')


subplot(2,1,2);
M1 = M(1:10609,:);
M2 = reshape(M1(:,80),[],103);
COV_M2 = M2' * M2;
S_COV_M2 = svd(COV_M2);
bar(log(S_COV_M2)); grid on;
title('Sorted Singular Values for The Spatial Covariance Matrix in time 0.8s: Cov(T(0.8s))')
ylabel('Log Values')

%----------------------------------------

figure(3)



subplot(4,1,1);
M1 = M(1:10609,:);
M2 = reshape(M1(:,15)-M1(:,10),[],103);
COV_M2 = M2' * M2;
S_COV_M2 = svd(COV_M2);
bar(log(S_COV_M2)); grid on;
title('Sorted Singular Values for The Spatial Covariance Matrix of T(0.15s)-T(0.10s)')
ylabel('Log Values')

subplot(4,1,2);
M1 = M(1:10609,:);
M2 = reshape(M1(:,25)-M1(:,20),[],103);
COV_M2 = M2' * M2;
S_COV_M2 = svd(COV_M2);
bar(log(S_COV_M2)); grid on;
title('Sorted Singular Values for The Spatial Covariance Matrix of T(0.25s)-T(0.20s)')
ylabel('Log Values')


subplot(4,1,3);
M1 = M(1:10609,:);
M2 = reshape(M1(:,45)-M1(:,40),[],103);
COV_M2 = M2' * M2;
S_COV_M2 = svd(COV_M2);
bar(log(S_COV_M2)); grid on;
title('Sorted Singular Values for The Spatial Covariance Matrix of T(0.45s)-T(0.40s)')
ylabel('Log Values')



subplot(4,1,4);
M1 = M(1:10609,:);
M2 = reshape(M1(:,75)-M1(:,70),[],103);
COV_M2 = M2' * M2;
S_COV_M2 = svd(COV_M2);
bar(log(S_COV_M2)); grid on;
title('Sorted Singular Values for The Spatial Covariance Matrix of T(0.75s)-T(0.70s)')
ylabel('Log Values')

