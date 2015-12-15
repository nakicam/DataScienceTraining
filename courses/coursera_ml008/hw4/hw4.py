import itertools as it
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats as st
import scipy.misc
import scipy.optimize as op
import scipy.io
import random

# set path
import os
os.chdir('%s/courses/coursera_ml008/hw4' % os.getenv('DST'))
print(os.getcwd())

# printing options 
np.set_printoptions(linewidth=250)
np.set_printoptions(precision=5)

# plotting options
plt.rc('font'  , size=18)
plt.rc('figure', figsize=(10, 8))
plt.rc('axes'  , labelsize=22)
plt.rc('legend', fontsize=16)
plt.rc('figure', figsize=(10, 8))

# ------------------------------------------------------------ #
# helper functions
# ------------------------------------------------------------ #

def g(z):
    return 1.0/(1 + np.exp(-z))

def g_prime(z):
    g_z = g(z)
    return np.multiply(g_z,(1-g_z))

def h(theta, X):
    X     = np.asmatrix(X)
    theta = np.asmatrix(theta)
    z     = X*theta.T
    return g(z)

def h_nn(theta1, theta2, X, shift_idx=True):
    m, n = X.shape
    
    # layer 1
    a1 = np.concatenate((np.ones((m,1)), X), axis=1)
    
    # layer 2
    a2 = h(theta1, a1)
    
    # layer 3
    a2 = np.concatenate((np.ones((m,1)), a2), axis=1)
    a3 = h(theta2, a2)
    
    # shift index due to thetas being 
    # trained by octave convention
    if shift_idx:
        a3 = np.roll(a3, shift=1, axis=1)
    
    # probability
    return np.asarray(a3)

def cost_nn(theta1, theta2, X, y, K=10, lambda_param=0.0):
    m, n     = X.shape
    h_value  = h_nn(theta1, theta2, X)
    y        = np.asarray(y)
    J        = (1.0/m)*np.sum(-y*np.log(h_value) - (1-y)*np.log(1-h_value))
    J       += (lambda_param/(2*m))*(np.sum(theta1[...,1:]**2) + np.sum(theta2[...,1:]**2))
    return J

def rand_initialize_weights(L_in, L_out, seed=1):
    np.random.seed(seed)
    eps    = np.sqrt(6.0/float(L_in + L_out))
    result = np.random.rand(L_out, L_in+1)*2*eps - eps
    return result

def forward_propagate(theta1, theta2, X):
    a_1 = prepend_ones(X)
    z_2 = a_1*theta1.T
    a_2 = h(theta1, a_1)
    a_2 = np.asmatrix(a_2)
    a_2 = prepend_ones(a_2)
    z_3 = a_2*theta2.T
    a_3 = g(z3)
    return a1, a2, a3, z2, z3

def grad_nn(theta1, theta2, X, y, K, lambda_param=0.0):  
    m, n   = X.shape
    theta1 = np.asmatrix(theta1)
    theta2 = np.asmatrix(theta2)

    def prepend_ones(a):
        return np.roll(np.concatenate([a, np.asmatrix(np.ones((1,1)))], axis=1), shift=1)

    # forward propagate
    a1, a2, a3, z2, z3 = forward_propagate(theta1, theta2, X)
    
    # back propagate
    assert y_vec.shape==a3.shape, "shape of y_vec and a3 is different"
    sigma3 = a3 - y_vec
    sigma2 = sigma3*theta2.T * g_prime(prepend_ones(z2)) 
    sigma2 = sigma2[1:,:] 
    accum1 = sigma2.dot(a1.T)/float(m)
    accum2 = sigma3.dot(a2.T)/float(m)
    accum1[:,1:] = accum1[:,1:] + (theta1[:,1:] * lamda / m)
    accum2[:,1:] = accum2[:,1:] + (theta2[:,1:] * lamda / m)
    return accum1, accum2

# def grad_nn(theta1, theta2, X, y, K, lambda_param=0.0):  
# 
#     m, n   = X.shape
#     theta1 = np.asmatrix(theta1)
#     theta2 = np.asmatrix(theta2)
# 
#     def prepend_ones(a):
#         return np.roll(np.concatenate([a, np.asmatrix(np.ones((1,1)))], axis=1), shift=1)
#             
#     Delta_1 = np.zeros_like(theta1)
#     Delta_2 = np.zeros_like(theta2)
#     
#     for t in np.arange(m):
#         x_t = np.asmatrix(X[t])
#         y_t = np.asmatrix(y[t])
#         
#         #--------------------------------- #
#         # step 1: forward propagation
#         #--------------------------------- #
#         
#         # layer 1
#         a_1 = prepend_ones(x_t)
#         
#         # layer 2
#         z_2 = a_1*theta1.T
#         a_2 = h(theta1, a_1)
#         a_2 = np.asmatrix(a_2)
#         a_2 = prepend_ones(a_2)
#         
#                 
#         # layer 3
#         #z_3 = a_2*theta2.T
#         a_3 = h(theta2, a_2)
#         a_3 = np.asmatrix(a_3)
#                 
#         #--------------------------------- #
#         # step 2: compute delta3
#         #--------------------------------- #
#         
#         delta_3 = a_3 - y_t
#         
#         #--------------------------------- #
#         # step 3: compute delta2
#         #--------------------------------- #
#         
#         delta_2 = np.multiply((delta_3*theta2)[...,1:], g_prime(z_2))
#         
#         #--------------------------------- #
#         # step 4: compute Delta
#         #--------------------------------- #
#         
#         Delta_1 = Delta_1 + delta_2.T*a_1
#         Delta_2 = Delta_2 + delta_3.T*a_2
# 
#     #--------------------------------- #
#     # step 5: compute Grad_J
#     #--------------------------------- #
#     
#     grad_J_1 = Delta_1/float(m)
#     grad_J_2 = Delta_2/float(m)
#     
#     #--------------------------------- #
#     # step 6: regularization
#     #--------------------------------- #
#     
#     grad_J_1[...,1:] += lambda_param*theta1[...,1:]/float(m)
#     grad_J_2[...,1:] += lambda_param*theta2[...,1:]/float(m)
#     
#     return grad_J_1, grad_J_2

