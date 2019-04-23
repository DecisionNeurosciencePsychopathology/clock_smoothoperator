function [data, y, u] = sceptic_get_data(data_file, so)
if(strcmpi(so.dataset,'explore'))
    load(data_file,'-mat','order','orderfmt')
    order=order(~cellfun('isempty',order));
    outx=cellfun(@cell2table, order, 'UniformOutput', false);
    data=vertcat(outx{:});
    data.Properties.VariableNames=orderfmt;
else
    data = readtable(data_file,'Delimiter',',','ReadVariableNames',true);
end


n_t = size(data,1); %number of rows
trials_to_fit = 1:n_t; %fit all trials by default
n_runs = n_t/so.trials_per_run; %usually 50 trials per run

%% discretize RTs down to time bins
rtrnd = round(data{trials_to_fit,'rt'} / so.trial_length * so.ntimesteps)';
rtrnd(rtrnd==0)=1;

%% compute multinomial response
y = zeros(so.ntimesteps, length(trials_to_fit));
for i = 1:length(trials_to_fit)
    y(rtrnd(i), i) = 1;
end

%% Inputs
u = [(data{trials_to_fit, 'rt'} / so.trial_length * so.ntimesteps)'; data{trials_to_fit, 'score'}'];
u = [zeros(size(u,1),1) u(:,1:end-1)]; %right shift inputs to get t versus t+1 correct in inputs versus predictions

end
