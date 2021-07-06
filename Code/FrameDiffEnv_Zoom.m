%This function takes a txt file with the name of the folder where the videos
% are. It loads each video and performs frame differencing on two halves of
%a video and saves the resulting amplitude envelopes in the folder where
%the function is.

function FrameDiff(dirfname)
    % open the file that lists all the directories containing video files to be analyzed
    fid=fopen(dirfname,'r'); l=fgetl(fid); 
    % read each directory name one line at time
    while ischar(l)
        % read all the video files and list them in the structure dd
        d1=dir(sprintf('%s/*.mp4',l)); 
        %d2=dir(sprintf('%s/*.m4v',l)); 
        dd=d1; %[d1;d2];
        % read and process each video file one at a time
        for a=1:length(dd)
            fname = sprintf('%s/%s',l,dd(a).name);
            disp(sprintf('loading %s...',fname));
            v=VideoReader(fname);
            pxr= px(181:540,640:1280,:); % This changes the size of the square for the right side
            pxl= px(181:540,1:639,:);  % This changes the size of the square for the left side
                                   % The first argument is the rows, the
                                   % second, is the columns, and the third
                                   % is the third dimension.
                                   % The command to look at the image is
                                   % image(pxl) or image(pxr)
                                   %The specific coordinates might vary
                                   %depending on the video, but the size of
                                   %the squares should be kept the same.

            while v.hasFrame==1 %Read all the frames one by one.
                xr=x(181:540,640:1280,:);
                xl=x(181:540,1:639,:);
                dr(f)=sum(sum(sum(abs(xr-pxr))));%Subtract the current frame from the previous one, and sum the movement.
                dl(f)=sum(sum(sum(abs(xl-pxl))));
                f = f + 1;
                pxr=xr;
                pxl=xl;
            end

             %Record the optical flow analysis
             
            fileID=fopen(sprintf('OFR%s.txt',dd(a).name), 'w');
            fprintf(fileID, '% d', dr);
            fclose(fileID);
            
            fileID=fopen(sprintf('OFL%s.txt',dd(a).name), 'w');
            fprintf(fileID, '% d', dl);
            fclose(fileID);
            
            clear dl dr;
    
        end
        
        clear d1 d2;
        l=fgetl(fid);
    end
    fclose(fid);
end
