_SCRname = "SpotScan";

private ["_step","_isdone","_true","_goodSpots","_isGood","_X","_Y","_scannedSpot","_steepnessInitial","_probeStep",
"_steepnessActual","_centralSpot","_probeNorth","_probeSouth","_probeEast","_probeWest","_goodmark"];
params ["_spotsneeded","_windroseOne","_windroseTwo","_scanRange","_sectorLenght","_sectorWidth","_markscan","_HQ"];
	
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
						if (((getposASL _centralSpot) select 2) <= (((getposASL _probeNorth) select 2)+_steepnessActual)) exitwith 
							{
							_isGood = false
							};
								
						switch (_windroseTwo) do 
							{
							case "E" : 
								{
								if (((getposASL _centralSpot) select 2) <= (((getposASL _probeEast) select 2)+_steepnessActual)) exitwith 
									{
									_isGood = false
									};
							
								if (_true) exitwith {_isGood = true}
								};
					
							case "W" : 
								{
								if (((getposASL _centralSpot) select 2) <= (((getposASL _probeWest) select 2)+_steepnessActual)) exitwith 
									{
									_isGood = false
									}; 
						
								if (_true) exitwith {_isGood = true}
								};
					
							default 
								{
								if _true exitwith 
									{
									_isGood = true
									}
								}
							}
						};
							
					 case "S": 
					 	{
						if (((getposASL _centralSpot) select 2) <= (((getposASL _probeSouth) select 2)+_steepnessActual)) exitwith 
							{
							_isGood = false
							}; 
								
						switch (_windroseTwo) do 
							{
							case "E" : 
								{
								if (((getposASL _centralSpot) select 2) <= (((getposASL _probeEast) select 2)+_steepnessActual)) exitwith 
									{
									_isGood = false
									}; 
							
								if (_true) exitwith {_isGood = true}
								};
					
							case "W" : 
								{
								if (((getposASL _centralSpot) select 2) <= (((getposASL _probeWest) select 2)+_steepnessActual)) exitwith 
									{
									_isGood = false
									}; 
						
								if (_true) exitwith {_isGood = true}
								};
					
							default 
								{
								if (_true) exitwith {_isGood = true}
								}
							}
						};
					
					 case "E" : 
					 	{
						if (((getposASL _centralSpot) select 2) <= (((getposASL _probeEast) select 2)+_steepnessActual)) exitwith 
							{
							_isGood = false
							}; 
						
						if (_true) exitwith {_isGood = true}
						};
					
					 case "W" : 
					 	{
						if (((getposASL _centralSpot) select 2) <= (((getposASL _probeWest) select 2)+_steepnessActual)) exitwith 
							{
							_isGood = false
							}; 
							
						if (_true) exitwith {_isGood = true}
						};
					
					 default 
					 	{
					 	if (_true) exitwith 
					 		{
					 		_isGood = false
					 		}
					 	}			
					};

					{					
					deleteVehicle _x
					}
				foreach [_centralSpot,_probeNorth,_probeSouth,_probeEast,_probeWest]
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
				
			if ((count _goodSpots) >= _Spotsneeded) exitwith {_isdone = true}
			}
		}
	};

_goodSpots