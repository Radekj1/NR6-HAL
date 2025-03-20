#include "..\script_component.hpp"
// Originally from HAC_fnc.sqf (RYD_GroupMarkerLoop)
	while {true} do
		{
		{
		[{
			{
			_myMark = _x getVariable ["RYD_ItsMyMark",""];
			if (({alive _x} count (units _x)) > 0) then
				{
				_side = side _x;
				if (_side in _this) then
					{
					_ldr = leader _x;
					_pos = getPosATL (vehicle _ldr);

					_color = switch (_side) do
						{
						case (west) : {"ColorWEST"};
						case (east) : {"ColorEAST"};
						case (resistance) : {"ColorGUER"};
						default {"ColorCIV"};
						};

					if (_myMark isEqualTo "") then
						{
						_myMark = "ItsMyMark_" + (str _x) + (str (random 100));
						_myMark = createMarkerLocal [_myMark,_pos];
						_myMark setMarkerColorLocal _color;
						_myMark setMarkerShapeLocal "ICON";
						_myMark setMarkerTypeLocal "mil_dot";
						_myMark setMarkerSize [0.75,0.75];

						_x setVariable ["RYD_ItsMyMark",_myMark]
						}
					else
						{
						_myMark setMarkerPos _pos;

						if (0 in _this) then
							{
							_myMark setMarkerText (_x getVariable ["RydHQ_MyCrypto",toUpper (getText (configFile >> "CfgVehicles" >> (typeOf (vehicle _ldr)) >> "displayName"))])
							};

						_nE = _ldr findNearestEnemy _ldr;

						if (isNull _nE) then
							{
							_myMark setMarkerType "mil_dot"
							}
						else
							{
							_myMark setMarkerType "mil_triangle"
							}
						}
					}
				}
			else
				{
				if not (isNil "_myMark") then
					{
					deleteMarker _myMark
					}
				}
			}
		}, 5] call CBA_fnc_waitAndExecute;
		} forEach allGroups
		};