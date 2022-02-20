a=xlsread('data_assign.xlsx');                                          
y=a(:,2); 
%%%%%% H(jw) %%%%%
wo = (2*pi)/193;                                                         %%wo is the sampling frequency%%
q = [];                                                                  %%empty array which will hold 193 values after looping%%
for k = 1:193                                                            
    q(k,1) = (1/8)*(4*cos((k-1)*wo)+cos(2*(k-1)*wo)+3);                  %%On solving h[n] in terms of dirac delta function and finding its fourier transform we get only real function in frequency domai%%
end
H=q(1:193,1);                                                            %%extracting 193 values to carry out individual division%%
for i=1:193
    if H(i,1)<0.3                                                       %%thresholding so that if value in H is zero then 1/H should not reach infinity%%
        H(i,1)=0.3;
    end
end 
%%%%%%Y(jw)%%%%%
x_original=a(:,1);                                                      %%given array of x[n]%%
Input_length=length(y);             
for j=1:Input_length                                                    %%loop to form a intial array which has zeros in it%%
    Y1(j,1)=0;
    for k=1:Input_length                                                %%loop to replace zeros with DTFT  y
        Y1(j,1)=Y1(j,1)+y(k).*exp(-1i*(2*pi/Input_length)*(j-1)*(k-1)); %%computing DTFT using conventional formula and adding it to the Y1 array of zeros
    end                                                                 
end                                                              

%%%%%%Xjw%%%%%%
Xj=Y1./H;                                                               %%elementwise division to get deblurred signal :(multiplication in frequency domain)%%

%%%InversingXj%%%%                                                      %%to convert a signal again into time domain%%
N=length(a(:,1));       
for j=1:193                                                             %%%loop to form a intial array which has zeros in it%%
    x1(j,1)=0;                                                          %%array of zeros of size 193
    for k=1:193
        x1(j,1)=x1(j,1)+(1/N)*Xj(k).*exp(1i*(2*pi/N)*(j-1)*(k-1));      %%compute the inverse fourier transform of the signal to get the deblurred signal in time domain%%
    end
end
x_deblurred=real(x1);                                                   %%x1 is array of imaginary no.'with very small imaginary values which can be neglected.

%%%%%%%Denoising%%%%%%
N=length(x_deblurred);
x_deblurr_denoise=zeros(size(x_deblurred));                             %%initializing an array with all zeros%%
x_deblurr_denoise(1)= (1/2)*(x_deblurred(1)+x_deblurred(2));            %%first element is average of 1st&2nd element of x_deblurred%%
x_deblurr_denoise(193)=(1/2)*(x_deblurred(192)+x_deblurred(193));       %%last element is the average of last two elements of x_deblurred%%
for j=1:5                                                              
   for index=2:192                                                      
            s=0;                                                        %%intially s is zero which will be replaced by sum of the one elemnet more and one element less than index
            for k=index-1:index+1                                       %%loop for computing average%%
              s=s+x_deblurred(k);
              x_deblurr_denoise(index)=s/3;                             %%x_deblurr_denoise zeros will replaced by average of s
            end     
    end
    x_deblurred=x_deblurr_denoise;
end
plot(1:193,x_deblurr_denoise,'k')
hold on
plot(1:193,x_original,'r')
title("Line plot of deblurred then denoiced y[n]");
xlabel("sample")
ylabel("output")
legend({"x_2[n]",'x[n]'},'Location','southwest')
disp(mean((x_deblurr_denoise-x_original).^2))