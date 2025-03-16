//Originally from HAC_fnc2
#include "..\script_component.hpp"
RYD_StatusQuo =
	{
	//_SCRname = "SQ";
	_orderFirst = _HQ getVariable "RydHQ_Orderfirst";

	private ["_SidePLY","_IgnoredPLY","_RydMarks","_MarkGrps","_checkFriends"];

	if (isNil ("_orderFirst")) then
		{
		_HQ setVariable ["RydHQ_Orderfirst",true];
		_HQ setVariable ["RydHQ_FlankReady",false];
		};

	if (_cycleC > 1) then
		{
		if not (_HQ getVariable ["RydHQ_ResetOnDemand",false]) then
			{
			if ((time - _lastReset) > (_HQ getVariable ["RydHQ_ResetTime",600])) then
				{
				_lastReset = time;
				[_HQ] call FUNC(HQReset)
				}
			}
		else
			{
			_code =
				{
				params ["_HQ"];
					[{
					[{((_HQ getVariable ["RydHQ_ResetNow",false]) or (_HQ getVariable ["RydHQ_KIA",false]))
					}, 1] call CBA_fnc_waitAndExecute;
					}, 
					{
					_HQ setVariable ["RydHQ_ResetNow",false];
					[_HQ] call FUNC(HQReset)
					}] call CBA_fnc_waitUntilAndExecute;
				};
			[[_HQ],_code] call FUNC(Spawn);
			};

		};

	_HQ setVariable ["RydHQ_Friends",[]];
	_HQ setVariable ["RydHQ_Enemies",[]];
	_HQ setVariable ["RydHQ_KnEnemies",[]];
	_HQ setVariable ["RydHQ_KnEnemiesG",[]];
	_HQ setVariable ["RydHQ_FValue",0];
	_HQ setVariable ["RydHQ_EValue",0];

	_FValue = 0;
	_EValue = 0;

	if (RydxHQ_AIChatDensity > 0) then
		{
		_varName1 = "HAC_AIChatRep";
		_varName2 = "_West";

		switch ((side _HQ)) do
			{
			case (east) : {_varName2 = "_East"};
			case (resistance) : {_varName2 = "_Guer"};
			};

		missionNamespace setVariable [_varName1 + _varName2,0];

		_varName1 = "HAC_AIChatLT";

		missionNamespace setVariable [_varName1 + _varName2,[0,""]]
		};

	_HQ setVariable ["RydHQ_LastSub",_HQ getVariable ["RydHQ_Subordinated",[]]];
	_HQ setVariable ["RydHQ_Subordinated",[]];

	_enemies = _HQ getVariable ["RydHQ_Enemies",[]];
	_friends = _HQ getVariable ["RydHQ_Friends",[]];

		{
		_isCaptive = _x getVariable ("isCaptive" + (str _x));
		if (isNil "_isCaptive") then {_isCaptive = false};

		if not (_isCaptive) then
			{
			_isCaptive = captive (leader _x)
			};

		_isCiv = false;
		if ((faction (leader _x)) in _civF) then
			{
			_isCiv = true
			}
		else
			{
			if ((side _x) in [civilian]) then
				{
				_isCiv = true
				}
			};

		if not ((isNull ((_HQ getVariable ["leaderHQ",(leader _HQ)]))) and {not (isNull _x) and {(alive ((_HQ getVariable ["leaderHQ",(leader _HQ)]))) and {(alive (leader _x)) and {not (_isCaptive)}}}}) then
			{
			if (not ((_HQ getVariable ["RydHQ_FrontA",false])) and {((side _x) getFriend (side _HQ) < 0.6) and {not (_isCiv)}}) then
				{
				if not (_x in _enemies) then
					{
					_enemies pushBack _x
					}
				};

			_front = true;
			_fr = _HQ getVariable ["RydHQ_Front",locationNull];
			if not (isNull _fr) then
				{
				_front = ((getPosATL (vehicle (leader _x))) in _fr)
				};

			if ((_HQ getVariable ["RydHQ_FrontA",false]) and {((side _x) getFriend (side _HQ) < 0.6) and {(_front) and {not (_isCiv)}}}) then
				{
				if not (_x in _enemies) then
					{
					_enemies pushBack _x;
					}
				};

			if ((_HQ getVariable ["RydHQ_SubAll",true])) then
				{
				if not ((side _x) getFriend (side _HQ) < 0.6) then
					{
					if (not (_x in _friends) and {not (((leader _x) in (_HQ getVariable ["RydHQ_Excluded",[]])) or {(_isCiv)})}) then
						{
						_friends pushBack _x
						}
					};
				};
			}
		}
	forEach allGroups;

	_HQ setVariable ["RydHQ_Enemies",_enemies];

	_excl = [];
		{
		_excl pushBack _x
		}
		forEach (_HQ getVariable ["RydHQ_Excluded",[]]);

	_HQ setVariable ["RydHQ_Excl",_excl];

	_subOrd = [];

	if (_HQ getVariable ["RydHQ_SubSynchro",false]) then
		{
			{
			if ((_x in (_HQ getVariable ["RydHQ_LastSub",[]])) and {not ((leader _x) in (synchronizedObjects (_HQ getVariable ["leaderHQ",(leader _HQ)]))) and {(_HQ getVariable ["RydHQ_SubSynchro",false])}}) then
				{
				_subOrd pushBack _x
				};

			if (not (_x in _subOrd) and {(({(_x in (synchronizedObjects (_HQ getVariable ["leaderHQ",(leader _HQ)])))} count (units _x)) > 0)}) then
				{
				_subOrd pushBack _x
				};
			}
		forEach allGroups;
		};

	if (_HQ getVariable ["RydHQ_SubNamed",false]) then
		{
		_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
		if (_signum in ["A","X"]) then {_signum = ""};

			{
			for [{_i = 1},{_i <= (_HQ getVariable ["RydHQ_NameLimit",100])},{_i = _i + 1}] do
				{
				if (not (_x in _subOrd) and {((str (leader _x)) == ("Ryd" + _signum + str (_i)))}) then
					{
					_subOrd pushBack _x
					};
				};
			}
		forEach allGroups;
		};

	_HQ setVariable ["RydHQ_Subordinated",_subOrd];

	_friends = _friends + _subOrd + (_HQ getVariable ["RydHQ_Included",[]]) - ((_HQ getVariable ["RydHQ_Excluded",[]]) + _excl + [_HQ]);
	_HQ setVariable ["RydHQ_NoWayD",allGroups - (_HQ getVariable ["RydHQ_LastFriends",[]])];

	_channel = _HQ getVariable ["RydHQ_myChannel",-1];

	if not (_channel < 0) then
		{
		_channel radioChannelRemove ((allUnits - (units _HQ)) + allDeadMen);
		_toAdd = [];

			{
				{
				if (isPlayer _x) then
					{
					_toAdd pushBack _x
					}
				}
			forEach (units _x)
			}
		forEach _friends;

		_channel radioChannelAdd _toAdd
		};

	_checkFriends = _friends;

	{
		if ((({alive _x} count (units _x)) == 0) or (_x == grpNull)) then {_friends = _friends - [_x]};
	} forEach _checkFriends;

	_friends = [_friends] call RYD_RandomOrd;

	_HQ setVariable ["RydHQ_Friends",_friends];

		{
		[_x] call CBA_fnc_clearWaypoints;
		}
	forEach (((_HQ getVariable ["RydHQ_Excluded",[]]) + _excl) - (_HQ getVariable ["RydHQ_NoWayD",[]]));

	if (_HQ getVariable ["RydHQ_Init",true]) then
		{
			{
			_cInitial = _cInitial + (count (units _x));
			if (RydHQ_CamV) then
				{

					{
					if (_x in ([player] + (switchableUnits - [player]))) then {[_x,_HQ] call RYD_LiveFeed}
					}
				forEach (units _x)
				}
			}
		forEach (_friends + [_HQ])
		};

	_HQ setVariable ["RydHQ_CInitial",_cInitial];

	_HQ setVariable ["RydHQ_CLast",(_HQ getVariable ["RydHQ_CCurrent",0])];
	_CLast = (_HQ getVariable ["RydHQ_CCurrent",0]);
	_CCurrent = 0;

		{
		_CCurrent = _CCurrent + (count (units _x))
		}
	forEach (_friends + [_HQ]);

	_HQ setVariable ["RydHQ_CCurrent",_CCurrent];

	_Ex = [];

	if (_HQ getVariable ["RydHQ_ExInfo",false]) then
		{
		_Ex = _excl + (_HQ getVariable ["RydHQ_Excluded",[]])
		};

	_knownE = [];
	_knownEG = [];

		{
		for [{_a = 0},{_a < count (units _x)},{_a = _a + 1}] do
			{
			_enemyU = vehicle ((units _x) select _a);

				{
				if (((_x knowsAbout _enemyU) >= 0.05) and not (_x getVariable ["Ryd_NoReports",false])) exitWith
					{
					if not (_enemyU in _knownE) then
						{
						_knownE pushBack _enemyU;
						(vehicle _enemyU) setVariable ["RydHQ_MyFO",(leader _x)];
						};

					if not ((group _enemyU) in _knownEG) then
						{
						_already = missionNamespace getVariable ["AlreadySpotted",[]];
						_knownEG pushBack (group _enemyU);
						if not ((group _enemyU) in _already) then
							{
							_UL = (leader _x);if not (isPlayer _UL) then {if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_EnemySpot,"EnemySpot"] call RYD_AIChatter}};
							}
						}
					}
				}
			forEach (_friends + [_HQ] + _Ex)
			}
		}
	forEach _enemies;

	_alwaysKn = ((_HQ getVariable ["RydHQ_AlwaysKnownU",[]]) - (_HQ getVariable ["RydHQ_AlwaysUnKnownU",[]])) - _knownE;

	_knownE = (_knownE + _alwaysKn) - (_HQ getVariable ["RydHQ_AlwaysUnKnownU",[]]);

		{
		_gp = group _x;
		if not (_gp in _knownEG) then {_knownEG pushBack _gp};
		}
	forEach _alwaysKn;

	_HQ setVariable ["RydHQ_KnEnemies",_knownE];
	_HQ setVariable ["RydHQ_KnEnemiesG",_knownEG];
	_HQ setVariable ["RydHQ_Ex",_Ex];

	[_HQ] spawn HAL_EBFT;

	_already = missionNamespace getVariable ["AlreadySpotted",[]];

		{
		if not (_x in _already) then
			{
			_already pushBack _x
			}
		}
	forEach _knownEG;

	missionNamespace setVariable ["AlreadySpotted",_already];

	_lossFinal = _cInitial - _CCurrent;

	if (_lossFinal < 0) then
		{
		_lossFinal = 0;
		_cInitial = _CCurrent;
		_HQ setVariable ["RydHQ_CInitial",_CCurrent];
		};

	_morale = _HQ getVariable ["RydHQ_Morale",0];

	if not (_HQ getVariable ["RydHQ_Init",true]) then
		{
		_lossP = _lossFinal/_cInitial;

		_HQ setVariable ["RydHQ_LTotal",_lossP];

		_lostU = _CLast - _CCurrent;

		if not (_lostU == 0) then
			{
			_lossArr = _HQ getVariable ["RydHQ_LossArr",[]];
			_lossArr pushBack [_lostU,time];

			if ((count _lossArr) > 200) then
				{
				_lossArr set [0,0];
				_lossArr = _lossArr - [0];
				};

			_HQ setVariable ["RydHQ_LossArr",_lossArr]
			};

		_lossWeight = 0;

			{
			_loss = _x select 0;
			_when = _x select 1;
			_age = ((time - _when)/30) max 6;

			_lossWeight = _lossWeight + ((_loss/(_age^1.15)) * (0.75 + (random 0.125) + (random 0.125) + (random 0.125) + (random 0.125)))
			}
		forEach (_HQ getVariable ["RydHQ_LossArr",[]]);

		_balanceF = (((random 5) + (random 5))/((1 + _lossP)^2)) - ((random 1) + (random 1)) - (((random 1.5) + (random 1.5)) * ((count _knownE)/_CCurrent));

		//diag_log format ["balance: %1 lossweight: %2 morale: %3",_balanceF,_lossWeight,_morale];

		_morale = _morale + ((_balanceF - _lossWeight)/(_HQ getVariable ["RydHQ_MoraleConst",1]));

		if (_lossP > (0.4 + (random 0.2))) then
			{
			_diff = ((-_morale)/50) - _lossP;
			if (_diff > 0) then
				{
				_morale = _morale - ((random (_diff * 10))/(_HQ getVariable ["RydHQ_MoraleConst",1]))
				}
			};
		};

	if (_morale < -50) then {_morale = -50};
	if (_morale > 0) then {_morale = 0};

	_HQ setVariable ["RydHQ_Morale",_morale];

	_HQ setVariable ["RydHQ_TotalLossP",(round (((_lossFinal/_cInitial) * 100) * 10)/10)];

	if (_HQ getVariable ["RydHQ_Debug",false]) then
		{
		_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
		_mdbg = format ["Morale %5 (%2): %1 - losses: %3 percent (%4)",_morale,(_HQ getVariable ["RydHQ_Personality","OTHER"]),(round (((_lossFinal/_cInitial) * 100) * 10)/10),_lossFinal,_signum];
		diag_log _mdbg;
		(_HQ getVariable ["leaderHQ",(leader _HQ)]) globalChat _mdbg;

		_cl = "<t color='#007f00'>%4 -> M: %1 - L: %2%3</t>";

		switch (side _HQ) do
			{
			case (west) : {_cl = "<t color='#0d81c4'>%4 -> M: %1 - L: %2%3</t>"};
			case (east) : {_cl = "<t color='#ff0000'>%4 -> M: %1 - L: %2%3</t>"};
			};

		_dbgMon = parseText format [_cl,(round (_morale * 10))/10,(round (((_lossFinal/_cInitial) * 100) * 10)/10),"%",_signum];

		_HQ setVariable ["DbgMon",_dbgMon];
		};

	_HQ setVariable ["RydHQ_Init",false];

		{
			{
			_SpecForcheck = false;
			_reconcheck = false;
			_FOcheck = false;
			_sniperscheck = false;
			_ATinfcheck = false;
			_AAinfcheck = false;
			_Infcheck = false;
			_Artcheck = false;
			_HArmorcheck = false;
			_MArmorcheck = false;
			_LArmorcheck = false;
			_LArmorATcheck = false;
			_Carscheck = false;
			_Aircheck = false;
			_BAircheck = false;
			_RAircheck = false;
			_NCAircheck = false;
			_Navalcheck = false;
			_Staticcheck = false;
			_StaticAAcheck = false;
			_StaticATcheck = false;
			_Supportcheck = false;
			_Cargocheck = false;
			_NCCargocheck = false;
			_Othercheck = true;

			_Crewcheck = false;
			_NCrewInfcheck = false;

			_tp = toLower (typeOf _x);
			_grp = group _x;
			_vh = vehicle _x;
			if (_x == _vh) then {_vh = objNull};
			_asV = assignedVehicle _x;
			_grpD = group (driver _vh);
			_grpG = group (gunner _vh);
			if (isNull _grpD) then {_grpD = _grpG};
			_Tvh = toLower (typeOf _vh);
			_TasV = toLower (typeOf _asV);

				if (((_grp == _grpD) and {(_Tvh in _specFor_class)}) or {(_tp in _specFor_class)}) then {_SpecForcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _recon_class)}) or {(_tp in _recon_class)}) then {_reconcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _FO_class)}) or {(_tp in _FO_class)}) then {_FOcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _snipers_class)}) or {(_tp in _snipers_class)}) then {_sniperscheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _ATinf_class)}) or {(_tp in _ATinf_class)}) then {_ATinfcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _AAinf_class)}) or {(_tp in _AAinf_class)}) then {_AAinfcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Inf_class)}) or {(_tp in _Inf_class)}) then {_Infcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Art_class)}) or {(_tp in _Art_class)}) then {_Artcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _HArmor_class)}) or {(_tp in _HArmor_class)}) then {_HArmorcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _MArmor_class)}) or {(_tp in _MArmor_class)}) then {_MArmorcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _LArmor_class)}) or {(_tp in _LArmor_class)}) then {_LArmorcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _LArmorAT_class)}) or {(_tp in _LArmorAT_class)}) then {_LArmorATcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Cars_class)}) or {(_tp in _Cars_class)}) then {_Carscheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Air_class)}) or {(_tp in _Air_class)}) then {_Aircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _BAir_class)}) or {(_tp in _BAir_class)}) then {_BAircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _RAir_class)}) or {(_tp in _RAir_class)}) then {_RAircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _NCAir_class)}) or {(_tp in _NCAir_class)}) then {_NCAircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Naval_class)}) or {(_tp in _Naval_class)}) then {_Navalcheck = true;_Othercheck = false};
				if (((_grp == _grpG) and {(_Tvh in _Static_class)}) or {(_tp in _Static_class)}) then {_Staticcheck = true;_Othercheck = false};
				if (((_grp == _grpG) and {(_Tvh in _StaticAA_class)}) or {(_tp in _StaticAA_class)}) then {_StaticAAcheck = true;_Othercheck = false};
				if (((_grp == _grpG) and {(_Tvh in _StaticAT_class)}) or {(_tp in _StaticAT_class)}) then {_StaticATcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Cargo_class)}) or {(_tp in _Cargo_class)}) then {_Cargocheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _NCCargo_class)}) or {(_tp in _NCCargo_class)}) then {_NCCargocheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Crew_class)}) or {(_tp in _Crew_class)}) then {_Crewcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _NCrewInf_class)}) or {(_tp in _NCrewInf_class)}) then {_NCrewInfcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Support_class)}) or {(_tp in _Support_class)}) then {_Supportcheck = true;_NCrewInfcheck = false;_Othercheck = false};

				if ((_Tvh in _NCCargo_class) and {(_x == (assignedDriver _asV)) and {((count (units (group _x))) == 1) and {not ((_ATinfcheck) or {(_AAinfcheck) or {(_reconcheck) or {(_FOcheck) or {(_sniperscheck)}}}})}}}) then {_NCrewInfcheck = false;_Othercheck = false};

				_vh = vehicle _x;

				if (_SpecForcheck) then {if not (_vh in _SpecFor) then {_SpecFor pushBack _vh};if not (_grp in _SpecForG) then {_SpecForG pushBack _grp}};
				if (_reconcheck) then {if not (_vh in _recon) then {_recon pushBack _vh};if not (_grp in _reconG) then {_reconG pushBack _grp}};
				if (_FOcheck) then {if not (_vh in _FO) then {_FO pushBack _vh};if not (_grp in _FOG) then {_FOG pushBack _grp}};
				if (_sniperscheck) then {if not (_vh in _snipers) then {_snipers pushBack _vh};if not (_grp in _snipersG) then {_snipersG pushBack _grp}};
				if (_ATinfcheck) then {if not (_vh in _ATinf) then {_ATinf pushBack _vh};if not (_grp in _ATinfG) then {_ATinfG pushBack _grp}};
				if (_AAinfcheck) then {if not (_vh in _AAinf) then {_AAinf pushBack _vh};if not (_grp in _AAinfG) then {_AAinfG pushBack _grp}};
				if (_Infcheck) then {if not (_vh in _Inf) then {_FValue = _FValue + 1;_Inf pushBack _vh};if not (_grp in _InfG) then {_InfG pushBack _grp}};
				if (_Artcheck) then {if not (_vh in _Art) then {_FValue = _FValue + 3;_Art pushBack _vh};if not (_grp in _ArtG) then {_ArtG pushBack _grp}};
				if (_HArmorcheck) then {if not (_vh in _HArmor) then {_FValue = _FValue + 10;_HArmor pushBack _vh};if not (_grp in _HArmorG) then {_HArmorG pushBack _grp}};
				if (_MArmorcheck) then {if not (_vh in _MArmor) then {_MArmor pushBack _vh};if not (_grp in _MArmorG) then {_MArmorG pushBack _grp}};
				if (_LArmorcheck) then {if not (_vh in _LArmor) then {_FValue = _FValue + 5;_LArmor pushBack _vh};if not (_grp in _LArmorG) then {_LArmorG pushBack _grp}};
				if (_LArmorATcheck) then {if not (_vh in _LArmorAT) then {_LArmorAT pushBack _vh};if not (_grp in _LArmorATG) then {_LArmorATG pushBack _grp}};
				if (_Carscheck) then {if not (_vh in _Cars) then {_FValue = _FValue + 3;_Cars pushBack _vh};if not (_grp in _CarsG) then {_CarsG pushBack _grp}};
				if (_Aircheck) then {if not (_vh in _Air) then {_FValue = _FValue + 15;_Air pushBack _vh};if not (_grp in _AirG) then {_AirG pushBack _grp}};
				if (_BAircheck) then {if not (_vh in _BAir) then {_BAir pushBack _vh};if not (_grp in _BAirG) then {_BAirG pushBack _grp}};
				if (_RAircheck) then {if not (_vh in _RAir) then {_RAir pushBack _vh};if not (_grp in _RAirG) then {_RAirG pushBack _grp}};
				if (_NCAircheck) then {if not (_vh in _NCAir) then {_NCAir pushBack _vh};if not (_grp in _NCAirG) then {_NCAirG pushBack _grp}};
				if (_Navalcheck) then {if not (_vh in _Naval) then {_Naval pushBack _vh};if not ((group _vh) in _NavalG) then {_NavalG pushBackUnique (group _vh)}};
				if (_Staticcheck) then {if not (_vh in _Static) then {_FValue = _FValue + 1;_Static pushBack _vh};if not (_grp in _StaticG) then {_StaticG pushBack _grp}};
				if (_StaticAAcheck) then {if not (_vh in _StaticAA) then {_StaticAA pushBack _vh};if not (_grp in _StaticAAG) then {_StaticAAG pushBack _grp}};
				if (_StaticATcheck) then {if not (_vh in _StaticAT) then {_StaticAT pushBack _vh};if not (_grp in _StaticATG) then {_StaticATG pushBack _grp}};
				if (_Supportcheck) then {if not (_vh in _Support) then {_Support pushBack _vh};if not (_grp in _SupportG) then {_SupportG pushBack _grp}};
				if (_Cargocheck) then {if not (_vh in _Cargo) then {_Cargo pushBack _vh};if not (_grp in _CargoG) then {_CargoG pushBack _grp}};
				if (_NCCargocheck) then {if not (_vh in _NCCargo) then {_NCCargo pushBack _vh};if not (_grp in _NCCargoG) then {_NCCargoG pushBack _grp}};
				if (_Crewcheck) then {if not (_vh in _Crew) then {_Crew pushBack _vh};if not (_grp in _CrewG) then {_CrewG pushBack _grp}};
				if (_NCrewInfcheck) then {if not (_vh in _NCrewInf) then {_NCrewInf pushBack _vh};if not (_grp in _NCrewInfG) then {_NCrewInfG pushBack _grp}};

			}
		forEach (units _x)
		}
	forEach _friends;

	_HQ setVariable ["RydHQ_FValue",_FValue];

	_HQ setVariable ["RydHQ_SpecFor",_SpecFor];
	_HQ setVariable ["RydHQ_recon",_recon];
	_HQ setVariable ["RydHQ_FO",_FO];
	_HQ setVariable ["RydHQ_snipers",_snipers];
	_HQ setVariable ["RydHQ_ATinf",_ATinf];
	_HQ setVariable ["RydHQ_AAinf",_AAinf];
	_HQ setVariable ["RydHQ_Art",_Art];
	_HQ setVariable ["RydHQ_HArmor",_HArmor];
	_HQ setVariable ["RydHQ_MArmor",_MArmor];
	_HQ setVariable ["RydHQ_LArmor",_LArmor];
	_HQ setVariable ["RydHQ_LArmorAT",_LArmorAT];
	_HQ setVariable ["RydHQ_Cars",_Cars];
	_HQ setVariable ["RydHQ_Air",_Air];
	_HQ setVariable ["RydHQ_BAir",_BAir];
	_HQ setVariable ["RydHQ_RAir",_RAir];
	_HQ setVariable ["RydHQ_NCAir",_NCAir];
	_HQ setVariable ["RydHQ_Naval",_Naval];
	_HQ setVariable ["RydHQ_Static",_Static];
	_HQ setVariable ["RydHQ_StaticAA",_StaticAA];
	_HQ setVariable ["RydHQ_StaticAT",_StaticAT];
	_HQ setVariable ["RydHQ_Support",_Support];
	_HQ setVariable ["RydHQ_Cargo",_Cargo];
	_HQ setVariable ["RydHQ_NCCargo",_NCCargo];
	_HQ setVariable ["RydHQ_Other",_Other];
	_HQ setVariable ["RydHQ_Crew",_Crew];

	_HQ setVariable ["RydHQ_SpecForG",_SpecForG];
	_HQ setVariable ["RydHQ_reconG",_reconG];
	_HQ setVariable ["RydHQ_FOG",_FOG];
	_HQ setVariable ["RydHQ_snipersG",_snipersG];
	_HQ setVariable ["RydHQ_ATinfG",_ATinfG];
	_HQ setVariable ["RydHQ_AAinfG",_AAinfG];
	_HQ setVariable ["RydHQ_ArtG",_ArtG];
	_HQ setVariable ["RydHQ_HArmorG",_HArmorG];
	_HQ setVariable ["RydHQ_MArmorG",_MArmorG];
	_HQ setVariable ["RydHQ_LArmorG",_LArmorG];
	_HQ setVariable ["RydHQ_LArmorATG",_LArmorATG];
	_HQ setVariable ["RydHQ_CarsG",_CarsG];
	_HQ setVariable ["RydHQ_AirG",_AirG];
	_HQ setVariable ["RydHQ_BAirG",_BAirG];
	_HQ setVariable ["RydHQ_RAirG",_RAirG];
	_HQ setVariable ["RydHQ_NCAirG",_NCAirG];
	_HQ setVariable ["RydHQ_NavalG",_NavalG];
	_HQ setVariable ["RydHQ_StaticG",_StaticG];
	_HQ setVariable ["RydHQ_StaticAAG",_StaticAAG];
	_HQ setVariable ["RydHQ_StaticATG",_StaticATG];
	_HQ setVariable ["RydHQ_NCCargoG",_NCCargoG];
	_HQ setVariable ["RydHQ_OtherG",_OtherG];
	_HQ setVariable ["RydHQ_CrewG",_CrewG];

	_NCrewInfG = _NCrewInfG - (_RAirG + _StaticG);
	_NCrewInf = _NCrewInf - (_RAir + _Static);
	_InfG = _InfG - (_RAirG + _StaticG);
	_Inf = _Inf - (_RAir + _Static);

	_CargoAirEx = [];
	_CargoLandEx = [];
	if (_HQ getVariable ["RydHQ_NoAirCargo",false]) then {_CargoAirEx = _AirG};
	if (_HQ getVariable ["RydHQ_NoLandCargo",false]) then {_CargoLandEx = (_CargoG - _AirG)};
	_CargoG = _CargoG - (_CargoAirEx + _CargoLandEx + (_HQ getVariable ["RydHQ_AmmoDrop",[]]));
	_HQ setVariable ["RydHQ_CargoAirEx",_CargoAirEx];
	_HQ setVariable ["RydHQ_CargoLandEx",_CargoLandEx];


		{
		if not (_x in _SupportG) then
			{
			_SupportG pushBack _x
			}
		}
	forEach (_HQ getVariable ["RydHQ_AmmoDrop",[]]);

	if not (isNil "LeaderHQ") then {if (_HQ == (group LeaderHQ)) then {
		ArtyFriendsA = _friends;
		ArtyArtA = _Art;
		ArtyArtGA = _ArtG;
		publicVariable "ArtyFriendsA";
		publicVariable "ArtyArtA";
		publicVariable "ArtyArtGA";
		}
	};

	if not (isNil "LeaderHQB") then {if (_HQ == (group LeaderHQB)) then {
		ArtyFriendsB = _friends;
		ArtyArtB = _Art;
		ArtyArtGB = _ArtG;
		publicVariable "ArtyFriendsB";
		publicVariable "ArtyArtB";
		publicVariable "ArtyArtGB";
		}
	};

	if not (isNil "LeaderHQC") then {if (_HQ == (group LeaderHQC)) then {
		ArtyFriendsC = _friends;
		ArtyArtC = _Art;
		ArtyArtGC = _ArtG;
		publicVariable "ArtyFriendsC";
		publicVariable "ArtyArtC";
		publicVariable "ArtyArtGC";
		}
	};

	if not (isNil "LeaderHQD") then {if (_HQ == (group LeaderHQD)) then {
		ArtyFriendsD = _friends;
		ArtyArtD = _Art;
		ArtyArtGD = _ArtG;
		publicVariable "ArtyFriendsD";
		publicVariable "ArtyArtD";
		publicVariable "ArtyArtGD";
		}
	};

	if not (isNil "LeaderHQE") then {if (_HQ == (group LeaderHQE)) then {
		ArtyFriendsE = _friends;
		ArtyArtE = _Art;
		ArtyArtGE = _ArtG;
		publicVariable "ArtyFriendsE";
		publicVariable "ArtyArtE";
		publicVariable "ArtyArtGE";
		}
	};

	if not (isNil "LeaderHQF") then {if (_HQ == (group LeaderHQF)) then {
		ArtyFriendsF = _friends;
		ArtyArtF = _Art;
		ArtyArtGF = _ArtG;
		publicVariable "ArtyFriendsF";
		publicVariable "ArtyArtF";
		publicVariable "ArtyArtGF";
		}
	};

	if not (isNil "LeaderHQG") then {if (_HQ == (group LeaderHQG)) then {
		ArtyFriendsG = _friends;
		ArtyArtG = _Art;
		ArtyArtGG = _ArtG;
		publicVariable "ArtyFriendsG";
		publicVariable "ArtyArtG";
		publicVariable "ArtyArtGG";
		}
	};

	if not (isNil "LeaderHQH") then {if (_HQ == (group LeaderHQH)) then {
		ArtyFriendsH = _friends;
		ArtyArtH = _Art;
		ArtyArtGH = _ArtG;
		publicVariable "ArtyFriendsH";
		publicVariable "ArtyArtH";
		publicVariable "ArtyArtGH";
		}
	};


	_HQ setVariable ["RydHQ_NCrewInf",_NCrewInf];
	_HQ setVariable ["RydHQ_NCrewInfG",_NCrewInfG];
	_HQ setVariable ["RydHQ_Inf",_Inf];
	_HQ setVariable ["RydHQ_InfG",_InfG];
	_HQ setVariable ["RydHQ_CargoG",_CargoG];
	_HQ setVariable ["RydHQ_SupportG",_SupportG];

		{
			{
			_SpecForcheck = false;
			_reconcheck = false;
			_FOcheck = false;
			_sniperscheck = false;
			_ATinfcheck = false;
			_AAinfcheck = false;
			_Infcheck = false;
			_Artcheck = false;
			_HArmorcheck = false;
			_MArmorcheck = false;
			_LArmorcheck = false;
			_LArmorATcheck = false;
			_Carscheck = false;
			_Aircheck = false;
			_BAircheck = false;
			_RAircheck = false;
			_NCAircheck = false;
			_Navalcheck = false;
			_Staticcheck = false;
			_StaticAAcheck = false;
			_StaticATcheck = false;
			_Supportcheck = false;
			_Cargocheck = false;
			_NCCargocheck = false;
			_Cargocheck = false;
			_NCCargocheck = false;
			_Othercheck = true;

			_Crewcheck = false;
			_NCrewInfcheck = false;

			_tp = toLower (typeOf _x);
			_grp = group _x;
			_vh = vehicle _x;
			if (_x == _vh) then {_vh = objNull};
			_asV = assignedVehicle _x;
			_grpD = group (driver _vh);
			_grpG = group (gunner _vh);
			if (isNull _grpD) then {_grpD = _grpG};
			_Tvh = toLower (typeOf _vh);
			_TasV = toLower (typeOf _asV);

				if (((_grp == _grpD) and {(_Tvh in _specFor_class)}) or {(_tp in _specFor_class)}) then {_SpecForcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _recon_class)}) or {(_tp in _recon_class)}) then {_reconcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _FO_class)}) or {(_tp in _FO_class)}) then {_FOcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _snipers_class)}) or {(_tp in _snipers_class)}) then {_sniperscheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _ATinf_class)}) or {(_tp in _ATinf_class)}) then {_ATinfcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _AAinf_class)}) or {(_tp in _AAinf_class)}) then {_AAinfcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Inf_class)}) or {(_tp in _Inf_class)}) then {_Infcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Art_class)}) or {(_tp in _Art_class)}) then {_Artcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _HArmor_class)}) or {(_tp in _HArmor_class)}) then {_HArmorcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _MArmor_class)}) or {(_tp in _MArmor_class)}) then {_MArmorcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _LArmor_class)}) or {(_tp in _LArmor_class)}) then {_LArmorcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _LArmorAT_class)}) or {(_tp in _LArmorAT_class)}) then {_LArmorATcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Cars_class)}) or {(_tp in _Cars_class)}) then {_Carscheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Air_class)}) or {(_tp in _Air_class)}) then {_Aircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _BAir_class)}) or {(_tp in _BAir_class)}) then {_BAircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _RAir_class)}) or {(_tp in _RAir_class)}) then {_RAircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _NCAir_class)}) or {(_tp in _NCAir_class)}) then {_NCAircheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Naval_class)}) or {(_tp in _Naval_class)}) then {_Navalcheck = true;_Othercheck = false};
				if (((_grp == _grpG) and {(_Tvh in _Static_class)}) or {(_tp in _Static_class)}) then {_Staticcheck = true;_Othercheck = false};
				if (((_grp == _grpG) and {(_Tvh in _StaticAA_class)}) or {(_tp in _StaticAA_class)}) then {_StaticAAcheck = true;_Othercheck = false};
				if (((_grp == _grpG) and {(_Tvh in _StaticAT_class)}) or {(_tp in _StaticAT_class)}) then {_StaticATcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Cargo_class)}) or {(_tp in _Cargo_class)}) then {_Cargocheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _NCCargo_class)}) or {(_tp in _NCCargo_class)}) then {_NCCargocheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Crew_class)}) or {(_tp in _Crew_class)}) then {_Crewcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _NCrewInf_class)}) or {(_tp in _NCrewInf_class)}) then {_NCrewInfcheck = true;_Othercheck = false};
				if (((_grp == _grpD) and {(_Tvh in _Support_class)}) or {(_tp in _Support_class)}) then {_Supportcheck = true;_NCrewInfcheck = false;_Othercheck = false};

				if ((_Tvh in _NCCargo_class) and {(_x == (assignedDriver _asV)) and {((count (units (group _x))) == 1) and {not ((_ATinfcheck) or {(_AAinfcheck) or {(_reconcheck) or {(_FOcheck) or {(_sniperscheck)}}}})}}}) then {_NCrewInfcheck = false;_Othercheck = false};

				_vh = vehicle _x;

				if (_SpecForcheck) then {if not (_vh in _EnSpecFor) then {_EnSpecFor pushBack _vh};if not (_grp in _EnSpecForG) then {_EnSpecForG pushBack _grp}};
				if (_reconcheck) then {if not (_vh in _Enrecon) then {_Enrecon pushBack _vh};if not (_grp in _EnreconG) then {_EnreconG pushBack _grp}};
				if (_FOcheck) then {if not (_vh in _EnFO) then {_EnFO pushBack _vh};if not (_grp in _EnFOG) then {_EnFOG pushBack _grp}};
				if (_sniperscheck) then {if not (_vh in _Ensnipers) then {_Ensnipers pushBack _vh};if not (_grp in _EnsnipersG) then {_EnsnipersG pushBack _grp}};
				if (_ATinfcheck) then {if not (_vh in _EnATinf) then {_EnATinf pushBack _vh};if not (_grp in _EnATinfG) then {_EnATinfG pushBack _grp}};
				if (_AAinfcheck) then {if not (_vh in _EnAAinf) then {_EnAAinf pushBack _vh};if not (_grp in _EnAAinfG) then {_EnAAinfG pushBack _grp}};
				if (_Infcheck) then {if not (_vh in _EnInf) then {_EValue = _EValue + 1;_EnInf pushBack _vh};if not (_grp in _EnInfG) then {_EnInfG pushBack _grp}};
				if (_Artcheck) then {if not (_vh in _EnArt) then {_EValue = _EValue + 3;_EnArt pushBack _vh};if not (_grp in _EnArtG) then {_EnArtG pushBack _grp}};
				if (_HArmorcheck) then {if not (_vh in _EnHArmor) then {_EValue = _EValue + 10;_EnHArmor pushBack _vh};if not (_grp in _EnHArmorG) then {_EnHArmorG pushBack _grp}};
				if (_MArmorcheck) then {if not (_vh in _EnMArmor) then {_EnMArmor pushBack _vh};if not (_grp in _EnMArmorG) then {_EnMArmorG pushBack _grp}};
				if (_LArmorcheck) then {if not (_vh in _EnLArmor) then {_EValue = _EValue + 5;_EnLArmor pushBack _vh};if not (_grp in _EnLArmorG) then {_EnLArmorG pushBack _grp}};
				if (_LArmorATcheck) then {if not (_vh in _EnLArmorAT) then {_EnLArmorAT pushBack _vh};if not (_grp in _EnLArmorATG) then {_EnLArmorATG pushBack _grp}};
				if (_Carscheck) then {if not (_vh in _EnCars) then {_EValue = _EValue + 3;_EnCars pushBack _vh};if not (_grp in _EnCarsG) then {_EnCarsG pushBack _grp}};
				if (_Aircheck) then {if not (_vh in _EnAir) then {_EValue = _EValue + 15;_EnAir pushBack _vh};if not (_grp in _EnAirG) then {_EnAirG pushBack _grp}};
				if (_BAircheck) then {if not (_vh in _EnBAir) then {_EnBAir pushBack _vh};if not (_grp in _EnBAirG) then {_EnBAirG pushBack _grp}};
				if (_RAircheck) then {if not (_vh in _EnRAir) then {_EnRAir pushBack _vh};if not (_grp in _EnRAirG) then {_EnRAirG pushBack _grp}};
				if (_NCAircheck) then {if not (_vh in _EnNCAir) then {_EnNCAir pushBack _vh};if not (_grp in _EnNCAirG) then {_EnNCAirG pushBack _grp}};
				if (_Navalcheck) then {if not (_vh in _EnNaval) then {_EnNaval pushBack _vh};if not (_grp in _EnNavalG) then {_EnNavalG pushBack _grp}};
				if (_Staticcheck) then {if not (_vh in _EnStatic) then {_EValue = _EValue + 1;_EnStatic pushBack _vh};if not (_grp in _EnStaticG) then {_EnStaticG pushBack _grp}};
				if (_StaticAAcheck) then {if not (_vh in _EnStaticAA) then {_EnStaticAA pushBack _vh};if not (_grp in _EnStaticAAG) then {_EnStaticAAG pushBack _grp}};
				if (_StaticATcheck) then {if not (_vh in _EnStaticAT) then {_EnStaticAT pushBack _vh};if not (_grp in _EnStaticATG) then {_EnStaticATG pushBack _grp}};
				if (_Supportcheck) then {if not (_vh in _EnSupport) then {_EnSupport pushBack _vh};if not (_grp in _EnSupportG) then {_EnSupportG pushBack _grp}};
				if (_Cargocheck) then {if not (_vh in _EnCargo) then {_EnCargo pushBack _vh};if not (_grp in _EnCargoG) then {_EnCargoG pushBack _grp}};
				if (_NCCargocheck) then {if not (_vh in _EnNCCargo) then {_EnNCCargo pushBack _vh};if not (_grp in _EnNCCargoG) then {_EnNCCargoG pushBack _grp}};
				if (_Crewcheck) then {if not (_vh in _EnCrew) then {_EnCrew pushBack _vh};if not (_grp in _EnCrewG) then {_EnCrewG pushBack _grp}};
				if (_NCrewInfcheck) then {if not (_vh in _EnNCrewInf) then {_EnNCrewInf pushBack _vh};if not (_grp in _EnNCrewInfG) then {_EnNCrewInfG pushBack _grp}};

			}
		forEach (units _x)
		}
	forEach _knownEG;

	_HQ setVariable ["RydHQ_EValue",_EValue];

	_HQ setVariable ["RydHQ_EnSpecFor",_EnSpecFor];
	_HQ setVariable ["RydHQ_Enrecon",_Enrecon];
	_HQ setVariable ["RydHQ_EnFO",_EnFO];
	_HQ setVariable ["RydHQ_Ensnipers",_Ensnipers];
	_HQ setVariable ["RydHQ_EnATinf",_EnATinf];
	_HQ setVariable ["RydHQ_EnAAinf",_EnAAinf];
	_HQ setVariable ["RydHQ_EnArt",_EnArt];
	_HQ setVariable ["RydHQ_EnHArmor",_EnHArmor];
	_HQ setVariable ["RydHQ_EnMArmor",_EnMArmor];
	_HQ setVariable ["RydHQ_EnLArmor",_EnLArmor];
	_HQ setVariable ["RydHQ_EnLArmorAT",_EnLArmorAT];
	_HQ setVariable ["RydHQ_EnCars",_EnCars];
	_HQ setVariable ["RydHQ_EnAir",_EnAir];
	_HQ setVariable ["RydHQ_EnBAir",_EnBAir];
	_HQ setVariable ["RydHQ_EnRAir",_EnRAir];
	_HQ setVariable ["RydHQ_EnNCAir",_EnNCAir];
	_HQ setVariable ["RydHQ_EnNaval",_EnNaval];
	_HQ setVariable ["RydHQ_EnStatic",_EnStatic];
	_HQ setVariable ["RydHQ_EnStaticAA",_EnStaticAA];
	_HQ setVariable ["RydHQ_EnStaticAT",_EnStaticAT];
	_HQ setVariable ["RydHQ_EnSupport",_EnSupport];
	_HQ setVariable ["RydHQ_EnCargo",_EnCargo];
	_HQ setVariable ["RydHQ_EnNCCargo",_EnNCCargo];
	_HQ setVariable ["RydHQ_EnOther",_EnOther];
	_HQ setVariable ["RydHQ_EnCrew",_EnCrew];

	_HQ setVariable ["RydHQ_EnSpecForG",_EnSpecForG];
	_HQ setVariable ["RydHQ_EnreconG",_EnreconG];
	_HQ setVariable ["RydHQ_EnFOG",_EnFOG];
	_HQ setVariable ["RydHQ_EnsnipersG",_EnsnipersG];
	_HQ setVariable ["RydHQ_EnATinfG",_EnATinfG];
	_HQ setVariable ["RydHQ_EnAAinfG",_EnAAinfG];
	_HQ setVariable ["RydHQ_EnArtG",_EnArtG];
	_HQ setVariable ["RydHQ_EnHArmorG",_EnHArmorG];
	_HQ setVariable ["RydHQ_EnMArmorG",_EnMArmorG];
	_HQ setVariable ["RydHQ_EnLArmorG",_EnLArmorG];
	_HQ setVariable ["RydHQ_EnLArmorATG",_EnLArmorATG];
	_HQ setVariable ["RydHQ_EnCarsG",_EnCarsG];
	_HQ setVariable ["RydHQ_EnAirG",_EnAirG];
	_HQ setVariable ["RydHQ_EnBAirG",_EnBAirG];
	_HQ setVariable ["RydHQ_EnRAirG",_EnRAirG];
	_HQ setVariable ["RydHQ_EnNCAirG",_EnNCAirG];
	_HQ setVariable ["RydHQ_EnNavalG",_EnNavalG];
	_HQ setVariable ["RydHQ_EnStaticG",_EnStaticG];
	_HQ setVariable ["RydHQ_EnStaticAAG",_EnStaticAAG];
	_HQ setVariable ["RydHQ_EnStaticATG",_EnStaticATG];
	_HQ setVariable ["RydHQ_EnSupportG",_EnSupportG];
	_HQ setVariable ["RydHQ_EnCargoG",_EnCargoG];
	_HQ setVariable ["RydHQ_EnNCCargoG",_EnNCCargoG];
	_HQ setVariable ["RydHQ_EnOtherG",_EnOtherG];
	_HQ setVariable ["RydHQ_EnCrewG",_EnCrewG];

	_EnNCrewInfG = _EnNCrewInfG - (_EnRAirG + _EnStaticG);
	_EnNCrewInf = _EnNCrewInf - (_EnRAir + _EnStatic);
	_EnInfG = _EnInfG - (_EnRAirG + _EnStaticG);
	_EnInf = _EnInf - (_EnRAir + _EnStatic);

	_HQ setVariable ["RydHQ_EnNCrewInf",_EnNCrewInf];
	_HQ setVariable ["RydHQ_EnNCrewInfG",_EnNCrewInfG];
	_HQ setVariable ["RydHQ_EnInf",_EnInf];
	_HQ setVariable ["RydHQ_EnInfG",_EnInfG];

	if (_HQ getVariable ["RydHQ_Flee",true]) then
		{
		_AllCow = 0;
		_AllPanic = 0;

			{
			_cow = _x getVariable ("Cow" + (str _x));
			if (isNil ("_cow")) then {_cow = 0};

			_AllCow = _AllCow + _cow;

			_panic = _x getVariable ("inPanic" + (str _x));
			if (isNil ("_panic")) then {_panic = false};

			if (_panic) then {_AllPanic = _AllPanic + 1};
			}
		forEach _friends;

		if (_AllPanic == 0) then {_AllPanic = 1};
		_midCow = 0;
		if not ((count _friends) == 0) then {_midCow = _AllCow/(count _friends)};

			{
			_cowF = ((- _morale)/(50 + (random 25))) + (random (2 * _midCow)) - _midCow;
			_cowF = _cowF * (_HQ getVariable ["RydHQ_Muu",1]);
			if (_x in _SpecForG) then {_cowF = _cowF - 0.8};
			if (_cowF < 0) then {_cowF = 0};
			if (_cowF > 1) then {_cowF = 1};
			_i = "";
			if (_cowF > 0.5) then
				{
				_UL = leader _x;
				if not (isPlayer _UL) then
					{
					_inDanger = _x getVariable ["NearE",0];
					if (isNil "_inDanger") then {_inDanger = 0};
					if (_inDanger > 0.05) then
						{
						if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_InFear,"InFear"] call RYD_AIChatter}
						}
					}
				};

			if (((random ((20 + (_morale/5))/_AllPanic)) < _cowF) and {((random 100) > (100/(_AllPanic + 1)))}) then
				{
				_dngr = _x getVariable ["NearE",0];
				if (isNil "_dngr") then {_dngr = 0};
				if (_dngr < (0.3 - (random 0.15) - (random 0.15))) exitWith {};

				[_x] call CBA_fnc_clearWaypoints;
				_x setVariable [("inPanic" + (str _x)), true];

				if (_HQ getVariable ["RydHQ_DebugII",false]) then
					{
					_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
					_i = [(getPosATL (vehicle (leader _x))),_x,"markPanic","ColorYellow","ICON","mil_dot",_signum + "!",_signum + "!",[0.5,0.5]] call RYD_Mark
					};

				_x setVariable [("Busy" + (str _x)), true];

				_UL = leader _x;
				if not (isPlayer _UL) then
					{
					if ((random 100) < RydxHQ_AIChatDensity) then {[_UL,RydxHQ_AIC_InPanic,"InPanic"] call RYD_AIChatter}
					};

				if (_HQ getVariable ["RydHQ_Surr",false]) then
					{
					if (_dngr < (0.5 + (random 0.5))) exitWith {};
					if ((random 100) > 0) then
						{
						if (_HQ getVariable ["RydHQ_DebugII",false]) then
							{
							_signum = _HQ getVariable ["RydHQ_CodeSign","X"];
							_i setMarkerColorLocal "ColorPink";
							_i setMarkerText (_signum + "!!!")
							};

						_isCaptive = _x getVariable ("isCaptive" + (str _x));
						if (isNil "_isCaptive") then {_isCaptive = false};
						if not (_isCaptive) then
							{
							[_x] spawn
								{
								_gp = _this select 0;
								_gp setVariable [("isCaptive" + (str _gp)), true];
								_gp setVariable ["RydHQ_MIA", true];

								(units _gp) orderGetIn false;
								(units _gp) allowGetIn false;//if (player in (units _gp)) then {diag_log "NOT ALLOW surr"};

									{
									[_x] spawn
										{
										_unit = _this select 0;

										sleep (random 1);
										if (isPlayer _unit) exitWith {[_unit] join grpNull};

										_unit setCaptive true;
										unassignVehicle _unit;

										for [{_a = 0},{_a < (count (weapons _unit))},{_a = _a + 1}] do
											{
											_weapon = (weapons _unit) select _a;
											private _weaponHolder = "GroundWeaponHolder" createVehicle getPosATL _unit;
											_unit action ["dropWeapon", _weaponHolder, _weapon]
											};

										_unit playAction "Surrender";
										}
									}
								forEach (units _gp)
								}
							}
						}
					}
				};

			_panic = _x getVariable ("inPanic" + (str _x));
			if (isNil ("_panic")) then {_panic = false};

			if not (_panic) then
				{
				_x allowFleeing _cowF;
				_x setVariable [("Cow" + (str _x)),_cowF,true];
				}
			else
				{
				_x allowFleeing 1;
				_x setVariable [("Cow" + (str _x)),1,true];
				if ((random 1.1) > _cowF) then
					{
					_isCaptive = _x getVariable ("isCaptive" + (str _x));
					if (isNil "_isCaptive") then {_isCaptive = false};
					_x setVariable [("inPanic" + (str _x)), false];
					if not (_isCaptive) then {_x setVariable [("Busy" + (str _x)), false]};
					}
				}
			}
		forEach _friends
		};

		{
		_KnEnPos pushBack (getPosATL (vehicle (leader _x)));
		if ((count _KnEnPos) >= 100) then {_KnEnPos = _KnEnPos - [_KnEnPos select 0]};
		}
	forEach _knownEG;

	_HQ setVariable ["RydHQ_KnEnPos",_KnEnPos];

	for [{_z = 0},{_z < (count _knownE)},{_z = _z + 1}] do
		{
		_KnEnemy = _knownE select _z;
			{
			if ((_x knowsAbout _KnEnemy) > 0.01) then {_HQ reveal [_KnEnemy,2]}
			}
		forEach _friends
		};

	if (_cycleC == 1) then
		{
		_Recklessness = _HQ getVariable ["RydHQ_Recklessness",0.5];
		_Activity = _HQ getVariable ["RydHQ_Activity",0.5];
		_Fineness = _HQ getVariable ["RydHQ_Fineness",0.5];
		_Circumspection = _HQ getVariable ["RydHQ_Circumspection",0.5];
		_Consistency = _HQ getVariable ["RydHQ_Consistency",0.5];

		if (_HQ getVariable ["RydHQ_AAO",false]) then
			{
			_AAO = ((((0.1 + _Recklessness + _Fineness + (_Activity * 1.5))/((1 + _Circumspection) max 1)) min 1.8) max 0.05) > ((random 1) + (random 1));
			_HQ setVariable ["RydHQ_ChosenAAO",_AAO];
			};

		if (_HQ getVariable ["RydHQ_EBDoctrine",false]) then
			{
			_EBT = ((((_activity + _Recklessness)/(2 + _Fineness)) min 0.8) max 0.01) > ((random 0.5) + (random 0.5));

			_HQ setVariable ["RydHQ_ChosenEBDoctrine",_EBT]
			};

		if ((_HQ getVariable ["RydHQ_ArtyShells",1]) > 0) then
			{
			[_ArtG,(_HQ getVariable ["RydHQ_ArtyShells",1])] call RYD_ArtyPrep;
			};

		if ((RydBB_Active) and ((_HQ getVariable ["leaderHQ",(leader _HQ)]) in (RydBBa_HQs + RydBBb_HQs))) then
			{
			_HQ setVariable ["RydHQ_readyForBB",true];
			_HQ setVariable ["RydHQ_Pending",false];
			if ((_HQ getVariable ["leaderHQ",(leader _HQ)]) in RydBBa_HQs) then
				{
				waitUntil {sleep 0.1;(RydBBa_InitDone)}
				};

			if ((_HQ getVariable ["leaderHQ",(leader _HQ)]) in RydBBb_HQs) then
				{
				waitUntil {sleep 0.1;(RydBBb_InitDone)}
				}
			}
		};

	if (_cycleC > 1) then
		{
		if (_HQ getVariable ["RydHQ_AAO",false]) then
			{
			_Consistency = _HQ getVariable ["RydHQ_Consistency",0.5];

			if ((random 100) > (((90 + ((0.5 + _Consistency) * 4.5)) min 99) max 90)) then
				{
				_Recklessness = _HQ getVariable ["RydHQ_Recklessness",0.5];
				_Activity = _HQ getVariable ["RydHQ_Activity",0.5];
				_Fineness = _HQ getVariable ["RydHQ_Fineness",0.5];
				_Circumspection = _HQ getVariable ["RydHQ_Circumspection",0.5];

				_AAO = (((((0.1 + _Recklessness + _Fineness + (_Activity * 1.5))/((1 + _Circumspection) max 1)) min 1.8) max 0.05) > ((random 1) + (random 1)));
				_HQ setVariable ["RydHQ_ChosenAAO",_AAO];
				}
			}
		};

	_AAO = _HQ getVariable ["RydHQ_ChosenAAO",false];
	_EBT = _HQ getVariable ["RydHQ_ChosenEBDoctrine",false];

	if ((abs _morale) > (0.1 + (random 10) + (random 10) + (random 10) + (random 10) + (random 10))) then {_AAO = false};

	if not (_AAO) then {_AAO = _HQ getVariable ["RydHQ_ForceAAO",false]};
	if not (_EBT) then {_EBT = _HQ getVariable ["RydHQ_ForceEBDoctrine",false]};

	if (_EBT) then {_AAO = true};

	_HQ setVariable ["RydHQ_ChosenEBDoctrine",_EBT];
	_HQ setVariable ["RydHQ_ChosenAAO",_AAO];

	if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};

	_Artdebug = _HQ getVariable ["RydHQ_Debug",false];
	if (_HQ getVariable ["RydHQ_ArtyMarks",false]) then {_Artdebug = true};

	if (((count _knownE) > 0) and {((count _ArtG) > 0) and {((_HQ getVariable ["RydHQ_ArtyShells",1]) > 0)}}) then {[_ArtG,_knownE,(_EnHArmor + _EnMArmor + _EnLArmor),_friends,_Artdebug,(_HQ getVariable ["leaderHQ",(leader _HQ)])] call RYD_CFF};

	_gauss100 = (random 10) + (random 10) + (random 10) + (random 10) + (random 10) + (random 10) + (random 10) + (random 10) + (random 10) + (random 10);
	_obj = _HQ getVariable "RydHQ_Obj";

	_moraleInfl = (_gauss100  * (_HQ getVariable ["RydHQ_OffTend",1])) + (_HQ getVariable ["RydHQ_Inertia",0]) + _morale;
	_enemyInfl = (_EValue/(_FValue max 1)) * 40;

	_delay = ((count _friends) * 5) + (round (((10 + (count _friends))/(0.5 + (_HQ getVariable ["RydHQ_Reflex",0.5]))) * (_HQ getVariable ["RydHQ_CommDelay",1])));

	_HQ setVariable ["RydHQ_myDelay",_delay];


	if (_HQ getVariable ["RydHQ_SimpleMode",false]) then {

		_taken = (_HQ getVariable ["RydHQ_Taken",[]]);
		_Navaltaken = (_HQ getVariable ["RydHQ_TakenNaval",[]]);

		{

				if ((_x getVariable ["SetTakenA",false]) and ((str (leader _HQ)) == "LeaderHQ") and not (_x in _taken)) then {_taken pushBack _x;};
				if ((_x getVariable ["SetTakenB",false]) and ((str (leader _HQ)) == "LeaderHQB") and not (_x in _taken)) then {_taken pushBack _x;};
				if ((_x getVariable ["SetTakenC",false]) and ((str (leader _HQ)) == "LeaderHQC") and not (_x in _taken)) then {_taken pushBack _x;};
				if ((_x getVariable ["SetTakenD",false]) and ((str (leader _HQ)) == "LeaderHQD") and not (_x in _taken)) then {_taken pushBack _x;};
				if ((_x getVariable ["SetTakenE",false]) and ((str (leader _HQ)) == "LeaderHQE") and not (_x in _taken)) then {_taken pushBack _x;};
				if ((_x getVariable ["SetTakenF",false]) and ((str (leader _HQ)) == "LeaderHQF") and not (_x in _taken)) then {_taken pushBack _x;};
				if ((_x getVariable ["SetTakenG",false]) and ((str (leader _HQ)) == "LeaderHQG") and not (_x in _taken)) then {_taken pushBack _x;};
				if ((_x getVariable ["SetTakenH",false]) and ((str (leader _HQ)) == "LeaderHQH") and not (_x in _taken)) then {_taken pushBack _x;};

		} forEach (_HQ getVariable ["RydHQ_Objectives",[]]);

		{

				if ((_x getVariable ["SetTakenA",false]) and ((str (leader _HQ)) == "LeaderHQ") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};
				if ((_x getVariable ["SetTakenB",false]) and ((str (leader _HQ)) == "LeaderHQB") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};
				if ((_x getVariable ["SetTakenC",false]) and ((str (leader _HQ)) == "LeaderHQC") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};
				if ((_x getVariable ["SetTakenD",false]) and ((str (leader _HQ)) == "LeaderHQD") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};
				if ((_x getVariable ["SetTakenE",false]) and ((str (leader _HQ)) == "LeaderHQE") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};
				if ((_x getVariable ["SetTakenF",false]) and ((str (leader _HQ)) == "LeaderHQF") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};
				if ((_x getVariable ["SetTakenG",false]) and ((str (leader _HQ)) == "LeaderHQG") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};
				if ((_x getVariable ["SetTakenH",false]) and ((str (leader _HQ)) == "LeaderHQH") and not (_x in _Navaltaken)) then {_Navaltaken pushBack _x;};

		} forEach (_HQ getVariable ["RydHQ_NavalObjectives",[]]);

		_HQ setVariable ["RydHQ_Taken",_taken];
		_HQ setVariable ["RydHQ_TakenNaval",_Navaltaken];

		if (_HQ getVariable ["RydHQ_ObjectiveRespawn",false]) then {

			_prefix = "";

			switch (side _HQ) do
			{
				case west: {_prefix = "respawn_west_"};
				case east: {_prefix = "respawn_east_"};
				case resistance: {_prefix = "respawn_guerrila_"};
				case civilian: {_prefix = "respawn_civilian_"};
			};

			{
				_objStr = (str _x);
				_objStr = (_prefix + (_objStr splitString " " joinString ""));
				if (_x in _taken) then {

					if ((_x getVariable [_objStr,[]]) isEqualTo []) then {
						private _respPoint = [];
						if not ((_x getVariable ["ObjName",""]) isEqualTo "") then {_respPoint = [(side _HQ), getPosATL _x,(_x getVariable ["ObjName",""])] call BIS_fnc_addRespawnPosition} else {_respPoint = [(side _HQ), getPosATL _x] call BIS_fnc_addRespawnPosition};
						_x setVariable [_objStr,_respPoint];
					};

				} else {
					if not ((_x getVariable [_objStr,[]]) isEqualTo []) then {
						private _respPoint = (_x getVariable [_objStr,[]]);
						_respPoint call BIS_fnc_removeRespawnPosition;
						_x setVariable [_objStr,[]];
					};
				}

			} forEach (_HQ getVariable ["RydHQ_Objectives",[]]);

		};

	};



	_objs = (((_HQ getVariable ["RydHQ_Objectives",[]]) + (_HQ getVariable ["RydHQ_NavalObjectives",[]])) - ((_HQ getVariable ["RydHQ_Taken",[]]) + (_HQ getVariable ["RydHQ_TakenNaval",[]])));

	if (((_moraleInfl > _enemyInfl) and not ((count _objs) < 1) and {not ((_HQ getVariable ["RydHQ_Order","ATTACK"]) in ["DEFEND"])}) or {(_HQ getVariable ["RydHQ_Berserk",false])} or {(_moraleInfl > _enemyInfl) and (_HQ getVariable ["LastStance","At"] == "De") and ((((75)*(_HQ getVariable ["RydHQ_Recklessness",0.5])*(count (_HQ getVariable ["RydHQ_KnEnemiesG",[]]))) >= (random 100)) or ((_HQ getVariable ["RydHQ_AttackAlways",false]) and (_HQ getVariable ["LastStance","At"] == "De") and ((count (_HQ getVariable ["RydHQ_KnEnemiesG",[]])) > 0)))}) then
		{
		_lastS = _HQ getVariable ["LastStance","At"];
		if ((_lastS == "De") or (_cycleC == 1)) then
			{
			if ((random 100) < RydxHQ_AIChatDensity) then {[(_HQ getVariable ["leaderHQ",(leader _HQ)]),RydxHQ_AIC_OffStance,"OffStance"] call RYD_AIChatter};
			};

		_HQ setVariable ["LastStance","At"];
		_HQ setVariable ["RydHQ_Inertia",30 * (0.5 + (_HQ getVariable ["RydHQ_Consistency",0.5]))*(0.5 + (_HQ getVariable ["RydHQ_Activity",0.5]))];
		[_HQ] call HAL_HQOrders
		}
	else
		{
		_lastS = _HQ getVariable ["LastStance","De"];
		if ((_lastS == "At") or (_cycleC == 1)) then
			{
			if ((random 100) < RydxHQ_AIChatDensity) then {[(_HQ getVariable ["leaderHQ",(leader _HQ)]),RydxHQ_AIC_DefStance,"DefStance"] call RYD_AIChatter};
			};

		_HQ setVariable ["LastStance","De"];
		_HQ setVariable ["RydHQ_Inertia", - (30  * (0.5 + (_HQ getVariable ["RydHQ_Consistency",0.5])))/(0.5 + (_HQ getVariable ["RydHQ_Activity",0.5]))];
		[_HQ] call HAL_HQOrdersDef
		};

	if (((((_HQ getVariable ["RydHQ_Circumspection",0.5]) + (_HQ getVariable ["RydHQ_Fineness",0.5]))/2) + 0.1) > (random 1.2)) then
		{
		_SFcount = {not (_x getVariable ["Busy" + (str _x),false]) and not (_x getVariable ["Unable",false]) and not (_x getVariable ["Resting" + (str _x),false])} count (_SpecForG - (_HQ getVariable ["RydHQ_SFBodyGuard",[]]));

		if (_SFcount > 0) then
			{
			_isNight = [] call RYD_isNight;
			_SFTgts = [];
			_chance = 40 + (60 * (_HQ getVariable ["RydHQ_Activity",0.5]));

				{
				_HQ = group _x;
				if (_HQ in _knownEG) then
					{
					_SFTgts pushBack _HQ
					}
				}
			forEach (RydxHQ_AllLeaders - [(_HQ getVariable ["leaderHQ",(leader _HQ)])]);

			if ((count _SFTgts) == 0) then
				{
				_chance = _chance/2;
				_SFTgts = _EnArtG
				};

			if ((count _SFTgts) == 0) then
				{
				_chance = _chance/3;
				_SFTgts = _EnStaticG
				};

			if (_isNight) then
				{
				_chance = _chance + 25
				};

			if ((count _SFTgts) > 0) then
				{
				_chance = _chance + (((2 * _SFcount) - (8/(0.75 + ((_HQ getVariable ["RydHQ_Recklessness",0.5])/2)))) * 20);
				_trgG = _SFTgts select (floor (random (count _SFTgts)));
				_alreadyAttacked = {_x == _trgG} count (_HQ getVariable ["RydHQ_SFTargets",[]]);
				_chance = _chance/(1 + _alreadyAttacked);
				if (_chance  < _SFcount) then
					{
					_chance = _SFcount
					}
				else
					{
					if (_chance > (85 + _SFcount)) then
						{
						_chance = 85 + _SFcount
						}
					};

				if ((random 100) < _chance) then
					{
					_SFAv = [];

						{
						_isBusy = _x getVariable ["Busy" + (str _x),false];

						if not (_isBusy) then
							{
							_isResting = _x getVariable ["Resting" + (str _x),false];

							if not (_isResting) then
								{
								if not (_x in (_HQ getVariable ["RydHQ_SFBodyGuard",[]])) then
									{
									_SFAv pushBack _x
									}
								}
							}
						}
					forEach _SpecForG;

					_team = _SFAv select (floor (random (count _SFAv)));
					_trg = vehicle (leader _trgG);
					if (not ((toLower (typeOf _trg)) in (_HArmor + _LArmor)) or ((random 100) > (90 - ((_HQ getVariable ["RydHQ_Recklessness",0.5]) * 10)))) then
						{
						//[_team,_trg,_trgG,_HQ] spawn HAL_GoSFAttack;
						[[_team,_trg,_trgG,_HQ],HAL_GoSFAttack] call FUNC(spawn);
						}
					}
				}
			}
		};

	if ((_HQ getVariable ["RydHQ_LRelocating",false]) and {not (_AAO)}) then
		{
		if ((abs (speed (vehicle (_HQ getVariable ["leaderHQ",(leader _HQ)])))) < 0.1) then {_HQ setVariable ["onMove",false]};
		_onMove = _HQ getVariable ["onMove",false];

		if not (_onMove) then
			{
			if (not (isPlayer (_HQ getVariable ["leaderHQ",(leader _HQ)])) and {((_cycleC == 1) or {not ((_HQ getVariable ["RydHQ_Progress",0]) == 0)})}) then
				{
				[_HQ] call CBA_fnc_clearWaypoints;if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {};

				_Lpos = position (_HQ getVariable ["leaderHQ",(leader _HQ)]);
				if (_cycleC == 1) then {_HQ setVariable ["RydHQ_Fpos",_Lpos]};

				_rds = 0;

				if (_HQ getVariable ["RydHQ_LRelocating",false]) then
					{
					_rds = 0;
					switch (_HQ getVariable ["RydHQ_NObj",1]) do
						{
						case (1) :
							{
							_Lpos = (_HQ getVariable ["RydHQ_Fpos",_Lpos]);
							if ((_HQ getVariable ["leaderHQ",(leader _HQ)]) in (RydBBa_HQs + RydBBb_HQs)) then
								{
								_Lpos = position (_HQ getVariable ["leaderHQ",(leader _HQ)])
								};

							_rds = 0
							};

						case (2) : {_Lpos = position (_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])};
						case (3) : {_Lpos = position (_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])};
						default {_Lpos = position (_HQ getVariable ["RydHQ_Obj3",(leader _HQ)])};
						};
					};

				_spd = "LIMITED";
				if ((_HQ getVariable ["RydHQ_Progress",0]) == -1) then {_spd = "NORMAL"};
				_HQ setVariable ["RydHQ_Progress",0];
				_enemyN = false;

					{
					_eLdr = vehicle (leader _x);
					_eDst = _eLdr distance _Lpos;

					if (_eDst < 600) exitWith {_enemyN = true}
					}
				forEach _knownEG;

				if not (_enemyN) then
					{
					_wp = [_HQ,_Lpos,"MOVE","AWARE","GREEN",_spd,["true",""],true,_rds,[0,0,0],"FILE"] call RYD_WPadd;
					if (isNull (assignedVehicle (_HQ getVariable ["leaderHQ",(leader _HQ)]))) then
						{
						if ((_HQ getVariable ["RydHQ_GetHQInside",false])) then {[_wp] call RYD_GoInside}
						};

					if (((_HQ getVariable ["RydHQ_LRelocating",false])) and {((_HQ getVariable ["RydHQ_NObj",1]) > 1) and {(_cycleC > 1)}}) then
						{
						_code =
							{
							_Lpos = _this select 0;
							_HQ = _this select 1;
							_knownEG = _this select 2;

							_eDst = 1000;
							_onPlace = false;
							_getBack = false;

							waitUntil
								{
								sleep 10;

									{
									_eLdr = vehicle (leader _x);
									_eDst = _eLdr distance _Lpos;

									if (_eDst < 600) exitWith {_getBack = true}
									}
								forEach _knownEG;

								if (isNull _HQ) then
									{
									_onPlace = true
									}
								else
									{
									if not (_getBack) then
										{
										if ((((vehicle (_HQ getVariable ["leaderHQ",(leader _HQ)])) distance _LPos) < 30) or {(_HQ getVariable ["RydHQ_KIA",false])}) then {_onPlace = true}
										}
									};


								((_getback) or {(_onPlace)})
								};

							if not (_onPlace) then
								{
								_rds = 30;
								switch (true) do
									{
									case ((_HQ getVariable ["RydHQ_NObj",1]) <= 2) : {_Lpos = getPosATL (vehicle (_HQ getVariable ["leaderHQ",(leader _HQ)]));_rds = 0};
									case ((_HQ getVariable ["RydHQ_NObj",1]) == 3) : {_Lpos = position (_HQ getVariable ["RydHQ_Obj1",(leader _HQ)])};
									case ((_HQ getVariable ["RydHQ_NObj",1]) >= 4) : {_Lpos = position (_HQ getVariable ["RydHQ_Obj2",(leader _HQ)])};
									};

								_getBack = false;

									{
									_eLdr = vehicle (leader _x);
									_eDst = _eLdr distance _Lpos;

									if (_eDst < 600) exitWith {_getBack = true}
									}
								forEach _knownEG;

								if (_getBack) then {_Lpos = getPosATL (vehicle (_HQ getVariable ["leaderHQ",(leader _HQ)]));_rds = 0};

								[_HQ] call CBA_fnc_clearWaypoints;if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {};

								_spd = "NORMAL";
								if not (((vehicle (_HQ getVariable ["leaderHQ",(leader _HQ)])) distance _LPos) < 50) then {_spd = "FULL"};
								_wp = [_HQ,_Lpos,"MOVE","AWARE","GREEN",_spd,["true",""],true,_rds,[0,0,0],"FILE"] call RYD_WPadd;
								if (isNull (assignedVehicle (_HQ getVariable ["leaderHQ",(leader _HQ)]))) then
									{
									if (_HQ getVariable ["RydHQ_GetHQInside",false]) then {[_wp] call RYD_GoInside}
									};

								_HQ setVariable ["onMove",true];
								}
							};

						[[_Lpos,_HQ,_knownEG],_code] call RYD_Spawn
						}
					}
				}
			}
		};

	_alive = true;
	_ct = time;
	_ctRev = time;
	_ctMedS = time;
	_ctFuel = time;
	_ctAmmo = time;
	_ctRep = time;
	_ctISF = time;
	_ctReloc = time;
	_ctLPos = time;
	_ctDesp = time;
	_ctEScan = time;
	_ctGarr = time;

	_HQ setVariable ["RydHQ_Pending",false];

	waitUntil
		{
		sleep 1;

		switch (true) do
			{
			case (isNull _HQ) : {_alive = false};
			case (({alive _x} count (units _HQ)) == 0) : {_alive = false};
			case (_HQ getVariable ["RydHQ_Surrender",false]) : {_alive = false};
			case (_HQ getVariable ["RydHQ_KIA",false]) : {_alive = false};
			};

		if (_alive) then
			{
			if (((time - _ctRev) >= 20) or (((time - _ct) > _delay) and (_delay <= 20))) then
				{
				_ctRev = time;
				[_HQ] call HAL_Rev;
				};

			if (((count (_HQ getVariable ["RydHQ_Support",[]])) > 0) and (_cycleC > 2)) then
				{
				if (((time - _ctMedS) >= 25) or (((time - _ct) > _delay) and (_delay <= 25))) then
					{
					if (_HQ getVariable ["RydHQ_SMed",true]) then
						{
						_ctMedS = time;
						[_HQ] call HAL_SuppMed;
						}
					};

				if (((time - _ctFuel) >= 25) or (((time - _ct) > _delay) and (_delay <= 25))) then
					{
					if (_HQ getVariable ["RydHQ_SFuel",true]) then
						{
						_ctFuel = time;
						[_HQ] call HAL_SuppFuel;
						}
					};

				if (((time - _ctRep) >= 25) or (((time - _ct) > _delay) and (_delay <= 25))) then
					{
					if (_HQ getVariable ["RydHQ_SRep",true]) then
						{
						_ctRep = time;
						[_HQ] call HAL_SuppRep;
						}
					};
				};

			if (((count ((_HQ getVariable ["RydHQ_Support",[]]) + (_HQ getVariable ["RydHQ_AmmoDrop",[]]))) > 0) and (_cycleC > 2)) then
				{
				if (((time - _ctAmmo) >= 25) or (((time - _ct) > _delay) and (_delay <= 25))) then
					{
					if (_HQ getVariable ["RydHQ_SAmmo",true]) then
						{
						_ctAmmo = time;
						[_HQ] call HAL_SuppAmmo;
						}
					};
				};

			if (((time - _ctISF) >= 30) or (((time - _ct) > _delay) and (_delay <= 30))) then
				{
				_ctISF = time;
				_nPos = getPosATL (vehicle (leader _HQ));

				if ((_nPos distance _HQlPos) > 10) then
					{
					_HQlPos = _nPos;

					[_HQ] call HAL_SFIdleOrd
					}
				};

			if (((time - _ctReloc) >= 60) or (((time - _ct) > _delay) and (_delay <= 60))) then
				{
				_ctReloc = time;
				[_HQ] call HAL_Reloc
				};



			if (((time - _ctLPos) >= 30) or (((time - _ct) > _delay) and (_delay <= 60))) then
				{
				_ctLPos = time;
				[_HQ] call HAL_LPos
				};


			if (((time - _ctDesp) >= 60) or (((time - _ct) > _delay) and (_delay <= 60))) then
				{
				_ctDesp = time;
				[_HQ] call Desperado
				};

			if (((time - _ctEScan) >= 60) or (((time - _ct) > _delay) and (_delay <= 60))) then
				{
				_ctEScan = time;
				[_HQ] call HAL_EnemyScan
				};

			if (((time - _ctGarr) >= 60) or (((time - _ct) > _delay) and (_delay <= 60))) then
				{
				_ctGarr = time;
				[_HQ,(_snipers + _ATinf + _AAinf)] spawn HAL_Garrison
				};
			};

		(((time - _ct) > _delay) or not (_alive))
		};

	if not (_alive) exitWith {RydxHQ_AllHQ = RydxHQ_AllHQ - [_HQ]};

		{
		_HQ reveal (vehicle (leader _x))
		}
	forEach _friends;

	for [{_z = 0},{_z < (count _knownE)},{_z = _z + 1}] do
		{
		_KnEnemy = _knownE select _z;

			{
			if ((_x knowsAbout _KnEnemy) > 0.01) then {_HQ reveal [_KnEnemy,2]}
			}
		forEach _friends
		};
	};