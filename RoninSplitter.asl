state("Ronin", "v8")
{

	int loading : "Ronin.exe", 0x002F01CC, 0x7DC, 0xC0;

	int level1 : "Ronin.exe", 0x0030CF34, 0x0, 0x1D8, 0xC, 0xC0;
	int level2 : "Ronin.exe", 0x0030CF34, 0x0, 0x2E8, 0xC, 0xB4;	// Not sure what these are exactly, but by checking all three you can get level changes
	int level3 : "Ronin.exe", 0x0030CF34, 0x0, 0x2E8, 0xC, 0xC0;

}

state("Ronin", "v9")
{

	int loading : "Ronin.exe", 0x002F7228, 0x5C, 0x418, 0x5C, 0xB4;

	int level1 : "Ronin.exe", 0x00313FA4, 0x0, 0x1D8, 0xC, 0xC0;
	int level2 : "Ronin.exe", 0x00313FA4, 0x0, 0x2E4, 0xC, 0xB4;
	int level3 : "Ronin.exe", 0x00313FA4, 0x0, 0x2E4, 0xC, 0xC0;

}


startup {

	vars.doubletap = 0;	// For preventing double split
}

init {

	switch(modules.First().ModuleMemorySize) {
		case 5705728:
			version = "v9";
			break;
		case 5668864:
			version = "v8";
			break;
	}

	//if (modules.First().ModuleMemorySize == 5705728) version = "v9";
	//if (modules.First().ModuleMemorySize == 5668864) version = "v8";
}

start {
	if ( old.loading == 0 && current.loading == 1 )
	{
		timer.IsGameTimePaused = true;
		vars.doubletap = 1;
		return true;
	}
}

isLoading {
	return current.loading == 1;
	
}

update
{
	// Double split prevention

	if ( vars.doubletap != 0 ) {
		if (vars.doubletap >= 1000) {
			vars.doubletap = 0;
		} else {
			vars.doubletap += 1;
		}
	}


}

split {

	if ( vars.doubletap == 0 ) {
		if ( current.level1 != old.level1 || current.level2 != old.level2 || current.level3 != old.level3 )
		{
			vars.doubletap = 1;
			return true;
		}
	}
	

}

/*

			level1		level2		level3

	Level 1		0		0		0
	Level 2		1		1		1
	Level 3		2		2		2
	Level 4		0		1		1
	Level 5		0		1		1
	Level 6		0		0		0
	Level 7		2		3		3
	Level 8		9		4		4
	Level 9		9		4		4
	Level 10	1		0		0
	Level 11	5		1		1
	Level 12	5		1		1
	Level 13	0		1		1
	Level 14	2		0		0
	Level 15	0		1		1


	This is what the level values settles on, but before they do the values change around
	a bit which makes it possible to check for all level changes by watching these three
	values

*/