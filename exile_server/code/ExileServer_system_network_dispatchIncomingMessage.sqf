/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_payload","_sessionId","_messageName","_messageParameters","_allowedParameters","_moduleName","_functionName","_functionCode"];
_payload = _this;
try 
{
	if (isNil "_payload") then
	{
		throw "Message payload is not defined!";
	};
	if (typeName _payload != "ARRAY") then
	{
		throw "Message payload is not a array!";
	};
	if (count _payload != 3) then
	{
		throw format ["Wrong envelope field count! Payload: %1", _payload]; 
	};
	_sessionId = _payload select 0;
	_messageName = _payload select 1;
	_messageParameters = _payload select 2;
	if (_messageName != "startSessionRequest") then
	{
		if (count _sessionId != 8) then
		{
			throw format ["Invalid session ID found! Payload: %1", _payload]; 
		};
		if !(_sessionId call ExileServer_system_session_isRegisteredId) then
		{
			throw format ["Unknown session ID found! Payload: %1", _payload]; 
		};
	};
	if !(isClass (configFile >> "CfgNetworkMessages" >> _messageName)) then
	{
		throw format ["Forbidden message name! Payload: %1", _payload]; 
	};
	_allowedParameters = getArray(configFile >> "CfgNetworkMessages" >> _messageName >> "parameters");
	if (count _messageParameters != count _allowedParameters) then
	{
		throw format ["Parameter count mismatch! Payload: %1", _payload]; 
	};
	{
		if (_x != typeName (_messageParameters select _forEachIndex)) then
		{
			throw format ["Parameter type mismatch! Index %1, Required %2, Found %3, Payload: %4", _forEachIndex, _x, (typeName (_messageParameters select _forEachIndex)), _payload];
		};
	}
	forEach _allowedParameters;
	_moduleName = getText(configFile >> "CfgNetworkMessages" >> _messageName >> "module");
	_functionName = format["ExileServer_%1_network_%2", _moduleName, _messageName];
	_functionCode = missionNamespace getVariable [_functionName,""];
	if(_functionCode isEqualTo "")then
	{
		throw format ["Invalid function call! Called: %1",_functionName];
	};
	[_sessionId, _messageParameters] call _functionCode;
}
catch
{
	format["Network message dispatch failed: %1", _exception]  call ExileServer_util_log;
};
true