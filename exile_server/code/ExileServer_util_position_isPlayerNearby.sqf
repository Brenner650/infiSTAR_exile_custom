private["_position","_radius","_result"];
_position = _this select 0;
_radius = _this select 1;
_result = false;
{if(alive _x)exitWith{_result = true;};} forEach (_position nearEntities [['Exile_Unit_Player'],_radius]);
if(_result)exitWith{true};
{if(isPlayer _x)exitWith{_result = true;};} forEach (_position nearEntities [['LandVehicle','Air'],_radius]);	// DB: who cares about boats? :P
_result