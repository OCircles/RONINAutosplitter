state("Ronin", "v8")
{

	int loading : "Ronin.exe", 0x002F01CC, 0x7DC, 0xC0;
	int menu : "Ronin.exe", 0x9CD30, 0x94;

}

state("Ronin", "v9")
{

	int loading : "Ronin.exe", 0x002F7228, 0x5C, 0x418, 0x5C, 0xB4;
	int menu : "Ronin.exe", 0x22B770, 0x6F8;

}


startup {
	vars.selectMenu = 0;
	vars.mainMenu = 0;
}

init {

	switch(modules.First().ModuleMemorySize) {
		case 5705728:
			version = "v9";
			vars.selectMenu = 12;
			vars.mainMenu = 1584196;
			break;
		case 5668864:
			version = "v8";
			vars.selectMenu = 4;
			vars.mainMenu = 1584308;
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
	if ( old.menu != vars.selectMenu && current.menu == vars.selectMenu ) return true;
	else if ( old.menu != vars.mainMenu && current.menu == vars.mainMenu ) return true;
}