% Copyright (c) Microsoft Corporation.
% Licensed under the MIT license.

function tools = get_tools_hand(exe_dir,python_dir,julia_dir)
% call_type:
%   0 standard - tools(id).run_cmd
%   1 theano - tools(id).run_cmd
%   2 ceres - tools(id).run_cmd+d+k
%   3 adimat
%   4 adimat sparse
%   5 mupad

% markers
cols = generate_colors();
markers = generate_symbols();

% tools
tools = {};
cpp_objective_ids = [];

tools(end+1).name = 'manual | C++ Eigen';
tools(end).exe = [exe_dir,'Manual_eigen.exe'];
tools(end).run_cmd = tools(end).exe;
tools(end).ext = 'manual_eigen';
tools(end).col = cols('manual');
tools(end).marker = markers('eigen');
tools(end).call_type = 0;
cpp_objective_ids = [cpp_objective_ids numel(tools)];

tools(end+1).name = 'ADOLC | C++ light';
tools(end).exe = [exe_dir,'ADOLC_light.exe'];
tools(end).run_cmd = tools(end).exe;
tools(end).ext = 'ADOLC_light';
tools(end).col = cols('adolc');
tools(end).marker = markers('light');
tools(end).call_type = 0;
cpp_objective_ids = [cpp_objective_ids numel(tools)];

tools(end+1).name = 'ADOLC | C++ Eigen';
tools(end).exe = [exe_dir,'ADOLC_eigen.exe'];
tools(end).run_cmd = tools(end).exe;
tools(end).ext = 'ADOLC_eigen';
tools(end).col = cols('adolc');
tools(end).marker = markers('eigen');
tools(end).call_type = 0;
cpp_objective_ids = [cpp_objective_ids numel(tools)];

tools(end+1).name = 'Adept | C++ light';
tools(end).exe = [exe_dir,'Adept_light.exe'];
tools(end).run_cmd = tools(end).exe;
tools(end).ext = 'Adept_light';
tools(end).col = cols('adept');
tools(end).marker = markers('light');
tools(end).call_type = 0;
cpp_objective_ids = [cpp_objective_ids numel(tools)];

tools(end+1).name = 'Theano | Python';
tools(end).exe = [python_dir,'Theano/Theano_hand.py'];
tools(end).run_cmd = ['python.exe ' tools(end).exe];
tools(end).ext = 'Theano';
tools(end).col = cols('theano');
tools(end).marker = markers('');
tools(end).call_type = 1;

tools(end+1).name = 'Theano (R-op) | Python';
tools(end).exe = [python_dir,'Theano/Theano_hand_simple_Rop.py'];
tools(end).run_cmd = ['python.exe ' tools(end).exe];
tools(end).ext = 'Theano_rop';
tools(end).col = cols('theano');
tools(end).marker = markers('r-op');
tools(end).call_type = 1;

tools(end+1).name = 'Ceres | C++ light';
tools(end).exe = [exe_dir,'Ceres/Ceres_light1.exe'];
tools(end).run_cmd = [exe_dir,'Ceres/Ceres_light'];
tools(end).ext = 'Ceres_light';
tools(end).col = cols('ceres');
tools(end).marker = markers('light');
tools(end).call_type = 2;
cpp_objective_ids = [cpp_objective_ids numel(tools)];

tools(end+1).name = 'Ceres | C++ Eigen';
tools(end).exe = [exe_dir,'Ceres/Ceres_eigen1.exe'];
tools(end).run_cmd = [exe_dir,'Ceres/Ceres_eigen'];
tools(end).ext = 'Ceres_eigen';
tools(end).col = cols('ceres');
tools(end).marker = markers('eigen');
tools(end).call_type = 2;
cpp_objective_ids = [cpp_objective_ids numel(tools)];

tools(end+1).name = 'DiffSharp | F#';
tools(end).exe = [exe_dir,'DiffSharp/DiffSharpTests.exe'];
tools(end).run_cmd = tools(end).exe;
tools(end).ext = 'DiffSharp';
tools(end).col = cols('diffsharp');
tools(end).marker = markers('automode');
tools(end).call_type = 0;

tools(end+1).name = 'DiffSharp-F | F#';
tools(end).exe = [exe_dir,'DiffSharpF/DiffSharpTests.exe'];
tools(end).run_cmd = tools(end).exe;
tools(end).ext = 'DiffSharp_F';
tools(end).col = cols('diffsharp');
tools(end).marker = markers('');
tools(end).call_type = 0;

tools(end+1).name = 'ADiMat | MATLAB';
tools(end).exe = 'hand_objective.m';
tools(end).ext = 'adimat';
tools(end).col = cols('adimat');
tools(end).marker = markers('');
tools(end).call_type = 3;

tools(end+1).name = 'Julia-F | Julia';
tools(end).exe = [julia_dir 'Tests/hand_F.jl'];
tools(end).run_cmd = ['julia.exe ' tools(end).exe];
tools(end).ext = 'Julia_F';
tools(end).col = cols('julia_f');
tools(end).marker = markers('');
tools(end).call_type = 0;

tools(end+1).name = 'Finite differences | C++';
tools(end).col = cols('finite_differences');
tools(end).marker = markers('');
tools(end).cpp_objective_ids = cpp_objective_ids;
tools(end).call_type = 6;

