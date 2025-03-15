_SCRname = "Front";
//Set up for "area of Operation / frontline" where units should fight.
private ["_front","_pos","_att","_XAxis","_YAxis","_dir","_isRec","_code","_code2"];

_code = 
	{
	_HQ = _this select 0;
	_front = _this select 1;
	_ia = _this select 2;
						
	while (!isNull _HQ) do
		{
		[{
		_ia setMarkerPosLocal (position _front);
		_ia setMarkerDirLocal (direction _front);
		_ia setMarkerSize (size _front);
		},{}, 5] call cba_waitAndExecute;
		if (_HQ getVariable ["RydHQ_KIA",false]) exitWith {}
		};
		
	deleteMarker _ia
	};
	
_code2 =
	{
	_HQ = _this select 0;
	_front = _this select 1;
	_isRec = _this select 2;
	_pos = _this select 3;
	_XAxis = _this select 4;
	_YAxis = _this select 5;
	_dir = _this select 6;
	_code = _this select 7;
	
	_alive = true;
	
		[{[{
		_alive = true;
		
		switch (true) do
			{
			case (isNil "_HQ") : {_alive = false};
			case (isNull _HQ) : {_alive = false};
			case (({alive _x} count (units _HQ)) < 1) : {_alive = false};
			};

		_debug = _HQ getVariable "RydHQ_Debug";
		
		(not (isNil "_debug") or not (_alive));

		},{}, 5] call cba_waitAndExecute;
		},{}] call cba_waitUntilAndExecute;
		
	if (!_alive) exitWith {};	

	if (_HQ getVariable ["RydHQ_Debug",false]) then
		{
		_shape = "ELLIPSE";
		if (_isRec) then {_shape = "RECTANGLE"};

		_ia = "markFront" + (str _HQ);
		_ia = createMarker [_ia,_pos];
		_ia setMarkerColorLocal "ColorRed";
		_ia setMarkerShapeLocal _shape;
		_ia setMarkerSizeLocal [_XAxis, _YAxis];
		_ia setMarkerDirLocal _dir;
		_ia setMarkerBrushLocal "Border";
		_ia setMarkerColor "ColorKhaki";
		_SCRname = "Front2";				
		[[_HQ,_front,_ia],_code] call RYD_Spawn
		}
	};
			

	{
	_front = _x getVariable ["RydHQ_Front",objNull];
	if !(isNull _front) then
		{
		_pos = position _front;
		_att = triggerArea _front;
		_XAxis = _att select 0;
		_YAxis = _att select 1;
		_dir = _att select 2;
		_isRec = _att select 3;

		_front = createLocation ["Name", _pos, _XAxis, _YAxis];
		_front setDirection _dir;
		_front setRectangular _isRec;
		
		_x setVariable ["RydHQ_Front",_front];

		[[_x,_front,_isRec,_pos,_XAxis,_YAxis,_dir,_code],_code2] call RYD_Spawn		
		}
	}
forEach RydxHQ_AllHQ;