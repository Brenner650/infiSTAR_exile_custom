clearBackpackCargoGlobal (_this select 6);
clearItemCargoGlobal (_this select 6);
clearMagazineCargoGlobal (_this select 6);
clearWeaponCargoGlobal (_this select 6);
deleteVehicle (_this select 6);
systemChat "You shoot AIR!";
cutText ["You shoot AIR!","PLAIN DOWN"];
hint "You are a muppet";
true