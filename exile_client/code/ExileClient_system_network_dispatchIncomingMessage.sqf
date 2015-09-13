/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_payload","_messageName","_messageParameters","_allowedParameters","_moduleName","_functionName","_functionCode","_message"];
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
	format ["Incoming message: %1", _payload] call ExileClient_util_log;
	if (count _payload != 2) then
	{
		throw format ["Wrong envelope field count! Payload: %1", _payload]; 
	};
	_messageName = _payload select 0;
	_messageParameters = _payload select 1;
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
			throw format ["Parameter type mismatch! Payload: %1", _payload];
		};
	}
	forEach _allowedParameters;
	diag_log format["Dispatching message '%1'...", _messageName];
	_moduleName = getText(configFile >> "CfgNetworkMessages" >> _messageName >> "module");
	_functionName = format["ExileClient_%1_network_%2", _moduleName, _messageName];
	_functionCode = missionNamespace getVariable [_functionName,""];
	if(_functionCode isEqualTo "")then
	{
		throw format ["Invalid function call! Called: %1",_functionName];
	};
	_messageParameters call _functionCode;
}
catch
{
	_message = "NetworkMenager - " + _exception;
	_message call ExileClient_util_log;
};
true