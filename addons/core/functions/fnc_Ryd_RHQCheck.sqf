#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf 
RYD_RHQCheck =
	{
	private ["_type","_noInTotal","_noInAdditional","_noInBasic","_civF","_total","_basicrhq","_Additionalrhq","_Inf","_Art","_HArmor","_LArmor","_Cars","_Air","_Naval","_Static","_Other","_specFor",
		"_recon","_FO","_snipers","_ATInf","_AAInf","_LArmorAT","_NCAir","_StaticAA","_StaticAT","_Cargo","_NCCargo","_Crew","_MArmor","_BAir","_RAir","_ammo","_fuel","_med","_rep"];

	_specFor = RHQ_SpecFor + RYD_WS_specFor_class - RHQs_SpecFor;

	_recon = RHQ_Recon + RYD_WS_recon_class - RHQs_Recon;

	_FO = RHQ_FO + RYD_WS_FO_class - RHQs_FO;

	_snipers = RHQ_Snipers + RYD_WS_snipers_class - RHQs_Snipers;

	_ATinf = RHQ_ATInf + RYD_WS_ATinf_class - RHQs_ATInf;

	_AAinf = RHQ_AAInf + RYD_WS_AAinf_class - RHQs_AAInf;

	_Inf = RHQ_Inf + RYD_WS_Inf_class - RHQs_Inf;

	_Art = RHQ_Art + RYD_WS_Art_class - RHQs_Art;

	_HArmor = RHQ_HArmor + RYD_WS_HArmor_class - RHQs_HArmor;

	_MArmor = RHQ_MArmor + RYD_WS_MArmor_class - RHQs_MArmor;

	_LArmor = RHQ_LArmor + RYD_WS_LArmor_class - RHQs_LArmor;

	_LArmorAT = RHQ_LArmorAT + RYD_WS_LArmorAT_class - RHQs_LArmorAT;

	_Cars = RHQ_Cars + RYD_WS_Cars_class - RHQs_Cars;

	_Air = RHQ_Air + RYD_WS_Air_class - RHQs_Air;

	_BAir = RHQ_BAir + RYD_WS_BAir_class - RHQs_BAir;

	_RAir = RHQ_RAir + RYD_WS_RAir_class - RHQs_RAir;

	_NCAir = RHQ_NCAir + RYD_WS_NCAir_class - RHQs_NCAir;

	_Naval = RHQ_Naval + RYD_WS_Naval_class - RHQs_Naval;

	_Static = RHQ_Static + RYD_WS_Static_class - RHQs_Static;

	_StaticAA = RHQ_StaticAA + RYD_WS_StaticAA_class - RHQs_StaticAA;

	_StaticAT = RHQ_StaticAT + RYD_WS_StaticAT_class - RHQs_StaticAT;

	_Support = RHQ_Support + RYD_WS_Support_class - RHQs_Support;

	_Cargo = RHQ_Cargo + RYD_WS_Cargo_class - RHQs_Cargo;

	_NCCargo = RHQ_NCCargo + RYD_WS_NCCargo_class - RHQs_NCCargo;

	_Crew = RHQ_Crew + RYD_WS_Crew_class - RHQs_Crew;

	_Other = RHQ_Other + RYD_WS_Other_class;

	_ammo = RHQ_Ammo + RYD_WS_ammo - RHQs_Ammo;

	_fuel = RHQ_Fuel + RYD_WS_fuel - RHQs_Fuel;

	_med = RHQ_Med + RYD_WS_med - RHQs_Med;

	_rep = RHQ_Rep + RYD_WS_rep - RHQs_Rep;

	_civF = ["CIV_F","CIV","CIV_RU","BIS_TK_CIV","BIS_CIV_special"];

	_basicrhq = _Inf + _Art + _HArmor + _LArmor + _Cars + _Air + _Naval + _Static;

	_Additionalrhq = _Other + _specFor + _recon + _FO + _snipers + _ATInf + _AAInf + _LArmorAT + _NCAir + _StaticAA + _StaticAT + _Cargo + _NCCargo + _Crew + _MArmor + _BAir + _RAir + _ammo + _fuel + _med + _rep;

	_total = _basicrhq + _Additionalrhq;

	_noInBasic = [];
	_noInAdditional = [];
	_noInTotal = [];

		{
		if not ((faction _x) in _civF) then
			{
			_type = toLower (typeOf _x);
			if not ((_type in _basicrhq) or (_type in _noInBasic)) then {_noInBasic pushBack _type};
			if not ((_type in _Additionalrhq) or (_type in _noInAdditional)) then {_noInAdditional pushBack _type};
			if not ((_type in _total) or (_type in _noInTotal)) then {_noInTotal pushBack _type};
			}
		}
	forEach (allUnits + vehicles);

	diag_log "-------------------------------------------------------------------------";
	diag_log "-----------------------------RHQCHECK REPORT-----------------------------";
	diag_log "-------------------------------------------------------------------------";
	diag_log "Types not added to basic RHQ:";

		{
		diag_log format ["%1",_x];
		}
	forEach _noInBasic;

	diag_log "-------------------------------------------------------------------------";
	diag_log "Types not added to exact RHQ (not all must be):";

		{
		diag_log format ["%1",_x];
		}
	forEach _noInAdditional;

	diag_log "-------------------------------------------------------------------------";
	diag_log "Types not added anywhere:";

		{
		diag_log format ["%1",_x];
		}
	forEach _noInTotal;
	diag_log "-------------------------------------------------------------------------";
	diag_log "-------------------------END OF RHQCHECK REPORT--------------------------";
	diag_log "-------------------------------------------------------------------------";

	"RHQ CHECK" hintC format ["Forgotten classes: %1\nClasses not present in basic categories: %2\n(see RPT file for detailed forgotten classes list)",count _noInTotal,count _noInBasic];
	};
