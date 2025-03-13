// [Side, Spawning helipads/objects (Array), Starting aircraft (array), Amount of available Aircraft, Faction, Threshold (0 to 1), Leaders (array), Pool of available aircraft classnames if "custom" faction is chosen (array), Delay time between checks (seconds) ] spawn NR6_fnc_AirReinforcements;

private 
    [
    "_side","_logic","_flight","_Commanders","_coreObj","_SpawnPads","_StartForces","_sidetick","_faction","_CurrentForces","_Pool","_Threshold","_Leaders","_SpawnRGroup","_CTR","_grp", "_GoodPads","_LiveForces","_CLiveForces","_CStartForces","_TickTime","_ExtraArgs","_sidetickHold","_sideEn","_sideEn2","_SpawnPos","_playerRange"
    ];

_logic = _this select 0;

_Commanders = [];

{
	if ((typeOf _x) == "NR6_HAL_Leader_Module") then {waitUntil {sleep 0.5; (not (isNil (_x getVariable "LeaderType")))}; _Commanders pushBack (call compile (_x getVariable "LeaderType"))};
} forEach (synchronizedObjects _logic);

_side = call compile (_logic getVariable "_side");
_SpawnPads =  [_logic];
_StartForces = [];
_coreObj = _logic;
_sidetick = _logic getVariable "_sidetick";
_faction = _logic getVariable "_faction";
_Threshold = _logic getVariable "_Threshold";
_HalReinf = _logic getVariable "_HalReinf";
_Leaders = _Commanders;
_TickTime = _logic getVariable "_TickTime";
_flight = call compile (_logic getVariable "_flight");
_DontLand = _logic getVariable "_DontLand";
_SpawnPos = [getPos _logic];
_playerRange = _logic getVariable "_playerRange";


if (_DontLand) then {_DontLand = "; (group _this) setVariable ['AirNoLand',true];"} else {_DontLand = ""};

if (isNil ("_TickTime")) then {_TickTime = 15};

{
    if (_x isKindOf "HeliH") then {_SpawnPads pushBack _x};
    if ((_x isKindOf "Air") and not ((crew _x) isEqualTo [])) then {_StartForces pushBack _x};
} forEach (synchronizedObjects _coreObj);

if (_StartForces isEqualTo []) then {_StartForces = [objNull]};
if (_SpawnPads isEqualTo []) then {_SpawnPads = [_coreObj]};


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




if (_faction == "B") then {

    _Pool = 
        [
            "FIR_F16C",
            "FIR_F15C_Blank"
        
        ]
};

if (_faction == "O") then {

    _Pool = 
        [
            "rhs_mig29s_vvsc",
            "RHS_Su25SM_vvsc",
            "Su33_Protatype_PT_2"
        
        ]
};

if (_faction == "I") then {

    _Pool = 
        [
        
        ]
};

if (_faction == "custom") then {

    _Pool = call compile (_logic getVariable "_Pool");
};



if (isNil "_sidetickHold") then 
    {
        _sidetickHold = 0;
    };

if (isNil "_sideEn") then 
    {
        _sideEn = civilian;
    };
if (isNil "_sideEn2") then 
    {
        _sideEn2 = civilian;
    };

if ((_HalReinf isEqualTo "KillSwitch") or (_HalReinf isEqualTo "ReCapture")) then 
{
if (_sideEn == civilian) then {
    if ((_sideEn == civilian) and ([west, _side] call BIS_fnc_sideIsEnemy)) exitWith 
    {
        _sideEn = west;
    }; 
    if ((_sideEn == civilian) and ([east, _side] call BIS_fnc_sideIsEnemy)) exitWith 
    {
        _sideEn = east;
    }; 
    if ((_sideEn == civilian) and ([resistance, _side] call BIS_fnc_sideIsEnemy)) exitWith 
    {
        _sideEn = resistance;
    }; 
    if (_sideEn == civilian) then {_sideEn = sideEnemy};
};

if (_sideEn2 == civilian) then {
    if ((_sideEn2 == civilian) and not (_sideEn == west) and ([west, _side] call BIS_fnc_sideIsEnemy)) exitWith 
    {
        _sideEn2 = west;
    }; 
    if ((_sideEn2 == civilian) and not (_sideEn == east) and ([east, _side] call BIS_fnc_sideIsEnemy)) exitWith 
    {
        _sideEn2 = east;
    }; 
    if ((_sideEn2 == civilian) and not (_sideEn == resistance) and ([resistance, _side] call BIS_fnc_sideIsEnemy)) exitWith 
    {
        _sideEn2 = resistance;
    }; 
    if (_sideEn2 == civilian) then {_sideEn2 = sideEnemy};
};
};

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

    _GoodPads = [];

    {
        if ((alive _x) or (_x getVariable ["HOT",false])) then {

            _GoodPads pushBack _x;
            
        };
    
    } forEach _SpawnPads;

    _CLiveForces = _LiveForces;

    if ((_HalReinf isEqualTo "KillSwitch") and ({_x distance (_SpawnPos select 0) < _playerRange} count allPlayers > 0) and (_side countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0)) then 
    {
        _sidetick = 0;
    };

    if ((_HalReinf isEqualTo "ReCapture") and (_sidetick != 0) and ((_sideEn countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0) or (_sideEn2 countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0)) and (_side countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0)) then 
    {
        if (_sidetick > 0) then 
        {
            _sidetickHold = _sidetick;
        };
        _sidetick = 0;
    };
    if ((_HalReinf isEqualTo "ReCapture") and (_sidetickHold != 0) and (_sideEn countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0) and (_sideEn2 countSide ((_SpawnPos select 0) nearEntities _playerRange) == 0) and (_side countSide ((_SpawnPos select 0) nearEntities _playerRange) > 0)) then 
    {
        if (_sidetick == 0) then 
        {
            _sidetick = _sidetickHold;
        };
        _sidetickHold = 0; 
    };

    {
        if (not (alive _x) or not (canMove _x) or ((damage _x) > 0.8) or ((fuel _x) < 0.2)) then {_LiveForces = (_LiveForces - [_x])}
    } forEach _CLiveForces;

    _CurrentForces = count _LiveForces;


    if ((_CurrentForces) < (_Threshold*_CStartForces)) then 
        {
            _chosenFlight = (selectRandom _flight);

            if ((_sidetick > 0) and not ({_x distance (_SpawnPos select 0) < _playerRange} count allPlayers > 0) and not (_GoodPads isEqualTo [])) then {

                private ["_grp"];

                _grp = [_GoodPads,_side,_Pool,_Leaders,_chosenFlight] call SpawnARGroupA;

                sleep 1;
                
                _sidetick = (_sidetick - _chosenFlight);
                _logic setVariable ["_sidetick",_sidetick];
                {if not ((vehicle _x) in _LiveForces) then {_LiveForces pushBack (vehicle _x)}} forEach (units _grp);

                (leader _grp) call compile ((_logic getVariable ["_ExtraArgs",""]) + _DontLand);

                    
            };  
        };

    if ((_sidetick <= 0) and (_sidetickHold <= 0)) exitWith {};

    sleep _TickTime;
    };