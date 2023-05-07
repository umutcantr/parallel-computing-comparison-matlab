% Author: Umutcan Genç
% Apply gaussian filter sequentially and parallel. Compare execution time
% of these two function.


% main function for finding execution time of sequential and parallel
% processing of given image
function test_parfor()
    % read input image
    img = imread('sevilla.jpg');

    % convert image to grayscale
    gray_img = im2gray(img);

    % apply Gaussian filter sequentially and measure execution time
    tic;
    filtered_seq = apply_gaussian_filter_sequential(img);
    time_seq = toc;
    
    % apply Gaussian filter in parallel and measure execution time
    tic;
    filtered_par = apply_gaussian_filter_parallel(img);
    time_par = toc;
    
    % display original and filtered images
    figure;

    subplot(1,3,1); imshow(img); title('Original Image');
    subplot(1,3,2); imshow(filtered_seq); title(['Sequential Filtered (', num2str(time_seq), ' s)']);
    subplot(1,3,3); imshow(filtered_par); title(['Parallel Filtered (', num2str(time_par), ' s)']);
    
    % get the current number of workers/cores
    poolobj = gcp("nocreate");  
    num_workers = poolobj.NumWorkers;

    % display number of cores and Tpar efficiency
    sgtitle(sprintf('Number of parallel cores: %d\nTpar efficiency is: %.2f ', num_workers, time_seq / time_par));
end

% apply gaussian filter using parallel for loops to image
function filtered_img = apply_gaussian_filter_parallel(img)
    % define Gaussian kernel
    kernel = fspecial('gaussian', [7 7], 0.2);

    % get size of image
    [rows, cols] = size(img);

    % preallocate filtered image
    filtered_img = zeros(rows, cols);

    % apply Gaussian filter using parfor loop
    parfor i = 4:rows-3
        temp_filtered = zeros(1, cols);
        for j = 4:cols-3
            % apply kernel to pixel neighborhood
            pixel_vals = img(i-3:i+3, j-3:j+3);
            filtered_pixel = sum(sum(kernel .* double(pixel_vals)));
            temp_filtered(j) = filtered_pixel;
        end
        filtered_img(i,:) = temp_filtered;
    end
end

% apply gaussian filter using sequential for loops to image
function filtered_img = apply_gaussian_filter_sequential(img)
    % define Gaussian kernel
    kernel = fspecial('gaussian', [7 7], 0.2);

    % get size of image
    [rows, cols] = size(img);

    % preallocate filtered image
    filtered_img = zeros(rows, cols);

    % apply Gaussian filter using nested for loop
    for i = 4:rows-3
        for j = 4:cols-3
            % apply kernel to pixel neighborhood
            pixel_vals = img(i-3:i+3, j-3:j+3);
            filtered_pixel = sum(sum(kernel .* double(pixel_vals)));
            filtered_img(i, j) = filtered_pixel;
        end
    end
end



