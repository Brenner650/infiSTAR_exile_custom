/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
scriptName 'ExileServer Main Thread';
ExileSystemSpawnThread = [];
ExileSystemThreadDelays = [];
ExileSystemMainTimer = time;
ExileSystemThreadSleep = 1;	// we sleep at least a second so the server can calm down
ExileSystemThreadID = 0;
//	[_delay, time, _function,_params, _threadId, _persistance]
if(!isNil'ExileServer_system_thread_initialize_THEAD')then{terminate ExileServer_system_thread_initialize_THEAD;ExileServer_system_thread_initialize_THEAD=nil;};
ExileServer_system_thread_initialize_THEAD = [] spawn {
	waitUntil { (time > 0) && PublicHiveIsLoaded };
	"Main thread started" call ExileServer_util_log;
	while{true}do
	{
		if !(ExileSystemSpawnThread isEqualTo []) then
		{
			{
				if (ExileSystemMainTimer > (((_x select 1) + (_x select 0)) - ExileSystemThreadSleep)) then
				{
					_x set [1, time];
					(_x select 3) call (_x select 2);
					if !(_x select 5) then
					{
						[_x select 4] call ExileServer_system_thread_removeTask;
						format ["Job not presistent, removing ID: %1", _forEachIndex] call ExileServer_util_log;
					};
				};
			} forEach ExileSystemSpawnThread;
		};
		uiSleep ExileSystemThreadSleep;
		ExileSystemMainTimer = time;
	};
};