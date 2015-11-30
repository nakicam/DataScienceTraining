input_layer_size = 3;
hidden_layer_size = 5;
num_labels = 3;
m = 5;
y  = 1 + mod(1:m, num_labels)';
Theta1 = debugInitializeWeights(hidden_layer_size, input_layer_size);
Theta2 = debugInitializeWeights(num_labels, hidden_layer_size);

% Reusing debugInitializeWeights to generate X
X  = debugInitializeWeights(m, input_layer_size - 1);
Theta1
Theta2
X
y
