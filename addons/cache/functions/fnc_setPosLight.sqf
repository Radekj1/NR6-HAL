params [];

{	
    if ( !(stopped _x) && (unitReady _x) && (isNull objectParent _x) && !(_x getVariable ["NR6Site", false])) then { 
        
        _testpos = (formationPosition _x);
        if (!(isNil "_testpos") && (count _testpos > 0)) then {
            if (!(isPlayer _x) && (vehicle _x == _x)) then {
                _x setPos [_testpos select 0, _testpos select 1, 0];
            };
        };
    };
} forEach _toCache;