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

    _logic call compile (_prefix + "CargoFind" + " = " + str (_logic getVariable "RydHQ_CargoFind"));
    _logic call compile (_prefix + "NoAirCargo" + " = " + str (_logic getVariable "RydHQ_NoAirCargo"));
    _logic call compile (_prefix + "NoLandCargo" + " = " + str (_logic getVariable "RydHQ_NoLandCargo"));
    _logic call compile (_prefix + "SMed" + " = " + str (_logic getVariable "RydHQ_SMed"));
    _logic call compile (_prefix + "SFuel" + " = " + str (_logic getVariable "RydHQ_SFuel"));
    _logic call compile (_prefix + "SAmmo" + " = " + str (_logic getVariable "RydHQ_SAmmo"));
    _logic call compile (_prefix + "SRep" + " = " + str (_logic getVariable "RydHQ_SRep"));
    _logic call compile (_prefix + "SupportWP" + " = " + str (_logic getVariable "RydHQ_SupportWP"));
    _logic call compile (_prefix + "ArtyShells" + " = " + str (_logic getVariable "RydHQ_ArtyShells"));
    _logic call compile (_prefix + "AirEvac" + " = " + str (_logic getVariable "RydHQ_AirEvac"));
    _logic call compile (_prefix + "SupportRTB" + " = " + str (_logic getVariable "RydHQ_SupportRTB"));

} forEach _Commanders;
