_SCRname = "SuppMed";

private ["_HQ","_med","_noenemy","_medS","_medSG","_medASG","_airMedAv","_landMedAv","_busy","_unable","_wounded","_Swounded","_Lwounded","_ambulances","_amb","_unitvar","_ambulances2","_SWunits","_a",
	"_SWunit","_halfway","_distT","_eClose1","_eClose2","_UL","_Wunits","_ambulance","_WUnit","_supported"];
params ["_HQ"];

_med = RHQ_Med + RYD_WS_med - RHQs_Med;
_noenemy = true;
	
_medS = [];
_medSG = [];
_medASG = [];

	{
	if not (_x in _medS) then
		{
		if ((toLower (typeOf (assignedvehicle _x))) in _med) then 
			{
			_medS pushBack _x;
			if not ((group _x) in _medSG) then 
				{
				_medSG pushBack _x
				};

			if not ((group _x) in (_medASG + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))) then
				{
				if (_x in (_HQ getVariable ["RydHQ_AirG",[]])) then 
					{
					_medASG pushBack (group _x)
					}
				}
			}
		}
	}
foreach (_HQ getVariable ["RydHQ_Support",[]]);

_HQ setVariable ["RydHQ_MedSupport",_medS];
_HQ setVariable ["RydHQ_MedSupportG",_medSG];
_HQ setVariable ["RydHQ_MedSupportAirG",_medASG];

_airMedAv = [];
_landMedAv = [];

	{
	_busy = _x getVariable ("Busy" + (str _x));
	if (isNil "_busy") then {_busy = false};
	_unable = false;
	_unable = _x getvariable "Unable";
	if (isNil ("_unable")) then {_unable = false};

	if not (_busy) and not (_unable) then {_airMedAv pushBack _x}
	}
foreach _medASG;

	{
	_busy = _x getVariable ("Busy" + (str _x));
	if (isNil "_busy") then {_busy = false};
	_unable = false;
	_unable = _x getvariable "Unable";
	if (isNil ("_unable")) then {_unable = false};

	if (not (_busy) and not (_unable)) then {_landMedAv pushBack _x}
	}
foreach (_medSG - _medASG);

_wounded = [];
_Swounded = [];
_Lwounded = [];

	{
	if not (isPlayer (leader _x)) then {
		{
		if ((vehicle _x) == _x) then
			{
			if ((damage _x) > 0.5) then
				{
				if ((damage _x) < 0.9) then 
					{
					_wounded pushBack _x
					};

				if (alive _x) then
					{
					if (((damage _x) > 0.75) or not (canStand _x)) then
						{
						_Swounded pushBack _x
						}
					}
				}
			}
		}
	foreach (units _x)
	};
	}
foreach ((_HQ getVariable ["RydHQ_Friends",[]]) - (_HQ getVariable ["RydHQ_ExMedic",[]]));

_Lwounded = _wounded - _Swounded;
_HQ setVariable ["RydHQ_Wounded",_wounded];
_ambulances = [];

	{
	_amb = assignedVehicle (leader _x);

	if not (isNull _amb) then
		{
		if (canMove _amb) then
			{
			if ((fuel _amb) > 0.2) then
				{
				_unitvar = str (_x);
				_busy = false;
				_busy = _x getvariable ("Busy" + _unitvar);
				if (isNil ("_busy")) then {_busy = false};

				if not (_busy) then
					{
					if not (_x in _ambulances) then 
						{
						_ambulances pushBack _x
						}
					}
				}
			}
		}
	}
foreach _medSG;

