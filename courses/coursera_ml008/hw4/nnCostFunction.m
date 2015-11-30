function [J, grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
M = size(X, 1);

         

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


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

for m = 1:M

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

% divide by m, and add regulariztion
dJ_dTheta1 = Delta_1/m;
dJ_dTheta1(:, 2:end) = dJ_dTheta1(:, 2:end) + lambda*Theta1(:, 2:end)/m;

dJ_dTheta2 = Delta_2/m;
dJ_dTheta2(:, 2:end) = dJ_dTheta2(:, 2:end) + lambda*Theta2(:, 2:end)/m;

% Unroll gradients
grad = [dJ_dTheta1(:) ; dJ_dTheta2(:)];

end
