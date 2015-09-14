
For 0919..
The main reason for this is to test if there is a any big performance gain from using remoteExecCall over PublicVariables.
I did not implement fixes from the forums.


------------------------------------------------------------
You have to edit your MPMission to replace the files from the exile_client folder.
Your MPMission has a 

config.cpp

that has the class: CfgExileCustomCode

Should look like this:

class CfgExileCustomCode 
{
	ExileClient_gui_safezone_safeESP = "fixes\ExileClient_gui_safezone_safeESP.sqf";
	ExileClient_gui_xm8_slide_healthScanner_onOpen = "fixes\ExileClient_gui_xm8_slide_healthScanner_onOpen.sqf";
	ExileClient_object_player_event_onKilled = "fixes\ExileClient_object_player_event_onKilled.sqf";
	ExileClient_object_player_initialize = "fixes\ExileClient_object_player_initialize.sqf";
	ExileClient_system_network_send = "fixes\ExileClient_system_network_send.sqf";
	ExileClient_util_containerCargo_add = "fixes\ExileClient_util_containerCargo_add.sqf";
};

You have to create a folder named "fixes" in your MPMission and move the files from my "exile_client\code" folder into that "fixes" folder.




In your description.ext of your MPMission you should currently have this (unless you have a seperate CfgRemoteExec.cpp, then it is there):

class CfgRemoteExec
{
	class Functions
	{
		mode = 0;
		jip = 0;
	};
	class Commands
	{
		mode=0;
	};
};

Since we want to reduce network usage of PublicVariables we are going to change this so the server does not need to publicVariable the exile "publicMessage" anymore


class CfgRemoteExec
{
	class Functions
	{
		jip = 0;
		mode = 1;
		class ExileClient_system_network_dispatchIncomingMessage 	{ allowedTargets=1; };
		class ExileServer_system_network_dispatchIncomingMessage 	{ allowedTargets=2; };
	};
	class Commands
	{
		mode=0;
	};
};