def roll_params(theta1, theta2):
    theta1 = np.asarray(theta1)
    theta2 = np.asarray(theta2)
    return np.concatenate([theta1.ravel(), theta2.ravel()])

def unroll_params(theta, shape1, shape2):
    size1  = shape1[0]*shape1[1]
    theta1 = theta[:size1].reshape(shape1)
    theta2 = theta[size1:].reshape(shape2)
    return theta1, theta2    

def unroll_params(theta, n_input_layers, n_hidden_layers, n_labels): 
    theta1_size  = (n_input_layers+1) * n_hidden_layers
    theta1_shape = (n_hidden_layers   , n_input_layers+1 )
    theta2_shape = (n_labels          , n_hidden_layers+1)
    theta1 = theta[:theta1_size].reshape(theta1_shape)
    theta2 = theta[theta1_size:].reshape(theta2_shape)
    return theta1, theta2    

def get_y_vec(y, K):
    m     = y.shape[0]
    y_vec = np.zeros((m,K))
    for row in np.arange(m):
        y_vec[row, y[row,0]-1] = 1
    return y_vec

def cost_wrapper(flat_theta, X, y_vec, K, lambda_param):
    print("flat_theta[0:5] = ", flat_theta[0:5])
#     th1, th2 = unroll_params(flat_theta, theta1_rand.shape, theta2_rand.shape)
    th1, th2 = unroll_params(flat_theta, n_input_layers, n_hidden_layers, K)
    result = cost_nn(th1, th2, X, y_vec, K, lambda_param)
    print("result of cost_nn = %e" % result)
    assert(result!=np.inf)
    assert(result!=np.nan)
    return result

def grad_wrapper(flat_theta, X, y_vec, K, lambda_param):
#     th1, th2 = unroll_params(flat_theta, theta1_rand.shape, theta2_rand.shape)
    th1, th2 = unroll_params(flat_theta, n_input_layers, n_hidden_layers, K)
    grad_J1, grad_J2 = grad_nn(th1, th2, X, y_vec, K, lambda_param)
    return roll_params(grad_J1, grad_J2)

def predict_nn(theta1, theta2, X):
    m, n    = X.shape
    h_value = h_nn(theta1, theta2, X, shift_idx=False)
    pred    = np.argmax(h_value, axis=1)
    return pred

# ------------------------------------------------------------ #
# inputs
# ------------------------------------------------------------ #

lambda_param    = 1.0
max_iter        = 10
K               = 10
seed            = 1
n_input_layers  = 400
n_hidden_layers = 25
theta1_rand     = np.asmatrix(rand_initialize_weights(n_input_layers , n_hidden_layers, seed=seed))
theta2_rand     = np.asmatrix(rand_initialize_weights(n_hidden_layers, K              , seed=seed))
theta_rand      = roll_params(theta1_rand, theta2_rand)

# ------------------------------------------------------------ #
# load data 
# ------------------------------------------------------------ #

data   = scipy.io.loadmat('ex4data1.mat')
X_orig = data['X']
y_true = data['y']
y_true = np.where(y_true==10, 0, y_true) # set to python standard
y_vec  = get_y_vec(y_true, K)
m, n   = X_orig.shape

# ------------------------------------------------------------ #
# optimize
# ------------------------------------------------------------ #

# op_result = op.minimize(
#     fun=cost_wrapper, 
# #     jac=grad_wrapper, 
#     x0=theta_rand, 
#     args=(X_orig, y_vec, K, lambda_param), 
# #     method='CG', 
#     options={'maxiter': max_iter, 'disp': True}
# )
op_result = scipy.optimize.fmin_cg(
    f=cost_wrapper,
    fprime=grad_wrapper,
    x0=theta_rand,
    args=(X_orig, y_vec, K, lambda_param), 
    maxiter=50, 
    disp=True, 
    full_output=True
)

# ------------------------------------------------------------ #
# result 
# ------------------------------------------------------------ #

# theta_fit              = op_result.x
theta_fit              = op_result[0]
theta1_fit, theta2_fit = unroll_params(theta_fit, theta1_rand.shape, theta2_rand.shape)
pred                   = predict_nn(theta1_fit, theta2_fit, X_orig)
pred_df                = pd.DataFrame(data={
                            "pred" : np.asarray(pred  ).reshape(m,), 
                            "true" : np.asarray(y_true).reshape(m,)
                        })

def get_char_acc(pred_df, char):
    mask_df    = pred_df[pred_df.true==char]
    pred_value = mask_df.pred
    true_value = mask_df.true
    accuracy   = np.mean((pred_value==true_value)*100)
    return accuracy

for char in np.arange(0,10):
    print "accurancy for %d is %1.2f"%(char, get_char_acc(pred_df, char))

accuracy = np.mean((pred==y_true)*100)
print("overall accuracy = %1.2f"%accuracy)
