function [waveaverage,vppmean]=waveread

    % Create device
    MSO5354 = visa( 'NI','USB0::0x1AB1::0x0515::MS5A243306842::INSTR' );
    MSO5354.InputBufferSize = 2048;
    % Open the device
    fopen(MSO5354);
    % fprintf(MSO5354, ':AUToscale');
    
    vppvec=[];
    wavematrix=[];

    for j=1:10    
        % Read waveform
        fprintf(MSO5354, ':WAVeform:DATA?');
        % Request data
        [data,len]= fread( MSO5354, 2048);
        
        % Inquiry X increment
        fprintf(MSO5354, ':WAVeform:XINCrement?');
        [taudata,~]= fread( MSO5354, 2048 );
        tau=str2double(char(taudata)');
            
        % Inquiry Y increment
        fprintf(MSO5354, ':WAVeform:YINCrement?');
        [Vscaledata,~]= fread( MSO5354, 2048 );
        Vscale=str2double(char(Vscaledata)');
            
        % Inquiry voltage reference line position
        fprintf(MSO5354, ':WAVeform:YREFerence?');
        [Vrefdata,~]= fread( MSO5354, 2048 );
        Vref=str2double(char(Vrefdata)');
            
        % Inquiry voltage offset
        fprintf(MSO5354, ':WAVeform:YORigin?');
        [Vbiasdata,~]= fread( MSO5354, 2048 );
        Vbias=str2double(char(Vbiasdata)');
            
        % Data analysis
        wave = data(12:len-1);
        wave = wave';
        wave=wave-Vref-Vbias;
        wave=wave.*Vscale;
        vpp=max(wave)-min(wave);
        wavematrix=[wavematrix;wave];
        vppvec=[vppvec, vpp];

    end
    
    vppmean=mean(vppvec);
    waveaverage = mean(wavematrix,1);

    % wave plot
    wavelen=length(wave);
    t=0:tau:(wavelen-1)*tau;
    plot( t,waveaverage );
    title("average wave")
        

      
    % Close RIGOL
    fclose(MSO5354);
    delete(MSO5354);
    clear MSO5354;

end