clc, clear

step=40;    % Total number of steps for motor movement
L1=10;      % Length of sound field in mm
L2=10;      % Width of sound field in mm
round=step+1;
vppmeanvec1=[];
waveaveragematrix1=[];
vppfordrawing1=zeros(1,round*round);
for k=1:round

    [waveaverage,vppmean]=waveread;
    vppmeanvec1=[vppmeanvec1, vppmean];
    waveaveragematrix1=[waveaveragematrix1;waveaverage];
    vppfordrawing1(1:length(vppmeanvec1))=vppmeanvec1;
    vppmatrix1=reshape(vppfordrawing1,round,round).';
    imagesc(vppmatrix1)
    axis equal

    xmax = size(vppmatrix1,2);  
    ymax = size(vppmatrix1,1);
    axis([1 xmax 1 ymax])
    set(gca, 'XAxisLocation', 'top')
        
   
    for i=(k*round-step+1):k*round      

        % X CW
        s = serialport("COM4",115200);
        num3 = ['03'; 'FD';...      % Address
        '00';...                    % Direction: 00 means CW to the right, 01 means CCW to the left.
        '05'; 'DC';...              
        '01';...                    
        '00'; '00'; '00'; 'a0';...  % The number of pulses, 0c80 is 3200 pulses, and the motor moves 5 mm. Please convert others as required.
        '00'; ...                   
        '00';...                    
        '6B';];                     
        num3=hex2dec(num3);         
        fwrite(s,num3)
        data=fread(s,4);
        data=data';
        hexStr=compose("%X", data); 
        delete(s);                  
        
        [waveaverage,vppmean]=waveread;
        vppmeanvec1=[vppmeanvec1, vppmean];
        waveaveragematrix1=[waveaveragematrix1;waveaverage];
        vppfordrawing1(1:length(vppmeanvec1))=vppmeanvec1;
        vppmatrix1=reshape(vppfordrawing1,round,round).';
        imagesc(vppmatrix1)
        axis equal
    
        xmax = size(vppmatrix1,2);  
        ymax = size(vppmatrix1,1);
        axis([1 xmax 1 ymax])
        set(gca, 'XAxisLocation', 'top')

    end

    % X CCW     
        s = serialport("COM4",115200);
        num3 = ['03'; 'FD';...      
        '01';...                    
        '05'; 'DC';...              
        '01';...                    
        '00'; '00'; '19'; '00';...  
        '00'; ...                   
        '00';...                    
        '6B';];                     
        num3=hex2dec(num3);        
        fwrite(s,num3)
        data=fread(s,4);
        data=data';
        hexStr=compose("%X", data); 
        delete(s);                  

    % Y CW
    s = serialport("COM4",115200);
    num1 = ['01'; 'FD';...      
    '00';...                    
    '05'; 'DC';...              
    '01';...                    
    '00'; '00'; '00'; 'a0';...  
    '00'; ...                   
    '01';...                    
    '6B';];                    
    num1=hex2dec(num1);         
    fwrite(s,num1)
    data=fread(s,4);
    data=data';
    hexStr=compose("%X", data); 
    delete(s)                   
    
    s = serialport("COM4",115200);
    num2 = ['02'; 'FD';...      
    '00';...                    
    '05'; 'DC';...              
    '01';...                    
    '00'; '00'; '00'; 'a0';...  
    '00'; ...                   
    '01';...                    
    '6B';];                     
    num2=hex2dec(num2);         
    fwrite(s,num2)
    data=fread(s,4);
    data=data';
    hexStr=compose("%X", data); 
    delete(s);                  
    
    s = serialport("COM4",115200);
    run=['00'; 'FF'; '66'; '6B'];
    run=hex2dec(run);           
    fwrite(s,run)
    data=fread(s,4);
    data=data';
    hexStr=compose("%X", data); 
    delete(s);                  
    pause(1);
    
end

apmatrix1=vppmatrix1/0.4;
x=0:0.1:L1;
y=0:0.1:L2;
imagesc(x,y,apmatrix1)
axis equal
axis([0 max(x) 0 max(y)])
xticks(1:1:L1);  
yticks(1:1:L2);
set(gca, 'XAxisLocation', 'top')
h=colorbar;
h.Label.String = 'acoustic pressure(MPa)';

save('vppvec.mat','vppfordrawing1')
save('vppmatrix.mat','vppmatrix1')
save('apmatrix.mat','apmatrix1')
save('wave.mat','waveaveragematrix1')