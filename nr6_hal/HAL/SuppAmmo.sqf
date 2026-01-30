_SCRname = "SuppAmmo";

private ["_HQ","_ammo","_noenemy","_ammoS","_ammoSG","_Hollow","_soldiers","_ZeroA","_ammoN","_av","_MTrucks","_mtr","_unitvar","_busy","_Unable","_MTrucks2","_MTrucks3","_MTrucks2a","_MTrucks3a","_Zunits","_a",
	"_Zunit","_halfway","_distT","_eClose1","_eClose2","_UL","_Hunits","_MTruck","_Hunit","_ammoBox","_supported"];

_HQ = _this select 0;

_ammo = RHQ_Ammo + RYD_WS_ammo - RHQs_Ammo;

_noenemy = true;
	
_ammoS = [];
_ammoSG = [];

	{
	if not (_x in _ammoS) then
		{
		if ((toLower (typeOf (assignedvehicle _x))) in _ammo) then 
			{
			_ammoS pushBack _x;

			if not ((group _x) in (_ammoSG + (_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))) then 
				{
				_ammoSG pushBack (group _x)
				}
			}
		}
	}
foreach (_HQ getVariable ["RydHQ_Support",[]]);

	{
	if not (_x in _ammoSG) then
		{
		_ammoSG pushBack _x
		}
	}
foreach (_HQ getVariable ["RydHQ_AmmoDrop",[]]);

_HQ setVariable ["RydHQ_AmmoSupport",_ammoS];
_HQ setVariable ["RydHQ_AmmoSupportG",_ammoSG];

_Hollow = [];
_soldiers = [];
_ZeroA = [];

	{
	
	if not (isPlayer (leader _x)) then {

		_ammoN = 0;

			{
			_ammoN = _ammoN + (count (magazines _x))
			}
		foreach (units _x);

			{
			_av = assignedvehicle _x;

			if not (isNull _av) then
				{
				if not (someAmmo _av) then
					{
					if not (_av in _ZeroA) then
						{
						if not ((toLower (typeOf _av)) in ((_HQ getVariable ["RydHQ_NCVeh",[]]))) then
							{
							if (((getposATL _x) select 2) < 5) then 
								{
								_ZeroA pushBack _av
								}
							}
						}
					}
				};

			if ((vehicle _x) == _x) then
				{
				if (((_x ammo ((weapons _x) select 0)) == 0) or ((count (magazines _x)) < 2) or ((_ammoN/(((count (units (group _x))) + 0.1)) < (6/(((_HQ getVariable ["RydHQ_Recklessness",0.5])*2) + 1))))) then
					{
					if not (_x in _Hollow) then 
						{
						_Hollow pushBack _x; 
						if not (_x in _soldiers) then 
							{
							_soldiers pushBack _x
							}
						}
					}
				}
			}
		foreach (units _x)
		
	};
	}
foreach ((_HQ getVariable ["RydHQ_Friends",[]]) - (_HQ getVariable ["RydHQ_ExReAmmo",[]]));

//_Hollow = _Hollow + _ZeroA;
_HQ setVariable ["RydHQ_Hollow",_Hollow + _ZeroA];
_MTrucks = [];

	{
	_mtr = assignedVehicle (leader _x);

	if not (isNull _mtr) then
		{
		if (canMove _mtr) then
			{
			if ((fuel _mtr) > 0.2) then
				{
				_unitvar = str (_x);
				_busy = false;
				_busy = _x getvariable ("Busy" + _unitvar);
				if (isNil ("_busy")) then {_busy = false};

				_unable = false;
				_unable = _x getvariable "Unable";
				if (isNil ("_unable")) then {_unable = false};

				if (not (_busy) and not (_unable)) then
					{
					if not (_x in _MTrucks) then 
						{
						_MTrucks pushBack _x
						}
					}
				}
			}
		}
	}
foreach _ammoSG;

_MTrucks2 = [];
_MTrucks3 = [];

	{
	if (_x in (_HQ getVariable ["RydHQ_AmmoDrop",[]])) then
		{
		_MTrucks3 pushBack _x
		}
	else
		{
		_MTrucks2 pushBack _x
		}
	}
foreach _MTrucks;

