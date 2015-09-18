/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private['_container','_vehicle'];
_container = _this select 1;
ExileClientInventoryOpened = false;
ExileClientCurrentInventoryContainer = objNull;
try
{
	if((typeOf _vehicle) in ['GroundWeaponHolder','WeaponHolderSimulated'])then
	{
		_inuseby = _vehicle getVariable ['HOLDER_IN_USE',''];
		if(netId player == _inuseby)then
		{
			_vehicle setVariable ['HOLDER_IN_USE',nil,true];
		};
		throw '';
	};
	if(_vehicle isKindOf 'Man')then
	{
		throw '';
	};
	['vehicleSaveRequest',[netId _container]] call ExileClient_system_network_send;
}
catch
{
	true
};
true