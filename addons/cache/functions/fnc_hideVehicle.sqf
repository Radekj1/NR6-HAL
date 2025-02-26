params [];

if (zbe_NoHideMode) exitWith {};


private _CGR = "";



{
    if (((vehicle _x) isKindOf "Air") or (_x getVariable ["zbe_SeeAll",false])) then {

        [_vehicle,false] remoteExecCall ["hideobject",_x];
        [_vehicle,true] remoteExecCall ["enableSimulation",_x];


    } else {

        if (!((_vehicle isKindOf "Air") && (10 > (random 100))) && !((owner _vehicle) isEqualTo (owner _x))) then {

            [_vehicle,true] remoteExecCall ["hideobject",_x];
            [_vehicle,false] remoteExecCall ["enableSimulation",_x];

        } else {

            [_vehicle,false] remoteExecCall ["hideobject",_x];
            [_vehicle,true] remoteExecCall ["enableSimulation",_x];

        };
    };
} forEach (allPlayers - (entities "HeadlessClient_F"));
