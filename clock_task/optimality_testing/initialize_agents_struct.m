function a = initialize_agents_struct()
%This defines the simulation parameters for all agents to be tested for optimality.
%These are stored in a struct where the field name is the model naem
clear a;

% NB: a struct array, despite its elegance, is causing many headaches in parfor loops since agents(a) indexing is invalid
% unless a is the parfor loop counter. This is not the best way to parallelize (since there are only 4-6 agents).
% revert to single struct and use fieldnames.

prop_spread_init=.20;           %tends to be pretty reasonable default for temporal generalization
beta_init=.1;                   %default for temperature parameter.
lr_bounds=[.001 1];             %min/max values for all fixed learning rate parameters
prop_spread_bounds=[.001, .7];  %min/max values for prop_spread (gaussian temporal generalization)
beta_bounds=[.001, 2];
omega_bounds=[0 100];
kl_bounds=[0 5];

fixedLR_softmax.init_params =  [prop_spread_init, beta_init,   .1]; %prop_spread, beta, alpha
fixedLR_softmax.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), lr_bounds(1)];
fixedLR_softmax.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), lr_bounds(2)];
fixedLR_softmax.k = length(fixedLR_softmax.init_params); %number of free parameters
fixedLR_softmax.name = 'fixedLR_softmax'; %add explicit name parameter since each field in struct gets pulled out separately
fixedLR_softmax.parnames = {'prop_spread', 'beta', 'alpha'};
fixedLR_softmax.clock_options=struct();
a(1) = fixedLR_softmax;

fixedLR_egreedy.init_params =  [prop_spread_init,  .1,  .1]; %prop_spread, epsilon, alpha
fixedLR_egreedy.lower_bounds = [prop_spread_bounds(1),   0, lr_bounds(1)];
fixedLR_egreedy.upper_bounds = [prop_spread_bounds(2),   1, lr_bounds(2)];
fixedLR_egreedy.k = length(fixedLR_egreedy.init_params); %number of free parameters
fixedLR_egreedy.name = 'fixedLR_egreedy';
fixedLR_egreedy.parnames = {'prop_spread', 'epsilon', 'alpha'};
fixedLR_egreedy.clock_options=struct();
a(2) = fixedLR_egreedy;

fixedLR_egreedy_grw.init_params =  [prop_spread_init,  .1,  .1,  .1]; %prop_spread, epsilon, alpha, sig_grw
fixedLR_egreedy_grw.lower_bounds = [prop_spread_bounds(1),   0, lr_bounds(1), .01];
fixedLR_egreedy_grw.upper_bounds = [prop_spread_bounds(2),   1, lr_bounds(2),  .7];
fixedLR_egreedy_grw.k = length(fixedLR_egreedy_grw.init_params); %number of free parameters
fixedLR_egreedy_grw.name = 'fixedLR_egreedy_grw';
fixedLR_egreedy_grw.parnames = {'prop_spread', 'epsilon', 'alpha', 'sig_grw'};
fixedLR_egreedy_grw.clock_options=struct();
a(3) = fixedLR_egreedy_grw;

asymfixedLR_softmax.init_params =  [prop_spread_init, beta_init,  .1,  .1]; %prop_spread, beta, alpha, rho
asymfixedLR_softmax.lower_bounds = [prop_spread_bounds(1),  beta_bounds(1), lr_bounds(1), lr_bounds(1)];
asymfixedLR_softmax.upper_bounds = [prop_spread_bounds(2),  beta_bounds(2), lr_bounds(2), lr_bounds(2)];
asymfixedLR_softmax.k = length(asymfixedLR_softmax.init_params); %number of free parameters
asymfixedLR_softmax.name = 'asymfixedLR_softmax'; 
asymfixedLR_softmax.parnames = {'prop_spread', 'beta', 'alpha', 'rho'}; 
asymfixedLR_softmax.clock_options=struct();
a(4) = asymfixedLR_softmax;

