/*
	infiSTAR: when you die your weapons dropped are not next to your body anymore, they will be on your body again!
*/
closeDialog 0;
ExileClientLastDiedPlayerObject = player;
ExileClientIsAutoRunning = false;
if !((vehicle player) isEqualTo player) then
{
	unassignVehicle player; 
	player action ['GetOut', vehicle player]; 
	player action ['Eject', vehicle player];
};
('ExileClientHUDLayer' call BIS_fnc_rscLayer) cutText ['', 'PLAIN'];

player spawn {
	private['_unit','_nObject'];
	_unit = _this;
	_nObject = objNull;
	waitUntil {_nObject = nearestObject [_unit, 'WeaponHolderSimulated'];!isNull _nObject};
	if(!isNull _nObject)then
	{
		_weaponCargo = weaponCargo _nObject;
		if!(_weaponCargo isEqualTo [])then
		{
			{
				_unit addWeapon _x;
			} forEach _weaponCargo;
		};
	};
	deleteVehicle _nObject;
};