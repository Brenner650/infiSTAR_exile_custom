/*
	Loads a single player object given by its ID

	IN:
	ARRAY - Player record
	ARRAY - Parameters (Session ID/Player Object Before)
*/

_data = _this select 0;
_oldPlayerObject = _this select 1;
_playerUID = _this select 2;
_sessionID = _this select 3;

_name = name _oldPlayerObject;

// Position
_position = [_data select DB_PLAYER_POSITION_X, _data select DB_PLAYER_POSITION_Y, _data select DB_PLAYER_POSITION_Z];
_direction = _data select DB_PLAYER_DIRECTION;



// RODfix (you see what I did there?)
_resetPosAboveObj = false;
if ((_position select 2)>2.5) then
{
	_intersectingObjs = lineIntersectsWith [ATLtoASL _position, [_position select 0,_position select 1,0], objNull, objNull, true];
	if (_intersectingObjs isEqualTo []) then
	{
		diag_log format ["Resetting player altitude to 0; Pos of %1 (%2) is above 2.5 meters, but there's nothing below the player!",_name,_playerUID];
		_position set [2,0];
	}
	else
	{
		_intersectingObj = _intersectingObjs select ((count _intersectingObjs)-1);
		_intersectingObjTopPos = ((getPosATL _intersectingObj) select 2)+((boundingBoxReal _intersectingObj) select 1 select 2);
		if (((_position select 2)-_intersectingObjTopPos)>2.5) then
		{
			diag_log format ["Resetting player altitude above intersecting object; It is more than 2.5 meters below the player position | %1 (%2) | type: %3.",_name,_playerUID,typeOf _intersectingObj];
			_resetPosAboveObj = true;
		};
	};
};



// TODO: Load group?
_group = createGroup independent;

// If the player has logged in the air, spawn them on the ground
// 2015-06-01: Does not work, since this is not ATL, but posWorld
/*if (_position select 2 > (5*3)) then // 5*3 = 5 floor building
{
	_position set [2, 0.1];
};*/

// Create Bambi AI
_player = _group createUnit ["Exile_Unit_Player", _position, [], 0, "CAN_COLLIDE"];
_player setDir _direction;

if (_resetPosAboveObj) then
{
	_position set [2, vectorMagnitude ((ATLToASL _position) vectorDiff getPos _player)];
	_player setPosASL _position;
}
else
{
	_player setPosATL _position;
};

_player disableAI "FSM";
_player disableAI "MOVE";
_player disableAI "AUTOTARGET";
_player disableAI "TARGET";

_clanID = (_data select DB_PLAYER_CLAN_ID);
_clanName = (_data select DB_PLAYER_CLAN_NAME);

// NULL -> -1
if !((typeName _clanID) isEqualTo "SCALAR") then
{
	_clanID = -1;
	_clanName = "";
};

// Restore stuff
_player setDamage (_data select DB_PLAYER_DAMAGE);
_player setFatigue (_data select DB_PLAYER_FATIGUE);
_player setName _name;
_player setVariable ["ExileMoney", (_data select DB_PLAYER_ACCOUNT_MONNEY)];
_player setVariable ["ExileScore", (_data select DB_PLAYER_ACCOUNT_SCORE)];
_player setVariable ["ExileKills", (_data select DB_PLAYER_ACCOUNT_KILLS)];
_player setVariable ["ExileDeaths", (_data select DB_PLAYER_ACCOUNT_DEATHS)];
_player setVariable ["ExileClanID", _clanID];
_player setVariable ["ExileClanName", _clanName];
_player setVariable ["ExileName", _name]; // because, Arma
_player setVariable ["ExileOwnerUID", _playerUID]; // because, Arma
_player setVariable ["ExileDatabaseID", _data select DB_PLAYER_ID];
_player setVariable ["ExileHunger", _data select DB_PLAYER_HUNGER];
_player setVariable ["ExileThirst", _data select DB_PLAYER_THIRST];
_player setVariable ["ExileAlcohol", _data select DB_PLAYER_ALCOHOL]; 
_player setVariable ["ExileIsBambi", false];
_player setVariable ["ExileXM8IsOnline", false, true];
_player setOxygenRemaining (_data select DB_PLAYER_OXYGEN_REMAINING);
_player setBleedingRemaining (_data select DB_PLAYER_BLEEDING_REMAINING);
_player setHitPointDamage ["hitHead", _data select DB_PLAYER_HITPOINT_HEAD];
_player setHitPointDamage ["hitBody", _data select DB_PLAYER_HITPOINT_BODY];
_player setHitPointDamage ["hitHands", _data select DB_PLAYER_HITPOINT_HANDS];
_player setHitPointDamage ["hitLegs", _data select DB_PLAYER_HITPOINT_LEGS];

// Remove everything first
_player call ExileClient_util_playerCargo_clear;

// Headgear
_headgear = _data select DB_PLAYER_HEADGEAR;

if (_headgear != "") then
{
	_player addHeadgear _headgear;
};

// Goggles
_goggles = _data select DB_PLAYER_GOGGLES;

if (_goggles != "") then
{
	_player addGoggles _goggles;
};

// Binocular
_binocular = _data select DB_PLAYER_BINOCULAR;

if (_binocular != "") then
{
	_player addWeaponGlobal _binocular;
};

// Uniform
_uniform = _data select DB_PLAYER_UNIFORM;
_vest = _data select DB_PLAYER_VEST;
_backpack = _data select DB_PLAYER_BACKPACK;

if (_uniform != "") then 
{
	_player forceAddUniform _uniform;
};

if (_vest != "") then
{
	_player addVest _vest;
};

if (_backpack != "") then
{
	_player addBackpackGlobal _backpack;
};

