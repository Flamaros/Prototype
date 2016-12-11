module platform.windows;

/*
// Need to be on runtime CRuntime_Microsoft instead of CRuntime_DigitalMars else _open_osfhandle can't be linked
void openConsole()
{
	import core.sys.windows.windows : AllocConsole, HANDLE, GetStdHandle, STD_OUTPUT_HANDLE;
	import core.stdc.stdint : intptr_t;
	import core.stdc.stdio;
	import core.sys.windows.winbase : STD_OUTPUT_HANDLE, STD_INPUT_HANDLE;

	AllocConsole();
	
    HANDLE handle_out = GetStdHandle(STD_OUTPUT_HANDLE);
    int hCrt = _open_osfhandle(cast(intptr_t)handle_out, _O_TEXT);
    FILE* hf_out = _fdopen(hCrt, "w");
    setvbuf(hf_out, null, _IONBF, 1);
    *stdout = *hf_out;

    HANDLE handle_in = GetStdHandle(STD_INPUT_HANDLE);
    hCrt = _open_osfhandle(cast(intptr_t)handle_in, _O_TEXT);
    FILE* hf_in = _fdopen(hCrt, "r");
    setvbuf(hf_in, null, _IONBF, 128);
    *stdin = *hf_in;
}
*/
