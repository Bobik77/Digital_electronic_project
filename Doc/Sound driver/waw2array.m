[y,Fs] = audioread("bump.wav");
maximal = max(y);
normalised = y ./ maximal;
y_int = round(normalised.*127 + 127);
output_data = y_int(:,1)

fid = fopen( 'sound_string.txt', 'wt' );
for n = 1:size(output_data+1)
  fprintf( fid, '%g,', output_data(n,1));
  
  if mod(n,50) == 0
      fprintf( fid, '\n');
  end
end
fclose(fid);