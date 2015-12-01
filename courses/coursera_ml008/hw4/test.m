lambda = 0
input_layer_size = 3
hidden_layer_size = 5
num_labels = 3
m = 5

Theta1 = debugInitializeWeights(hidden_layer_size, input_layer_size)
% Theta1 = randomInitializeWeights(hidden_layer_size, input_layer_size)
size(Theta1);

Theta2 = debugInitializeWeights(num_labels, hidden_layer_size)
% Theta2 = randomInitializeWeights(num_labels, hidden_layer_size)
size(Theta2)

X = debugInitializeWeights(m, input_layer_size - 1)
size(X)

y = 1 + mod(1:m, num_labels)'
size(y)

% Unroll parameters
nn_params = [Theta1(:) ; Theta2(:)];
size(nn_params)

% Short hand for cost function
costFunc = @(p) nnCostFunction(p, input_layer_size, hidden_layer_size, num_labels, X, y, lambda);

[cost, grad] = costFunc(nn_params);
% numgrad = computeNumericalGradient(costFunc, nn_params);

cost
grad
