_SCRname = "SuppFuel";

private ["_HQ","_fuel","_noenemy","_fuelS","_fuelSG","_dried","_ZeroF","_av","_cisterns","_cis","_unitvar","_busy","_unable","_cisterns2","_Zunits","_a","_cistern","_Zunit","_noenemy","_halfway","_distT",
	"_eClose1","_eClose2","_UL","_Dunits","_Dunit","_supported"];

_HQ = _this select 0;

_fuel = RHQ_Fuel + RYD_WS_fuel - RHQs_Fuel;
_noenemy = true;
	
_fuelS = [];
_fuelSG = [];

	{
	if not (_x in _fuelS) then
		{
		if ((toLower (typeOf (assignedVehicle _x))) in _fuel) then 
			{
			_fuelS pushBack _x;
			if not ((group _x) in (_fuelSG + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))) then 
				{
				_fuelSG pushBack (group _x)
				}
			}
		}
	}
forEach (_HQ getVariable ["RydHQ_Support",[]]);

_HQ setVariable ["RydHQ_FuelSupport",_fuelS];
_HQ setVariable ["RydHQ_FuelSupportG",_fuelSG];

_dried = [];
_ZeroF = [];

	{
	if not (isPlayer (leader _x)) then {
		{
		_av = assignedVehicle _x;
		if not (isNull _av) then
			{
			if ((fuel _av) <= 0.1) then
				{
				if not (_av in _dried) then
					{
					if (((getPosATL _x) select 2) < 5) then 
						{
						_dried pushBack (assignedVehicle _x)
						}
					}
				}
			};

		if not (isNull _av) then
			{
			if ((fuel _av) == 0) then
				{
				if not (_av in _ZeroF) then
					{
					if (((getPosATL _x) select 2) < 5) then 
						{
						_ZeroF pushBack (assignedVehicle _x)
						}
					}
				}
			}
		}
	forEach (units _x)
	};
	}
forEach ((_HQ getVariable ["RydHQ_Friends",[]]) - (_HQ getVariable ["RydHQ_ExRefuel",[]]));

_HQ setVariable ["RydHQ_Dried",_dried];
_cisterns = [];


	{
	_cis = assignedVehicle (leader _x);

	if not (isNull _cis) then
		{
		if (canMove _cis) then
			{
			if ((fuel _cis) > 0.2) then
				{
				_unitvar = str (_x);
				_busy = false;
				_busy = _x getVariable ("Busy" + _unitvar);
				if (isNil ("_busy")) then {_busy = false};

				_unable = false;
				_unable = _x getVariable "Unable";
				if (isNil ("_unable")) then {_unable = false};

				if (not (_busy) and not (_unable)) then
					{
					if not (_x in _cisterns) then 
						{
						_cisterns pushBack _x
						}
					}
				}
			}
		}
	}
forEach _fuelSG;

