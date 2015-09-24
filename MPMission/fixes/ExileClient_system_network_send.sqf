/*
	infiSTAR.de: we don"t like spam selling on full servers to get a lot of money, do we?
*/
params["_messageName",["_messageParameters",[],[[]]]];
_checkList = ["purchaseItemRequest","sellItemRequest"];
try
{
	if(_messageName in _checkList)then
	{
		_stringcode = str _this;
		if(isNil"fnc_check_packets_QUEARRAY")then{fnc_check_packets_QUEARRAY = [];};
		if(_stringcode in fnc_check_packets_QUEARRAY)then
		{
			_inputID = fnc_check_packets_QUEARRAY find _stringcode;
			_lastCall = fnc_check_packets_QUEARRAY select (_inputID+1);
			_timedif = diag_tickTime - _lastCall;
			if(_timedif < 1.5)then
			{
				for "_i" from 0 to 3 do{closeDialog 0;};
				throw _messageName;
			}
			else
			{
				fnc_check_packets_QUEARRAY deleteRange [_inputID,(_inputID+1)];
			};
		};
		fnc_check_packets_QUEARRAY pushBack _stringcode;
		fnc_check_packets_QUEARRAY pushBack diag_tickTime;
	};
	_publicMessage = [ExileClientSessionId, _messageName, _messageParameters];
	_publicMessage remoteExecCall ["ExileServer_system_network_dispatchIncomingMessage", 2];
	_publicMessage = nil;
}
catch
{
	_log = format["<infiSTAR.de> ANTI-SPAM blocked [%1]",_exception];
	systemChat _log;
	true
};
true