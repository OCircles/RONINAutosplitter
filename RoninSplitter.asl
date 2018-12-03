state("Ronin", "v8")
{

	int loading : "Ronin.exe", 0x002F01CC, 0x7DC, 0xC0;
	short bike : "Ronin.exe", 0x561758, 0x140;

}

state("Ronin", "v9")
{

	int loading : "Ronin.exe", 0x002F7228, 0x5C, 0x418, 0x5C, 0xB4;
	ushort bike : "Ronin.exe", 0x56A758, 0xE4;

}


startup {
	vars.doubletap = 0;
	vars.bikeVar = 0;
}

init {

	switch(modules.First().ModuleMemorySize) {
		case 5705728:
			version = "v9";
			vars.bikeVar = 52688;
			break;
		case 5668864:
			version = "v8";
			vars.bikeVar = 21368;
			break;
	}
}


start {
	if ( old.loading == 0 && current.loading == 1 )
	{
		timer.IsGameTimePaused = true;
		return true;
	}
}

isLoading {
	return current.loading == 1;
}

split {
	if ( vars.doubletap == 0) {
		if ( old.bike != vars.bikeVar && current.bike == vars.bikeVar ) {
			vars.doubletap = 500;
			return true;
		}
	}
}

update {
	if ( vars.doubletap != 0 ) vars.doubletap -= 1;
}