// [Side, Spawning helipads/objects (array), Starting aircraft (array), Availabe empty aircraft (array), Threshold (0 to 1), Leaders (aray), Delay time between checks (seconds)] spawn NR6_fnc_AirReinforcementsB;
if (!isServer) exitwith {};
private 
    [
    "_side","_Commanders","_coreObj","_SpawnPads","_sideForces","_sidetick","_faction","_CurrentForces","_Pool","_Threshold","_Leaders","_SpawnRGroup","_CTR","_grp", "_GoodPads","_LiveForces","_CLiveForces","_CStartForces","_TickTime","_GoodsideForces","_ExtraArgs"
    ];

params ["_logic"];
//_logic = _this select 0;

_Commanders = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {waitUntil {sleep 0.5; (not (isNil (_x getvariable "LeaderType")))}; _Commanders pushback (call compile (_x getvariable "LeaderType"))};
} foreach (synchronizedObjects _logic);

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
    if (_x isKindOf "HeliH") then {_SpawnPads pushback _x};
    if ((_x isKindOf "Air") and ((crew _x) isequalto [])) then {_sideForces pushback _x};
    if ((_x isKindOf "Air") and not ((crew _x) isequalto [])) then {_StartForces pushback _x};
} forEach (synchronizedObjects _coreObj);

if (_StartForces isequalto []) then {_StartForces = [objNull]};


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





_RespawnAirBHandle = [{
    params ["_args", "_RespawnAirBHandle"];
    _args params ["_SpawnPads","_LiveForces","_sideForces","_logic","_side","_Leaders","_DontLand","_Threshold","_CStartForces","_TickTime"];
    private ["_GoodsideForces","_GoodPads","_CLiveForces","_CurrentForces","_grp"];
    _GoodsideForces = [];
    _LiveForces = _logic getVariable ["_LiveForcesAR_B", _LiveForces];
    {
        if ((alive _x) and ((damage _x) < 0.4) and not (_x getvariable ["Air_ReinforcementsNR6_Taken",false])) then {

            _GoodsideForces pushback _x;
            _x setVehicleLock "LOCKED";
            
        };
    
    } forEach _sideForces;

    _GoodPads = [];

    {
        if ( not ([] isequalto ((getpos _x) findEmptyPosition [0,0,"B_Heli_Transport_01_F"])) and (alive _x)) then {

            _GoodPads pushback _x;
            
        };
    
    } forEach _SpawnPads;

    _CLiveForces = _LiveForces;

    {
        if (not (alive _x) or not (canMove _x) or ((damage _x) > 0.8) or ((fuel _x) < 0.2)) then {_LiveForces = (_LiveForces - [_x])}
    } forEach _CLiveForces;

    _CurrentForces = count _LiveForces;


    if ((_CurrentForces) < (_Threshold*_CStartForces)) then 
        {
            if ( not (_GoodsideForces isequalto []) and not (_GoodPads isequalto [])) then {

                private ["_grp"];

                _grp = [_GoodPads,_side,_GoodsideForces,_Leaders] call SpawnARGroupB;

                //sleep 1;
                
                _LiveForces pushback (vehicle (leader _grp));

                (leader _grp) call compile ((_logic getVariable ["_ExtraArgs",""]) + _DontLand);

                    
            };  
        };
    _logic setVariable ["_LiveForcesAR_B",_LiveForces];
    if (_GoodsideForces isequalto []) then {(_RespawnAirBHandle) call CBA_fnc_removePerFrameHandler;};
}, _TickTime, [_SpawnPads,_LiveForces,_sideForces,_logic,_side,_Leaders,_DontLand,_Threshold,_CStartForces,_TickTime
]] call CBA_fnc_addPerFrameHandler;