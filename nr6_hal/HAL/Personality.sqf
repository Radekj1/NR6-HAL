_SCRname = "Personality";

private ["_rnd","_MAtt","_pers","_signum","_Recklessness","_Consistency","_Activity","_Reflex","_Circumspection","_Fineness"];
params ["_HQ"];

_signum = _HQ getVariable ["RydHQ_CodeSign","X"];

_rnd = random 100;

_MAtt = _HQ getVariable ["RydHQ_MAtt",false];
_pers = _HQ getVariable ["RydHQ_Personality","OTHER"];

_Recklessness = _HQ getVariable ["RydHQ_Recklessness",0.5];
_Consistency = _HQ getVariable ["RydHQ_Consistency",0.5];
_Activity = _HQ getVariable ["RydHQ_Activity",0.5];
_Reflex = _HQ getVariable ["RydHQ_Reflex",0.5];
_Circumspection = _HQ getVariable ["RydHQ_Circumspection",0.5];
_Fineness = _HQ getVariable ["RydHQ_Fineness",0.5];

switch (true) do
	{
	case ((not (_MAtt) and (_rnd < 10)) or ((_MAtt) and (_pers == "GENIUS"))) : 
		{
		_pers = "GENIUS";
		_Recklessness = 0.5;
		_Consistency = 1;
		_Activity = 1;
		_Reflex = 1;
		_Circumspection = 1;
		_Fineness = 1
		};
		
	case ((not (_MAtt) and ((_rnd >= 10) and (_rnd < 20))) or ((_MAtt) and (_pers == "IDIOT"))) : 
		{
		_pers = "IDIOT";
		_Recklessness = 1;
		_Consistency = 0;
		_Activity = 0;
		_Reflex = 0;
		_Circumspection = 0;
		_Fineness = 0
		};
		
	case ((not (_MAtt) and ((_rnd >= 20) and (_rnd < 30))) or ((_MAtt) and (_pers == "COMPETENT"))) : 
		{
		_pers = "COMPETENT";
		_Recklessness = 0.5;
		_Consistency = 0.5;
		_Activity = 0.5;
		_Reflex = 0.5;
		_Circumspection = 0.5;
		_Fineness = 0.5
		};
		
	case ((not (_MAtt) and ((_rnd >= 30) and (_rnd < 40))) or ((_MAtt) and (_pers == "EAGER"))) : 
		{
		_pers = "EAGER";
		_Recklessness = 1;
		_Consistency = 0;
		_Activity = 1;
		_Reflex = 1;
		_Circumspection = 0;
		_Fineness = 0
		};
		
	case ((not (_MAtt) and ((_rnd >= 40) and (_rnd < 50))) or ((_MAtt) and (_pers == "DILATORY"))) : 
		{
		_pers = "DILATORY";
		_Recklessness = 0;
		_Consistency = 1;
		_Activity = 0;
		_Reflex = 0;
		_Circumspection = 0.5;
		_Fineness = 0.5
		};
		
	case ((not (_MAtt) and ((_rnd >= 50) and (_rnd < 60))) or ((_MAtt) and (_pers == "SCHEMER"))) : 
		{
		_pers = "SCHEMER";
		_Recklessness = 0.5;
		_Consistency = 1;
		_Activity = 0;
		_Reflex = 0;
		_Circumspection = 1;
		_Fineness = 1
		};
		
	case ((not (_MAtt) and ((_rnd >= 60) and (_rnd < 70))) or ((_MAtt) and (_pers == "BRUTE"))) : 
		{
		_pers = "BRUTE";
		_Recklessness = 0.5;
		_Consistency = 1;
		_Activity = 1;
		_Reflex = 0.5;
		_Circumspection = 0;
		_Fineness = 0
		};
		
	case ((not (_MAtt) and ((_rnd >= 70) and (_rnd < 80))) or ((_MAtt) and (_pers == "CHAOTIC"))) : 
		{
		_pers = "CHAOTIC";
		_Recklessness = 0.5;
		_Consistency = 0;
		_Activity = 1;
		_Reflex = 1;
		_Circumspection = 0.5;
		_Fineness = 0.5
		};
		
	case (not (_MAtt)) :
		{
		_Recklessness = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_Consistency = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_Activity = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_Reflex = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_Circumspection = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_Fineness = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		};
	};
	
_HQ setVariable ["RydHQ_Recklessness",_Recklessness];
_HQ setVariable ["RydHQ_Consistency",_Consistency];
_HQ setVariable ["RydHQ_Activity",_Activity];
_HQ setVariable ["RydHQ_Reflex",_Reflex];
_HQ setVariable ["RydHQ_Circumspection",_Circumspection];
_HQ setVariable ["RydHQ_Fineness",_Fineness];

_HQ setVariable ["RydHQ_Personality",_pers];

if (_HQ getVariable ["RydHQ_Debug",false]) then {diag_log format ["Commander %8 (%7) - Recklessness: %1 Consistency: %2 Activity: %3 Reflex: %4 Circumspection: %5 Fineness: %6",_Recklessness,_Consistency,_Activity,_Reflex,_Circumspection,_Fineness,_pers,_signum]};
