 function [weights]=train_SDNN(weights,layers,network_struct,spike_times_learn,DoG_params,STDP_params,num_img_learn,learnable_layers,total_time,deta_STDP_minus,deta_STDP_plus)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ.
%   �˴���ʾ��ϸ˵��
% STDP_per_layer=STDP_params.STDP_per_layer;
% offset_STDP=STDP_params.offset_STDP;
[~,num_layers]=size(network_struct);
max_iter=STDP_params.max_iter;
curr_lay_idx=1;
learning_layer=learnable_layers(1);%ѵ�����Ӧ�Ĳ���
counter=1;
cl_store=zeros(1,1000);
n=1;
 fprintf('-------------------- STARTING LEARNING---------------------\n')             %��ʼѵ����֮����е���
 for i=1:max_iter  %max_iter Ϊ����������
     perc=i/max_iter;
     fprintf('---------------------LEARNING PROGRESS %1.0f/%1.0f --- %2.4f-------------------- \n',i,max_iter,perc)  %��ʾ��ǰ��ѵ������
      if i==100
          save("weights_100.mat","weights");
      elseif i==200
          save("weights_200.mat","weights");
      elseif i==300
          save("weights_300.mat","weights");
      elseif i==400
          save("weights_400.mat","weights");
      elseif i==500
          save("weights_500.mat","weights");
      elseif i==600
          save("weights_600.mat","weights");
      elseif i==700
          save("weights_700.mat","weights");
      elseif i==800
          save("weights_800.mat","weights");
      elseif i==900
          save("weights_900.mat","weights");
      elseif i==1000
          save("weights_1000.mat","weights");
      elseif i==1100
          save("weights_1100.mat","weights");
      elseif i==1200
          save("weights_1200.mat","weights");
      elseif i==1300
          save("weights_1300.mat","weights");
      elseif i==1400
          save("weights_1400.mat","weights");
      elseif i==1500
          save("weights_1500.mat","weights");
      elseif i==1600
          save("weights_1600.mat","weights");
      elseif i==1700
          save("weights_1700.mat","weights");
      elseif i==1800
          save("weights_1800.mat","weights");
      end
          
      
     if counter>STDP_params.max_learning_iter(learning_layer)      %max_learning_iter������������壬��ʾ���ĵ�������
         curr_lay_idx=curr_lay_idx+1;%�л�����һ��ѧϰ��
         learning_layer=learnable_layers(curr_lay_idx);%learning layer�Ķ��壬�õ����ڵ�ǰѧϰ�ľ���
         counter=1;
     end
      counter=counter+1;
     %���ú��� reset_layers
     layers=reset_layers(layers,num_layers);%�����еĲ���лָ�
     
      %�õ������������
     path_img=spike_times_learn{n};
      if n<num_img_learn
          n=n+1;
      else
          n=1;
      end    
     st=DoG_filter_to_st(path_img,DoG_params.DoG_size,DoG_params.img_size,total_time,num_layers);%  st = spike_time ��������ʱ��

     layers_buff=init_layers(network_struct);%��ˮ�߽ṹ
     weights=train_step3( weights,layers,layers_buff,network_struct,total_time,learning_layer,st,STDP_params.STDP_per_layer,deta_STDP_minus,deta_STDP_plus,STDP_params.offset); %���� ����train_step()  ��������Ϊst��������ʱ����Ϣ������������忪ʼ����Ȩֵѵ��

     w=weights{2};
[Hw,Ww,Mw,Dw]=size(w);
N=Hw*Ww*Dw;
cl=0;
for kw=1:Dw
    for iw=1:Hw
        for jw=1:Ww
            cl=cl+(w(iw,jw,kw)*(1-w(iw,jw,kw)))/N;
        end
    end
end
cl_store(i)=cl;  
 end
    fprintf('---------LEARNING PROGRESS %2.3f------------- \n',perc)
     
    fprintf('-------------------- FINISHED LEARNING---------------------\n')

end

