function H = Hardness_3D(S, theta, phi)
B = Bulk_3D(S, theta, phi);
E = Young_3D(S, theta, phi);
H = Hardness(E, B);
end