params ["_units", "_unit"];

private _distance = 10^5;
private _unitDistance = 0;

{
    _unitDistance = _x distance _unit;
    if (_unitDistance < _distance) then {
        _distance = _unitDistance;
    };
} forEach _units;
	
_distance