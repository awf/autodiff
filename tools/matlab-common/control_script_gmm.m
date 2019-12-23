% Copyright (c) Microsoft Corporation.
% Licensed under the MIT license.

%% set paths and get tools struct array
root_dir = 'C:/Users/Filip/Dropbox/MSR/autodiff/';
exe_dir = [root_dir 'Release/gmm/'];
python_dir = [root_dir 'Python/'];
julia_dir = [root_dir 'Julia/'];
data_dir = [root_dir 'gmm_instances/'];
% npts_str = '2.5M'; replicate_point = true;
data_dir = [data_dir npts_str '/'];
data_dir_est = [data_dir 'est/'];
npoints = 2.5e6;
problem_name='gmm';

tools = get_tools_gmm(exe_dir,python_dir,julia_dir);
manual_cpp_id = 1;
ntools = numel(tools);

%% generate parameters (instance sizes) and order them
d_all = [2 10 20 32 64];
k_all = [5 10 25 50 100 200];
params = {};
num_params = [];
for d = d_all
    icf_sz = d*(d + 1) / 2;
    for k = k_all
        num_params(end+1) = k + d*k + icf_sz*k;
        params{end+1} = [d k num_params(end)];
    end
end

[num_params, order] = sort(num_params);
params = params(order);
% ignore = [2 3 4 5 8 10];
% params = params(~ismember(1:numel(params),ignore));
for i=1:numel(params)
    disp(num2str(params{i}));
end

fns = {};
for i=1:numel(params)
    d = params{i}(1);
    k = params{i}(2);
    fns{end+1} = [problem_name '_d' num2str(d) '_K' num2str(k)];
end
ntasks = numel(params);
% save('params_' problem_name '.mat','params');

% %% generate new instances and write into files - do only once
% addpath('awful/matlab')
% for i=1:ntasks
%     disp(['runnning: ' num2str(i) '; params: ' num2str(params{i})]);
%     
%     d = params{i}(1);
%     k = params{i}(2);
%     
%     rng(1);
%     paramsGMM.alphas = randn(1,k);
%     paramsGMM.means = au_map(@(i) rand(d,1), cell(k,1));
%     paramsGMM.means = [paramsGMM.means{:}];
%     paramsGMM.inv_cov_factors = au_map(@(i) randn(d*(d+1)/2,1), cell(k,1));
%     paramsGMM.inv_cov_factors = [paramsGMM.inv_cov_factors{:}];
%     if replicate_point
%         x = randn(d,1);
%     else
%         x = randn(d,npoints);
%     end
%     hparams = [1 0];
%     
%     save_gmm_instance([data_dir fns{i} '.txt'], paramsGMM, x, hparams, npoints);
% end

%% write script for running tools once
fn_run_once = 'run_tools_once.mk';
nruns=ones(ntasks,ntools);
write_script(fn_run_once,params,data_dir,data_dir_est,fns,tools,...
    nruns,nruns,replicate_point);

%% run all tools once - runtimes estimates
% tic
% system(fn_run_once);
% toc

% tools ran from matlab
nruns = ones(1,ntasks);
for i=1:ntools
   J_file = [data_dir_est problem_name '_J_' tools(i).ext '.mat'];
   times_file = [data_dir_est problem_name '_times_' tools(i).ext '.mat'];
   if tools(i).call_type == 3 % adimat
       do_adimat_vector = false;
       adimat_run_gmm_tests(do_adimat_vector,params,data_dir,fns,...
           nruns,nruns,J_file,times_file,replicate_point);
   elseif tools(i).call_type == 4 % adimat vector
       do_adimat_vector = true;
       adimat_run_gmm_tests(do_adimat_vector,params,data_dir,fns,...
           nruns,nruns,J_file,times_file,replicate_point);
   elseif tools(i).call_type == 5 % mupad
       mupad_run_gmm_tests(params,data_dir,fns,...
           nruns,nruns,times_file,replicate_point);
   end    
end

%% read time estimates & determine nruns for everyone
[times_est_f,times_est_J,up_to_date_mask] = ...
    read_times(data_dir,data_dir_est,fns,tools,problem_name);

