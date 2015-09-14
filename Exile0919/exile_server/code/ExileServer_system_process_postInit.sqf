hotfix_getNearbyPlayers =
{
	private ["_pos", "_dis", "_OK", "_players"];
	_OK = params
	[
		["_pos",[0,0,0],[objNull,[]],[2,3]],
		["_dis",0,[0]]
	];
	if(!_OK)exitWith{}; 
	_players = _pos nearEntities ["Exile_Unit_Player",_dis];
	{_entitie = _x;{if(isPlayer _x)then{_players pushBack _x;};} forEach (crew _entitie);} forEach (_pos nearEntities [["LandVehicle", "Air", "Ship"], _dis]);
	_players
};
if (!isNil "PublicHiveVersion") then
{
	call ExileServer_system_thread_initialize;
	call ExileServer_system_playerSaveQueue_initialize;
	call ExileServer_system_swapOwnershipQueue_initialize;
	call ExileServer_system_vehicleSaveQueue_initialize;
	call ExileServer_system_simulationMonitor_initialize;
	call ExileServer_system_lootManager_initialize;
	call ExileServer_system_weather_initialize;
	call ExileServer_world_initialize;
	call ExileServer_system_localityMonitor_initialize;
	call ExileServer_system_territory_maintenance_check;
	PublicHiveIsLoaded = true; 
	publicVariable "PublicHiveIsLoaded";
	format ["Server is up and running! Version: %1", PublicHiveVersion] call ExileServer_util_log;
	[] execFSM "exile_server\fsm\main.fsm";
	call ExileServer_system_rcon_event_ready;
};