clear;

rand_seq_len = input('Enter the length of the pseudo random binary sequence: ');
N = input('Enter the length of the window (2, 4 or 6): ');
snr = input('Enter the signal to noise ratio: ');
%snr = inf;
L = input('Enter the order of the channel: ');
Nn = input('Enter the number of QAM elements (3, 7, 15, ...): ');
Ncp = input('Enter the length of the cyclic prefix (Lcp >= L): ');

x = round(rand(1,rand_seq_len));

% add zeros to the end of the stream
x_norm = x;
if (rem(length(x),N) > 0),
    x_norm = [x zeros(1,N-rem(length(x),N))];
end
% add zeros to the end of the stream to fit a multiple of 2*(Nn+1)*N
N_t = Nn*N;
if (rem(length(x),N_t) > 0),
    x_norm = [x_norm zeros(1,N_t-rem(length(x_norm),N_t))];
end

[y_qam lut] = qam_mod(x_norm, N);

Nl = length(y_qam)/Nn;

y_pack_cut = reshape(y_qam, Nn, Nl);
y_pack = [zeros(1,Nl); y_pack_cut; zeros(1,Nl); flipud(conj(y_pack_cut))];

[y_serial y_ifft] = ofdm_mod(y_pack, Ncp);

y_n = awgn(y_serial, snr);

% coeff = use values from exercise 2-2 2-3
coeff = randn(1,L);
y_ch = filter(coeff, 1, y_n);

[y_demod_ofdm y_resh y_cut] = ofdm_demod(y_ch, Nn, Nl, Ncp);

y_demod_ofdm_cut = y_demod_ofdm(2:Nn+1,:);

ch_f_cut = y_demod_ofdm_cut./y_pack_cut;

ch_f = [zeros(1,Nl); ch_f_cut; zeros(1,Nl); flipud(conj(ch_f_cut))];

ch_f_av = sum(ch_f.').'/length(ch_f(1,:));

ch_t = real(ifft(ch_f_av));

coeff = [coeff zeros(1,length(ch_t(:,1))-length(coeff))];
subplot(2, 1, 1);
plot(coeff);
subplot(2, 1, 2);
plot(ch_t);