kalman_softmax.init_params = [prop_spread_init, beta_init]; %proportion_spread, beta
kalman_softmax.lower_bounds = [prop_spread_bounds(1), beta_bounds(1)];
kalman_softmax.upper_bounds = [prop_spread_bounds(2), beta_bounds(2)];
kalman_softmax.k = length(kalman_softmax.init_params); %number of free parameters
kalman_softmax.name = 'kalman_softmax'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_softmax.parnames = {'prop_spread', 'beta'};
kalman_softmax.clock_options=struct();
a(5) = kalman_softmax;

kalman_processnoise.init_params = [prop_spread_init, beta_init, 1]; %prop_spread, beta, omega
kalman_processnoise.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), omega_bounds(1)];
kalman_processnoise.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), omega_bounds(2)];
kalman_processnoise.k = length(kalman_processnoise.init_params); %number of free parameters
kalman_processnoise.name = 'kalman_processnoise'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_processnoise.parnames = {'prop_spread', 'beta', 'omega'};
kalman_processnoise.clock_options=struct();
a(6) = kalman_processnoise;

kalman_sigmavolatility.init_params = [prop_spread_init, beta_init, 0.5, 0.8]; %prop_spread, beta, phi, gamma
kalman_sigmavolatility.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), 0, 0];
kalman_sigmavolatility.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), 10, 0.99];
kalman_sigmavolatility.k = length(kalman_sigmavolatility.init_params); %number of free parameters
kalman_sigmavolatility.name = 'kalman_sigmavolatility'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_sigmavolatility.parnames = {'prop_spread', 'beta', 'phi', 'gamma'};
kalman_sigmavolatility.clock_options=struct();
a(7) = kalman_sigmavolatility;

kalman_uv_logistic.init_params = [prop_spread_init, 0.7, 10]; %prop_spread, tradeoff (prop reduction in uncertainty), discrim (slope of logistic)
kalman_uv_logistic.lower_bounds = [prop_spread_bounds(1), 0.1, 0.01];
kalman_uv_logistic.upper_bounds = [prop_spread_bounds(2), .99, 100];
kalman_uv_logistic.k = length(kalman_uv_logistic.init_params); %number of free parameters
kalman_uv_logistic.name = 'kalman_uv_logistic'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_uv_logistic.parnames = {'prop_spread', 'tradeoff', 'discrim'};
kalman_uv_logistic.clock_options=struct();
a(8) = kalman_uv_logistic;

kalman_uv_sum.init_params = [prop_spread_init, beta_init, 0.6]; %prop_spread, beta, tau (mix of U and V)
kalman_uv_sum.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), 0];
kalman_uv_sum.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), 1];
kalman_uv_sum.k = length(kalman_uv_sum.init_params); %number of free parameters
kalman_uv_sum.name = 'kalman_uv_sum'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_uv_sum.parnames = {'prop_spread', 'beta', 'tau'};
kalman_uv_sum.clock_options=struct();
a(9) = kalman_uv_sum;

fixedLR_kl_softmax.init_params = [prop_spread_init, beta_init, 0.1, 0.1, 0.1]; %prop_spread, beta, alpha, kappa, lambda
fixedLR_kl_softmax.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), lr_bounds(1), 0, 0];
fixedLR_kl_softmax.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), lr_bounds(2), kl_bounds(2), kl_bounds(2)];
fixedLR_kl_softmax.k = length(fixedLR_kl_softmax.init_params); %number of free parameters
fixedLR_kl_softmax.name = 'fixedLR_kl_softmax'; %add explicit name parameter since each field in struct gets pulled out separately
fixedLR_kl_softmax.parnames = {'prop_spread', 'beta', 'alpha', 'kappa', 'lambda'};
fixedLR_kl_softmax.clock_options=struct();
a(10) = fixedLR_kl_softmax;

kalman_kl_softmax.init_params = [prop_spread_init, beta_init, 0.1, 0.1]; %prop_spread, beta, kappa, lambda
kalman_kl_softmax.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), kl_bounds(1), kl_bounds(1)];
kalman_kl_softmax.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), kl_bounds(2), kl_bounds(2)];
kalman_kl_softmax.k = length(kalman_kl_softmax.init_params); %number of free parameters
kalman_kl_softmax.name = 'kalman_kl_softmax'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_kl_softmax.parnames = {'prop_spread', 'beta', 'kappa', 'lambda'};
kalman_kl_softmax.clock_options=struct();
a(11) = kalman_kl_softmax;

