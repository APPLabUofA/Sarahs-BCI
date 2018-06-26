function B = design_bandpass(freqs,srate,atten,minphase)
% Design a bandpass filter
%   freq : Frequency filter. The parameters of a bandpass filter 
%           [raise-start,raise-stop,fall-start,fall-stop], e.g., [7 8 14 15]
%           for a filter with 8-14 Hz pass-band and 1 Hz transition bandwidth 
%           between passband and stop-bands; if given as a single scalar, a 
%           moving-average filter is designed (legacy option).
%   srate:  Sampling rate

    % get frequencies and amplitudes
    freqs = min(freqs*2/srate,0.95);
    % design Kaiser window for smallest transition band
    [dummy,pos] = min(diff(freqs)); %#ok<ASGLU>
    wnd = design_kaiser(freqs(pos),freqs(pos+1),atten,false);
    % design FIR filter with that window
    B = design_fir(length(wnd)-1,[0 freqs 1],[0 0 1 1 0 0],[],wnd);
    % transform to minimum-phase design
    if minphase
        n = length(B);
        wnd = [1 2*ones(1,(n+mod(n,2))/2-1) ones(1,1-mod(n,2)) zeros(1,(n+mod(n,2))/2-1)];
        B = real(ifft(exp(fft(wnd.*real(ifft(log(abs(fft(B))+10^(-atten/10))))))));
    end
end