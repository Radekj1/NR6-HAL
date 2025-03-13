private ["_logic","_Commanders","_Leader","_prefix"];

_logic = (_this select 0);
_Commanders = [];

{
    if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_Commanders pushBack _x};
} forEach (synchronizedObjects _logic);

{
    _Leader = (_x getVariable "LeaderType");

    if (_Leader == "LeaderHQ") then {_prefix = "RydHQ_"};
    if (_Leader == "LeaderHQB") then {_prefix = "RydHQB_"};
    if (_Leader == "LeaderHQC") then {_prefix = "RydHQC_"};
    if (_Leader == "LeaderHQD") then {_prefix = "RydHQD_"};
    if (_Leader == "LeaderHQE") then {_prefix = "RydHQE_"};
    if (_Leader == "LeaderHQF") then {_prefix = "RydHQF_"};
    if (_Leader == "LeaderHQG") then {_prefix = "RydHQG_"};
    if (_Leader == "LeaderHQH") then {_prefix = "RydHQH_"};

    _Leader = call compile _Leader;

    _logic call compile (_prefix + "Fast" + " = " + str (_logic getVariable "RydHQ_Fast"));
    _logic call compile (_prefix + "CommDelay" + " = " + str (_logic getVariable "RydHQ_CommDelay"));
    _logic call compile (_prefix + "HQChat" + " = " + str (_logic getVariable "RydHQ_HQChat"));
    _logic call compile (_prefix + "ChatDebug" + " = " + str (_logic getVariable "RydHQ_ChatDebug"));
    _logic call compile (_prefix + "ExInfo" + " = " + str (_logic getVariable "RydHQ_ExInfo"));
    _logic call compile (_prefix + "ResetTime" + " = " + str (_logic getVariable "RydHQ_ResetTime"));
    _logic call compile (_prefix + "ResetOnDemand" + " = " + str (_logic getVariable "RydHQ_ResetOnDemand"));
    _logic call compile (_prefix + "SubAll" + " = " + str (_logic getVariable "RydHQ_SubAll"));
    _logic call compile (_prefix + "SubSynchro" + " = " + str (_logic getVariable "RydHQ_SubSynchro"));
    _logic call compile (_prefix + "KnowTL" + " = " + str (_logic getVariable "RydHQ_KnowTL"));
    _logic call compile (_prefix + "GetHQInside" + " = " + str (_logic getVariable "RydHQ_GetHQInside"));
    _logic call compile (_prefix + "CamV" + " = " + str (_logic getVariable "RydHQ_CamV"));
    _logic call compile (_prefix + "InfoMarkers" + " = " + str (_logic getVariable "RydHQ_InfoMarkers"));
    _logic call compile (_prefix + "ArtyMarks" + " = " + str (_logic getVariable "RydHQ_ArtyMarks"));
    _logic call compile (_prefix + "SecTasks" + " = " + str (_logic getVariable "RydHQ_SecTasks"));
    _logic call compile (_prefix + "Debug" + " = " + str (_logic getVariable "RydHQ_Debug"));

} forEach _Commanders;
