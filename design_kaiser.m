% design a Kaiser window for a low-pass FIR filter
function W = design_kaiser(lo,hi,atten,odd)
    % determine beta parameter of the window
    if atten < 21
        beta = 0;
    elseif atten <= 50
        beta = 0.5842*(atten-21).^0.4 + 0.07886*(atten-21);
    else
        beta = 0.1102*(atten-8.7);
    end
    % determine the number of points
    N = round((atten-7.95)/(2*pi*2.285*(hi-lo)))+1;
    if odd && ~mod(N,2)
        N = N+1; end
    % design the window
    W = besseli(0,beta*sqrt(1-(2*((0:(N-1))/(N-1))-1).^2))/besseli(0,beta);
