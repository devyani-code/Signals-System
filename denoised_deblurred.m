a=xlsread('data_assign.xlsx');                                                 %%read given data%%
y=a(:,2);                                                                      %%y[n] array%%
x_original=a(:,1);                                                             %%x[n] array%%
%%%%%%%Denoising%%%%%%
N=length(y);
y_denoised=zeros(size(y));                                                     %%initializing an array with all zeros%%
y_denoised(1)= (1/2)*(y(1)+y(2));                                              %%first element is average of 1st&2nd element of y[n]%%
y_denoised(193)=(1/2)*(y(192)+y(193));                                         %%last element will be average of last two elements of y[n]%%
for j=1:5                                                                      %%for other elements of y_denoised%%
   for index=2:192
            s=0;
            for k=index-1:index+1                                              %%loop for computing average%% 
              s=s+y(k);
              y_denoised(index,1)=s/3;                                         %%each element will be average of three elements element of index k,k-1&k+1
            end     
    end
    y=y_denoised;
end

%%%%%% H(jw) %%%%%
wo = (2*pi)/193;                                                               
q = [];                                                                         %%empty arry which will hold 193 values of Hjw
for k = 1:200                                                                   %%loop for index of frequency, k = 0 means omega = 0 and so  on%%
    q(k,1) = (1/8)*(4*cos((k-1)*wo)+cos(2*(k-1)*wo)+3);                         %%%On solving h[n] in terms of dirac delta function and finding its fourier transform we get only real function in frequency domain
end
H=q(1:193,1);

for i=1:193                                                                     %%thresholding to replace zeros if any are there in Hjw
    if H(i,1)<0.3
        H(i,1)=0.3;
    end
end         
%%%%%%Y(jw)%%%%%
Input_length=length(y);                                                          
for j=1:Input_length                                                             
    Y(j,1)=0;                                                                    %%loop to form a intial array which has zeros in it
    for k=1:Input_length                                                         %%%loop to replace zeros with DTFT of y_denoised 
        Y(j,1)=Y(j,1)+y_denoised(k).*exp(-1i*(2*pi/Input_length)*(j-1)*(k-1));   %%computing DTFT using conventional formula and adding it to the Y1 array of zeros%%
    end                                                                          
end                                                                              

%%%%%%Xjw%%%%%%
Xj=Y./H;                                                                         %%elementwise division to get deblurred signal Xjw from Y./H::(multiplication in frequency domain)%%


%%%InversingXj%%%%                                                               %%to convert a signal again into time domain%%
N=length(a(:,1));

for j=1:193                                                                      %%loop to form a intial array which has zeros in it
    x(j,1)=0;                                                                    %%array of zeros of size 193
    for k=1:193                                                                   
        x(j,1)=x(j,1)+(1/N)*Xj(k,1).*exp(1i*(2*pi/N)*(j-1)*(k-1));              %%compute the inverse fourier transform of the signal to get the deblurred signal in time domain%%
    end
end
x_denoise_deblurr=real(x);                                                      %%x_denoise_deblurr is array of imaginary no.'with very small imaginary values which can be neglected and hence it only has real values
plot(1:193,x_denoise_deblurr,'k')
hold on
plot(1:193,x_original,'g')
title("Line plot of denoised then deblurred y[n]");
xlabel("sample")
ylabel("output")
legend({"x_1[n]",'x[n]'},'Location','southwest')
disp(mean((x_denoise_deblurr-x_original).^2))