nruns_f = determine_n_runs(times_est_f);
nruns_J = determine_n_runs(times_est_J);
save([data_dir_est 'estimates_backup.mat'],'nruns_f','nruns_J',...
    'times_est_f','times_est_J','up_to_date_mask');
nruns_f = nruns_f .* ~up_to_date_mask;
nruns_J = nruns_J .* ~up_to_date_mask;

%% write script for running tools
fn_run_experiments = 'run_experiments.mk';
write_script(fn_run_experiments,params,data_dir,data_dir,...
    fns,tools,nruns_f,nruns_J,replicate_point);

%% run all experiments
% tic
% system(fn_run_experiments);
% toc

% tools ran from matlab
for i=1:ntools
   J_file = [data_dir problem_name '_J_' tools(i).ext '.mat'];
   times_file = [data_dir problem_name '_times_' tools(i).ext '.mat'];
   if tools(i).call_type == 3 % adimat
       do_adimat_vector = false;
       adimat_run_gmm_tests(do_adimat_vector,params,data_dir,fns,...
           nruns_f(:,i),nruns_J(:,i),J_file,times_file,replicate_point);
   elseif tools(i).call_type == 4 % adimat vector
       do_adimat_vector = true;
       adimat_run_gmm_tests(do_adimat_vector,params,data_dir,fns,...
           nruns_f(:,i),nruns_J(:,i),J_file,times_file,replicate_point);
   elseif tools(i).call_type == 5 % mupad
       mupad_run_gmm_tests(params,data_dir,fns,...
           nruns_f(:,i),nruns_J(:,i),times_file,replicate_point);
   end    
end

% %% transport missing runtimes (from data_dir_est to data_dir)
% load([data_dir_est 'estimates_backup.mat']);
% [times_fixed_f,times_fixed_J] = ...
%     read_times(data_dir,'-',fns,tools,problem_name);
% mask_f = (nruns_f==0) & ~up_to_date_mask & ~isinf(times_est_f);
% mask_J = (nruns_J==0) & ~up_to_date_mask & ~isinf(times_est_J);
% times_fixed_f(mask_f) = times_est_f(mask_f);
% times_fixed_J(mask_J) = times_est_J(mask_J);
% for i=1:ntools
%     if tools(i).call_type < 3
%         postfix = ['_times_' tools(i).ext '.txt'];
%         for j=1:ntasks
%             if any([mask_f(j,i) mask_J(j,i)])
%                 fn = [data_dir fns{j} postfix];
%                 fid = fopen(fn,'w');
%                 fprintf(fid,'%f %f\n',times_fixed_f(j,i),times_fixed_J(j,i));
%                 fprintf(fid,'tf tJ');
%                 fclose(fid);
%             end
%         end
%     end
% end

%% read final times
[times_f,times_J] = ...
    read_times(data_dir,data_dir,fns,tools,problem_name);

% add finite differences times
for i=1:ntools
    if tools(i).call_type == 6
        nparams=[params{:}]; nparams=nparams(3:3:end);
        [times_f(:,i), times_J(:,i)] = compute_finite_diff_times_J(tools(i),...
            nparams,times_f);
    end
end

% times_f_relative = bsxfun(@rdivide,times_f,times_f(:,manual_cpp_id));
% times_f_relative(isnan(times_f_relative)) = Inf;
% times_f_relative(times_f_relative==0) = Inf;
times_J_relative = times_J./times_f;
% times_J_relative = bsxfun(@rdivide,times_J,times_J(:,manual_cpp_id));
times_J_relative(isnan(times_J_relative)) = Inf;
times_J_relative(times_J_relative==0) = Inf;

%% output results
save([data_dir 'times_' date],'times_f','times_J','params','tools');

%% plot times
x=[params{:}]; x=x(3:3:end);
title_ = [' - ' npts_str ' data points'];
xlabel_ = '# parameters';

plot_log_runtimes(tools,times_J,x,...
    ['GMM Gradient Absolute runtimes' title_],...
    'runtime [seconds]',xlabel_);

plot_log_runtimes(tools,times_J_relative,x,...
    ['GMM Gradient Runtimes Relative to Objective Runtimes' title_],...
    'relative runtime',xlabel_);

