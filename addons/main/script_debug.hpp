/**
Fast Recompiling via function
**/
// #define DISABLE_COMPILE_CACHE
// To Use: [] call HAL_PREP_RECOMPILE;

#ifdef DISABLE_COMPILE_CACHE
    #define LINKFUNC(x) {_this call FUNC(x)}
    #define PREP_RECOMPILE_START    if (isNil "HAL_PREP_RECOMPILE") then {HAL_RECOMPILES = []; HAL_PREP_RECOMPILE = {{call _x} forEach HAL_RECOMPILES;}}; private _recomp = {
    #define PREP_RECOMPILE_END      }; call _recomp; HAL_RECOMPILES pushBack _recomp;
#else
    #define LINKFUNC(x) FUNC(x)
    #define PREP_RECOMPILE_START ; /* disabled */
    #define PREP_RECOMPILE_END ; /* disabled */
#endif


/**
STACK TRACING
**/
//#define ENABLE_CALLSTACK
//#define ENABLE_PERFORMANCE_COUNTERS
//#define DEBUG_EVENTS

#ifdef ENABLE_CALLSTACK
    #define CALLSTACK(function) {if(HAL_IS_ERRORED) then { ['AUTO','AUTO'] call HAL_DUMPSTACK_FNC; HAL_IS_ERRORED = false; }; HAL_IS_ERRORED = true; HAL_STACK_TRHAL set [HAL_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, HAL_CURRENT_FUNCTION, 'ANON', _this]]; HAL_STACK_DEPTH = HAL_STACK_DEPTH + 1; HAL_CURRENT_FUNCTION = 'ANON'; private _ret = _this call ##function; HAL_STACK_DEPTH = HAL_STACK_DEPTH - 1; HAL_IS_ERRORED = false; _ret;}
    #define CALLSTACK_NAMED(function, functionName) {if(HAL_IS_ERRORED) then { ['AUTO','AUTO'] call HAL_DUMPSTACK_FNC; HAL_IS_ERRORED = false; }; HAL_IS_ERRORED = true; HAL_STACK_TRHAL set [HAL_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, HAL_CURRENT_FUNCTION, functionName, _this]]; HAL_STACK_DEPTH = HAL_STACK_DEPTH + 1; HAL_CURRENT_FUNCTION = functionName; private _ret = _this call ##function; HAL_STACK_DEPTH = HAL_STACK_DEPTH - 1; HAL_IS_ERRORED = false; _ret;}
    #define DUMPSTACK ([__FILE__, __LINE__] call HAL_DUMPSTACK_FNC)

    #define FUNC(var1) {if(HAL_IS_ERRORED) then { ['AUTO','AUTO'] call HAL_DUMPSTACK_FNC; HAL_IS_ERRORED = false; }; HAL_IS_ERRORED = true; HAL_STACK_TRHAL set [HAL_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, HAL_CURRENT_FUNCTION, 'TRIPLES(ADDON,fnc,var1)', _this]]; HAL_STACK_DEPTH = HAL_STACK_DEPTH + 1; HAL_CURRENT_FUNCTION = 'TRIPLES(ADDON,fnc,var1)'; private _ret = _this call TRIPLES(ADDON,fnc,var1); HAL_STACK_DEPTH = HAL_STACK_DEPTH - 1; HAL_IS_ERRORED = false; _ret;}
    #define EFUNC(var1,var2) {if(HAL_IS_ERRORED) then { ['AUTO','AUTO'] call HAL_DUMPSTACK_FNC; HAL_IS_ERRORED = false; }; HAL_IS_ERRORED = true; HAL_STACK_TRHAL set [HAL_STACK_DEPTH, [diag_tickTime, __FILE__, __LINE__, HAL_CURRENT_FUNCTION, 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)', _this]]; HAL_STACK_DEPTH = HAL_STACK_DEPTH + 1; HAL_CURRENT_FUNCTION = 'TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)'; private _ret = _this call TRIPLES(DOUBLES(PREFIX,var1),fnc,var2); HAL_STACK_DEPTH = HAL_STACK_DEPTH - 1; HAL_IS_ERRORED = false; _ret;}
#else
    #define CALLSTACK(function) function
    #define CALLSTACK_NAMED(function, functionName) function
    #define DUMPSTACK ; /* disabled */
#endif


/**
PERFORMANCE COUNTERS SECTION
**/
//#define ENABLE_PERFORMANCE_COUNTERS
// To Use: [] call HAL_common_fnc_dumpPerformanceCounters;

#ifdef ENABLE_PERFORMANCE_COUNTERS
    #define CBA_fnc_addPerFrameHandler { private _ret = call CBA_fnc_addPerFrameHandler; if(isNil "HAL_PFH_COUNTER" ) then { HAL_PFH_COUNTER=[]; }; HAL_PFH_COUNTER pushBack [[_ret, __FILE__, __LINE__], _this];  _ret }

    #define CREATE_COUNTER(x) if(isNil "HAL_COUNTERS" ) then { HAL_COUNTERS=[]; }; GVAR(DOUBLES(x,counter))=[]; GVAR(DOUBLES(x,counter)) set[0, QUOTE(GVAR(DOUBLES(x,counter)))];  GVAR(DOUBLES(x,counter)) set[1, diag_tickTime]; HAL_COUNTERS pushBack GVAR(DOUBLES(x,counter));
    #define BEGIN_COUNTER(x) if(isNil QUOTE(GVAR(DOUBLES(x,counter)))) then { CREATE_COUNTER(x) }; GVAR(DOUBLES(x,counter)) set[2, diag_tickTime];
    #define END_COUNTER(x) GVAR(DOUBLES(x,counter)) pushBack [(GVAR(DOUBLES(x,counter)) select 2), diag_tickTime];

    #define DUMP_COUNTERS ([__FILE__, __LINE__] call HAL_DUMPCOUNTERS_FNC)
#else
    #define CREATE_COUNTER(x) ; /* disabled */
    #define BEGIN_COUNTER(x) ; /* disabled */
    #define END_COUNTER(x) ; /* disabled */
    #define DUMP_COUNTERS ; /* disabled */
#endif
