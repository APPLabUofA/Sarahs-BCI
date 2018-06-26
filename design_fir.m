% design an FIR filter using the frequency-sampling method
function B = design_fir(N,F,A,nfft,W,odd)
    if nargin < 4 || isempty(nfft)
        nfft = max(512,2^ceil(log(N)/log(2))); end
    if nargin < 5
        W = 0.54 - 0.46*cos(2*pi*(0:N)/N); end
    if nargin < 6
        odd = false; end
    % calculate interpolated frequency response
    F = interp1(round(F*nfft),A,(0:nfft),'pchip');
    % set phase & transform into time domain
    F = F .* exp(-(0.5*N)*sqrt(-1)*pi*(0:nfft)./nfft);
    if odd 
        F = F.*(-i); end %#ok<IJCL>
    B = real(ifft([F conj(F(end-1:-1:2))]));
    % apply window to kernel
    B = B(1:N+1).*W(:)';
end