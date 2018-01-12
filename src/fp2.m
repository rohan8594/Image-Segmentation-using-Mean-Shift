%Load and resize image to 64x64
lena = imresize(imread('Segmentation_Data/Lena.bmp'), 0.125);
lena = imcrop(lena,[0 0 40 40]); %crop image to reduce computation time
h1 = figure;
colormap('gray');
imagesc(lena)
title('Original Image')

%Vectorize image
vectorized_im = lena(:);
I_length = length(vectorized_im);
h = 4; %bandwidth
max_iterations = 8; %max iteration = 10
J = zeros(I_length, 1);
gaussian = zeros(I_length, 1); 
numerator_results = zeros(I_length, 1);

%main loop
for i=1:I_length

   y = vectorized_im(i);
   
   for k=1:max_iterations
     for j=1:I_length
       exp_arg = -(norm(double(y - vectorized_im(j))) ^ 2) / (h ^ 2); %gaussian kernel
       gaussian(j) = exp(exp_arg);
     end
     
     for j=1:I_length
       numerator_results(j) = (vectorized_im(j) * gaussian(j));
     end
     numerator = sum(numerator_results);
     denominator = sum(gaussian);       
     y = numerator / denominator;
   end
   
   J(i) = y; %filtered image
   
end

%Display output image
h2 = figure;
colormap('gray');
result = reshape(J, [40, 40]);
imagesc(result)
title('Segmented Image')