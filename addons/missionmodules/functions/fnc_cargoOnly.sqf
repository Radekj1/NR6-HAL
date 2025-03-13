params ["_logic"];

private _commanders = [];
private _leader = objNull;
private _prefix = "";

{
    if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_commanders pushBack _x};
} forEach (synchronizedObjects _logic);

{
    _leader = (_x getVariable "LeaderType");

    if (_Leader == "LeaderHQ") then {_prefix = "RydHQ_"};
    if (_Leader == "LeaderHQB") then {_prefix = "RydHQB_"};
    if (_Leader == "LeaderHQC") then {_prefix = "RydHQC_"};
    if (_Leader == "LeaderHQD") then {_prefix = "RydHQD_"};
    if (_Leader == "LeaderHQE") then {_prefix = "RydHQE_"};
    if (_Leader == "LeaderHQF") then {_prefix = "RydHQF_"};
    if (_Leader == "LeaderHQG") then {_prefix = "RydHQG_"};
    if (_Leader == "LeaderHQH") then {_prefix = "RydHQH_"};

    waitUntil {sleep 0.5; (not (isNil _Leader))};
    _Leader = call compile _Leader;

    if (call compile ("isNil " + "'" + _prefix + "CargoOnly" + "'")) then {

        call compile (_prefix + "CargoOnly" + " = " + "[]");

    };

    {
        if not (_x isKindOf "Logic") then {
            _x call compile (_prefix + "CargoOnly" + " pushback " + "(group _this)");
        } else {
            _x setVariable ["_ExtraArgs",(_logic getVariable ["_ExtraArgs",""]) + "; " + _prefix + "CargoOnly" + " pushback " + "(group _this)"];
        };

    } forEach (synchronizedObjects _logic);

} forEach _commanders;
