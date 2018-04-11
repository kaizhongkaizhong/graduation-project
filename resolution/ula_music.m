close all; clear all; clc;
% ------参数------
SNR = 5;
%N = 12;
N = 8;
c = 1500;
f = 10e3;
lambda = c/f;
d = lambda/2;       % 单位阵元间距
fs = 40e3;
poi = [0:N-1];   % ula阵元位置
N_s = 2;         % 信源数
phi0 =  [10 14];       % 入射角度
phi = -90:0.1:90;
%单频信号
T_sig = 0.01;
T = 2*T_sig;
t_sig = 0:1/fs:T_sig-1/fs;
t = 0:1/fs:T-1/fs;
L_sig = length(t_sig);
L = length(t);
sig_org = sin(2*pi*f*t_sig);
sig_org2 = sin(2*pi*8e3*t_sig);
sig = [sig_org, zeros(1, L-L_sig);
       sig_org2, zeros(1, L-L_sig)]; %add zero
% plot(t_sig,sig_org2);
w_sig = exp(-1j*2*pi*f*d*poi.'*sind(phi0)/c);
sig_arr = w_sig*sig;
% sig_arr = zeros(N,L);
% for q = 1:length(phi0)  
%     w_sig = exp(-1j*2*pi*f*d*poi*sind(phi0(q))/c).';
%     sig_arr =  w_sig*sig(q,:);
% end
x_arr = awgn(sig_arr,SNR,'measured');
Rxx=x_arr*x_arr'/L;  


%% cbf
% P_cbf = zeros(1,length(phi));
% for ii = 1:length(phi)
%     w = conj(exp(-1j*2*pi*f*d*poi*sind(phi(ii))/c));
%     P_cbf(ii) = sum(abs(w*x_arr));
% end
%  figure;
%  plot(phi,P_cbf);
    
%     
% --------------------------------------------------------------------------
[V,D]=eig(Rxx);             %分解得到特征值D和特征向量V
[D1,I]=sort(diag(D));       %将特征值排序
U=V(:,I);
Un1=fliplr(U);
for m=1:length(phi)
    a_n=exp(-j*2*pi*d*[0:N-1].'*sind(phi(m))/lambda);
    Un=Un1(:,N_s+1:N);         %选取阵元数-信源数个特征值和特征向量作为噪声子空间
    p(m)=1/(a_n'*Un*Un'*a_n);  % MUSIC算法空间谱
end
% P=10*log10(abs(p)/max(abs(p)));
P=abs(p)/max(abs(p));

plot(phi, P);
% --------------------------------------------------------------------------
% [U,S,V] = svd(Rxx);
% lamda = diag(S);
% ratio = lamda(1:end-1)./lamda(2:end);
% ix = find(ratio>10) + 1;
% ix = ix(1);
% Un = U(:,ix:end);              % 噪声子空间
% for m=1:length(phi)
%     tao =  (d*poi.'*sind(phi(m)))/c;    
%     a_n = exp(-1j*2*pi*f*tao);
% %     a_n=exp(-j*2*pi*d*[0:N-1].'*sind(phi(m))/lambda);
%     p(m)=1/(a_n'*Un*Un'*a_n);  % MUSIC算法空间谱
% end
% %--------------------------------------------------------------------------
% P=10*log10(abs(p)/max(abs(p)));
% % P=abs(p)/max(abs(p));
% 
% plot(phi, P);