_ambulances2 = +_ambulances;
_SWunits = +_Swounded;
_a = 0;
for [{_a = 500},{_a <= 44000},{_a = _a + 500}] do
	{
		{
		_ambulance = assignedvehicle (leader _x);

		for [{_b = 0},{_b < (count _Swounded)},{_b = _b + 1}] do 
			{
			_SWunit = _Swounded select _b;

				{
				if ((_SWunit distance (assignedvehicle (leader _x))) < 125) exitwith 
					{
					if not ((group _SWunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_SupportedG",[]];
						_supported pushBack (group _SWunit);
						_HQ setVariable ["RydHQ_SupportedG",_supported];
						//_HQ setVariable ["RydHQ_SupportedG",(_HQ getVariable ["RydHQ_SupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_SupportedG",[]])),(group _SWunit)]]
						}
					};
				}
			foreach _medSG;

				{
				if ((_SWunit distance _x) < 125) exitwith 
					{
					if not ((group _SWunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_SupportedG",[]];
						_supported pushBack (group _SWunit);
						_HQ setVariable ["RydHQ_SupportedG",_supported];
						//_HQ setVariable ["RydHQ_SupportedG",(_HQ getVariable ["RydHQ_SupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_SupportedG",[]])),(group _SWunit)]]
						}
					};
				}
			foreach (_HQ getVariable ["RydHQ_MedPoints",[]]);

			_noenemy = true;
			_halfway = [(((position _ambulance) select 0) + ((position _SWunit) select 0))/2,(((position _ambulance) select 1) + ((position _SWunit) select 1))/2];
			_distT = 500/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
			_eClose1 = [_SWunit,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;
			_eClose2 = [_halfway,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;				
			if ((_eClose1) or (_eClose2)) then {_noenemy = false};

			if not ((group _SWunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then
				{
				_UL = leader (group _SWunit);
				if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_MedReq,"MedReq"] call RYD_AIChatter}};
				};				

			if (not ((group _SWunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) and ((_SWunit distance _ambulance) <= _a) and (_noenemy) and (_x in _ambulances)) then 
				{
				if ((_a > 1500) and ((count _airMedAv) > 0) and not (_x in _airMedAv)) exitwith {};
				if ((_a <= 1500) and ((count _landMedAv) > 0) and not (_x in _landMedAv)) exitwith {};
				if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppAss,"SuppAss"] call RYD_AIChatter};
				if (_x in _airMedAv) then {_airMedAv = _airMedAv - [_x]} else {_landMedAv = _landMedAv - [_x]};
				_ambulances = _ambulances - [_x];
				_SWunits = _SWunits - [_SWunit];
				
				_supported = _HQ getVariable ["RydHQ_SupportedG",[]];
				_supported pushBack (group _SWunit);
				_HQ setVariable ["RydHQ_SupportedG",_supported];
				
				//_HQ setVariable ["RydHQ_SupportedG",(_HQ getVariable ["RydHQ_SupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_SupportedG",[]])),(group _SWunit)]];
				[_ambulance,_SWunit,_wounded,_HQ] call HAL_GoMedSupp; 
				}
			else
				{
				if (_a >= 44000) then 
					{
					if not ((group _SWunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppDen,"SuppDen"] call RYD_AIChatter}};
					_SWunits = _SWunits - [_SWunit]
					};
				};
			
			if (((count _ambulances) == 0) or ((count _SWunits) == 0)) exitwith {};
			};
			
		if (((count _ambulances) == 0) or ((count _SWunits) == 0)) exitwith {};
		}
	foreach _ambulances2;
	};

_Wunits = +_wounded;

for [{_a = 500},{_a < 10000},{_a = _a + 500}] do
	{
		{
		_ambulance = assignedvehicle (leader _x);
		for [{_b = 0},{_b < (count _wounded)},{_b = _b + 1}] do 
			{
			_Wunit = _wounded select _b;

				{
				if ((_Wunit distance (assignedvehicle (leader _x))) < 250) exitwith 
					{
					if not ((group _Wunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_SupportedG",[]];
						_supported pushBack (group _Wunit);
						_HQ setVariable ["RydHQ_SupportedG",_supported];
						//_HQ setVariable ["RydHQ_SupportedG",(_HQ getVariable ["RydHQ_SupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_SupportedG",[]])),(group _Wunit)]]
						}
					};
				}
			foreach _medSG;

				{
				if ((_Wunit distance _x) < 250) exitwith 
					{
					if not ((group _Wunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_SupportedG",[]];
						_supported pushBack (group _Wunit);
						_HQ setVariable ["RydHQ_SupportedG",_supported];
						//_HQ setVariable ["RydHQ_SupportedG",(_HQ getVariable ["RydHQ_SupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_SupportedG",[]])),(group _Wunit)]]
						}
					};
				}
			foreach (_HQ getVariable ["RydHQ_MedPoints",[]]);

			_noenemy = true;
			_halfway = [(((position _ambulance) select 0) + ((position _Wunit) select 0))/2,(((position _ambulance) select 1) + ((position _Wunit) select 1))/2];
			_distT = 600/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
			_eClose1 = [_Wunit,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;
			_eClose2 = [_halfway,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;				
			if ((_eClose1) or (_eClose2)) then {_noenemy = false};

			if not ((group _Wunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then
				{
				_UL = leader (group _Wunit);
				if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_MedReq,"MedReq"] call RYD_AIChatter}};	
				};
			
			if (not ((group _Wunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) and ((_Wunit distance _ambulance) <= _a) and (_noenemy) and (_x in _ambulances)) then 
				{
				if ((_a > 2500) and ((count _airMedAv) > 0) and not (_x in _airMedAv)) exitwith {};
				if ((_a <= 2500) and ((count _landMedAv) > 0) and not (_x in _landMedAv)) exitwith {};
				if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppAss,"SuppAss"] call RYD_AIChatter};
				if (_x in _airMedAv) then {_airMedAv = _airMedAv - [_x]} else {_landMedAv = _landMedAv - [_x]};
				_ambulances = _ambulances - [_x];
				_Wunits = _Wunits - [_Wunit];
				
				_supported = _HQ getVariable ["RydHQ_SupportedG",[]];
				_supported pushBack (group _Wunit);
				_HQ setVariable ["RydHQ_SupportedG",_supported];
				
				//_HQ setVariable ["RydHQ_SupportedG",(_HQ getVariable ["RydHQ_SupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_SupportedG",[]])),(group _Wunit)]];
				[_ambulance,_Wunit,_wounded,_HQ] call HAL_GoMedSupp; 
				}
			else
				{
				if (_a >= 10000) then 
					{
					if not ((group _Wunit) in (_HQ getVariable ["RydHQ_SupportedG",[]])) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppDen,"SuppDen"] call RYD_AIChatter}};
					_Wunits = _Wunits - [_Wunit]
					};
				};
			
			if (((count _ambulances) == 0) or ((count _Wunits) == 0)) exitwith {};
			};
			
		if (((count _ambulances) == 0) or ((count _Wunits) == 0)) exitwith {};
		}
	foreach _ambulances2;
	};

