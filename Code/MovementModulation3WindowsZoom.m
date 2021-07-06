%This function takes a folder of txt file of movement amplitudes or sound amplitudes
%and runs spectral analysis on the time series. It returns a matrix with the power 
%spectrum for each file.

function FrameDiff(dirfname)
    % open the file that lists all the directories containing video files to be analyzed
    fid=fopen(dirfname,'r'); l=fgetl(fid); 
    % read each directory name one line at time
    while ischar(l)
        % read all the video files and list them in the structure dd
        d1=dir(sprintf('%s/*.txt',l));
        dd=d1;
        % read and process each video file one at a time
        for a=1:length(dd)
            fname = sprintf('%s/%s',l,dd(a).name);
            disp(sprintf('loading %s...',fname));
            dw = dlmread(fname);
            
             %calculate the fourmin
             fourmin=4*60*25;
             dwl=floor(length(dw)/3);
             
            for t=1:3
                dwp=dw(((dwl*t)-dwl)+1:dwl*t);
                %Here starts the spectral analysis part.
                %If the video is not longer than 47 seconds make fourmin the
                %length of d so that the next for loop works.

                if length(dwp) < fourmin
                    fourmin = length(dwp);
                end

                %If the video is longer than 4 min break it up in parts and
                %get the mean

                N=ceil(length(dwp)/fourmin);
                for s=1:N
                    if s==N
                        data=dwp((end-fourmin)+1:end);
                    else
                        data= dwp((s-1)*fourmin+1:s*fourmin);
                    end
                    [lfs(:,s),lps(:,s)]=specanal(data'); %This line calls the spectral analyses function.
                end
                if t==1
                    if N>1 % Here we take the mean power for all windows if there was more than one.
                        fst1(a,:)=mean(lfs');
                        pst1(a,:)=mean(lps');
                    else
                        fst1(a,:)=lfs';
                        pst1(a,:)=lps';
                    end
                elseif t==2
                    if N>1 % Here we take the mean power for all windows if there was more than one.
                        fst2(a,:)=mean(lfs');
                        pst2(a,:)=mean(lps');
                    else
                        fst2(a,:)=lfs';
                        pst2(a,:)=lps';
                    end
                else
                    if N>1 % Here we take the mean power for all windows if there was more than one.
                        fst3(a,:)=mean(lfs');
                        pst3(a,:)=mean(lps');
                    else
                        fst3(a,:)=lfs';
                        pst3(a,:)=lps';
                    end
                end
                clear dwp lfs lps data N;
            end
            clear dw;
        end
        
        save(sprintf('%s/SpecAnal3Win%s.mat',l,dd(a).name)); %Here we save the file. We only really care about lspl, lspr, pspl and pspr
        clear d1 d2 fourmin;
        l=fgetl(fid);
    end
    fclose(fid);
end
