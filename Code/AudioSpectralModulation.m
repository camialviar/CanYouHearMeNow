% This script takes a txt file with the name of the folders that contain
% the videos. It extracts the sound waves, takes the Hilbert envelope, and 
%saves it to txt files.

function AudioSpectralModulation(dirfname)
    nmin = 4; % number of minutes per Spectral analysis
   
    fid=fopen(dirfname,'r'); l=fgetl(fid); 
    while ischar(l)
        dd=dir(sprintf('%s/*.m4a',l)); 
        %d2=dir(sprintf('%s/*.wav',l)); 
        %dd=[d1;d2];
        for i=1:length(dd)
            fname = sprintf('%s/%s',l,dd(i).name);
            disp(sprintf('loading %s...',fname));
            [w, fs] = audioread(fname); %sr = fs/ds;
            
            % compute Hilbert envelope of waveform
            %disp(sprintf('compute envelope %d of %d...',i,N));
            env = abs(hilbert(w(:,1)));
            
            %Downsample and smooth the envelope by taking the mean of
            %as many windows as needed to get the new sample rate. Here is
            %25 windows per each 11000 data points.
            c=1;
            for cp = 1:1280:(length(env)-1279)
                win =env(cp:cp+1279);
                dw(c)=mean(win);
                c=c+1;
            end    
            
            sr=25;
            dws = sr*60*nmin;
        
            %Record the downsampled wave form
             
            fileID=fopen(sprintf('Env%s.txt',dd(i).name), 'w');
            fprintf(fileID, '% d', dw);
            fclose(fileID);
            
            %if length(dw) < dws
            %    dws = length(dw);
            %end
            %[lfs,lps] = HilbertSpectralModulation(dw,dws);
            %fst(i,:)=lfs; pst(i,:)=lps; 
        end
        clear d1 d2 lfs lps dw w cp c env win;
        %save(sprintf('%s/specmod4minOriginalSampleRate.mat',l)); 
        %clear fst pst;
        l=fgetl(fid);
    end
    fclose(fid);
end
