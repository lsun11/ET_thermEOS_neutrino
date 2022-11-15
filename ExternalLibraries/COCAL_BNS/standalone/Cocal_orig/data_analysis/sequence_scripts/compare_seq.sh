# Extract angular momentum j_adm data
cut -b 85-100 Hs2.5d_APR1 > seq0
cut -b 85-100 spHs2.5d_APR1_w0.05_A6.txt > seq1

paste seq0 seq1 > seq01
