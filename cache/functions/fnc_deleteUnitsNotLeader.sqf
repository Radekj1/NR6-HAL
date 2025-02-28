params ["_group"];

{
    deleteVehicle _x;
} forEach units _group - [leader _group];