_MTrucks2a = +_MTrucks2;
_MTrucks3a = +_MTrucks3;

_Zunits = +_ZeroA;
_a = 0;
for [{_a = 500},{_a <= 44000},{_a = _a + 500}] do
	{
		{
		_MTruck = assignedvehicle (leader _x);

		for [{_b = 0},{_b < (count _ZeroA)},{_b = _b + 1}] do 
			{
			_Zunit = _ZeroA select _b;		

				{
				if ((_Zunit distance (assignedvehicle (leader _x))) < 25) exitwith 
					{
					if not ((group _Zunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_ASupportedG",[]];
						_supported pushBack (group _Zunit);
						_HQ setVariable ["RydHQ_ASupportedG",_supported];
						//_HQ setVariable ["RydHQ_ASupportedG",(_HQ getVariable ["RydHQ_ASupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_ASupportedG",[]])),(group _Zunit)]]
						}
					};
				}
			foreach _ammoSG;
			
				{
				if ((_Zunit distance _x) < 25) exitwith 
					{
					if not ((group _Zunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) then 
						{
						_supported = _HQ getVariable ["RydHQ_ASupportedG",[]];
						_supported pushBack (group _Zunit);
						_HQ setVariable ["RydHQ_ASupportedG",_supported];
						//_HQ setVariable ["RydHQ_ASupportedG",(_HQ getVariable ["RydHQ_ASupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_ASupportedG",[]])),(group _Zunit)]]
						}
					};
				}
			foreach (_HQ getVariable ["RydHQ_AmmoPoints",[]]);
			
			_noenemy = true;

			_halfway = [(((position _MTruck) select 0) + ((position _Zunit) select 0))/2,(((position _MTruck) select 1) + ((position _Zunit) select 1))/2];
			_distT = 500/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
			_eClose1 = [_Zunit,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;
			_eClose2 = [_halfway,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;				
			if ((_eClose1) or (_eClose2)) then {_noenemy = false};
			if not ((group _Zunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) then
				{
				_UL = leader (group (assignedDriver _Zunit));
				if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_SuppReq,"SuppReq"] call RYD_AIChatter}};
				};
			
			if (not ((group _Zunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) and ((_Zunit distance _MTruck) <= _a) and (_noenemy) and (_x in _MTrucks)) then 
				{
				if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppAss,"SuppAss"] call RYD_AIChatter};
				_MTrucks2 = _MTrucks2 - [_x];
				_Zunits = _Zunits - [_Zunit];
				_supported = _HQ getVariable ["RydHQ_ASupportedG",[]];
				_supported pushBack (group _Zunit);
				_HQ setVariable ["RydHQ_ASupportedG",_supported];
				//_HQ setVariable ["RydHQ_ASupportedG",(_HQ getVariable ["RydHQ_ASupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_ASupportedG",[]])),(group _Zunit)]];
				//[_MTruck,_Zunit,_Hollow,_soldiers,false,objNull,_HQ] spawn HAL_GoAmmoSupp
				
				[[_MTruck,_Zunit,_Hollow,_soldiers,false,objNull,_HQ],HAL_GoAmmoSupp] call RYD_Spawn;
				}
			else
				{
				if (_a >= 44000) then 
					{
					if not ((group _Zunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppDen,"SuppDen"] call RYD_AIChatter}};
					_Zunits = _Zunits - [_Zunit]
					};
				};
			
			if (((count _MTrucks2) == 0) or ((count _Zunits) == 0)) exitwith {};
			};
			
		if (((count _MTrucks2) == 0) or ((count _Zunits) == 0)) exitwith {};
		}
	foreach _MTrucks2a;
	};

