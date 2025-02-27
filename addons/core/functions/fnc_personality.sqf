#include "..\script_component.hpp"
// Originally from HAL\Personality.sqf

params ["_HQ"];

private _signum = _HQ getVariable ["RydHQ_CodeSign", "X"];

//get personality type
private _personality = _HQ getVariable ["RydHQ_Personality", "OTHER"];

private _recklessness = _HQ getVariable ["RydHQ_Recklessness", 0.5];
private _consistency = _HQ getVariable ["RydHQ_Consistency", 0.5];
private _activity = _HQ getVariable ["RydHQ_Activity", 0.5];
private _reflex = _HQ getVariable ["RydHQ_Reflex", 0.5];
private _circumspection = _HQ getVariable ["RydHQ_Circumspection", 0.5];
private _fineness = _HQ getVariable ["RydHQ_Fineness", 0.5];

switch (_personality) do {
	case ("GENIUS") : {
		_recklessness = 0.5;
		_consistency = 1;
		_activity = 1;
		_reflex = 1;
		_circumspection = 1;
		_fineness = 1
	};

	case ("IDIOT") : {
		_recklessness = 1;
		_consistency = 0;
		_activity = 0;
		_reflex = 0;
		_circumspection = 0;
		_fineness = 0
	};

	case ("COMPETENT") : {
		_recklessness = 0.5;
		_consistency = 0.5;
		_activity = 0.5;
		_reflex = 0.5;
		_circumspection = 0.5;
		_fineness = 0.5
    };

	case ("EAGER") : {
		_recklessness = 1;
		_consistency = 0;
		_activity = 1;
		_reflex = 1;
		_circumspection = 0;
		_fineness = 0
	};

	case ("DILATORY") : {
		_recklessness = 0;
		_consistency = 1;
		_activity = 0;
		_reflex = 0;
		_circumspection = 0.5;
		_fineness = 0.5
    };

	case ("SCHEMER") : {
		_recklessness = 0.5;
		_consistency = 1;
		_activity = 0;
		_reflex = 0;
		_circumspection = 1;
		_fineness = 1
	};

	case ("BRUTE") : {
		_recklessness = 0.5;
		_consistency = 1;
		_activity = 1;
		_reflex = 0.5;
		_circumspection = 0;
		_fineness = 0
	};

	case ("CHAOTIC") : {
		_personality = "CHAOTIC";
		_recklessness = 0.5;
		_consistency = 0;
		_activity = 1;
		_reflex = 1;
		_circumspection = 0.5;
		_fineness = 0.5
	};

	case ("OTHER") : {
		_recklessness = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_consistency = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_activity = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_reflex = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_circumspection = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
		_fineness = (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1) + (random 0.1);
	};
};

_HQ setVariable ["RydHQ_Recklessness", _recklessness];
_HQ setVariable ["RydHQ_Consistency", _consistency];
_HQ setVariable ["RydHQ_Activity", _activity];
_HQ setVariable ["RydHQ_Reflex", _reflex];
_HQ setVariable ["RydHQ_Circumspection", _circumspection];
_HQ setVariable ["RydHQ_Fineness", _fineness];

_HQ setVariable ["RydHQ_Personality", _personality];

LOG_8("Commander %8 (%7) - Recklessness: %1 Consistency: %2 Activity: %3 Reflex: %4 Circumspection: %5 Fineness: %6",_recklessness,_consistency,_activity,_reflex,_circumspection,_fineness,_personality,_signum);