kalman_processnoise_kl.init_params = [prop_spread_init, beta_init, 1, 0.1, 0.1]; %prop_spread, beta, omega, kappa, lambda
kalman_processnoise_kl.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), omega_bounds(1), 0, 0];
kalman_processnoise_kl.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), omega_bounds(2), kl_bounds(2), kl_bounds(2)];
kalman_processnoise_kl.k = length(kalman_processnoise_kl.init_params); %number of free parameters
kalman_processnoise_kl.name = 'kalman_processnoise_kl'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_processnoise_kl.parnames = {'prop_spread', 'beta', 'omega', 'kappa', 'lambda'};
kalman_processnoise_kl.clock_options=struct();
a(12) = kalman_processnoise_kl;

kalman_uv_sum_kl.init_params = [prop_spread_init, beta_init, 0.6, 0.1, 0.1]; %prop_spread, beta, tau, kappa, lambda
kalman_uv_sum_kl.lower_bounds = [prop_spread_bounds(1), beta_bounds(1), 0, kl_bounds(1), kl_bounds(1)];
kalman_uv_sum_kl.upper_bounds = [prop_spread_bounds(2), beta_bounds(2), 1, kl_bounds(2), kl_bounds(2)];
kalman_uv_sum_kl.k = length(kalman_uv_sum_kl.init_params); %number of free parameters
kalman_uv_sum_kl.name = 'kalman_uv_sum_kl'; %add explicit name parameter since each field in struct gets pulled out separately
kalman_uv_sum_kl.parnames = {'prop_spread', 'beta', 'tau', 'kappa', 'lambda'};
kalman_uv_sum_kl.clock_options=struct();
a(13) = kalman_uv_sum_kl;

%Load in clock options
load('optimality_testing/clock_options.mat');

qlearning.init_params = [0.9 0.2 0.08 0.99];
qlearning.lower_bounds = [0.8 0.01 0.01 0.90];
qlearning.upper_bounds = [0.99 0.35 0.30 0.999];
qlearning.k = length(qlearning.init_params); %number of free parameters
qlearning.name = 'qlearning';
qlearning.parnames = {'gamma', 'alpha', 'epsilon', 'lambda'};
qlearning.clock_options=clock_options;
a(14) = qlearning;

sarsa.init_params = [0.9 0.2 0.08 0.99];
sarsa.lower_bounds = [0.8 0.01 0.01 0.90];
sarsa.upper_bounds = [0.99 0.35 0.30 0.999];
sarsa.k = length(sarsa.init_params); %number of free parameters
sarsa.name = 'sarsa';
sarsa.parnames = {'gamma', 'alpha', 'epsilon', 'lambda'};
sarsa.clock_options=clock_options;
sarsa.clock_options.agent = 'sarsa';
a(15) = sarsa;

franktc.init_params = [ 0.2, 3000, 0.3, 0.3, 1000, 0.1, 300 ];
franktc.lower_bounds = [ 0, 0, 0.01, 0.01, 1, 0, 0 ];
franktc.upper_bounds = [1, 100000, 5, 5, 5000, 5000, 10000 ];
franktc.k = length(franktc.init_params); %number of free parameters
franktc.name = 'franktc';
franktc.parnames = {'lambda', 'epsilon', 'alphaG', 'alphaN', 'K', 'nu', 'rho'};
franktc.clock_options=struct();
a(16) = franktc;

fixedLR_softmax_bfix.init_params =  [prop_spread_init, .1]; %prop_spread, alpha
fixedLR_softmax_bfix.lower_bounds = [prop_spread_bounds(1), lr_bounds(1)];
fixedLR_softmax_bfix.upper_bounds = [prop_spread_bounds(2), lr_bounds(2)];
fixedLR_softmax_bfix.k = length(fixedLR_softmax_bfix.init_params); %number of free parameters
fixedLR_softmax_bfix.name = 'fixedLR_softmax_bfix'; %add explicit name parameter since each field in struct gets pulled out separately
fixedLR_softmax_bfix.parnames = {'prop_spread', 'alpha'};
fixedLR_softmax_bfix.clock_options=struct();
a(17) = fixedLR_softmax_bfix;


end
