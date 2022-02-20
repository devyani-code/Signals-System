subplot(2,2,1)                              %%subplot1 of x_deblurr_denoise vs x_original
plot(1:193,x_deblurr_denoise)
hold on
plot(1:193,x_original)                    
title("Line plot of deblurred then denoiced y[n]");
xlabel("sample")
ylabel("output")
legend({"x_2[n]",'x[n]'},'Location','southwest')

subplot(2,2,2)                              %%subplot 2 of x_denoise_deblurr vs x_original
x_denoise_deblurr=real(x);
plot(1:193,x_denoise_deblurr)
hold on
plot(1:193,x_original)
title("Line plot of denoised then deblurred y[n]");
xlabel("sample")
ylabel("output")
legend({"x_1[n]",'x[n]'},'Location','southwest')

subplot(2,2,3);                            %%subplot 3 of x_denoise_deblurr vs x_original vs x_denoise_deblur
plot(1:193,x_deblurr_denoise,'y')
hold on
plot(1:193,x_original,'r')
plot(1:193,x_denoise_deblurr,'k')
title("analysis of x_1[n],x_2[n] & original x[n]");
legend({"x_2[n]",'x[n]','x_1[n]'},'Location','southwest')

subplot(2,2,4);                           %%%%subplot 4 of y_original vs x_original
plot(1:193,a(:,2),'g')
hold on
plot(1:193,x_original,'b')
title("analysis of given original y[n] & original x[n]");
legend({"y[n]",'x[n]'},'Location','southwest')