if ((count (_HQ getVariable ["RydHQ_AmmoBoxes",[]])) > 0) then
	{
	_Hunits = +_Hollow;

	for [{_a = 500},{_a < 44000},{_a = _a + 500}] do
		{
			{
			_MTruck = assignedvehicle (leader _x);
			
			for [{_b = 0},{_b < (count _Hollow)},{_b = _b + 1}] do 
				{
				_Hunit = _Hollow select _b;

					{
					if ((_Hunit distance (assignedvehicle (leader _x))) < 250) exitwith 
						{
						if not ((group _Hunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) then 
							{
							_supported = _HQ getVariable ["RydHQ_ASupportedG",[]];
							_supported pushBack (group _Hunit);
							_HQ setVariable ["RydHQ_ASupportedG",_supported];
							//_HQ setVariable ["RydHQ_ASupportedG",(_HQ getVariable ["RydHQ_ASupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_ASupportedG",[]])),(group _Hunit)]]
							}
						};
					}
				foreach _ammoSG;

					{
					if ((_Hunit distance _x) < 250) exitwith 
						{
						if not ((group _Hunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) then 
							{
							_supported = _HQ getVariable ["RydHQ_ASupportedG",[]];
							_supported pushBack (group _Hunit);
							_HQ setVariable ["RydHQ_ASupportedG",_supported];
							//_HQ setVariable ["RydHQ_ASupportedG",(_HQ getVariable ["RydHQ_ASupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_ASupportedG",[]])),(group _Hunit)]]
							}
						};
					}
				foreach (_HQ getVariable ["RydHQ_AmmoPoints",[]]);

				_noenemy = true;
				_halfway = [(((position _MTruck) select 0) + ((position _Hunit) select 0))/2,(((position _MTruck) select 1) + ((position _Hunit) select 1))/2];
				_distT = 300/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2));
				_eClose1 = [_Hunit,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;
				_eClose2 = [_halfway,(_HQ getVariable ["RydHQ_KnEnemiesG",[]]),_distT] call RYD_CloseEnemy;				
				if ((_eClose1) or (_eClose2)) then {_noenemy = false};

				if not ((group _Hunit) in ((_HQ getVariable ["RydHQ_ASupportedG",[]]) + (_HQ getVariable ["RydHQ_Boxed",[]]))) then
					{
					_UL = leader (group _Hunit);
					if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_SuppReq,"SuppReq"] call RYD_AIChatter}};
					};
			
				if (not ((group _Hunit) in ((_HQ getVariable ["RydHQ_ASupportedG",[]]) + (_HQ getVariable ["RydHQ_Boxed",[]]))) and ((_Hunit distance _MTruck) <= _a) and (_noenemy) and (_x in _MTrucks) and ((count (_HQ getVariable ["RydHQ_AmmoBoxes",[]])) > 0)) then 
					{
					if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppAss,"SuppAss"] call RYD_AIChatter};
					_MTrucks3 = _MTrucks3 - [_x];
					_Hunits = _Hunits - [_Hunit];
					
					_supported = _HQ getVariable ["RydHQ_ASupportedG",[]];
					_supported pushBack (group _Hunit);
					_HQ setVariable ["RydHQ_ASupportedG",_supported];
					
					//_HQ setVariable ["RydHQ_ASupportedG",(_HQ getVariable ["RydHQ_ASupportedG",[]]) set [(count (_HQ getVariable ["RydHQ_ASupportedG",[]])),(group _Hunit)]];
					_ammoBox = (_HQ getVariable ["RydHQ_AmmoBoxes",[]]) select 0;
					_HQ setVariable ["RydHQ_AmmoBoxes",(_HQ getVariable ["RydHQ_AmmoBoxes",[]]) - [_ammoBox]];
					//[_MTruck,_Hunit,_Hollow,_soldiers,true,_ammoBox,_HQ] spawn HAL_GoAmmoSupp; 
					[[_MTruck,_Hunit,_Hollow,_soldiers,true,_ammoBox,_HQ],HAL_GoAmmoSupp] call RYD_Spawn;
					}
				else
					{
					if (_a >= 44000) then 
						{
						if not ((group _Hunit) in (_HQ getVariable ["RydHQ_ASupportedG",[]])) then {if ((random 100) < RydxHQ_AIChatDensity) then {[(leader _HQ),RydxHQ_AIC_SuppDen,"SuppDen"] call RYD_AIChatter}};
						_Hunits = _Hunits - [_Hunit]
						};
					};				
				if (((count _MTrucks3) == 0) or ((count _Hunits) == 0)) exitwith {};
				};
				
			if (((count _MTrucks3) == 0) or ((count _Hunits) == 0)) exitwith {};
			}
		foreach _MTrucks3a
		}
	};