% to_show=[1 2 3 4 10 11 14 16 18 19 20 21 22]; % unique languages for gmm
plot_log_runtimes(tools,times_f,x,...
    ['GMM Objective Absolute Runtimes' title_],...
    'runtime [seconds]',xlabel_);

%% verify results (except mupad and adimats)
addpath('adimat-0.6.0-4971');
start_adimat
addpath('awful\matlab');
opt = admOptions('independents', [1 2 3],  'functionResults', {1});
bad = {};
num_ok = 0;
num_not_comp = 0;
for i=1:ntasks
    disp(['comparing to adimat: ' num2str(i) '; params: ' num2str(params{i})]);
    d = params{i}(1);
    k = params{i}(2);
    [paramsGMM,x,hparams] = load_gmm_instance(...
        [data_dir fns{i} '.txt'],replicate_point);
    [Jrev,fvalrev] = admDiffRev(@gmm_objective_vector_repmat, 1, paramsGMM.alphas,...
        paramsGMM.means, paramsGMM.inv_cov_factors, x, hparams, opt);
    
    for j=1:ntools
        if tools(j).call_type < 3
            fn = [data_dir fns{i} '_J_' tools(j).ext '.txt'];
            if exist(fn,'file')
                Jexternal = load_J(fn);
                tmp = norm(Jrev(:) - Jexternal(:)) / norm(Jrev(:));
                if tmp < 1e-5
                    num_ok = num_ok + 1;
                else
                    bad{end+1} = {fn, tmp};
                end
            else
                disp([tools(j).name ': not computed']);
                num_not_comp = num_not_comp + 1;
            end
        end
    end
end
disp(['num ok: ' num2str(num_ok)]);
disp(['num bad: ' num2str(numel(bad))]);
disp(['num not computed: ' num2str(num_not_comp)]);
for i=1:numel(bad)
    disp([bad{i}{1} ' : ' num2str(bad{i}{2})]);
end

%% do 2D plots
tool_id = 1;
vals_J = zeros(numel(d_all),numel(k_all));
vals_relative = vals_J;
for i=1:ntasks
    d = params{i}(1);
    k = params{i}(2);
    vals_relative(d_all==d,k_all==k) = times_J_relative(i,tool_id);
    vals_J(d_all==d,k_all==k) = times_J(i,tool_id);
end
[x,y]=meshgrid(k_all,d_all);
figure
surf(x,y,vals_J);
xlabel('d')
ylabel('K')
set(gca,'FontSize',14,'ZScale','log')
title(['Runtime (seconds): ' tools(tool_id).name])
figure
surf(x,y,vals_relative);
xlabel('d')
ylabel('K')
set(gca,'FontSize',14)
title(['Runtime (relative): ' tools(tool_id).name])

%% output into excel/csv
csvwrite('tmp.csv',times_J*1000,2,1);
csvwrite('tmp2.csv',times_relative,2,1);
labels = {};
for i=1:ntasks
    labels{end+1} = [num2str(params{i}(1)) ',' num2str(params{i}(2)) ...
        '->' num2str(params{i}(3))];
end
xlswrite('tmp.xlsx',labels')
xlswrite('tmp.xlsx',tools,1,'B1')

%% mupad compilation
mupad_compile_times = Inf(1,ntasks);
mupad_compile_times(1:13) = [0.0014, 0.0019, 0.014, 0.15, 0.089,...
    0.6, 0.5, 3.3, 4.25, 8.7, 15.1, 26, 50];

vals = zeros(numel(d_all),numel(k_all));
for i=1:ntasks
    d = params{i}(1);
    k = params{i}(2);
    vals(d_all==d,k_all==k) = mupad_compile_times(i);
end
[x,y]=meshgrid(k_all,d_all);
figure
surf(x,y,vals);
xlabel('d')
ylabel('K')
set(gca,'FontSize',14,'ZScale','log')
title('Compile time (hours): MuPAD')

figure
x=[params{:}]; x=x(3:3:end);
loglog(x,mupad_compile_times,'linewidth',2)
xmax = find(~isinf(mupad_compile_times)); xmax=x(xmax(end));
xlim([x(1) xmax])
xlabel('# parameters')
ylabel('compile time [hours]')
title('Compile time (hours): MuPAD')
