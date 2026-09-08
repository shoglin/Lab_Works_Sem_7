W1 = tf(0.0067, [1 0])
W2 = 21;
W3 = tf(14, [0.15 1]);
W4 = 36;
W5 = 59;
W6 = tf(1, [1 0]);

W12 = feedback(W1, W2, -1);
W123 = series(W3, W12);
W1234 = feedback(W123, W4, -1);
W123456 = series(W5, W1234, W6);
W7 = feedback(W123456, 1, -1)

