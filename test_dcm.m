clear;
clc;

load('test_data.mat');      %�����������
%ATT���ݸ�ʽΪ��{'LineNo';'TimeUS';'DesRoll';'Roll';'DesPitch';'Pitch';'DesYaw';'Yaw';'ErrRP';'ErrYaw'}
%IMU���ݸ�ʽΪ��{'LineNo';'TimeUS';'GyrX';'GyrY';'GyrZ';'AccX';'AccY';'AccZ';'ErrG';'ErrA';'Temp';'GyHlt';'AcHlt'}
%AHR2���ݸ�ʽΪ��{'LineNo';'TimeUS';'Roll';'Pitch';'Yaw';'Alt';'Lat';'Lng'}
%MAG���ݸ�ʽΪ��{'LineNo';'TimeUS';'MagX';'MagY';'MagZ';'OfsX';'OfsY';'OfsZ';'MOfsX';'MOfsY';'MOfsZ';'Health'}
%����ATTΪEKF������̬��AHR2ΪDCM������̬
imu_interval_s=0.02;
%ʱ����Ϊ0.02��
%��ʼ����Ϊ����������
dcmEst=[1 0 0; 0 1 0; 0 0 1];

imu_sequence = size(IMU,1);     %�ۻ�����,ͨ����ȡ�����ڴ�С
mag_num = size(MAG,1);
discuss = ceil(imu_sequence/mag_num);       %��ȡ��
graf(imu_sequence,4)=zeros;      %��ͼ�����ʼ��
ACC_WEIGHT=0.02;        %���ٶȼƵ�Ȩ��
MAG_WEIGHT=0.01;         %�����Ƶ�Ȩ��

for n = 1:imu_sequence          %ѭ��imu_sequence�ν��о�����£���100�������100*0.02=2s������仯Ӧ��Ϊ2��4��6
    Kacc = -IMU(n,[6,7,8]);     %����ԭʼ���ٶȼƵ�ֵ
    Kacc = Kacc/norm(Kacc);     %���ٶȼ�������һ������
    wA(3)=zeros;
    wA=cross(dcmEst(2,:),Kacc);     %wA = Kgyro x	 Kacc
    
    w(3) = zeros;
    w = -IMU(n,[3,4,5]);        %����ԭʼ�����ǵ�ֵ
          
    %��������Ƶ����ݣ�ע��SD���ﲢû��IMU��ô�����ݣ�����������ǵ���ֵ
    z = ceil(n/discuss);
    %�޷�
    if z <= 1
        z = 1;
    elseif z >= mag_num
            z = mag_num;
    end
    Imag = MAG(z,[3,4,5]);
    Imag = Imag/norm(Imag);     %���������ݹ�һ������
    wM(3) = zeros;
    wM=cross(dcmEst(1,:),Imag);     %wM = Igyro x Imag
    
    Theta=(w*imu_interval_s + wA*ACC_WEIGHT + wM*MAG_WEIGHT)/(1+ACC_WEIGHT+MAG_WEIGHT);   %��ʱ�����ĽǶȱ仯������ȡȨ��ֵ
    
    dR(3)=zeros;
    for k = 1:3
        dR=cross(Theta,dcmEst(k,:));        %�������
        dcmEst(k,:)=dcmEst(k,:)+dR;     %�ۼ�
    end
    %������
    error=-dot(dcmEst(1,:),dcmEst(2,:))*0.5;
    %���У��
    x_est = dcmEst(2,:) * error;
    y_est = dcmEst(1,:) * error;
    dcmEst(1,:) = dcmEst(1,:) + x_est;
    dcmEst(2,:) = dcmEst(2,:) + y_est;
    %������
    dcmEst(3,:) = cross(dcmEst(1,:), dcmEst(2,:));
    if 1
        %̩��չ����һ������
        dcmEst(1,:)=0.5*(3-dot(dcmEst(1,:),dcmEst(1,:))) * dcmEst(1,:);
        dcmEst(2,:)=0.5*(3-dot(dcmEst(2,:),dcmEst(2,:))) * dcmEst(2,:);
        dcmEst(3,:)=0.5*(3-dot(dcmEst(3,:),dcmEst(3,:))) * dcmEst(3,:);
    else
        %ƽ����
        dcmEst(1,:)=dcmEst(1,:)/norm(dcmEst(1,:));
        dcmEst(2,:)=dcmEst(2,:)/norm(dcmEst(2,:));
        dcmEst(3,:)=dcmEst(3,:)/norm(dcmEst(3,:));
    end

    %ת��Ϊŷ����
    graf(n,1)=n*imu_interval_s;
    %graf(n,2)=atan2(dcmEst(3,2),dcmEst(3,3));      %yaw   
    %graf(n,3)=-asin(dcmEst(3,1));      %pitch               
    %graf(n,4)=atan2(dcmEst(2,1),dcmEst(1,1));      %roll
    %ʹ��matlab������[yaw, pitch, roll] = dcm2angle(dcm)
    %[graf(n,2),graf(n,3),graf(n,4)] = dcm2angle(dcmEst);
    %ʹ����Ԫ������ת��
    q = dcm2quat(dcmEst);
    [graf(n,2),graf(n,3),graf(n,4)] = quat2angle(q);
end

figure('NumberTitle', 'off', 'Name', 'Matlab��DCM������̬');
subplot(3,1,1);
%ת��Ϊ�ǶȲ���ͼ��Ϊ����ɿص��㷨�Աȣ����ȡ����
plot(graf(:,1),-graf(:,4)*(180/pi),'-g');%roll
grid on;
subplot(3,1,2);
plot(graf(:,1),-graf(:,3)*(180/pi),'-r');%pitch
grid on;
subplot(3,1,3);
plot(graf(:,1),-graf(:,2)*(180/pi),'-b');%yaw
grid on;
plot_dcm;