function [so] = sceptic_validate_options(so)
% nbasis:      8 works well, 4 also OK
% multinomial:  if 1 fits p_chosen from the softmax; continuous RT (multinomial=0) works less well
% multisession: treats runs/conditions as separate, helps fit (do not allow X0 to vary though)
% fixed_params_across_runs -- self-explanatory
% fit_propspread -- makes temporal generalization within the eligibility trace a free parameter
% ntimesteps:      number of time bins
% u_aversion:   allow for uncertainty (ambiguity) aversion for UV_sum

if nargin < 1, so=[]; end

%if user specifies a dataset upstream, don't check environment variable
if isfield(so, 'sceptic_dataset')
    fprintf('Using user-specified dataset: %s.\n   Will not check sceptic_dataset environment variable.\n', so.sceptic_dataset);
else
    so.dataset=getenv('sceptic_dataset');
    if strcmpi(so.dataset, '')
        so.dataset='mmclock_fmri'; %or mmclock_fmri or specc_fmri
    end
end

%same principle for model variant
if isfield(so, 'model')
    fprintf('Using user-specified model: %s.\n   Will not check sceptic_model environment variable.\n', so.model);
else
    so.model=getenv('sceptic_model');
    if strcmpi(so.model, '')
        so.model = 'decay'; % will run to get value and prediction errors.
    end
end

if ~isfield(so, 'nbasis'), so.nbasis=24; end
if ~isfield(so, 'multinomial'), so.multinomial=1; end
if ~isfield(so, 'multisession'), so.multisession=0; end
if ~isfield(so, 'fixed_params_across_runs'), so.fixed_params_across_runs=1; end
if ~isfield(so, 'fit_propspread'), so.fit_propspread=0; end
if ~isfield(so, 'max_prop_spread'), so.max_prop_spread = .0125; end %used for fixed propspread case
if ~isfield(so, 'stick_pe'), so.stick_pe=0; end %spread PE by eligibility
if ~isfield(so, 'ntimesteps')
    if strcmpi(so.dataset,'explore')
        so.ntimesteps=50;
    else
        so.ntimesteps=40;
    end
end
if ~isfield(so, 'u_aversion'), so.u_aversion=1; end  % default based on Cognition analyses
if ~isfield(so, 'graphics'), so.graphics=0; end
if ~isfield(so, 'model'), so.model='fixed'; end
if ~isfield(so, 'trials_per_run')
    if strcmpi(so.dataset,'explore')
        so.trials_per_run=120;
    else
        so.trials_per_run=50;
    end
end
if ~isfield(so, 'trial_length')  %trial length in ms (used for discretizing to bins)
    if strcmpi(so.dataset,'explore')
        so.trial_length=5000;
    else
        so.trial_length=4000;
    end
end
if ~isfield(so, 'saveresults'), so.saveresults=0; end %used in some places to denote whether to save fitted outputs
if ~isfield(so, 'factorize_decay'), so.factorize_decay=0; end %whether to reparameterize decay model with alpha multiplying entire update
if ~isfield(so, 'function_wise_pe'), so.function_wise_pe=0; end %whether PE is computed compared to the evaluated value function (1) or the individual basis weight (0)
if ~isfield(so, 'uniform'), so.uniform=0; end %whether decay is uniform (1) or whether values are maintained within eligibility trace

%hidden states field used to index hidden state vector inside evolution and observation functions
if strcmpi(so.model,'fixed')
    so.evo_fname = @h_sceptic_fixed_fmri;
    so.hidden_states=2; %track basis weights (value), as well as PE as tag-along state
    so.n_theta=1; %learning rate
    so.theta_names={'alpha'};
elseif contains(so.model,'decay')
    so.evo_fname = @h_sceptic_fixed_decay_fmri;
    so.hidden_states=3; %track basis weights (value), as well as PE and decay as tag-along states
    so.n_theta=2; %learning rate and selective maintenance parameters (decay outside of the eligibility trace)
    so.theta_names={'alpha', 'gamma'};
    
    %model variants for factorize, equate prop sprad, uniform decay
    if contains(so.model, 'factorize'), so.factorize_decay=1; end %factorize alpha + decay
    if contains(so.model, 'separate'), so.factorize_decay=0; end
    
    if contains(so.model, 'uniform'), so.uniform=1; end %uniform decay
    if contains(so.model, 'selective'), so.uniform=0; end %selective decay
elseif strcmpi(so.model,'fixed_UV')
    so.evo_fname = @h_sceptic_kalman_fmri;
    so.hidden_states=3; %track basis weights (value), as well as PE and uncertainty
    so.n_theta=2; %learning rate alpha and uncertainty sensitivity parameter tau
    so.theta_names={'tau', 'alpha'};
end

if contains(so.model, 'psequate'), so.max_prop_spread = -1; end %equate SD to underlying basis

if contains(so.model, 'stickpe'), so.stick_pe=1; end

so.obs_fname = @g_sceptic; %just regular softmax observation rule for now
so.phi_names = {'beta'}; %temperature

if strcmpi(so.dataset, 'mmclock_meg')
    so.trials_per_run=63; %63 for MEG, 50 for fMRI
else
    so.trials_per_run=50;
end

end
