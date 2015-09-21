/*
	Sends a message to everyone but server (non-persistent)
*/
params ["_messageName", "_messageParameters", ["_exludeSessionID", "-1"]];	// _exludeSessionID is not used anywhere yet.
_publicMessage = [_messageName, _messageParameters];
_publicMessage remoteExecCall ["ExileClient_system_network_dispatchIncomingMessage", -2];
_publicMessage = nil;