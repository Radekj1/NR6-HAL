#include "..\script_component.hpp"
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

					//waitUntil {
//						sleep 0.0000001;
						[{
						[{
						_canFire = false;
						_timeOut = false;

						_minRange = (_minRange + 100);
						_posCheck = [(_pos select 0) + _minRange, (_pos select 1),0];
						_canFire = _posCheck inRangeOfArtillery [[_lPiece],_mainAmmoType];
						}, 0.5] call CBA_fnc_waitAndExecute;
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
						
					},{}] call CBA_fnc_waitUntilAndExecute;
//					_vehO setVariable ["RHQ_RangeMin",_minRange];
					missionNamespace setVariable ["RHQ_ClassRangeMin" + str (_veh),_minRange];

					_checkLoop = false;
					_posCheck = position _lPiece;
					_checkRange = 0;
					_timeOut = false;
					_canFire = false;
					_maxRange = _minRange;

					//waitUnil {
//						sleep 0.0000001;
					[{
						[{
						_canFire = true;
						_timeOut = false;

						_maxRange = (_maxRange + 1000);
						_posCheck = [(_pos select 0) + _maxRange, (_pos select 1),0];
						_canFire = _posCheck inRangeOfArtillery [[_lPiece],_mainAmmoType];
						}, 0.5] call CBA_fnc_waitAndExecute;
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
					},{}] call CBA_fnc_waitUntilAndExecute;
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

//	true
	};