_uniformContainer = uniformContainer _player;

if !(isNil "_uniformContainer") then
{
	// Uniform Weapons
	{ 
		_uniformContainer addWeaponCargoGlobal _x; 
	} 
	forEach (_data select DB_PLAYER_UNIFORM_WEAPONS);

	// Uniform Magazines
	{ 
		//_uniformContainer addMagazineCargoGlobal _x; 
		_uniformContainer addMagazineAmmoCargo [_x select 0, 1, _x select 1]; 
	} 
	forEach (_data select DB_PLAYER_UNIFORM_MAGAZINES);

	// Uniform Items
	{ 
		_uniformContainer addItemCargoGlobal _x; 
	} 
	forEach (_data select DB_PLAYER_UNIFORM_ITEMS);
};

_vestContainer = vestContainer _player;

if !(isNil "_vestContainer") then
{
	// Vest Weapons
	{ 
		_vestContainer addWeaponCargoGlobal _x; 
	} 
	forEach (_data select DB_PLAYER_VEST_WEAPONS);

	// Vest Magazines
	{ 
		//_vestContainer addMagazineCargoGlobal _x; 
		_vestContainer addMagazineAmmoCargo [_x select 0, 1, _x select 1]; 
	} 
	forEach (_data select DB_PLAYER_VEST_MAGAZINES);

	// Vest Items
	{ 
		_vestContainer addItemCargoGlobal _x; 
	} 
	forEach (_data select DB_PLAYER_VEST_ITEMS);
};

_backpackContainer = backpackContainer _player;

if !(isNil "_backpackContainer") then
{
	// Backpack Weapons
	{ 
		_backpackContainer addWeaponCargoGlobal _x; 
	} 
	forEach (_data select DB_PLAYER_BACKPACK_WEAPONS);

	// Backpack Magazines
	{ 
		//_backpackContainer addMagazineCargoGlobal _x; 
		_backpackContainer addMagazineAmmoCargo [_x select 0, 1, _x select 1]; 
	} 
	forEach (_data select DB_PLAYER_BACKPACK_MAGAZINES);

	// Backpack Items
	{ 
		_backpackContainer addItemCargoGlobal _x; 
	} 
	forEach (_data select DB_PLAYER_BACKPACK_ITEMS);
};
	
_loadObject = nil;

switch (true) do
{
	case (_uniform != ""): 	{ _loadObject = _uniformContainer; };
	case (_vest != ""): 	{ _loadObject = _vestContainer; };
	case (_backpack != ""): { _loadObject = _backpackContainer; };
};

// Loaded magazines
if !(isNil "_loadObject") then
{
	{ 
		_loadObject addMagazineAmmoCargo [_x select 0, 1, _x select 1]; 
	} 
	forEach (_data select DB_PLAYER_LOADED_MAGAZINES);
};

// Primary weapon
_primaryWeapon = _data select DB_PLAYER_PRIMARY_WEAPON;

if (_primaryWeapon != "") then 
{
	_player addWeaponGlobal _primaryWeapon;

	// Primary weapon items (scope etc.)
	removeAllPrimaryWeaponItems _player;

	{ 
		if (_x != "") then
		{
			_player addPrimaryWeaponItem _x; 
		};
	} 
	forEach (_data select DB_PLAYER_PRIMARY_WEAPON_ITEMS);
};

// Handgun Weapon
_handgunWeapon = _data select DB_PLAYER_HANDGUN_WEAPON;

if (_handgunWeapon != "") then
{
	_player addWeaponGlobal _handgunWeapon;

	// Handgun scopes etc.
	removeAllHandgunItems _player;

	{ 
		if (_x != "") then
		{
			_player addHandgunItem _x; 
		};
	} 
	forEach (_data select DB_PLAYER_HANDGUN_ITEMS);
};

// Secondary Weapon
_secondaryWeapon = _data select DB_PLAYER_SECONDARY_WEAPON;

if (_secondaryWeapon != "") then
{
	_player addWeaponGlobal _secondaryWeapon;
	// There is no removeAllSecondaryWeaponItems?
	{ 
		if (_x != "") then
		{
			_player addSecondaryWeaponItem _x; 
		};
	} 
	forEach (_data select DB_PLAYER_SECONDARY_WEAPON_ITEMS);
};
 
 // Current weapon
 _currentWeapon = _data select DB_PLAYER_CURRENT_WEAPON;

if (_currentWeapon != "") then
{
	 _player selectWeapon _currentWeapon;
};

_assigned_items = _data select DB_PLAYER_ASSIGNED_ITEMS;

// Assigned items
if !(_assigned_items isEqualTo []) then
{
	{
		_player linkItem _x;
	}
	forEach _assigned_items;
};

// Killed event
_player addMPEventHandler ["MPKilled", {_this call ExileServer_object_player_event_onMpKilled}];

////////////////////////////////////////
// FUCK OFF ARMA
////////////////////////////////////////
//uiSleep 0.2;
////////////////////////////////////////
// FUCK OFF ARMA
////////////////////////////////////////

// Tell the client
[
	_sessionID, 
	"loadPlayerResponse", 
	[
		(netId _player),
		str (_player getVariable ["ExileMoney", 0]),
		str (_player getVariable ["ExileScore", 0]),
		(_player getVariable ["ExileKills", 0]),
		(_player getVariable ["ExileDeaths", 0]),
		(_player getVariable ["ExileHunger", 100]),
		(_player getVariable ["ExileThirst", 100]),
		(_player getVariable ["ExileAlcohol", 0]),
		(_player getVariable ["ExileClanName", ""])
	]
] 
call ExileServer_system_network_send_to;

// Change player object assigned to the session
[_sessionID, _player] call ExileServer_system_session_update;

true