_cisterns2 = +_cisterns;
_Zunits = +_ZeroF;
_a = 0;
for [{_a = 500},{_a <= 44000},{_a = _a + 500}] do
	{
		{
		_cistern = assignedVehicle (leader _x);

		for [{_b = 0},{_b < (count _ZeroF)},{_b = _b + 1}] do 
			{
			_Zunit = _ZeroF select _b;

				{
				if ((_Zunit distance (assignedVehicle (leader _x))) < 300) exitWith 
					{
					if not ((group _Zunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_FSupportedG",[]];
						_supported pushBack (group _Zunit);
						_HQ setVariable ["RydHQ_FSupportedG",_supported];
						//_HQ setVariable ["RydHQ_FSupportedG",(_HQ getVariable ["RydHQ_FSupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_FSupportedG",[]])),(group _Zunit)]]
						}
					};
				}
			forEach _fuelSG;

				{
				if ((_Zunit distance _x) < 300) exitWith 
					{
					if not ((group _Zunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_FSupportedG",[]];
						_supported pushBack (group _Zunit);
						_HQ setVariable ["RydHQ_FSupportedG",_supported];
						//_HQ setVariable ["RydHQ_FSupportedG",(_HQ getVariable ["RydHQ_FSupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_FSupportedG",[]])),(group _Zunit)]]
						}
					};
				}
			forEach (_HQ getVariable ["RydHQ_FuelPoints",[]]);

			_noenemy = true;
			_halfway = [(((position _cistern) select 0) + ((position _Zunit) select 0))/2,(((position _cistern) select 1) + ((position _Zunit) select 1))/2];
			_distT = 500/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
			_eClose1 = [_Zunit,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;
			_eClose2 = [_halfway,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;				
			if ((_eClose1) or (_eClose2)) then {_noenemy = false};
			
			if not ((group _Zunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then
				{
				_UL = leader (group (assignedDriver _Zunit));
				if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_SuppReq,"SuppReq"] call RYD_AIChatter}};
				};

			if (not ((group _Zunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) and ((_Zunit distance _cistern) <= _a) and (_noenemy) and (_x in _cisterns)) then 
				{
				if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppAss,"SuppAss"] call RYD_AIChatter};
				_cisterns = _cisterns - [_x];
				_Zunits = _Zunits - [_Zunit];
				
				_supported = _HQ getVariable ["RydHQ_FSupportedG",[]];
				_supported pushBack (group _Zunit);
				_HQ setVariable ["RydHQ_FSupportedG",_supported];
				
				//_HQ setVariable ["RydHQ_FSupportedG",(_HQ getVariable ["RydHQ_FSupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_FSupportedG",[]])),(group _Zunit)]];
				//[_cistern,_Zunit,_dried,_HQ] spawn HAL_GoFuelSupp;
				[[_cistern,_Zunit,_dried,_HQ],HAL_GoFuelSupp] call RYD_Spawn;
				}
			else
				{
				if (_a >= 44000) then 
					{
					if not ((group _Zunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppDen,"SuppDen"] call RYD_AIChatter}};
					_Zunits = _Zunits - [_Zunit]
					};
				};
			
			if (((count _cisterns) == 0) or ((count _Zunits) == 0)) exitWith {};
			};
			
		if (((count _cisterns) == 0) or ((count _Zunits) == 0)) exitWith {};
		}
	forEach _cisterns2;
	};

_Dunits = +_dried;

for [{_a = 500},{_a < 10000},{_a = _a + 500}] do
	{
		{
		_cistern = assignedVehicle (leader _x);
		for [{_b = 0},{_b < (count _dried)},{_b = _b + 1}] do 
			{
			_Dunit = _dried select _b;

				{
				if ((_Dunit distance (assignedVehicle (leader _x))) < 400) exitWith 
					{
					if not ((group _Dunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_FSupportedG",[]];
						_supported pushBack (group _Dunit);
						_HQ setVariable ["RydHQ_FSupportedG",_supported];
						//_HQ setVariable ["RydHQ_FSupportedG",(_HQ getVariable ["RydHQ_FSupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_FSupportedG",[]])),(group _Dunit)]]
						}
					};
				}
			forEach _fuelSG;

				{
				if ((_Dunit distance _x) < 400) exitWith 
					{
					if not ((group _Dunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_FSupportedG",[]];
						_supported pushBack (group _Dunit);
						_HQ setVariable ["RydHQ_FSupportedG",_supported];
						//_HQ setVariable ["RydHQ_FSupportedG",(_HQ getVariable ["RydHQ_FSupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_FSupportedG",[]])),(group _Dunit)]]
						}
					};
				}
			forEach (_HQ getVariable ["RydHQ_FuelPoints",[]]);

			_noenemy = true;
			_halfway = [(((position _cistern) select 0) + ((position _Dunit) select 0))/2,(((position _cistern) select 1) + ((position _Dunit) select 1))/2];
			_distT = 600/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
			_eClose1 = [_Dunit,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;
			_eClose2 = [_halfway,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;				
			if ((_eClose1) or (_eClose2)) then {_noenemy = false};

			if not ((group _Dunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then
				{
				_UL = leader (group (assignedDriver _Dunit));
				if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_SuppReq,"SuppReq"] call RYD_AIChatter}};
				};
			
			if (not ((group _Dunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) and ((_Dunit distance _cistern) <= _a) and (_noenemy) and (_x in _cisterns)) then 
				{
				if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppAss,"SuppAss"] call RYD_AIChatter};
				_cisterns = _cisterns - [_x];
				_Dunits = _Dunits - [_Dunit];
				
				_supported = _HQ getVariable ["RydHQ_FSupportedG",[]];
				_supported pushBack (group _Dunit);
				_HQ setVariable ["RydHQ_FSupportedG",_supported];
				
				//_HQ setVariable ["RydHQ_FSupportedG",(_HQ getVariable ["RydHQ_FSupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_FSupportedG",[]])),(group _Dunit)]];
				//[_cistern,_Dunit,_dried,_HQ] spawn HAL_GoFuelSupp; 
				[[_cistern,_Dunit,_dried,_HQ],HAL_GoFuelSupp] call RYD_Spawn;
				}
			else
				{
				if (_a >= 10000) then 
					{
					if not ((group _Dunit) in (_HQ getVariable ["RydHQ_FSupportedG",[]])) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppDen,"SuppDen"] call RYD_AIChatter}};
					_Dunits = _Dunits - [_Dunit]
					};
				};
			
			if (((count _cisterns) == 0) or ((count _Dunits) == 0)) exitWith {};
			};
			
		if (((count _cisterns) == 0) or ((count _Dunits) == 0)) exitWith {};
		}
	forEach _cisterns2;
	};
