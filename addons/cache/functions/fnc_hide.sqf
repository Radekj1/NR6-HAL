params [];

if (zbe_NoHideMode) exitwith {};


private _CGR = "";
_group setvariable ["zbe_hidden",true];

{
    if not (isPlayer _x) then {

        _CGR = _x;

        {
            if (((vehicle _x) iskindof "Air") || (_x getvariable ["zbe_SeeAll",false])) then {

                if (((_CGR iskindof "CaManBase") && ((_x distance _CGR) > 3000)) && !((owner _CGR) isEqualTo (owner _x))) then {

                    [_CGR,true] remoteExecCall ["hideobject",_x];
                    [_CGR,false] remoteExecCall ["enableSimulation",_x];

                } else {

                    [_CGR,false] remoteExecCall ["hideobject",_x];
                    [_CGR,true] remoteExecCall ["enableSimulation",_x];

                };

            } else {

                if (!(((vehicle _CGR) iskindof "Air") && (((vehicle _CGR) distance _x) < 2500)) && !(((vehicle _CGR) iskindof "Air") && (10 > (random 100))) && !((owner _CGR) isEqualTo (owner _x))) then {

                    [_CGR,true] remoteExecCall ["hideobject",_x];
                    [_CGR,false] remoteExecCall ["enableSimulation",_x];

                } else {

                    [_CGR,false] remoteExecCall ["hideobject",_x];
                    [_CGR,true] remoteExecCall ["enableSimulation",_x];

                };
            };
        } forEach (allPlayers - (entities "HeadlessClient_F"));
        
    };
} forEach (_toCache);