clc, clear

step=40;    % Total number of steps for motor movement
L1=10;      % Length of sound field in mm
L2=10;      % Width of sound field in mm
round=step+1;
vppmeanvec2=[];
waveaveragematrix2=[];
vppfordrawing2=zeros(1,round*round);
for k=1:round

    [waveaverage,vppmean]=waveread;
    vppmeanvec2=[vppmeanvec2, vppmean];
    waveaveragematrix2=[waveaveragematrix2;waveaverage];
    vppfordrawing2(1:length(vppmeanvec2))=vppmeanvec2;
    vppmatrix2=reshape(vppfordrawing2,round,round).';
    imagesc(vppmatrix2)
    axis equal

    xmax = size(vppmatrix2,2);  
    ymax = size(vppmatrix2,1);
    axis([1 xmax 1 ymax])
    set(gca, 'XAxisLocation', 'top')
        
   
    for i=(k*round-step+1):k*round      

        % X CW
        s = serialport("COM4",115200);
        num3 = ['03'; 'FD';...      
        '00';...                    
        '05'; 'DC';...              
        '01';...                    
        '00'; '00'; '00'; 'a0';...  
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
        vppmeanvec2=[vppmeanvec2, vppmean];
        waveaveragematrix2=[waveaveragematrix2;waveaverage];
        vppfordrawing2(1:length(vppmeanvec2))=vppmeanvec2;
        vppmatrix2=reshape(vppfordrawing2,round,round).';
        imagesc(vppmatrix2)
        axis equal
    
        xmax = size(vppmatrix2,2);  
        ymax = size(vppmatrix2,1);
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

    % Z CCW
    s = serialport("COM4",115200);
    num4 = ['04'; 'FD';...     
    '01';...                   
    '05'; 'DC';...              
    '01';...                    
    '00'; '00'; '00'; 'a0';...  
    '00'; ...                   
    '00';...                    
    '6B';];                    
    num4=hex2dec(num4);        
    fwrite(s,num4)
    data=fread(s,4);
    data=data';
    hexStr=compose("%X", data); 
    delete(s);                  
    pause(1);
    
end

apmatrix2=vppmatrix2/0.4;
x=0:0.1:L1;
y=0:0.1:L2;
imagesc(x,y,apmatrix2)
axis equal
axis([0 max(x) 0 max(y)])
xticks(1:1:L1);  
yticks(1:1:L2);
set(gca, 'XAxisLocation', 'top')
h=colorbar;
h.Label.String = 'acoustic pressure(MPa)';

save('vppvec.mat','vppfordrawing2')
save('vppmatrix.mat','vppmatrix2')
save('apmatrix.mat','apmatrix2')
save('wave.mat','waveaveragematrix2')
