/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_vehicleObject","_ExileVehicleSaveQueuedAt"];
_vehicleObject = _this;
if(!isNull _vehicleObject)then
{
	if(_vehicleObject getVariable ["ExileIsPersistent",false])then
	{
		_ExileVehicleSaveQueuedAt = _vehicleObject getVariable ["ExileVehicleSaveQueuedAt",-1];
		if(_ExileVehicleSaveQueuedAt isEqualTo -1)then
		{
			_vehicleObject setVariable ["ExileVehicleSaveQueuedAt", time];
			ExileServerVehicleSaveQueue pushBack _vehicleObject;
		};
	};
};
true