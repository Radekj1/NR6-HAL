RYD_StatusQuo =
	{
	_SCRname = "SQ";
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
				[_HQ] call HAL_HQReset
				}
			}
		else
			{
			_code =
				{
				_HQ = _this select 0;

				waitUntil
					{
					sleep 1;
					((_HQ getVariable ["RydHQ_ResetNow",false]) or (_HQ getVariable ["RydHQ_KIA",false]))
					};

				_HQ setVariable ["RydHQ_ResetNow",false];
				[_HQ] call HAL_HQReset
				};

			[[_HQ],_code] call RYD_Spawn;
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
							_i setMarkerColor "ColorPink";
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
						[[_team,_trg,_trgG,_HQ],HAL_GoSFAttack] call RYD_Spawn;
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

// RYD_isInside =
// 	{
// 	private ["_pos","_cam","_target","_pX","_pY","_pZ","_pos1","_pos2","_level","_roofed","_axis","_mark","_vh","_axisArr","_marks"];

// 	_vh = _this select 0;
// 	_pos = _this select 1;
// 	_level = _this select 2;
// 	_axisArr = _this select 3;
// 	_marks = _axisArr select 1;
// 	_axisArr = _axisArr select 0;

// 	_cam = objNull;

// 	if ((count _this) > 5) then {_cam = _this select 5};

// 	_target = objNull;

// 	if ((count _this) > 6) then {_target = _this select 6};

// 	_pX = _pos select 0;
// 	_pY = _pos select 1;
// 	_pZ = _pos select 2;

// 	_pos1 = [_pX,_pY,_pZ];

// 	_roofed = false;

// 		{
// 		_axis = _x;
// 		_mark = _marks select _foreachIndex;

// 		_pos2 = +_pos1;
// 		_pos2 set [_axis,(_pos2 select _axis) + (_level * _mark)];

// 		_roofed = lineIntersects [ATLToASL (_vh modelToWorld _pos1), ATLToASL (_vh modelToWorld _pos2),_cam,_target];

// 		if (_roofed) exitWith {}
// 		}
// 	forEach _axisArr;

// 	_roofed
// 	};

// RYD_LiveFeed =
// 	{
// 	private ["_unit","_HQ","_id"];

// 	_unit = _this select 0;
// 	_HQ = _this select 1;

// 	_id = _unit addAction ["Enable cam view", (RYD_Path + "LF\LF.sqf"),[_HQ], -71, false, true, "", "(not RydxHQ_LFActive) and (_this == _target)"];
// 	_id = _unit addAction ["Disable cam view", (RYD_Path + "LF\LF.sqf"),[_HQ], -81, false, true, "", "(RydxHQ_LFActive) and (_this == _target)"];

// 	true
// 	};

// RYD_LF =
// 	{
	// _SCRname = "RYD_LF";

	// private ["_src","_dc","_leader","_posS"];

	// _src = _this select 0;
	// _leader = _this select 1;

	// if not (RydHQ_LF) then
	// 	{
	// 	_dc = "EmptyDetector" createVehicle (getPosATL _src);

	// 	RydHQ_LF = true;
	// 	[_src,_src,_leader,0] call BIS_fnc_liveFeed;

	// 	waitUntil {not (isNil "BIS_liveFeed")};
	// 	waitUntil {camCommitted BIS_liveFeed};

	// 	if ([] call RYD_isNight) then
	// 		{
	// 		[1] call RYD_LF_EFF
	// 		};

	// 	_vh = vehicle _src;
	// 	_tp = toLower (typeOf _vh);

	// 	(group _leader) setVariable ["RydHQ_LFSourceFin",_vh];

	// 	_vPos = [0,50,2];

	// 	if not (_src == _vh) then
	// 		{
	// 		_vPos = [0,30,0];

	// 		_pX = 0;
	// 		_pY = (sizeOf (typeOf _vh))/15;
	// 		_pZ = -_pY;

	// 		_sign = 1;

	// 		if (_tp in ["b_truck_01_ammo_f"]) then
	// 			{
	// 			_pZ = 0
	// 			};

	// 		if (_vh isKindOf "Air") then
	// 			{
	// 			_pY = (sizeOf (typeOf _vh))/4;
	// 			_pZ = 0;
	// 			_sign = 2
	// 			};

	// 		_inside = true;

	// 		while {_inside} do
	// 			{
	// 			_inside = [_vh,[_pX,_pY,_pZ],6,[[1],[1]]] call RYD_isInside;
	// 			_pZ = _pZ + (0.01 * _sign);
	// 			};

	// 		if (_tp in ["b_mbt_01_cannon_f","i_mbt_03_cannon_f"]) then
	// 			{
	// 			_pZ = _pZ + 0.1;
	// 			}
	// 		else
	// 			{
	// 			_pZ = _pZ + 0.2;
	// 			};

	// 		//_dc setPos (_vh modelToWorld [_pX,_pY,0]);
	// 		_dc attachTo [_vh,[_pX,_pY,_pZ]];
	// 		}
	// 	else
	// 		{
	// 		//_dc setPos (_vh modelToWorld [0.22,0.05,0]);
	// 		_dc attachTo [_vh,[0.22,0.05,0.1],"head"];
	// 		};

	// 	[[_dc,[0,0,0]]] call BIS_fnc_liveFeedSetSource;

	// 	_code =
	// 		{
	// 		_tgt = _this select 0;
	// 		_vPos = _this select 1;
	// 		_isFoot = (_tgt == (vehicle _tgt));

	// 		while {not (isNil "BIS_liveFeed")} do
	// 			{
	// 			if ((_isFoot) and not (_tgt == (vehicle _tgt))) exitWith
	// 				{
	// 				if (isNil "RydxHQ_LFTerminating") then
	// 					{
	// 					RydxHQ_LFTerminating = true;
	// 					[] call BIS_fnc_liveFeedTerminate;
	// 					waitUntil {isNil "BIS_liveFeed"};
	// 					RydxHQ_LFTerminating = nil;
	// 					_dc = _tgt getVariable ["RydHQ_CamPoint",objNull];

	// 					deleteVehicle _dc;

	// 					_tgt setVariable ["RydHQ_CamPoint",nil];

	// 					RydHQ_LF = false;
	// 					}
	// 				};

	// 			_tgtF = _tgt modelToWorld _vPos;
	// 			if not (_isFoot) then {BIS_liveFeed setDir (getDir _tgt)};
	// 			[_tgtF] call BIS_fnc_liveFeedSetTarget;
	// 			sleep 0.02
	// 			}
	// 		};

	// 	[[_src,_vPos],_code] call RYD_Spawn
	// 	}
	// else
	// 	{
	// 	if (isNil "RydxHQ_LFTerminating") then
	// 		{
	// 		RydxHQ_LFTerminating = true;
	// 		[] call BIS_fnc_liveFeedTerminate;
	// 		waitUntil {isNil "BIS_liveFeed"};
	// 		RydxHQ_LFTerminating = nil;
	// 		_dc = _src getVariable ["RydHQ_CamPoint",objNull];

	// 		deleteVehicle _dc;

	// 		_src setVariable ["RydHQ_CamPoint",nil];

	// 		RydHQ_LF = false;
	// 		}
	// 	}
	// };

// RYD_LF_EFF =
// 	{
// 	private ["_mode"];

// 	_mode = _this select 0;

// 	if not (isNil "BIS_liveFeed") then
// 		{
// 		[_mode] call BIS_fnc_liveFeedEffects;
// 		}
// 	};

RYD_LF_Loop =
	{
	_leader = _this select 0;
	_HQ = (_this select 3) select 0;
	_maxD = -1;
	_friends = [];

	while {RydxHQ_LFActive} do
		{
		if (not (isNil "BIS_liveFeed") and not (RydHQ_LF)) exitWith {RydxHQ_LFActive = false};

		switch (isNil "RydHQ_CamVOnly") do
			{
			case (true) : {_friends = (_HQ getVariable ["RydHQ_Friends",[]]) + (RydHQ_CamVIncluded - (_HQ getVariable ["RydHQ_Friends",[]]))};
			case (false) : {_friends = RydHQ_CamVOnly};
			};

		_newS = objNull;
		_newG = grpNull;
		_was0 = true;
		_wasNull = true;

		if ((count _friends) > 0) then
			{
			_was0 = false;
			_maxD = -1;

				{
				_alive = true;
				switch (true) do
					{
					case (isNil {_x}) : {_alive = false};
					case (isNull _x) : {_alive = false};
					case (({(alive _x)} count (units _x)) < 1) : {_alive = false};
					};

				if (_alive) then
					{
					_dngr = _x getVariable ["NearE",0];
					if ((abs (speed (vehicle (leader _x)))) > 0.1) then {_dngr = _dngr + 0.0001};
					if (_x getVariable ["Busy" + (str _x),false]) then {_dngr = 2 * _dngr};
					if (_dngr > _maxD) then
						{
						_maxD = _dngr;
						_units = (units _x) - RydHQ_CamVExcluded;
						if ((count _units) > 0) then
							{
							_newG = _x;
							_newS = _units select (floor (random (count _units)));
							}
						}
					}

				}
			forEach _friends
			};

		_currentS = _HQ getVariable ["RydHQ_LFSource",objNull];

		if not (isNull _newS) then
			{
			_wasNull = false;
			if not (_newS == _currentS) then
				{
				if ((_maxD > 0) or ((random 100) > 75)) then
					{
					_HQ setVariable ["RydHQ_LFSource",_newS];
					_currentS = _HQ getVariable ["RydHQ_LFSource",objNull];

					_dName = getText (configFile >> "CfgVehicles" >> (typeOf (vehicle _newS)) >> "displayName");

					if (RydHQ_LF) then
						{
						_leader groupChat "Terminating current video link...";
						_cSFin = _HQ getVariable ["RydHQ_LFSourceFin",_newS];
						[_cSFin,_leader] call RYD_LF;
						waitUntil {(isNil "BIS_liveFeed")};
						};

					_leader groupChat format ["Establishing new video link with %1...",_dName];
					[_newS,_leader] call RYD_LF;
					waitUntil {not (isNil "BIS_liveFeed")};
					_leader groupChat format ["Video link with %1 established.",_dName];
					}
				}
			};

		_stoper = time;
		_stoper2 = time;
		_alive = true;
		_mpl = 1;

		waitUntil
			{
			sleep 0.1;

			switch (true) do
				{
				case (isNull _HQ) : {_alive = false};
				case (({alive _x} count (units _HQ)) < 1) : {_alive = false};
				case (not (alive _leader)) : {_alive = false};
				case ((isNull (_HQ getVariable ["RydHQ_LFSourceFin",(vehicle _newS)])) and not (_wasNull)) : {_alive = false};
				case ((not (alive (_HQ getVariable ["RydHQ_LFSourceFin",(vehicle _newS)]))) and not (_wasNull)) : {_alive = false};
				//case ((not (_newG in (_HQ getVariable ["RydHQ_Friends",[]]))) and not (_wasNull)) : {_alive = false};
				case ((_newG getVariable ["RydHQ_MIA",false]) and not (_wasNull)) : {_alive = false};
				case (_HQ getVariable ["RydHQ_KIA",false]) : {_alive = false};
				};

			if (_alive) then
				{
				if not (_maxD > 0) then
					{
					if ((time - _stoper2) > 5) then
						{
						if ((_was0) or (_wasNull) or not (_maxd > 0)) then
							{
							if ((count (_HQ getVariable ["RydHQ_Friends",[]])) > 0) then
								{
								_stoper = time - 31
								}
							};

						_stoper2 = time
						}
					}
				};

			_dngr = _newG getVariable ["NearE",0];
			if ((abs (speed (vehicle (leader _newG)))) > 0.1) then {_dngr = _dngr + 0.0001};
			if (_newG getVariable ["Busy" + (str _newG),false]) then {_dngr = 2 * _dngr};

			if (_dngr > (((random 1) + _dngr) * _mpl)) then
				{
				_stoper = time - (10 * _mpl);
				_mpl = _mpl + 0.1
				};

			if not (_alive) then {RydxHQ_LFActive = false};

			(not (RydxHQ_LFActive) or ((time - _stoper) > 30))
			};
		};

	if not (isNil "BIS_liveFeed") then
		{
		_leader groupChat "Terminating current video link...";
		_currentS = _HQ getVariable ["RydHQ_LFSourceFin",objNull];
		[_currentS,_leader] call RYD_LF;
		waitUntil {(isNil "BIS_liveFeed")};
		_leader groupChat "Video link terminated.";
		};
	};

RYD_FindClosest =
	{
	private ["_ref","_objects","_closest","_dstMin","_dstAct"];

	_ref = _this select 0;
	_objects = _this select 1;

	_closest = objNull;

	if ((count _objects) > 0) then
		{
		_closest = _objects select 0;
		_dstMin = _ref distance _closest;

			{
			_dstAct = _ref distance _x;

			if (_dstAct < _dstMin) then
				{
				_closest = _x;
				_dstMin = _dstAct
				}
			}
		forEach _objects
		};

	_closest
	};

/*RYD_FindClosestWithIndex =
	{
	private ["_ref","_objects","_closest","_dstMin","_dstAct","_index","_clIndex","_clst","_act"];

	_ref = _this select 0;
	_objects = _this select 1;

	_closest = objNull;

	if ((count _objects) > 0) then
		{
		_closest = _objects select 0;
		_clst = _closest;
		if ((typeName _clst) == (typename grpNull)) then {_clst = vehicle (leader _clst)};
		_index = 0;
		_clIndex = 0;
		_dstMin = _ref distance _clst;

			{
			_act = _x;
			if ((typeName _act) == (typename grpNull)) then {_act = vehicle (leader _act)};
			_dstAct = _ref distance _act;

			if (_dstAct < _dstMin) then
				{
				_closest = _x;
				_dstMin = _dstAct;
				_clIndex = _index
				};

			_index = _index + 1
			}
		foreach _objects
		};

	[_closest,_clIndex]
	};*/

RYD_ClusterC =
	{
	private ["_points","_clusters","_checked","_newCluster","_point","_range"];

	_points = _this select 0;
	_range = _this select 1;

	_clusters = [];
	_checked = [];
	_newCluster = [];

		{
		if not (_x in _checked) then
			{
			_checked pushBack _x;
			_point = _x;
			_newCluster = [_point];

				{
				if ((_point distance _x) < _range) then
					{
					_checked pushBack _x;
					_newCluster pushBack _x;
					}
				}
			forEach _points;

			_clusters pushBack _newCluster
			}
		}
	forEach _points;

	_clusters
	};

// RYD_Spawn =
// 	{
// 	private ["_arguments","_script","_handle"];

// 	_arguments = _this select 0;
// 	_script = _this select 1;

// 	_handle = _arguments spawn _script;

// 	RydxHQ_Handles pushBack _handle;

// 		{
// 		if (isNil {_x}) then
// 			{
// 			RydxHQ_Handles set [_foreachIndex,0]
// 			}
// 		else
// 			{
// 			if not (_x isEqualTo 0) then
// 				{
// 				if (scriptDone _x) then
// 					{
// 					RydxHQ_Handles set [_foreachIndex,0]
// 					}
// 				}
// 			}
// 		}
// 	forEach RydxHQ_Handles;

// 	RydxHQ_Handles = RydxHQ_Handles - [0];

// 	/*diag_log format ["New Handle - time: %1 count: (%2 - %3)",time,{not ((str _x) in ["<NULL-script>"])} count RydxHQ_Handles,{((str _x) in ["<NULL-script>"])} count RydxHQ_Handles];

// 	private ["_arr","_ix"];

// 	_arr = toArray (str _script);
// 	_ix = _arr find 59;
// 	_arr resize _ix;

// 	if not ((_arr select 1) in [83]) then
// 		{
// 		_arr resize 32
// 		}
// 	else
// 		{
// 		_arr = _arr - [34];
// 		_arr = [_arr] call RYD_ReverseArr;
// 		_arr resize ((_arr find 61) - 1);
// 		_arr = [_arr] call RYD_ReverseArr;
// 		};

// 	_string = toString _arr;

// 	if (isNil "RYD_Array") then {RYD_Array = []};

// 	if ((count RYD_Array) < 1) then
// 		{
// 		RYD_Array = [[_string,1]]
// 		}
// 	else
// 		{
// 		_inside = false;

// 			{
// 			if (_string in _x) exitWith
// 				{
// 				_x set [1,(_x select 1) + 1];
// 				_inside = true
// 				}
// 			}
// 		foreach RYD_Array;

// 		if not (_inside) then
// 			{
// 			RYD_Array pushBack [_string,1]
// 			}
// 		};

// 	diag_log "--------------------------------------------------------------------------------";

// 		{
// 		diag_log format ["%1",_x];
// 		}
// 	foreach RYD_Array*/
// 	};

RYD_ReverseArr =
	{
	private ["_arr","_final","_amnt"];

	_arr = _this select 0;
	_amnt = count _arr;

	_final = [];

		{
		_amnt = _amnt - 1;
		_final set [_amnt,_x]
		}
	forEach _arr;

	_final
	};

RYD_GroupMarkerLoop =
	{
	while {true} do
		{
		sleep 5;

			{
			_myMark = _x getVariable ["RYD_ItsMyMark",""];
			if (({alive _x} count (units _x)) > 0) then
				{
				_side = side _x;
				if (_side in _this) then
					{
					_ldr = leader _x;
					_pos = getPosATL (vehicle _ldr);

					_color = switch (_side) do
						{
						case (west) : {"ColorWEST"};
						case (east) : {"ColorEAST"};
						case (resistance) : {"ColorGUER"};
						default {"ColorCIV"};
						};

					if (_myMark isEqualTo "") then
						{
						_myMark = "ItsMyMark_" + (str _x) + (str (random 100));
						_myMark = createMarker [_myMark,_pos];
						_myMark setMarkerColor _color;
						_myMark setMarkerShape "ICON";
						_myMark setMarkerType "mil_dot";
						_myMark setMarkerSize [0.75,0.75];

						_x setVariable ["RYD_ItsMyMark",_myMark]
						}
					else
						{
						_myMark setMarkerPos _pos;

						if (0 in _this) then
							{
							_myMark setMarkerText (_x getVariable ["RydHQ_MyCrypto",toUpper (getText (configFile >> "CfgVehicles" >> (typeOf (vehicle _ldr)) >> "displayName"))])
							};

						_nE = _ldr findNearestEnemy _ldr;

						if (isNull _nE) then
							{
							_myMark setMarkerType "mil_dot"
							}
						else
							{
							_myMark setMarkerType "mil_triangle"
							}
						}
					}
				}
			else
				{
				if not (isNil "_myMark") then
					{
					deleteMarker _myMark
					}
				}
			}
		forEach allGroups
		}
	};

RYD_PresentRHQ =
	{
	private ["_allVehs","_allUnits","_vehClass","_wpClass","_magClass","_ammoClass","_addedU","_addedV","_veh","_vehClass2","_weapons","_hasLaserD","_wpClass2","_type","_mags",
	"_isDriver","_turrets","_mainT","_isArmed","_isAA","_isAT","_weaps","_trt","_wps","_wp","_muzzles","_ammo","_ammoC","_dam","_isCargo"];

	RYD_WS_AllClasses = RYD_WS_Inf_class + RYD_WS_Art_class + RYD_WS_HArmor_class + RYD_WS_MArmor_class + RYD_WS_LArmor_class + RYD_WS_Cars_class + RYD_WS_Air_class + RYD_WS_Naval_class + RYD_WS_Static_class + RYD_WS_Support_class + RYD_WS_Other_class;
	//RYD_WS_AllClasses = [];

	_allVehs = [];

		{
		if ((side _x) in [west,east,resistance]) then
			{
			_vh = toLower (typeOf _x);
			if not (_vh in RYD_WS_AllClasses) then
				{
				RYD_WS_AllClasses pushBackUnique _vh;
				_allVehs pushBack _x
				}
			}
		}
	forEach vehicles;

	_allUnits = [];

		{
		if ((side _x) in [west,east,resistance]) then
			{
			_vh = toLower (typeOf _x);
			if not (_vh in RYD_WS_AllClasses) then
				{
				RYD_WS_AllClasses pushBackUnique _vh;
				_allUnits pushBack _x
				}
			}
		}
	forEach allUnits;

	_vehClass = configFile >> "CfgVehicles";
	_wpClass = configFile >> "CfgWeapons";
	_magClass = configFile >> "CfgMagazines";
	_ammoClass = configFile >> "CfgAmmo";

	_addedU = [];
	_addedV = [];

		{
		_veh = toLower (typeOf _x);
		if not (_veh in _addedU) then
			{
			_addedU pushBack _veh;
			RHQ_Inf pushBackUnique _veh;

			_vehClass2 = _vehClass >> _veh;

			if ((getNumber (_vehClass2 >> "camouflage")) < 1) then
				{
				if ((toLower (getText (_vehClass2 >> "textSingular"))) isEqualTo "sniper") then
					{
					RHQ_Snipers pushBackUnique _veh
					}
				else
					{
					_weapons = getArray (_vehClass2 >> "weapons");

					RHQ_Recon pushBackUnique _veh;

					_hasLaserD = false;

						{
						_wpClass = configFile >> "CfgWeapons" >> _x;
						_type = getNumber (_wpClass >> "type");

						if (_type == 4096) then
							{
							_cursor = toLower (getText (_wpClass >> "cursor"));
							if (_cursor in ["","emptycursor"]) then
								{
								_cursor = toLower (getText (_wpClass >> "cursorAim"))
								};

							if (_cursor isEqualTo "laserdesignator") exitWith {_hasLaserD = true}
							};

						if (_hasLaserD) exitWith {}
						}
					forEach _weapons;

					if (_hasLaserD) then
						{
						RHQ_FO pushBackUnique _veh
						}
					}
				};

			_wps = getArray (_vehClass2 >> "Weapons");

			if ((count _wps) > 1) then
				{
				_isAT = false;
				_isAA = false;

					{
					_sWeapon = _x;
					_mgs = configFile >> "CfgWeapons" >> _sWeapon >> "magazines";
					if (isArray _mgs) then
						{
						_mgs = getArray _mgs;

						if ((count _mgs) > 0) then
							{
							_mag = _mgs select 0;
							_ammo = getText (configFile >> "CfgMagazines" >> _mag >> "ammo");
							_ammoC = configFile >> "CfgAmmo" >> _ammo;

							_isAA = ((getNumber (_ammoC >> "airLock")) > 1) or {((getNumber (_ammoC >> "airLock")) > 0) and {((getNumber (_ammoC >> "irLock")) > 0)}};

							if not (_isAA) then
								{
								_isAT = ((((getNumber (_ammoC >> "irLock")) + (getNumber (_ammoC >> "laserLock"))) > 0) and {((getNumber (_ammoC >> "airLock")) < 2)})
								};

							if (not (_isAT) and {not (_isAA)}) then
								{

									{
									_ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
									_ammoC = configFile >> "CfgAmmo" >> _ammo;
									_actHit = getNumber (_ammoC >> "hit");

									if (_actHit > 150) exitWith {_isAT = true}
									}
								forEach _mgs
								};

							if (_isAT) then
								{
								RHQ_ATInf pushBackUnique _veh
								};

							if (_isAA) then
								{
								RHQ_AAInf pushBackUnique _veh
								};
							}
						};

					if ((_isAT) or {(_isAA)}) exitWith {}
					}
				forEach _wps
				}
			}
		}
	forEach _allUnits;

	_flareMags = ["Laserbatteries","60Rnd_CMFlareMagazine","120Rnd_CMFlareMagazine","240Rnd_CMFlareMagazine","60Rnd_CMFlare_Chaff_Magazine","120Rnd_CMFlare_Chaff_Magazine","240Rnd_CMFlare_Chaff_Magazine","192Rnd_CMFlare_Chaff_Magazine","168Rnd_CMFlare_Chaff_Magazine","300Rnd_CMFlare_Chaff_Magazine"];

		{
		_veh = toLower (typeOf _x);
		_vehO = _x;
		if not (_veh in _addedV) then
			{
			_addedV pushBack _veh;

			_vehClass2 = _vehClass >> _veh;

			_isDriver = (getNumber (_vehClass2 >> "hasDriver")) > 0;

			_turrets = _vehClass2 >> "Turrets";
			_cT = count _turrets;
			_tMags = [];

			if (_cT > 0) then
				{
				for "_i" from 0 to (_cT - 1) do
					{
					_trt = _turrets select _i;
					if (isClass _trt) then
						{
						_trt = configName _trt;
						_mgT = _vehClass2 >> "Turrets" >> _trt >> "magazines";
						if (isArray _mgT) then
							{
							_tMags = _tMags + (getArray _mgT)
							}
						}
					}
				};

			_mainT = _turrets >> "MainTurret";
			_isMainT = isClass _mainT;

			_isAmmoS = (getNumber (_vehClass2 >> "transportAmmo")) > 0;
			_isFuelS = (getNumber (_vehClass2 >> "transportFuel")) > 0;
			_isRepS = (getNumber (_vehClass2 >> "transportRepair")) > 0;
			_isMedS = (getNumber (_vehClass2 >> "attendant")) > 0;
			_mags = getArray (_vehClass2 >> "magazines") + _tMags;
			_isArmed = (count (_mags - _flareMags)) > 0;
			_isCargo = ((getNumber (_vehClass2 >> "transportSoldier")) > 0) and {((getNumber (_vehClass2 >> "transportAmmo")) + (getNumber (_vehClass2 >> "transportFuel")) + (getNumber (_vehClass2 >> "transportRepair")) + (getNumber (_vehClass2 >> "attendant"))) < 1};
			_isArty = (getNumber (_vehClass2 >> "artilleryScanner")) > 0;

			_type = "inf";

			_base = _veh;
			/*
			while {not (_base in ["air","ship","tank","car","wheeled_apc_f","ugv_01_base_f"])} do
				{
				_base = inheritsFrom (_vehClass >> _base);
				if not (isClass _base) exitWith {};
				_base = toLower (configName _base);
				if (_base in ["allvehicles","all"]) exitWith {};
				};
			*/
			switch (true) do {
				case (_veh isKindOf "air"): {_base = "air"};
				case (_veh isKindOf "ship"): {_base = "ship"};
				case (_veh isKindOf "tank"): {_base = "tank"};
				case (_veh isKindOf "car"): {_base = "car"};
				case (_veh isKindOf "wheeled_apc_f"): {_base = "wheeled_apc_f"};
				case (_veh isKindOf "ugv_01_base_f"): {_base = "ugv_01_base_f"};
				default {_base = _veh};
			};

			if not (_base isEqualTo "ugv_01_base_f") then
				{
				if (_base in ["air","ship","tank","car","wheeled_apc_f"]) then
					{
					_type = _base
					};
				};

			if (_isArty) then
				{
				RHQ_Art pushBackUnique _veh;

				if not (missionNamespace getVariable ["RHQ_ClassRangeDefined" + str (_veh),false]) then {

					_lPiece = _vehO;
					_pos = position _lPiece;
					_minRange = 0;
					_maxRange = 0;

					_mainAmmoType = (((magazinesAmmo _lPiece) select 0) select 0);

					_checkLoop = false;
					_posCheck = position _lPiece;
					_checkRange = 0;
					_timeOut = false;
					_canFire = false;

					waitUntil {

//						sleep 0.0000001;

						_canFire = false;
						_timeOut = false;

						_minRange = (_minRange + 100);
						_posCheck = [(_pos select 0) + _minRange, (_pos select 1),0];
						_canFire = _posCheck inRangeOfArtillery [[_lPiece],_mainAmmoType];

						if (_canFire) then {
//							_minRange = (_minRange - 100);
							_checkRange = _minRange;
							_canFire = false;
							for "_i" from 100 to 0 step -25 do {

								_checkRange = (_minRange - 25);
								_posCheck = [(_pos select 0) + _checkRange, (_pos select 1),0];
								_canFire = _posCheck inRangeOfArtillery [[_lPiece],_mainAmmoType];

								if not (_canFire) exitWith {_minRange = _checkRange};
							};
						};

						_checkRange = _minRange;

						if (_checkRange > 200000) then {_timeOut = true};


						((_canFire) or (_timeOut))
					};

//					_vehO setVariable ["RHQ_RangeMin",_minRange];
					missionNamespace setVariable ["RHQ_ClassRangeMin" + str (_veh),_minRange];

					_checkLoop = false;
					_posCheck = position _lPiece;
					_checkRange = 0;
					_timeOut = false;
					_canFire = false;
					_maxRange = _minRange;

					waitUntil {

//						sleep 0.0000001;

						_canFire = true;
						_timeOut = false;

						_maxRange = (_maxRange + 1000);
						_posCheck = [(_pos select 0) + _maxRange, (_pos select 1),0];
						_canFire = _posCheck inRangeOfArtillery [[_lPiece],_mainAmmoType];

						if not (_canFire) then {
//							_maxRange = (_maxRange - 1000);
							_checkRange = _maxRange;
							_canFire = true;
							for "_i" from 1000 to 0 step -25 do {

								_checkRange = (_maxRange - 25);
								_posCheck = [(_pos select 0) + _checkRange, (_pos select 1),0];
								_canFire = _posCheck inRangeOfArtillery [[_lPiece],_mainAmmoType];

								if (_canFire) exitWith {_maxRange = _checkRange};
							};
						};

						_checkRange = _maxRange;
						//if (_checkRange > 50000) then {_maxRange = (_maxRange + 975);};

						if (_checkRange > 200000) then {_timeOut = true};


						(not (_canFire) or (_timeOut))
					};

//					_vehO setVariable ["RHQ_RangeMax",_maxRange];
//					_vehO setVariable ["RHQ_RangeDefined",true];
					missionNamespace setVariable ["RHQ_ClassRangeMax" + str (_veh),_maxRange];
					missionNamespace setVariable ["RHQ_ClassRangeDefined" + str (_veh),true];

				};

				_prim = "";
				_rare = "";
				_sec = "";
				_smoke = "";
				_illum = "";

				if (_isArmed) then
					{
					_mags = magazines _vehO;

					if (_isMainT) then
						{
						_mags = _mags + ((getArray (_mainT >> "magazines")) - _mags)
						};

					_maxHit = 10;

						{
						_ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
						_ammoC = configFile >> "CfgAmmo" >> _ammo;

						_actHit = getNumber (_ammoC >> "indirectHitRange");
						_subM = toLower (getText (_ammoC >> "submunitionAmmo"));

						if (_actHit <= 10) then
							{
							if not (_subM isEqualTo "") then
								{
								_ammoC = configFile >> "CfgAmmo" >> _subM;
								_actHit = getNumber (_ammoC >> "indirectHitRange")
								}
							};

						if ((_actHit > _maxHit) and {_actHit < 100}) then
							{
							_maxHit = _actHit;
							_prim = _x
							}
						}
					forEach _mags;

					_mags = _mags - [_prim];
					_mags0 = +_mags;
					_illumChosen = false;
					_smokeChosen = false;
					_rareChosen = false;
					_secChosen = false;

						{
						_ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
						_ammoC = configFile >> "CfgAmmo" >> _ammo;

						_hit = getNumber (_ammoC >> "indirectHit");
						_lc = _ammoC >> "lightColor";
						_sim = toLower (getText (_ammoC >> "simulation"));
						_subM = toLower (getText (_ammoC >> "submunitionAmmo"));

						if (_hit <= 10) then
							{
							if not (_subM isEqualTo "") then
								{
								_ammoC = configFile >> "CfgAmmo" >> _subM;
								_hit = getNumber (_ammoC >> "indirectHit")
								}
							};

						switch (true) do
							{
							case ((isArray _lc) and {not (_illumChosen)}) :
								{
								_illum = _x;
								_mags = _mags - [_x];
								_illumChosen = true
								};

							case ((_hit <= 10) and {(_subM isEqualTo "smokeshellarty") and {not (_smokeChosen)}}) :
								{
								_smoke = _x;
								_mags = _mags - [_x];
								_smokeChosen = true
								};

							case ((_sim isEqualTo "shotsubmunitions") and {not (_rareChosen)}) :
								{
								_rare = _x;
								_mags = _mags - [_x];
								_rareChosen = true
								};

							case ((_hit > 10) and {not ((_secChosen) or {(_rare == _x)})})  :
								{
								_sec = _x;
								_mags = _mags - [_x];
								_secChosen = true
								}
							}
						}
					forEach _mags0;

					if (_sec isEqualTo "") then
						{
						_maxHit = 10;

							{
							_ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
							_ammoC = configFile >> "CfgAmmo" >> _ammo;
							_subAmmo = _ammoC >> "subMunitionAmmo";

							if ((isText _subAmmo) and {not ((getText _subAmmo) isEqualTo "")}) then
								{
								_ammoC = configFile >> "CfgAmmo" >> (getText _subAmmo);
								};

							_actHit = getNumber (_ammoC >> "indirectHit");

							if (_actHit > _maxHit) then
								{
								_maxHit = _actHit;
								_sec = _x
								}
							}
						forEach _mags;
						}
					};

				_arr = [_prim,_rare,_sec,_smoke,_illum];
				if (({_x isEqualTo ""} count _arr) < 5) then
					{
					RydHQ_Add_OtherArty pushBackUnique [[_veh],_arr]
					}
				};

			if (_isDriver) then
				{
				switch (_type) do
					{
					case ("car") : {RHQ_Cars pushBackUnique _veh};
					case ("tank") : {RHQ_HArmor pushBackUnique _veh};
					case ("wheeled_apc_f") : {RHQ_LArmor pushBackUnique _veh};
					case ("air") :
						{
						RHQ_Air pushBackUnique _veh;

						if not (_isArmed) then
							{
							RHQ_NCAir pushBackUnique _veh;
							};

						_isUAV = (getNumber (_vehClass2 >> "Uav")) > 0;

						if not (_isUAV) then
							{
							_isUAV = (toLower (getText (_vehClass2 >> "crew"))) in ["b_uav_ai","i_uav_ai","o_uav_ai"];
							};

						if (_isUAV) then
							{
							RHQ_RAir pushBackUnique _veh
							}
						};

					case ("ship") : {RHQ_Naval pushBackUnique _veh};
					};

				if (_isCargo) then
					{
					RHQ_Cargo pushBackUnique _veh;
					if not (_isArmed) then
						{
						RHQ_NCCargo pushBackUnique _veh;
						}
					};

				RHQ_HArmor = RHQ_HArmor - RHQ_Art;

				if (_isArmed) then
					{
					_mags = magazines _vehO;

					if (_isMainT) then
						{
						_mags = _mags + ((getArray (_mainT >> "magazines")) - _mags)
						};

						{
						_ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
						_ammoC = configFile >> "CfgAmmo" >> _ammo;

						_isAA = (getNumber (_ammoC >> "airLock")) > 1;
						_isAT = ((((getNumber (_ammoC >> "irLock")) + (getNumber (_ammoC >> "laserLock"))) > 0) and {((getNumber (_ammoC >> "airLock")) < 2)});

						if ((_isAA) and {not (_type isEqualTo "air")}) then {RHQ_AAInf pushBackUnique _veh};
						if (_isAT) then
							{
							if (_type isEqualTo "wheeled_apc_f") then
								{
								RHQ_LArmorAT pushBackUnique _veh
								}
							else
								{
								if (_type isEqualTo "car") then
									{
									RHQ_ATInf pushBackUnique _veh
									}
								}
							};

						if ((_isAA) or {(_isAT)}) exitWith {}
						}
					forEach _mags
					}
				}
			else
				{
				if (_isArmed) then
					{
					RHQ_Static pushBackUnique _veh;

					_mags = magazines _vehO;

					if (_isMainT) then
						{
						_mags = _mags + ((getArray (_mainT >> "magazines")) - _mags)
						};

						{
						_ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
						_ammoC = configFile >> "CfgAmmo" >> _ammo;

						_isAA = (getNumber (_ammoC >> "airLock")) > 1;
						_isAT = ((((getNumber (_ammoC >> "irLock")) + (getNumber (_ammoC >> "laserLock"))) > 0) and {((getNumber (_ammoC >> "airLock")) < 2)});

						if (_isAA) then {RHQ_StaticAA pushBackUnique _veh};
						if (_isAT) then {RHQ_StaticAT pushBackUnique _veh};

						if ((_isAA) or {(_isAT)}) exitWith {}
						}
					forEach _mags
					}
				};

			if (_isAmmoS) then
				{
				if not (_veh in RHQ_Ammo) then
					{
					RHQ_Ammo pushBackUnique _veh
					};

				if not (_veh in RHQ_Support) then
					{
					RHQ_Support pushBackUnique _veh
					}
				};

			if (_isFuelS) then
				{
				if not (_veh in RHQ_Fuel) then
					{
					RHQ_Fuel pushBackUnique _veh
					};

				if not (_veh in RHQ_Support) then
					{
					RHQ_Support pushBackUnique _veh
					}
				};

			if (_isRepS) then
				{
				if not (_veh in RHQ_Rep) then
					{
					RHQ_Rep pushBackUnique _veh
					};

				if not (_veh in RHQ_Support) then
					{
					RHQ_Support pushBackUnique _veh
					}
				};

			if (_isMedS) then
				{
				if not (_veh in RHQ_Med) then
					{
					RHQ_Med pushBackUnique _veh
					};

				if not (_veh in RHQ_Support) then
					{
					RHQ_Support pushBackUnique _veh
					}
				};

			if (_type in ["air","tank","wheeled_apc_f"]) then
				{
				_crew = _vehClass >> _veh >> "crew";

				if (isText _crew) then
					{
					_crew = toLower (getText _crew);

					if not (_crew in (RYD_WS_Crew_class + RHQ_Crew)) then
						{
						RHQ_Crew pushBackUnique _crew;
						}
					}
				}
			};
		}
	forEach _allVehs;

	if (isNil "RydHQ_Add_OtherArty") then {RydHQ_Add_OtherArty = []};

	RydHQ_OtherArty = [] + RydHQ_Add_OtherArty;

		{
			{
			RydHQ_AllArty pushBackUnique (toLower _x)
			}
		forEach (_x select 0)
		}
	forEach RydHQ_OtherArty;

	publicVariable "RydHQ_OtherArty";

	RHQ_Inf = RHQ_Inf - ["b_uav_ai","i_uav_ai","o_uav_ai"];
	RHQ_Crew = RHQ_Crew - ["b_uav_ai","i_uav_ai","o_uav_ai"];

	true
	};

HAL_FBFTLOOP =

	{

		private ["_SidePLY","_IgnoredPLY","_RydMarks","_MarkGrps","_checkFriends","_OldMarkGrps","_mrk","_mrk2","_OldRydMarks","_RydOrd","_OldRydOrd","_RydMarksOrd","_OldRydMarksOrd"];

		_HQ = (_this select 0);

		while {not (isNull _HQ)} do {


			_SidePLY = [];
			_IgnoredPLY = [];

			{
				if ((side _x) == (side _HQ)) then {_SidePLY pushBack _x};
				if ((group _x) in (_HQ getVariable ["RydHQ_Friends",[]])) then  {_IgnoredPLY pushBack (group _x)};

			} forEach allPlayers;

			_OldMarkGrps = _HQ getVariable ["RydMarkGrpF",[]];
			_OldRydMarks = _HQ getVariable ["RydMarksF",[]];

			_OldRydOrd = _HQ getVariable ["RydOrdnances",[]];
			_OldRydMarksOrd = _HQ getVariable ["RydMarksOrd",[]];

			_MarkGrps = [];
			_RydMarks = [];

			_RydOrd = [];
			_RydMarksOrd = [];

			if (_HQ getVariable ["RydHQ_InfoMarkers",false]) then {

				//{
				//	private ["_ply"];
				//	_ply = _x;
				_MarkGrps = ((_HQ getVariable ["RydHQ_Friends",[]]) - _IgnoredPLY);
				_RydOrd = _HQ getVariable ["RydHQ_OrdnanceDrops",[]];

					{
						private ["_mrk","_mrkcolor","_mrktype","_mrktext","_mrk2","_mrksize","_distance","_dx","_dY","_angle","_dXb","_dYb","_posX","_posY","_mrk3"];

						_mrk = _x getVariable "FirstMarkF";
						if (isNil "_mrk") then {_mrk = createMarker ["markF" + (str _x),(leader _x)];_x setVariable ["FirstMarkF",_mrk];};
						_mrkcolor = format ["Color%1", side _x];
						_mrktype = _x call HAL_fnc_getType;
						_mrksize = [_x,units _x,_mrktype] call HAL_fnc_getSize;

						switch (side _x) do {

							case west : {_mrktype = "b_" + _mrktype};
							case east : {_mrktype = "o_" + _mrktype};
							case resistance : {_mrktype = "n_" + _mrktype};
							default {_mrktype = "Empty"};

						};

						_mrk setMarkerType _mrktype;
						_mrk setMarkerColor _mrkcolor;


						if not (_mrksize == -1) then {

							_mrk2 = _x getVariable "FirstMarkF2";
							if (isNil "_mrk2") then {_mrk2 = createMarker ["markF2" + (str _x),(leader _x)];_x setVariable ["FirstMarkF2",_mrk2];};
							_mrk2 setMarkerType ("group_" + (str _mrksize));

						};

						_mrktext = _x getVariable ["Ryd_MarkText",nil];

						if (isNil "_mrktext") then {

							if ((RydxHQ_InfoMarkersID) and ((side _x) == (side _HQ))) then {_mrk setMarkerText (groupId _x)};

						} else {

							if ((side _x) == (side _HQ)) then {_mrk setMarkerText _mrktext};

						};

						_mrk setMarkerSize [0.75,0.75];
						if not (_mrksize == -1) then {

							if ((side _x) == east) then {_mrk2 setMarkerSize [0.85,1.15]};
							if ((side _x) == west) then {_mrk2 setMarkerSize [0.85,0.85]};
							if ((side _x) == resistance) then {_mrk2 setMarkerSize [0.85,1.05]};
							_mrk2 setMarkerPos (position (leader _x));
							_RydMarks pushBack _mrk2;

						};

						_RydMarks pushBack _mrk;
						_mrk setMarkerPos (position (leader _x));

					} forEach _MarkGrps;

					{
						private ["_mrk","_mrkcolor","_mrktype"];

						_mrk = _x getVariable "FirstMarkOrd";
						if (isNil "_mrk") then {_mrk = createMarker ["markOrd" + (str _x),_x];_x setVariable ["FirstMarkOrd",_mrk];};
						_mrkcolor = format ["Color%1", side (leader _HQ)];

						switch (side (leader _HQ)) do {

							case west : {_mrktype = "b_" + "Ordnance"};
							case east : {_mrktype = "o_" + "Ordnance"};
							case resistance : {_mrktype = "n_" + "Ordnance"};
							default {_mrktype = "Empty"};

						};

						_mrk setMarkerType _mrktype;
						_mrk setMarkerColor _mrkcolor;

						_mrk setMarkerSize [0.75,0.75];


						_RydMarksOrd pushBack _mrk;
						_mrk setMarkerPos (position _x);

					} forEach _RydOrd;

				//} foreach _SidePLY;

			};

			{
				_x setVariable ["FirstMarkF",nil];
				_x setVariable ["FirstMarkF2",nil];
			} forEach (_OldMarkGrps - (_MarkGrps - [grpNull]));

			{
				deleteMarker _x;
			} forEach (_OldRydMarks - _RydMarks);


			{
				_x setVariable ["FirstMarkOrd",nil];
			} forEach (_OldRydOrd - (_RydOrd - [objNull]));

			{
				deleteMarker _x;
			} forEach (_OldRydMarksOrd - _RydMarksOrd);

			_HQ setVariable ["RydMarkGrpF",_MarkGrps];
			_HQ setVariable ["RydMarksF",_RydMarks];

			_HQ setVariable ["RydOrdnances",_RydOrd];
			_HQ setVariable ["RydMarksOrd",_RydMarksOrd];

			sleep 5;

		};


	};

HAL_EBFT =

	{
		private ["_SidePLY","_IgnoredPLY","_RydMarks","_MarkGrps","_checkFriends","_OldMarkGrps","_mrk","_mrk2","_OldRydMarks"];

		_HQ = (_this select 0);

		_OldMarkGrps = _HQ getVariable ["RydMarkGrpE",[]];
		_OldRydMarks = _HQ getVariable ["RydMarksE",[]];

		_MarkGrps = [];
		_RydMarks = [];

		if (_HQ getVariable ["RydHQ_InfoMarkers",false]) then {

			//{
			//	private ["_ply"];
			//	_ply = _x;
			_MarkGrps = (_HQ getVariable ["RydHQ_KnEnemiesG",[]]);

				{
					private ["_mrk","_mrkcolor","_mrktype","_mrktext","_mrk2","_mrksize","_distance","_dx","_dY","_angle","_dXb","_dYb","_posX","_posY","_mrk3"];

					_mrk = _x getVariable "FirstMarkE";
					if (isNil "_mrk") then {_mrk = createMarker ["markE" + (str _x),(leader _x)];_x setVariable ["FirstMarkE",_mrk];};
					_mrkcolor = format ["Color%1", side _x];
					_mrktype = _x call HAL_fnc_getType;
					_mrksize = [_x,units _x,_mrktype] call HAL_fnc_getSize;

					switch (side _x) do {

							case west : {_mrktype = "b_" + _mrktype};
							case east : {_mrktype = "o_" + _mrktype};
							case resistance : {_mrktype = "n_" + _mrktype};
							default {_mrktype = "Empty"};

					};

					_mrk setMarkerType _mrktype;
					_mrk setMarkerColor _mrkcolor;

					if not (_mrksize == -1) then {

						_mrk2 = _x getVariable "FirstMarkE2";
						if (isNil "_mrk2") then {_mrk2 = createMarker ["markE2" + (str _x),(leader _x)];_x setVariable ["FirstMarkE2",_mrk2];};
						_mrk2 setMarkerType ("group_" + (str _mrksize));

					};

					_mrktext = _x getVariable ["Ryd_MarkText",nil];

					if (isNil "_mrktext") then {

						if ((RydxHQ_InfoMarkersID) and ((side _x) == (side _HQ))) then {_mrk setMarkerText (groupId _x)};

					} else {

						if ((side _x) == (side _HQ)) then {_mrk setMarkerText _mrktext};

					};

					_mrk setMarkerSize [0.75,0.75];
					if not (_mrksize == -1) then {

						if ((side _x) == east) then {_mrk2 setMarkerSize [0.85,1.15]};
						if ((side _x) == west) then {_mrk2 setMarkerSize [0.85,0.85]};
						if ((side _x) == resistance) then {_mrk2 setMarkerSize [0.85,1.05]};

						_mrk2 setMarkerPos (position (leader _x));
						_RydMarks pushBack _mrk2;

					};

					_RydMarks pushBack _mrk;
					_mrk setMarkerPos (position (leader _x));

				} forEach _MarkGrps;
			//} foreach _SidePLY;

			};

			{
				_x setVariable ["FirstMarkE",nil];
				_x setVariable ["FirstMarkE2",nil];
			} forEach (_OldMarkGrps - (_MarkGrps - [grpNull]));

			{
				deleteMarker _x;
			} forEach (_OldRydMarks - _RydMarks);

			_HQ setVariable ["RydMarkGrpE",_MarkGrps];
			_HQ setVariable ["RydMarksE",_RydMarks];
	};

HAL_SecTasks =

	{
		private ["_leader","_side","_HQ","_taskedGroups","_taskedGroups"];

		_HQ = _this select 0;

		while {not (isNull _HQ)} do {

			if ((_HQ getVariable ["RydHQ_SecTasks",true]) and (_HQ getVariable ["RydHQ_SimpleMode",true])) then {

				_taskedGroups = [];

				_friends = _HQ getVariable ["RydHQ_Friends",[]];

				{
					if ((group _x) in _friends) then {
						_taskedGroups pushBackUnique (group _x);
					}
				} forEach allPlayers;

				{
					private ["_Group","_TaskedObjectives","_DefendObjectives","_taskedGroups","_taskedGroups","_setTaken","_taskID","_ObjName","_ParentID"];

					_Group = _x;
					_TaskedObjectives = (_Group getVariable ["TaskedObjectives",[]]);
					_DefendObjectives = (_Group getVariable ["DefendObjectives",[]]);

					_ParentID = _Group getVariable "SecTskParentID";

					if (isNil "_ParentID") then {
						_ParentID = str (_HQ) + str (_Group) + "masterTask";
						[_Group, [_ParentID], ["List of objective control related tasks.", "Objectives", nil] , _x,"CREATED", -10, false, "map"] call BIS_fnc_taskCreate;
						_Group setVariable ["SecTskParentID",_ParentID];
						};

					{
						_setTaken = false;
						if (_x in (_HQ getVariable ["RydHQ_Taken",[]])) then {_setTaken = true} else {_setTaken = false};

						_taskID = (str _Group) + (str _x) + "HALStsk";

						_ObjName = _x getVariable "ObjName";
						if (isNil "_ObjName") then {

							_where = mapGridPosition (getPos _x);
							_ObjName = "Objective At " + _where;

							_nL = nearestLocations [(getPos _x), ["Hill","NameCityCapital","NameCity","NameVillage","NameLocal","Strategic","StrongpointArea"], 500];

							if ((count _nL) > 0) then {
								_nL = _nL select 0;
								_where = (text _nL);
								_ObjName = _where;
								};
							};

						if not (_setTaken) then {

							[_Group, [_taskID,_ParentID], ["Secure objective.", "Secure " + _ObjName, nil] , _x,"CREATED", -1, false, "move"] call BIS_fnc_taskCreate;
							_TaskedObjectives pushBack _x;

							} else {

							[_Group, [_taskID,_ParentID], ["Defend objective.", "Defend " + _ObjName, nil] , _x,"CREATED", -1, false, "defend"] call BIS_fnc_taskCreate;
							_TaskedObjectives pushBack _x;
							_DefendObjectives pushBack _x;

							};

					} forEach ((_HQ getVariable ["RydHQ_Objectives",[]]) - _TaskedObjectives);

					{
						_taskID = (str _Group) + (str _x) + "HALStsk";

						[_taskID] call BIS_fnc_deleteTask;
						_TaskedObjectives = _TaskedObjectives - [_x];
						_DefendObjectives = _DefendObjectives - [_x];

					} forEach (_TaskedObjectives - (_HQ getVariable ["RydHQ_Objectives",[]]));

					{

						_taskID = (str _Group) + (str _x) + "HALStsk";

						if (_x in (_HQ getVariable ["RydHQ_Taken",[]])) then {
							[_taskID,"SUCCEEDED"] call BIS_fnc_taskSetState;
							_TaskedObjectives = _TaskedObjectives - [_x];
							};

					} forEach (_TaskedObjectives - _DefendObjectives);

					{

						_taskID = (str _Group) + (str _x) + "HALStsk";

						if not (_x in (_HQ getVariable ["RydHQ_Taken",[]])) then {
							[_taskID,"FAILED"] call BIS_fnc_taskSetState;
							_DefendObjectives = _DefendObjectives - [_x];
							_TaskedObjectives = _TaskedObjectives - [_x];
							};

					} forEach _DefendObjectives;

					_Group setVariable ["TaskedObjectives",_TaskedObjectives];
					_Group setVariable ["DefendObjectives",_DefendObjectives];

				} forEach _taskedGroups;

				sleep 15;
			};
		};
	};

RYD_PresentRHQLoop =

	{
		sleep 60;
		while {RydxHQ_RHQAutoFill} do {

			waitUntil {sleep 5; (({(_x getVariable ["RydHQ_Pending",false])} count RydxHQ_AllHQ) == 0)};
			[] spawn RYD_PresentRHQ;
			sleep 60;
		};
	};

RYD_deployUAV =
	{
	private ["_gp","_pos","_HQ","_uav","_hasUAV","_myPos","_ang","_unit","_backpack","_backPackClass","_assClass","_uavClass","_sPos","_uav","_gpUAV","_mPos","_wp","_timer","_alive","_nE","_excl","_alt"];

	_gp = _this select 0;//uav team
	_pos = _this select 1;//position to be observed
	_HQ = _this select 2;

	_uav = objNull;
	_hasUAV = false;

		{
		_unit = _x;

		_backpack = unitBackpack _unit;

		if (not (isNull _backPack) and {(_unit == (vehicle _unit))}) then
			{
			_backPackClass = typeOf _backPack;
			_assClass = configFile >> "CfgVehicles" >> _backPackClass >> "assembleInfo";
			if (isClass _assClass) then
				{
				_uavClass = _assClass >> "assembleTo";
				if (isText _uavClass) then
					{
					_uavClass = getText _uavClass;
					_hasUAV = true;

						{
						doStop _x;
						if not (isPlayer _x) then
							{
							_x setUnitPos "MIDDLE"
							}
						}
					forEach (units _gp);

					sleep (5 + (random 5));

					if ((isNull _unit) or {not (alive _unit)}) exitWith {};

					removeBackpack _unit;

					_myPos = getPosATL _unit;

					_ang = [_myPos,_pos,20] call RYD_AngTowards;
					_sPos = [_myPos,_ang,2] call RYD_PosTowards2D;
					_sPos set [2,0];

					_uav = createVehicle [_uavClass, _sPos, [], 0, "NONE"];

					createVehicleCrew _uav;

					_gpUAV = group _uav;

						{
						_x setSkill ["spotDistance",1];
						_x setSkill ["spotTime",1]
						}
					forEach (units _gpUAV);

					_excl = _HQ getVariable ["RydHQ_Excluded",[]];
					_excl pushBack _gpUAV;

					_alt = _HQ getVariable ["RydHQ_UAVAlt",150];

					_mPos = [_pos,50] call RYD_RandomAround;
					_mPos set [2,_alt];//does nothing, 50 meters alt by default
					_uav flyInHeight _alt;//works fine

					deleteWaypoint [_gpUAV,0];

					_wp = _gpUAV addWaypoint [_mPos, 0];
					_wp setWaypointType "SAD";
					_wp setWaypointBehaviour "CARELESS";
					_wp setWaypointCombatMode "RED";
					_wp setWaypointSpeed "FULL";
					_wp setWaypointStatements ["true","deletewaypoint [(group this), 0]"];
					_wp setWaypointTimeout [20,30,40];

					_wp = _gpUAV addWaypoint [_sPos, 0];
					_wp setWaypointType "MOVE";
					_wp setWaypointBehaviour "CARELESS";
					_wp setWaypointCombatMode "BLUE";
					_wp setWaypointSpeed "FULL";
					_wp setWaypointStatements ["true","{(vehicle _x) land 'LAND'} foreach (units (group this));deletewaypoint [(group this), 0]"];

					_unit connectTerminalToUAV _uav;

					_uav doWatch _mPos;

					_timer = time;
					_alive = true;

					waitUntil
						{
						sleep 1;

						_nE = _unit findNearestEnemy _unit;

						switch (true) do
							{
							case (isNull _uav): {_alive = false};
							case (not (alive _uav)): {_alive = false};
							case (not (alive (assignedDriver _uav))): {_alive = false};
							case ((fuel _uav) == 0): {_alive = false};
							case not (canMove _uav): {_alive = false};
							case (isNull _unit): {_alive = false};
							case (not (alive _unit)): {_alive = false};
							case (not (isNull _nE) and {((_nE distance _unit) < 100) or {(_nE knowsAbout _unit) > 1}}): {_alive = false};
							};

						(not (_alive) or {(isTouchingGround _uav) and {((toLower (landResult _uav)) isEqualTo "found") or {((toLower (landResult _uav)) isEqualTo "notfound") or {(time - _timer) > 900}}}})
						};

						{
						deleteVehicle _x
						}
					forEach (crew _uav);

					deleteVehicle _uav;
					deleteGroup _gpUAV;

						{
						_x doMove (position _x);
						if not (isPlayer _x) then
							{
							_x setUnitPos "AUTO"
							}
						}
					forEach (units _gp);

					if (not (_alive) or {((time - _timer) > 900)}) exitWith {};
					if ((_unit distance _sPos) > 100) exitWith {};

					_unit addBackpack _backPackClass
					}
				}
			};

		if (_hasUAV) exitWith {};
		}
	forEach (units _gp);

	_hasUAV
	};
