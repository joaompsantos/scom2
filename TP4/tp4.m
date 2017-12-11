%% Ex 2.1
clc; clear; close all;
 
% '0' and '1' Probability
p = 0.5;

% Codes To Simulate
codes= {'hamming',15,11;
        'cyclic',15,7;
        'cyclic',31,16}

% Ask User Input
idx = input('Select Line Of Desired Coder: ');
assert(idx>0 && idx <= length(codes))    

% Code Efficincy
r = codes{idx,3}/codes{idx,2};

% Number of Bits In Each Segment Simulation
Nbits = codes{idx,3}*10e3;

% SNR Values to simulate
snrs = 3:0.5:8;
pe = qfunc(sqrt(2*r*10.^(snrs./10)));

% Minimum error
mine = 50;

% Maximum Bit Count
maxb = 1e6;

% Post Decoder Error Probability
pe_rx=[];
tic
for i=1:length(pe)
    % Total Bit Counter
    bitt = 0;

    % Total Error Counter
    errt = 0;
    fprintf('SNR = %4.2f\n',snrs(i));
    while((errt < mine) && (bitt<maxb))
        % Binary Sequence to Encode
        d = randsrc(1,Nbits,[0 1;(1-p) p]);
        bitt = bitt + Nbits;
        
        % Encode Data
        enc = encode(d,codes{idx,2},codes{idx,3},codes{idx,1});
        fprintf('Done Encoding\n');
        % AWGN Generation
        e = randsrc(1,length(enc),[0 1; (1-pe(i)) pe(i)]);
        
        % Received Signal
        rx = mod(enc+e,2);
        
        % Decode Received
        dec = decode(rx,codes{idx,2},codes{idx,3},codes{idx,1});
        fprintf('Done Decoding\n');
        
        errt = errt + biterr(d,dec(1:Nbits));
        fprintf('Errt = %d\n BitT = %d\n', errt, bitt);
        
    end
    pe_rx = [pe_rx errt/bitt];
    
end
time = toc

pe_t = qfunc(sqrt(2*10.^(snrs./10)));

figure
semilogy(snrs,pe_t,'-o',snrs,pe,'-o',snrs,pe_rx,'-o')
title(sprintf('Type: %s N= %d K=%d',codes{idx,1},codes{idx,2},codes{idx,3}))
xlabel('Eb/no');
ylabel('Pe');
grid on
legend('Sem Codificação',sprintf('%s(%d,%d) Theoretical',codes{idx,1},codes{idx,2},codes{idx,3}),sprintf('%s(%d,%d) Experimental',codes{idx,1},codes{idx,2},codes{idx,3}))



