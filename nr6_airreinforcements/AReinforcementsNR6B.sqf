// [Side, Spawning helipads/objects (array), Starting aircraft (array), Availabe empty aircraft (array), Threshold (0 to 1), Leaders (aray), Delay time between checks (seconds)] spawn NR6_fnc_AirReinforcementsB;

private 
    [
    "_side","_logic","_Commanders","_coreObj","_SpawnPads","_sideForces","_sidetick","_faction","_CurrentForces","_Pool","_Threshold","_Leaders","_SpawnRGroup","_CTR","_grp", "_GoodPads","_LiveForces","_CLiveForces","_CStartForces","_TickTime","_GoodsideForces","_ExtraArgs"
    ];

_logic = _this select 0;

_Commanders = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {waitUntil {sleep 0.5; (not (isNil (_x getVariable "LeaderType")))}; _Commanders pushBack (call compile (_x getVariable "LeaderType"))};
} forEach (synchronizedObjects _logic);

_side = call compile (_logic getVariable "_side");
_SpawnPads =  [];
_StartForces = [];
_sideForces = [];
_coreObj = _logic;
_Threshold = _logic getVariable "_Threshold";
_Leaders = _Commanders;
_TickTime = _logic getVariable "_TickTime";
_DontLand = _logic getVariable "_DontLand";
if (_DontLand) then {_DontLand = "; (group _this) setVariable ['AirNoLand',true];"} else {_DontLand = ""};


if (isNil ("_TickTime")) then {_TickTime = 15};

{
    if (_x isKindOf "HeliH") then {_SpawnPads pushBack _x};
    if ((_x isKindOf "Air") and ((crew _x) isEqualTo [])) then {_sideForces pushBack _x};
    if ((_x isKindOf "Air") and not ((crew _x) isEqualTo [])) then {_StartForces pushBack _x};
} forEach (synchronizedObjects _coreObj);

if (_StartForces isEqualTo []) then {_StartForces = [objNull]};


_LiveForces = _StartForces;

_CurrentForces = count _LiveForces;

_CStartForces = count _StartForces;


sleep 5;

if (isNil ("RydHQ_Included")) then {RydHQ_Included = []};
if (isNil ("RydHQB_Included")) then {RydHQB_Included = []};
if (isNil ("RydHQC_Included")) then {RydHQC_Included = []};
if (isNil ("RydHQD_Included")) then {RydHQD_Included = []};
if (isNil ("RydHQE_Included")) then {RydHQE_Included = []};
if (isNil ("RydHQF_Included")) then {RydHQF_Included = []};
if (isNil ("RydHQG_Included")) then {RydHQG_Included = []};
if (isNil ("RydHQH_Included")) then {RydHQH_Included = []};

if (isNil ("LeaderHQ")) then {LeaderHQ = objNull};
if (isNil ("LeaderHQB")) then {LeaderHQB = objNull};
if (isNil ("LeaderHQC")) then {LeaderHQC = objNull};
if (isNil ("LeaderHQD")) then {LeaderHQD = objNull};
if (isNil ("LeaderHQE")) then {LeaderHQE = objNull};
if (isNil ("LeaderHQF")) then {LeaderHQF = objNull};
if (isNil ("LeaderHQG")) then {LeaderHQG = objNull};
if (isNil ("LeaderHQH")) then {LeaderHQH = objNull};

sleep 20;
private _counter = count _StartForces;

while {_CStartForces < _counter} do 
{
    _CStartForces = count _StartForces;
    sleep 20;
    _counter = count _StartForces;
};




while {true} do 

    {

    _GoodsideForces = [];

    {
        if ((alive _x) and ((damage _x) < 0.4) and not (_x getVariable ["Air_ReinforcementsNR6_Taken",false])) then {

            _GoodsideForces pushBack _x;
            _x setVehicleLock "LOCKED";
            
        };
    
    } forEach _sideForces;

    _GoodPads = [];

    {
        if ( not ([] isEqualTo ((getPos _x) findEmptyPosition [0,0,"B_Heli_Transport_01_F"])) and (alive _x)) then {

            _GoodPads pushBack _x;
            
        };
    
    } forEach _SpawnPads;

    _CLiveForces = _LiveForces;

    {
        if (not (alive _x) or not (canMove _x) or ((damage _x) > 0.8) or ((fuel _x) < 0.2)) then {_LiveForces = (_LiveForces - [_x])}
    } forEach _CLiveForces;

    _CurrentForces = count _LiveForces;


    if ((_CurrentForces) < (_Threshold*_CStartForces)) then 
        {
            if ( not (_GoodsideForces isEqualTo []) and not (_GoodPads isEqualTo [])) then {

                private ["_grp"];

                _grp = [_GoodPads,_side,_GoodsideForces,_Leaders] call SpawnARGroupB;

                sleep 1;
                
                _LiveForces pushBack (vehicle (leader _grp));

                (leader _grp) call compile ((_logic getVariable ["_ExtraArgs",""]) + _DontLand);

                    
            };  
        };

    if (_GoodsideForces isEqualTo []) exitWith {};

    sleep _TickTime;
    };