function [VMax, VMin] = GetMaxMin(V, X, Y, Z, Flag_M)
if Flag_M == 1
    if size(V, 3) == 3
        Vmin = V(:, :, 1);
        Vmax = V(:, :, 3);
    else
        Vmin = V;
        Vmax = V;
    end
    [min_col, min_index_row] = min(abs(Vmin));
    [min_min, min_index_col] = min(min_col);
    min_row_index = min_index_row(min_index_col);
    min_x = X(min_row_index, min_index_col);
    min_y = Y(min_row_index, min_index_col);
    min_z = Z(min_row_index, min_index_col);
    VMin = {num2str(min_min), num2str(min_x), num2str(min_y), num2str(min_z)};
    
    [max_col, max_index_row] = max(abs(Vmax));
    [max_max, max_index_col] = max(max_col);
    max_row_index = max_index_row(max_index_col);
    max_x = X(max_row_index, max_index_col);
    max_y = Y(max_row_index, max_index_col);
    max_z = Z(max_row_index, max_index_col);
    VMax = {num2str(max_max), num2str(max_x), num2str(max_y), num2str(max_z)};
else
    [min_min, min_index] = min(abs(V));
    min_x = X(min_index);
    min_y = Y(min_index);
    VMin = {num2str(min_min), num2str(min_x), num2str(min_y)};
    
    [max_max, max_index] = max(abs(V));
    max_x = X(max_index);
    max_y = Y(max_index);
    VMax = {num2str(max_max), num2str(max_x), num2str(max_y)};
end
end