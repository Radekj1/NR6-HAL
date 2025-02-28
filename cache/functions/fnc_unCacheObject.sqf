params [];

{
    _x enableSimulationGlobal true;
    _x hideObjectGlobal false;
    [_x, false] remoteExecCall ["hideobject",0];
    [_x, true] remoteExecCall ["enableSimulation",0];

} forEach (allMissionObjects "Static");
