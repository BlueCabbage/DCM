%ATT���ݸ�ʽΪ��{'LineNo';'TimeUS';'DesRoll';'Roll';'DesPitch';'Pitch';'DesYaw';'Yaw';'ErrRP';'ErrYaw'}
%IMU���ݸ�ʽΪ��{'LineNo';'TimeUS';'GyrX';'GyrY';'GyrZ';'AccX';'AccY';'AccZ';'ErrG';'ErrA';'Temp';'GyHlt';'AcHlt'}
%AHR2���ݸ�ʽΪ��{'LineNo';'TimeUS';'Roll';'Pitch';'Yaw';'Alt';'Lat';'Lng'}
%MAG���ݸ�ʽΪ��{'LineNo';'TimeUS';'MagX';'MagY';'MagZ';'OfsX';'OfsY';'OfsZ';'MOfsX';'MOfsY';'MOfsZ';'Health'}
%����ATTΪEKF������̬��AHR2ΪDCM������̬
figure('NumberTitle', 'off', 'Name', '�ɿض�DCM������̬');
subplot(3,1,1);
plot(AHR2(:,2),AHR2(:,3),'-g');%Roll        %��ӡDCM��̬��,����AHR2(:,2)��ΪTimeUS����������
title('Roll');
xlabel('Time/s');
ylabel('Angle/deg');
grid on;
subplot(3,1,2);
plot(AHR2(:,2),AHR2(:,4),'-r');%Pitch
title('Pitch');
xlabel('Time/s');
ylabel('Angle/deg');
grid on;
subplot(3,1,3);
plot(AHR2(:,2),AHR2(:,5),'-b');%Yaw
title('Yaw');
xlabel('Time/s');
ylabel('Angle/deg');
grid on;