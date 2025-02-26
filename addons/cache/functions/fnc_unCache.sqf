params [];

_group setvariable ["zbe_hidden",false];

{
    if !(isPlayer _x) then {
        _x enablesimulationglobal true;
        _x hideObjectGlobal false;
        [_x,false] remoteExecCall ["hideobject",0];
        [_x,true] remoteExecCall ["enableSimulation",0];
    };
} forEach (_toCache);