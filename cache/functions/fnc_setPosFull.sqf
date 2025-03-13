params [];

{
    if ( !(stopped _x) && !(_x getVariable ["NR6Site", false])) then {

        _testpos = (formationPosition _x);
        if (!(isNil "_testpos") && (count _testpos > 0)) then {
            if (!(isPlayer _x) && (isNull objectParent _x)) then {
                _x setPos [_testpos select 0,_testpos select 1,0];
                _x allowDamage false;
                [_x]spawn {[3] call CBA_fnc_waitAndExecute;(_this select 0) allowDamage true;};
            };
        };
    };
} forEach _toCache;
