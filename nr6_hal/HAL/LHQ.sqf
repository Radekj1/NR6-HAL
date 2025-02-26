_SCRname = "LHQ";

_cycle = 0;

_HQ = _this select 0;
_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
_debug = _HQ getVariable ["RydHQ_Debug",false];

while {not (isNull _HQ)} do
	{
	_last = _HQ getVariable ["leaderHQ",objNull];
	if (isNil ("_last")) then {_last = objNull};
	sleep 0.2;
	if (isNull _HQ) exitWith {};
	if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {}; 
	_HQ setVariable ["leaderHQ",(leader _HQ)];

	if not (_last == (leader _HQ)) then
		{
		if not (isNull (leader _HQ)) then
			{
			if (alive (leader _HQ)) then
				{
				if not (isNull _HQ) then
					{
					if not (_cycle == (_HQ getVariable ["RydHQ_Cyclecount",0])) then
						{
						if not ((_HQ getVariable ["RydHQ_Cyclecount",0]) < 2) then 
							{
							RydxHQ_AllLeaders = RydxHQ_AllLeaders - [_last];
							RydxHQ_AllLeaders pushBack (leader _HQ);
							_cycle = (_HQ getVariable ["RydHQ_Cyclecount",0]);
							
							_Personality = _Personality + "-";
							_Recklessness = _Recklessness + (random 0.2);
							_Consistency = _Consistency - (random 0.2);
							_Activity = _Activity - (random 0.2);
							_Reflex = _Reflex - (random 0.2);
							_Circumspection = _Circumspection - (random 0.2);
							_Fineness = _Fineness - (random 0.2);
							
							if (_Recklessness > 1) then {_Recklessness = 1};
							if (_Recklessness < 0) then {_Recklessness = 0};
							
							if (_Consistency > 1) then {_Consistency = 1};
							if (_Consistency < 0) then {_Consistency = 0};
							
							if (_Activity > 1) then {_Activity = 1};
							if (_Activity < 0) then {_Activity = 0};
							
							if (_Reflex > 1) then {_Reflex = 1};
							if (_Reflex < 0) then {_Reflex = 0};
							
							if (_Circumspection > 1) then {_Circumspection = 1};
							if (_Circumspection < 0) then {_Circumspection = 0};
							
							if (_Fineness > 1) then {_Fineness = 1};
							if (_Fineness < 0) then {_Fineness = 0};
							
							_HQ setVariable ["RydHQ_Recklessness",_Recklessness];
							_HQ setVariable ["RydHQ_Consistency",_Consistency];
							_HQ setVariable ["RydHQ_Activity",_Activity];
							_HQ setVariable ["RydHQ_Reflex",_Reflex];
							_HQ setVariable ["RydHQ_Circumspection",_Circumspection];
							_HQ setVariable ["RydHQ_Fineness",_Fineness];

							[] spawn
								{
								sleep (60 + (random 120));
								_HQ setVariable ["RydHQ_Morale",(_HQ getVariable ["RydHQ_Morale",0]) - (10 + round (random 10))]
								}
							}
						}
					}
				}
			}
		};

	if (({alive _x} count (units _HQ)) == 0) exitWith 
		{
		RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ];
		};
	};

if (_debug) then 
	{
	hintSilent format ["HQ of %1 forces has been destroyed!",_signum]
	};