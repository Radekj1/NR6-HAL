_SCRname = "Front";

private ["_front","_pos","_att","_XAxis","_YAxis","_dir","_isRec","_code","_code2"];

_code = 
	{
	params ["_HQ","_front","_ia"];
						
	while {not (isNull _HQ)} do
		{
		sleep 5;
		
		_ia setMarkerPos (position _front);
		_ia setMarkerDir (direction _front);
		_ia setMarkerSize (size _front);
		
		if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {}
		};
		
	deleteMarker _ia
	};
	
_code2 =
	{
	params ["_HQ","_front","_isRec","_pos","_XAxis","_YAxis","_dir","_code"];
	
	_alive = true;
	
	waitUntil
		{
		sleep 5;
		
		_alive = true;
		
		switch (true) do
			{
			case (isNil "_HQ") : {_alive = false};
			case (isNull _HQ) : {_alive = false};
			case (({alive _x} count (units _HQ)) < 1) : {_alive = false};
			};

		_debug = _HQ getVariable "RydHQ_Debug";
		
		(not (isNil "_debug") or not (_alive))
		};
		
	if not (_alive) exitWith {};	

	if (_HQ getVariable ["RydHQ_Debug",false]) then
		{
		_shape = "ELLIPSE";
		if (_isRec) then {_shape = "RECTANGLE"};

		_ia = "markFront" + (str _HQ);
		_ia = createMarker [_ia,_pos];
		_ia setMarkerColor "ColorRed";
		_ia setMarkerShape _shape;
		_ia setMarkerSize [_XAxis, _YAxis];
		_ia setMarkerDir _dir;
		_ia setMarkerBrush "Border";
		_ia setMarkerColor "ColorKhaki";
		_SCRname = "Front2";				
		[_HQ,_front,_ia] call _code;
		}
	};
			

	{
	_front = _x getVariable ["RydHQ_Front",objNull];
	if not (isNull _front) then
		{
		_pos = position _front;
		_att = triggerArea _front;
		_att params ["_XAxis","_YAxis","_dir","_isRec"];

		_front = createLocation ["Name", _pos, _XAxis, _YAxis];
		_front setDirection _dir;
		_front setRectangular _isRec;
		
		_x setVariable ["RydHQ_Front",_front];

		[_x,_front,_isRec,_pos,_XAxis,_YAxis,_dir,_code] call _code2;		
		}
	}

foreach RydxHQ_AllHQ;
