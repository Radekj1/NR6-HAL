private ["_Leader","_logic","_grp","_LeaderType"];

_logic = (_this select 0);
_grpID = (_logic getVariable "HQname");
_LeaderType = (_logic getVariable "BBLeader");

_logic call compile (_LeaderType + " = _this");

RydBB_Active = true;

_Commanders = [];
if (isNil "RydBBa_HQs") then {RydBBa_HQs = []};
if (isNil "RydBBb_HQs") then {RydBBb_HQs = []};

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

    waitUntil {sleep 0.5; (not (isNil _Leader))};

    _Leader = call compile _Leader;

    if (_LeaderType == "RydBBa_SAL") then {RydBBa_HQs pushBackUnique _Leader};
    if (_LeaderType == "RydBBb_SAL") then {RydBBb_HQs pushBackUnique _Leader};

} forEach _Commanders;
