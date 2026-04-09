function UpdateSUMO(block)
setup(block);

function setup(block)

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 4;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Override input port properties
block.InputPort(1).Dimensions        = 1;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = true;

% Override output port properties
block.OutputPort(1).Dimensions      = 1;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';

% Register parameters
block.NumDialogPrms     = 0;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [0.1 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'DefaultSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------

% block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
% block.RegBlockMethod('InitializeConditions', @InitializeConditions);
% block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('SetInputPortSamplingMode', @SetInputsPortFrameData);
% block.RegBlockMethod('Update', @Update);
% block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required


%%
%% InitializeConditions:
%%   Functionality    : Called at the start of simulation and if it is 
%%                      present in an enabled subsystem configured to reset 
%%                      states, it will be called when the enabled subsystem
%%                      restarts execution to reset the states.
%%   Required         : No
%%   C MEX counterpart: mdlInitializeConditions
%%
% function InitializeConditions(block)
% cont = 1;
% end InitializeConditions


%%
%% Start:
%%   Functionality    : Called once at start of model execution. If you
%%                      have states that should be initialized once, this 
%%                      is the place to do it.
%%   Required         : No
%%   C MEX counterpart: mdlStart
    % function Start(block)

%end Start

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C MEX counterpart: mdlOutputs
%%
function Outputs(block)
% Leggo la velocità del veicolo controllato in input
    v_1 = block.InputPort(1).Data;

% Setto la velocità del veicolo
    traci.vehicle.setSpeedMode('Ego_Vehicle',0)
    traci.vehicle.setSpeed('Ego_Vehicle',v_1)
   
% Step di simulazione
    traci.simulationStep();
    corsia = traci.vehicle.getLaneID('Ego_Vehicle');
    speed_limite = traci.lane.getMaxSpeed(corsia);
    
% Estrazione dati che interessano il veicolo e un eventuale leader    
%     v_out_1 = traci.vehicle.getSpeed('1');
    [leader, dist] = traci.vehicle.getLeader('Ego_Vehicle');
    if dist == -1
        speed_leader = speed_limite;
        dist = 1000;
    else
        speed_leader = traci.vehicle.getSpeed(leader);
    end
    lane_id = traci.vehicle.getRoadID('Ego_Vehicle');
    if strcmp(lane_id,'230252807.1990') == 1
%         lane_id == '230252807.1990'
        flag_stop = 1;
    else
        flag_stop = 0;
    end
block.OutputPort(1).Data = speed_leader;
block.OutputPort(2).Data = dist;
block.OutputPort(3).Data = speed_limite;
block.OutputPort(4).Data = flag_stop;


%end Outputs
function SetInputsPortFrameData(block,idx,fd)
    block.InputPort(idx).SamplingMode = fd;
    for i = 1:block.NumOutputPorts
        block.OutputPort(i).SamplingMode = fd;
    end
%%
%% Update:
%%   Functionality    : Called to update discrete states
%%                      during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlUpdate
%%
% function Update(block)


%end Update

%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlDerivatives
%%

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate
