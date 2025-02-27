#include "..\script_component.hpp"

/**
 * @description Calculates the distance from a point to a line segment defined by two points
 * @param {Array} First point (p1) defining the line [x,y,z]
 * @param {Array} Second point (p2) defining the line [x,y,z]
 * @param {Array} The reference point (pc) to calculate distance from [x,y,z]
 * @return {Number} Distance from reference point to line segment
 */
params ["_p1", "_p2", "_pc"];

// Calculate distances
private _d0 = _p1 distance _p2;  // Line segment length
private _d1 = _pc distance _p1;  // Distance from reference point to p1
private _d2 = _pc distance _p2;  // Distance from reference point to p2

// Initialize with direct distance to p1
private _d = _d1;

// Check if the closest point is one of the endpoints
switch (true) do {
    // If the point is "behind" p1
    case (((_d0 * _d0) + (_d1 * _d1)) <= (_d2 * _d2)): {
        _d = _d1;
    };
    // If the point is "behind" p2
    case (((_d0 * _d0) + (_d2 * _d2)) <= (_d1 * _d1)): {
        _d = _d2;
    };
    // Otherwise the closest point is somewhere along the line segment
    default {
        // Extract 2D coordinates
        private _x1 = _p1 select 0;
        private _y1 = _p1 select 1;
        private _x2 = _p2 select 0;
        private _y2 = _p2 select 1;
        private _xc = _pc select 0;
        private _yc = _pc select 1;

        // Calculate line equation parameters (y = ax + b)
        private _a = (_y2 - _y1)/(_x2 - _x1);
        private _b = _y1 - _x1 * _a;

        // Calculate perpendicular distance
        _d = abs(((_a/_b) * _xc) + ((-1/_b) * _yc) + 1)/(sqrt(((_a/_b) * (_a/_b)) + (1/(_b * _b))));
    };
};

_d 