function [trend,peak,BDR] = BaseLine(GPSNH3,window,Percentile)

% example: 
% window = 400; Percentile = 1; % window is 4x typical "time width" of large farm plume (100 s)
% [NH3trend NH3peak] = BaseLine(NH3,window,Percentile);
% [CH4trend CH4peak] = BaseLine(CH4,window,Percentile);

windows = 1:window:length(GPSNH3);
windows = horzcat(windows,length(GPSNH3));
traffic = zeros(size(windows));
for i = 1:length(windows)-1
    pstart = windows(i);
    pend = windows(i+1)-1;
    piece = GPSNH3(pstart:pend);
   
%     temp = cov(x1,x2);
%     if length(x1) > 10
%     traffic(i) = temp(2,1)/sqrt(temp(1,1)*temp(2,2));
%     end
   
    p = prctile(piece,Percentile);
    bdr = find(piece <= p)+pstart-1;
    bdr = bdr(:);
    if i > 1
        BDR = [BDR;bdr];
    else
        BDR = bdr;
    end
end
% close 
%  plot(windows,traffic,'.')
trend = interp1(BDR,GPSNH3(BDR),(1:length(GPSNH3))');
peak = GPSNH3-trend;