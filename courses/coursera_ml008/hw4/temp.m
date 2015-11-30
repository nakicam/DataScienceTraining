%% Temp

%% Initialization
clear ; close all; clc

% Setup the parameters you will use for this exercise
input_layer_size  = 400;  % 20x20 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 10;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

lambda = 1;

load('ex4data1.mat');

% Load the weights into variables Theta1 and Theta2
load('ex4weights.mat');

% Unroll parameters 
nn_params = [Theta1(:) ; Theta2(:)];

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
M = size(X, 1);
n = size(X, 2);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));



%% forward propagation
K = num_labels;

% input layer
a1 = [ones(M, 1) X]';

% hiddern layer
z2 = Theta1*a1;
a2 = sigmoid(z2);
a2 = [ones(M,1) a2']';

% output layer
z3 = Theta2*a2;
a3 = sigmoid(z3);
h = a3';

J = 0;
for k = 1:K
    h_k = h(:,k);
    y_k = y==k;
    J = J + sum(-y_k.*log(h_k) - (1-y_k).*log(1-h_k))/M;
end

% remove bias parameter
Theta1_cut = Theta1(:,2:end);
Theta2_cut = Theta2(:,2:end);
reg = lambda*(sum(Theta1_cut(:).^2)+sum(Theta2_cut(:).^2))/(2*M);

% add regularization terms
J = J + reg;


%% back propagation

Delta_1 = zeros(size(Theta1));
Delta_2 = zeros(size(Theta2));

for m = 1

    % forward prop to find z2, a2, z3, and a3 for a given example x_m
    % input layer    
    a1_m = [1; X(m,:)'];

    % hiddern layer
    z2_m = Theta1*a1_m;
    a2_m = [1; sigmoid(z2_m)];    

    % output layer
    z3_m = Theta2*a2_m;
    a3_m = sigmoid(z3_m);    
    
    % compute delta3
    % these are K x 1 arrays    
    y_k  =  reshape((1:K) == y(m), K, 1);
    delta_3k = a3_m - y_k;

    % compute delta 2    
    temp = (Theta2'*delta_3k);
    delta_2 = temp(2:end).*sigmoidGradient(z2_m);    
    
    Delta_1 = Delta_1 + delta_2*a1_m';
    Delta_2 = Delta_2 + delta_3k*a2_m';

end

% devide by m, and add regulariztion
dJ_dTheta1 = Delta_1/m;
dJ_dTheta1(:, 2:end) = dJ_dTheta1(:, 2:end) + lambda*Theta1(:, 2:end)/m;

dJ_dTheta2 = Delta_2/m;
dJ_dTheta2(:, 2:end) = dJ_dTheta2(:, 2:end) + lambda*Theta2(:, 2:end)/m;

% Unroll gradients
grad = [dJ_dTheta1(:) ; dJ_dTheta2(:)];