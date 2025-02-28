params [];

private ["_CGR"];

	{
		if not (isPlayer _x) then {

			_CGR = _x;

			{
				if (((vehicle _x) isKindOf "Air") or (_x getVariable ["zbe_SeeAll",false])) then {

					if (((_x distance _CGR) > zbe_aiCacheDist) and not ((owner _CGR) isEqualTo (owner _x))) then {

						[_CGR,false] remoteExecCall ["hideobject",_x];
						[_CGR,false] remoteExecCall ["enableSimulation",_x];

					} else {

						[_CGR,false] remoteExecCall ["hideobject",_x];
						[_CGR,true] remoteExecCall ["enableSimulation",_x];

					};

				} else {

					if (((_x distance _CGR) > zbe_aiCacheDist) and not ((owner _CGR) isEqualTo (owner _x))) then {

						[_CGR,true] remoteExecCall ["hideobject",_x];
						[_CGR,false] remoteExecCall ["enableSimulation",_x];

					} else {

						[_CGR,false] remoteExecCall ["hideobject",_x];
						[_CGR,true] remoteExecCall ["enableSimulation",_x];

					};
				};
			} forEach (allPlayers - (entities "HeadlessClient_F"));

		};
	} forEach _objects;
