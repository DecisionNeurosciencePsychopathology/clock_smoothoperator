function [priors] = sceptic_get_priors(dim, so)
  priors=[];
  priors.a_alpha = Inf;   % infinite precision prior
  priors.b_alpha = 0;
  priors.a_sigma = 1;     % Jeffrey's prior
  priors.b_sigma = 1;     % Jeffrey's prior

  if strcmpi(so.model, 'decay_factorize_selective_psequate_fixedparams_fmri')
    %fix params at group means from MFX
    priors.muPhi = [ 2.576046 ];
    priors.SigmaPhi = zeros(dim.n_phi);

    priors.muTheta = [ -0.4139055; -0.02077855 ];
    priors.SigmaTheta = zeros(dim.n_theta);

  elseif strcmpi(so.model, 'decay_factorize_selective_psequate_fixedparams_meg')
    %fix params at group means from MFX
    priors.muPhi = [ 2.473331 ]; %beta
    priors.SigmaPhi = zeros(dim.n_phi); 

    priors.muTheta = [ -0.2807462; 0.5393902 ]; %alpha, gamma
    priors.SigmaTheta = zeros(dim.n_theta);

  elseif strcmpi(so.model, 'specc_decay_factorize_selective_psequate_fixedparams')
    %fix params at group medians from MFX
    priors.muPhi = [ 2.482078 ]; %median beta
    priors.SigmaPhi = zeros(dim.n_phi); 

    priors.muTheta = [ -0.5212639; 0.4397096 ]; %median alpha, gamma
    priors.SigmaTheta = zeros(dim.n_theta);

  elseif strcmpi(so.model, 'fixed_uv_ureset_fixedparams_fmri')
    %fix params at group means from MFX
    priors.muPhi = [ 3.605866; -6.879471 ]; %beta, tau
    priors.SigmaPhi = zeros(dim.n_phi);

    priors.muTheta = [ 3.623665 ]; %learning rate
    priors.SigmaTheta = zeros(dim.n_theta);

  elseif strcmpi(so.model, 'fixed_uv_ureset_fixedparams_meg')
    %fix params at group means from MFX
    priors.muPhi = [ 3.58216; -6.982361 ]; %beta, tau
    priors.SigmaPhi = zeros(dim.n_phi);

    priors.muTheta = [ 4.218003 ]; %learning rate
    priors.SigmaTheta = zeros(dim.n_theta);    

  else
    priors.muPhi = zeros(dim.n_phi,1); % exp tranform on temperature inside observation fx
    priors.SigmaPhi = 1e1*eye(dim.n_phi); %variance of 10

    priors.muTheta = zeros(dim.n_theta,1); %mean of 0
    priors.SigmaTheta = 1e1*eye(dim.n_theta); %variance of 10
  end
  
  %0 mean and variance on initial states
  priors.muX0 = zeros(dim.n,1); %nbasis * hidden_states
  priors.SigmaX0 = zeros(dim.n);
  
  %for u + v models, we need to initialize the sigmas at sigma_noise
  %this is done downstream in clock_sceptic_fmri
  
  
end
