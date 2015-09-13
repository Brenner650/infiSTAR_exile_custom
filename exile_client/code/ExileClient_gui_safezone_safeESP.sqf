// infiSTAR: we really don't want to be seen as invisible admin! I use the getplayeruid way instead of isPlayer because that would need scripts.txt white-listing
private["_espRenderRange","_distance","_alpha","_clr","_crew","_veh","_bbr","_p1","_p2","_maxHeight","_pos"];
_espRenderRange = _this;
if(!isNull cameraOn)then
{
	{
		if(!isNull _x)then
		{
			if((getPlayerUID _x) isEqualTo '')exitWith{};
			if(isHidden _x)exitWith{};
			_distance = cameraOn distance _x;
			_alpha = (1-(_distance/_espRenderRange));
			_clr = [1,1,1,_alpha];	
			_crew = crew (vehicle _x);
			_name = '';
			{
				if(_forEachIndex == 0) then
				{
					_name = _name + format['%1',name _x];
				}
				else
				{
					if(alive _x) then {_name = _name + format[', %1',name _x];};
				};
			}
			forEach _crew;
			_veh = vehicle _x;
			_bbr = boundingBoxReal _veh;
			_p1 = _bbr select 0;
			_p2 = _bbr select 1;
			_maxHeight = (abs ((_p2 select 2) - (_p1 select 2))) * 1.25; 
			_pos = visiblePosition _veh;
			_pos set[2,(_pos select 2) + _maxHeight];
			drawIcon3D['',_clr,_pos,0,0,0,_name,1,0.04];
		};
	} forEach ((cameraOn nearEntities[['Exile_Unit_Player', 'LandVehicle', 'Ship', 'Air'], _espRenderRange]) - [cameraOn, vehicle cameraOn]);
};
true