function H = Hardness_4D(S, theta, phi, chi)
B = Bulk_3D(S, theta, phi);
G = Shear_4D(S, theta, phi, chi);
H = Hardness(G, B);
end