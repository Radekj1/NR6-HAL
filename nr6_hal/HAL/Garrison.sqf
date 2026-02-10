_SCRname = "Garrison";
params ["_HQ","_recArr"];

_Garrison = _HQ getVariable ["RydHQ_Garrison",[]];
_garrRange = _HQ getVariable ["RydHQ_GarrRange",1];

{
	if (_x getVariable [("NOGarrisoned" + (str _x)),false]) then {_x setVariable [("Garrisoned" + (str _x)),false];_x setVariable [("NOGarrisoned" + (str _x)),false];_Garrison = _Garrison - [_x];};

} foreach _Garrison;

_HQ setVariable ["RydHQ_Garrison",_Garrison];

if (isNil "RydxHQ_GarrisonV2") then {RydxHQ_GarrisonV2 = false};

_posTaken = [];

for [{_a = 0},{_a < (count _Garrison)},{_a = _a + 1}] do
	{
	_unitG = _Garrison select _a;
	_garrisoned = _unitG getVariable ("Garrisoned" + (str _unitG));
	if (isNil "_garrisoned") then {_garrisoned = false};

	_NOgarrisoned = _unitG getVariable ("NOGarrisoned" + (str _unitG));
	if (isNil "_NOgarrisoned") then {_NOgarrisoned = false};

	_Unable = _unitG getvariable "Unable";
	if (isNil ("_Unable")) then {_Unable = false};


	if (not (_garrisoned) and not (_NOgarrisoned) and not (RydxHQ_GarrisonV2) and not (_Unable)) then
		{
		[_unitG] call RYD_WPdel;

		_unitG setVariable ["Garrisoned" + (str _unitG),true];

		_pos = getPosATL (vehicle (leader _unitG));
		_units = [];

		_UL = leader _unitG;
		_AV = assignedVehicle _UL;

		if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

		if ((_HQ getVariable ["RydHQ_Debug",false]) or (isPlayer (leader _unitG))) then 
			{
			_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
			_i = [_pos,_unitG,"markGarrison","ColorBrown","ICON","mil_box","Garr " + _signum," - GARRISON",[0.5,0.5]] call RYD_Mark;
			};

		if ((_HQ getVariable ["RydHQ_GarrVehAb",false]) and not (isPlayer (leader _unitG))) then
			{
			//{unassignVehicle _x} foreach (units _unitG);
			(units _unitG) orderGetIn false;
			(units _unitG) allowGetin false;//if (player in (units _unitG)) then {diag_log "NOT ALLOW garr"};
			sleep 5
			};

		if (not (isNull _AV) and not (_HQ getVariable ["RydHQ_GarrVehAb",false])) exitWith
			{
			_frm = "DIAMOND";
			if (isPlayer (leader _unitG)) then {_frm = formation _unitG};
			_wp = [_unitG,position (leader _unitG),"SENTRY","AWARE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],false,0,[0,0,0],_frm] call RYD_WPadd
			};

		_units = (units _unitG) - [leader _unitG]; 

		if not (isPlayer _UL) then
			{
			_list = _pos nearObjects ["StaticWeapon",300 * _garrRange];
			_staticWeapons = [];

				{
				if ((_x emptyPositions "gunner") > 0) then 
					{
					_staticWeapons pushBack _x;	
					};
				} 
			forEach _list;

				{
				if ((count _units) > 0) then 
					{
					_unit = (_units select ((count _units) - 1));

					if (((random 1) > 0.1) and not ((toLower (typeOf _unit)) in _recArr)) then 
						{
						_unit assignAsGunner _x;
						[_unit] orderGetIn true;
						
						_units resize ((count _units) - 1)
						}
					}
				} 
			forEach _staticWeapons;

			_Bldngs = _pos nearObjects ["House",300 * _garrRange];
			_posTaken = missionnamespace getvariable ["PosTaken",[]];
			_posAll = [];
			_posAll0 = [];

				{
				_Bldg = _x;
				if ((_Bldg distance _UL) > (300 * _garrRange)) then {_Bldg = ObjNull};

				if not (isNull _Bldg) then
					{
					_posAct = _Bldg buildingpos 0;
					_j = 0;	
					while {((_posAct distance [0,0,0]) > 0)} do
						{
						_tkn = false;

							{
							if ((typeName _x) == (typeName [])) then
								{
								if (((_x select 0) + (_x select 1)) == ((_posAct select 0) + (_posAct select 1))) exitWith {_tkn = true}
								}
							}
						foreach _posTaken;

						if not (_tkn) then
							{
							_tkn = false;
							_sum = (_posAct select 0) + (_posAct select 1);

								{
								if ((typeName _x) == (typeName [])) then
									{
									if (((_x select 0) + (_x select 1)) == _sum) exitWith {_tkn = true}
									}
								}
							foreach _posTaken;

							if not (_tkn) then 
								{
								_posAll pushBack [_posAct,_Bldg]
								}
							};
							
						_j = _j + 1;
						_posAct = _Bldg buildingpos _j;
						}
					}
				}
			foreach _Bldngs;

			_posAll0 = +_posAll;

				{
				_ix = 0;
				if not ((count _posAll) == 0) then
					{
					_ix = floor (random (count _posAll));
					_posS = _posAll select _ix;
					_posS params ["_posS","_bld"];
					_ct = 0;

					_posTaken = missionnamespace getVariable ["PosTaken",[]];

					while {((_posS in _posTaken) and (_ct < 20))} do
						{
						_ix = floor (random (count _posAll));
						_posS = _posAll select _ix;
						_ct = _ct + 1
						};

					if not ((_posS distance _pos) > (350 * _garrRange)) then
						{
						if ((random 100) > 20) then
							{
							_tkn = false;
							_sum = (_posS select 0) + (_posS select 1);

								{
								if ((typeName _x) == (typeName [])) then
									{
									if (((_x select 0) + (_x select 1)) == _sum) exitWith {_tkn = true}
									}
								}
							foreach _posTaken;

							if not (_tkn) then 
								{
								_posAll set [_ix,0];
								_posAll = _posAll - [0];
								_ix  = count _posTaken;
								_posTaken pushBack _posS;
								_posTaken = _posTaken - [0];
								missionnamespace setVariable ["PosTaken",_posTaken];
								[_x,_posS,_bld,[_posTaken,_ix],_HQ] call RYD_GarrS;
								_units = _units - [_x]
								}
							}
						}
					}
				}
			foreach _units;

			_patrolPos = [];

				{
				_pA = _x select 0;
				if ((typeName _pA) == (typeName [])) then
					{
					_isGood = true;
					if ((_pA select 2) > 16) then
						{
						_isGood = false
						};
						
					if (_isGood) then
						{								
						for "_i" from 0 to ((count _patrolPos) - 1) do
							{
							_pPos = _patrolPos select _i;
							_dst = _pPos distance _pA;
							if (_dst > 0.1) then
								{
								if (_dst < 16) then 
									{
									_isGood = false
									}
								};
							}
						};
						
					if (_isGood) then
						{
						_patrolPos pushBack _pA;
						}
					}
				}
			foreach _posAll0;
			
			if ((count _patrolPos) > 1) then 
				{
				[_unitG,_patrolPos,_HQ] call RYD_GarrP
				}
			else
				{
				_frm = "DIAMOND";
				if (isPlayer (leader _unitG)) then {_frm = formation _unitG};
				_wp = [_unitG,position (leader _unitG),"SENTRY","AWARE","YELLOW","NORMAL",["true","deletewaypoint [(group this), 0];"],false,0,[0,0,0],_frm] call RYD_WPadd;
				}
			}
		};

	if (not (_garrisoned) and not (_NOgarrisoned) and (RydxHQ_GarrisonV2) and not (_Unable)) then
		{

		_unitG setVariable ["Garrisoned" + (str _unitG),true];

		_objs = [(_HQ getVariable ["RydHQ_Taken",[]]),getPosATL (vehicle (leader _unitG)),500] call RYD_DistOrdC;

		_UL = leader _unitG;
		_AV = assignedVehicle _UL;
		_pos = getPosATL (vehicle (leader _unitG));
		
		if ((count _objs) > 0) then {_pos = getPosATL (_objs select 0)};

		if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_OrdConf,"OrdConf"] call RYD_AIChatter}};

		if (_unitG getVariable ["Busy" + (str _unitG),true]) then {
			_unitG setVariable ["Break",true];
			waitUntil {sleep 1; not (_unitG getVariable ["Break",false])};
		};

		[_unitG] call RYD_WPdel;

		if (_HQ getVariable ["RydHQ_Debug",false]) then 
			{
			_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
			_i = [_pos,_unitG,"markGarrison","ColorBlack","ICON","mil_box","GARR " + (groupId _unitG) + " " + _signum," - GARRISON",[0.5,0.5]] call RYD_Mark;
			};

		_task = [(leader _unitG),["Setup Garrison", "Setup a garrison and defend the area.", ""],(getPosATL (leader _unitG)),"defend"] call RYD_AddTask;

		[_unitG,_pos,150,1,0.5,0,false] remoteExecCall ["NR6_fnc_CBA_Defend",(leader _unitG)];
	
		}
	};

