# 	pre_process_PACMAN_PIF performs a set of initial checks on the
#   raw data from a PACMAN unit generating a CLEAN_PACMAN output file
# 	
# 	raw_file_path =	FULL path for the folder where the RAW file(s) are [STRING]
# 	start_Fname =	Start DATE for the files to be processed (YYYYMMDD) [INTEGER]
# 	end_Fname =	End DATE for the files to be processed (YYYYMMDD)
# 			Needs to be EQUAL OR LARGER than start_Fname [INTEGER]
# 	ou_suffix =	TEXT added to the output filenames to identify specific experiments.
# 	out_file_path =	FULL path for the OUTPUT file. Note that the images
# 			will be saved in the same path and with similar names. [STRING]
#
# 	This function is in the public domain. Gustavo Olivares.

function status=pre_process(raw_file_path,start_Fname,end_Fname,ou_suffix,out_file_path)
%% Read PACMAN file and plot
page_screen_output(0);
page_output_immediately(1);
%% Which file to work with
work_dir=raw_file_path;
#File indices to work with
start_idx=start_Fname
end_idx=end_Fname
#Output file name ... in the same working directory
out_file_path
ou_file=[num2str(start_idx,'%d') '_' ou_suffix '.txt']
fid_ou=fopen([out_file_path ou_file],'w');
headers={'Octave_time', ...
'Count', ...
'Year', ...
'Month', ...
'Day', ...
'Hour', ...
'Minute', ...
'Second', ...
'Distance', ...
'Temperature_mV', ...
'Temperature_IN_C', ...
'PM_mV', ...
'CO2_mV', ...
'CO_mV', ...
'Movement', ...
'COstatus', ...
'COvalid'};
fmt_hrd='';
for xi=1:16
  fmt_hrd=[fmt_hrd '%s\t'];
end
fmt_hrd=[fmt_hrd '%s\n'];
fprintf(fid_ou,fmt_hrd,headers{:})
#Vector to pad the data output when invalid records are found
pad_vec=[NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
d_vec=zeros(1,15);
first_date=1;
COstatus_prev=2;
CO=0;
for f_idx=start_idx:end_idx
  in_file=[num2str(f_idx,'%d') '.TXT'];
  printf('\n\n%s\n',in_file);
  [nfo err1 msg1]=stat([work_dir in_file]);
  #Check that the file actually has some data in
  # minimum file size restriction
  if nfo.size>1000
    #Open file and process
    fid_in=fopen([work_dir in_file],'r');
    while ~feof(fid_in)
      strin=fgetl(fid_in);
      if length(strin)<10
      	strin(1)='C';
      end
      if strin(1)~='C'
        while (1==1)
          p_d_vec=d_vec;
          d_vec=sscanf(strin,'%f')';
          %establish error condition
          % 1==OK; 0==ERROR
          %Number of elements in the record must be 15 
          OK_nelements=length(d_vec)==15;
          %Valid date
          if OK_nelements
            % (catching error 165 from the RTC)
            % year must be above 1000
            OK_RTC=d_vec(2)>1000;
            %repeated records
            if first_date
              first_date=0;
              OK_same_record=1;
              curr_date_num=datenum(d_vec(2:7));
              curr_d_vec=d_vec(2:7);
            else
              OK_same_record=~(all(p_d_vec(2:7)==d_vec(2:7));
            end
            if ~OK_same_record
              printf('%s\t%s\n','Repeated',datestr(datenum(d_vec(2:7)),0));
            end
          else
	        d_vec=p_d_vec;
	      end
          if and(OK_nelements,OK_RTC,OK_same_record)
            % if all error checks pass, then leave this loop and put the
            % record to the output file
            break;
          else
            strin=fgetl(fid_in);
          end        
      end
        COstatus_curr=d_vec(end);
        if and(COstatus_curr==1,COstatus_prev==2)
          % flag the record as CO valid
          CO=1;
        else
          % flag the record as CO invalid
	      CO=0;
        end
        next_date_num=datenum(d_vec(2:7));
        while next_date_num>curr_date_num
          % Fill missing records
          printf('%s\t%s\n','GAP ',datestr(datenum(d_vec(2:7)),0));
          fprintf(fid_ou,'%.8f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',[curr_date_num pad_vec]);
          curr_d_vec=curr_d_vec+[0 0 0 0 0 1];
          curr_date_num=datenum(curr_d_vec);
          CO=0;
        end
        fprintf(fid_ou,'%.8f\t%s\t%f\n',curr_date_num,strin,CO);
        COstatus_prev=COstatus_curr;
        curr_d_vec=curr_d_vec+[0 0 0 0 0 1];
        curr_date_num=datenum(curr_d_vec);
      end
    end
    fclose(fid_in);
  end
end
fclose(fid_ou);
