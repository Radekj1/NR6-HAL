params ["_logic", "_units", "_activated"];

private _commanders = [];
private _leader = objNull;
private _prefix = "";

{
    if ((typeOf _x) == "NR6_HAL_Leader_Module") then {_commanders pushBack _x};
} forEach (synchronizedObjects _logic);

{
    _leader = (_x getVariable "LeaderType");

    if (_leader == "LeaderHQ") then {_prefix = "RydHQ_"};
    if (_leader == "LeaderHQB") then {_prefix = "RydHQB_"};
    if (_leader == "LeaderHQC") then {_prefix = "RydHQC_"};
    if (_leader == "LeaderHQD") then {_prefix = "RydHQD_"};
    if (_leader == "LeaderHQE") then {_prefix = "RydHQE_"};
    if (_leader == "LeaderHQF") then {_prefix = "RydHQF_"};
    if (_leader == "LeaderHQG") then {_prefix = "RydHQG_"};
    if (_leader == "LeaderHQH") then {_prefix = "RydHQH_"};

    _leader = call compile _leader;

    _logic call compile (_prefix + "MAtt" + " = " + str (_logic getVariable "RydHQ_MAtt"));
    _logic call compile (_prefix + "Personality" + " = " + str (_logic getVariable "RydHQ_Personality"));

} forEach _commanders;
