_SCRname = "SpotScan";

private ["_spotsneeded","_windroseOne","_windroseTwo","_scanRange","_sectorLenght","_sectorWidth","_markscan","_HQ","_step","_isdone","_true","_goodSpots","_isGood","_X","_Y","_scannedSpot",
	"_steepnessInitial","_probeStep","_steepnessActual","_centralSpot","_probeNorth","_probeSouth","_probeEast","_probeWest","_goodmark"];

_spotsneeded = _this select 0;
_windroseOne = _this select 1;
_windroseTwo = _this select 2;
_scanRange = _this select 3;
_sectorLenght = _this select 4;
_sectorWidth = _this select 5;
_markscan = _this select 6;
_HQ = _this select 7;
	
//_step = (_sectorLenght + _sectorWidth)/30;
_step = 80;
_isdone = false;
_true = true;
_goodSpots = [];
_isGood = false;
for [{_steepnessInitial = 1},{(_steepnessInitial >= 1) and not (_isdone)},{_steepnessInitial = _steepnessInitial/1.5}] do
	{
	for [{_Y = ((_markscan) select 1) - _sectorWidth},{_Y <= ((_markscan) select 1) + _sectorWidth},{_Y = _Y + _step}] do
		{
		for [{_X = ((_markscan) select 0) - _sectorLenght},{_X <= ((_markscan) select 0) + _sectorLenght},{_X = _X + _step}] do
			{
			_scannedSpot = [_X,_Y];
				
			for [{_probeStep = 2.5;_isGood = true},{(_probeStep <= _scanRange) and (_isGood)},{_probeStep = 2*_probeStep}] do
				{
				_steepnessActual = _steepnessInitial/(1 + (10/_probeStep));
				_centralSpot = createTrigger ["EmptyDetector",_scannedSpot]; 
				_probeNorth = createTrigger ["EmptyDetector",[_X,_Y+_probeStep]];
				_probeSouth = createTrigger ["EmptyDetector",[_X,_Y-_probeStep]];
				_probeEast = createTrigger ["EmptyDetector",[_X+_probeStep,_Y]];
				_probeWest = createTrigger ["EmptyDetector",[_X-_probeStep,_Y]];
				
				switch (_windroseOne) do
					{
					 case "N" : 
						{
						if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeNorth) select 2)+_steepnessActual)) exitWith 
							{
							_isGood = false
							};
								
						switch (_windroseTwo) do 
							{
							case "E" : 
								{
								if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeEast) select 2)+_steepnessActual)) exitWith 
									{
									_isGood = false
									};
							
								if (_true) exitWith {_isGood = true}
								};
					
							case "W" : 
								{
								if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeWest) select 2)+_steepnessActual)) exitWith 
									{
									_isGood = false
									}; 
						
								if (_true) exitWith {_isGood = true}
								};
					
							default 
								{
								if _true exitWith 
									{
									_isGood = true
									}
								}
							}
						};
							
					 case "S": 
					 	{
						if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeSouth) select 2)+_steepnessActual)) exitWith 
							{
							_isGood = false
							}; 
								
						switch (_windroseTwo) do 
							{
							case "E" : 
								{
								if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeEast) select 2)+_steepnessActual)) exitWith 
									{
									_isGood = false
									}; 
							
								if (_true) exitWith {_isGood = true}
								};
					
							case "W" : 
								{
								if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeWest) select 2)+_steepnessActual)) exitWith 
									{
									_isGood = false
									}; 
						
								if (_true) exitWith {_isGood = true}
								};
					
							default 
								{
								if (_true) exitWith {_isGood = true}
								}
							}
						};
					
					 case "E" : 
					 	{
						if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeEast) select 2)+_steepnessActual)) exitWith 
							{
							_isGood = false
							}; 
						
						if (_true) exitWith {_isGood = true}
						};
					
					 case "W" : 
					 	{
						if (((getPosASL _centralSpot) select 2) <= (((getPosASL _probeWest) select 2)+_steepnessActual)) exitWith 
							{
							_isGood = false
							}; 
							
						if (_true) exitWith {_isGood = true}
						};
					
					 default 
					 	{
					 	if (_true) exitWith 
					 		{
					 		_isGood = false
					 		}
					 	}			
					};

					{					
					deleteVehicle _x
					}
				forEach [_centralSpot,_probeNorth,_probeSouth,_probeEast,_probeWest]
				};
	
			if (_isGood) then 
				{
				_goodSpots pushBack _scannedSpot;
				if (_HQ getVariable ["RydHQ_Debug",false]) then 
					{
					_goodmark = createMarker[(str _X)+(str _Y),_scannedSpot];
					_goodmark setMarkerColor "ColorBlack";
					_goodmark setMarkerShape "ICON";
					_goodmark setMarkerSize [0.2,0.2];
					((str _X)+(str _Y)) setMarkerType "mil_dot"
					}
				};
				
			if ((count _goodSpots) >= _Spotsneeded) exitWith {_isdone = true}
			}
		}
	};

_goodSpots