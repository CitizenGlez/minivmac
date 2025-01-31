/*
	WRCNFGAP.i
	Copyright (C) 2007 Paul C. Pratt

	You can redistribute this file and/or modify it under the terms
	of version 2 of the GNU General Public License as published by
	the Free Software Foundation.  You should have received a copy
	of the license along with this file; see the file COPYING.

	This file is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	license for more details.
*/

/*
	WRite "CNFGrAPi.h"
*/

LOCALPROC WriteOSXLocalTalkCNFUIOSG(void)
{
	WriteDestFileLn("#include <sys/socket.h>");
	WriteDestFileLn("#include <arpa/inet.h>");
	if ((gbk_lto_bpf == gbo_lto)
		|| (gbk_targfam_fbsd == gbo_targfam)
		|| CurUseAllFiles)
	{
		if ((gbk_apifam_osx == gbo_apifam)
			|| (gbk_apifam_cco == gbo_apifam)
			|| (gbk_targfam_fbsd == gbo_targfam))
		{
			WriteDestFileLn("#include <netinet/in.h>");
		}
	}
	if ((gbk_lto_bpf == gbo_lto) || CurUseAllFiles) {
		if ((gbk_apifam_osx == gbo_apifam)
			|| (gbk_apifam_cco == gbo_apifam))
		{
			/* -lto bpf is so far only implemented for OS X */
			WriteDestFileLn("#include <net/if.h>");
			WriteDestFileLn("#include <net/route.h>");
			WriteDestFileLn("#include <net/if_dl.h>");
			WriteDestFileLn("#include <sys/select.h>");
			WriteDestFileLn("#include <sys/ioctl.h>");
			WriteDestFileLn("#include <sys/sysctl.h>");
			WriteDestFileLn("#include <net/bpf.h>");
		}
	}
	if ((gbk_lto_udp == gbo_lto) || CurUseAllFiles) {
#if 0
		WriteDestFileLn("#include <ifaddrs.h>");
#endif
		WriteCompCondBool("use_SO_REUSEPORT",
			(gbk_apifam_osx == gbo_apifam)
				|| (gbk_apifam_cco == gbo_apifam)
				|| ((gbk_apifam_xwn == gbo_apifam)
					&& (gbk_targfam_fbsd == gbo_targfam)));
	}
}

LOCALPROC WriteCommonCNFUIOSGContents(void)
{
	WriteDestFileLn("/*");
	++DestFileIndent;
		WriteDestFileLn(
			"see comment in OSGCOMUI.h");
		WriteConfigurationWarning();
	--DestFileIndent;
	WriteDestFileLn("*/");


	if (gbo_TstCompErr) {
		WriteDestFileLn("#error \"Testing Compile Time Error\"");
	}

	if (gbk_ide_msv == cur_ide) {
		if (ide_vers >= 8000) {
			WriteBlankLineToDestFile();
			WriteDestFileLn("#define _CRT_SECURE_NO_DEPRECATE 1");
		}
		WriteBlankLineToDestFile();
		WriteDestFileLn(
			"/* ignore warning generated by system includes */");
		if (ide_vers >= 6000) {
			WriteDestFileLn("#pragma warning(push)");
		}
		WriteDestFileLn("#pragma warning(disable : 4201 4115 4214)");
	}

	WriteBlankLineToDestFile();

	if (gbk_apifam_osx == gbo_apifam) {
		if (gbk_targfam_carb == gbo_targfam) {
			/* kIdeMW8 or kIdeMPW3_6_a1 */
			if (gbk_ide_mw8 == cur_ide) {
				WriteDestFileLn("#include <MacHeadersCarbon.h>");
			} else
			{
				WriteDestFileLn("#include <Carbon.h>");
				WriteDestFileLn("#include <stdlib.h>");
				WriteDestFileLn("#include <string.h>");
#if UseOpenGLinOSX
				WriteDestFileLn("#include <agl.h>");
#endif
			}
			WriteDestFileLn("#define UsingCarbonLib 1");
		} else {
			/* kIdeMW8 or kIdeBashGcc or kIdeAPB */
			if (gbk_ide_mw8 == cur_ide) {
				WriteDestFileLn("#include <MSL MacHeadersMach-O.h>");
			}
			WriteDestFileLn("#include <Carbon/Carbon.h>");
#if UseOpenGLinOSX
			WriteDestFileLn("#include <AGL/agl.h>");
#endif
#if UseMachinOSX
			WriteDestFileLn("#include <mach/mach_interface.h>");
			WriteDestFileLn("#include <mach/mach_port.h>");
#endif
			WriteDestFileLn("#include <unistd.h>");
				/* for nanosleep */

			if (WantLocalTalk || CurUseAllFiles) {
				WriteOSXLocalTalkCNFUIOSG();
			}
		}
	} else if (gbk_apifam_cco == gbo_apifam) {
		WriteDestFileLn("#import <Cocoa/Cocoa.h>");
#if MayUseSound
		if (MySoundEnabled || CurUseAllFiles) {
			WriteDestFileLn("#include <CoreAudio/CoreAudio.h>");
			WriteDestFileLn("#include <AudioUnit/AudioUnit.h>");
		}
#endif
#if UseOpenGLinOSX
		WriteDestFileLn("#include <OpenGL/gl.h>");
#endif
		WriteDestFileLn("#include <stdio.h>");
		WriteDestFileLn("#include <stdlib.h>");
		WriteDestFileLn("#include <string.h>");
		WriteDestFileLn("#include <sys/param.h>");
		WriteDestFileLn("#include <sys/time.h>");
		if (WantUnTranslocate || CurUseAllFiles) {
			WriteDestFileLn("#include <dlfcn.h>");
		}
		if (WantLocalTalk || CurUseAllFiles) {
			WriteDestFileLn("#include <unistd.h>");
			WriteOSXLocalTalkCNFUIOSG();
		}
		if ((gbk_ide_xcd == cur_ide) && (ide_vers >= 12100)) {
			/* ok */
		} else {
			if (gbk_cpufam_a64 != gbo_cpufam) {
				WriteDestFileLn("#define UseAudioComp 0");
			}

			/* use deprecated names */

			WriteDestFileLn("#define MyNSPasteboardTypeString"
				" NSStringPboardType");
			WriteDestFileLn("#define MyNSEventModifierFlagCapsLock"
				" NSAlphaShiftKeyMask");
			WriteDestFileLn("#define MyNSEventModifierFlagShift"
				" NSShiftKeyMask");
			WriteDestFileLn("#define MyNSEventModifierFlagControl"
				" NSControlKeyMask");
			WriteDestFileLn("#define MyNSEventModifierFlagOption"
				" NSAlternateKeyMask");
			WriteDestFileLn("#define MyNSEventModifierFlagCommand"
				" NSCommandKeyMask");
			WriteDestFileLn("#define MyNSWindowStyleMaskBorderless"
				" NSBorderlessWindowMask");
			WriteDestFileLn("#define MyNSWindowStyleMaskTitled"
				" NSTitledWindowMask");
			WriteDestFileLn("#define MyNSWindowStyleMaskMiniaturizable"
				" NSMiniaturizableWindowMask");
			WriteDestFileLn("#define MyNSWindowStyleMaskClosable"
				" NSClosableWindowMask");
			WriteDestFileLn("#define MyNSEventTypeLeftMouseDown"
				" NSLeftMouseDown");
			WriteDestFileLn("#define MyNSEventTypeLeftMouseUp"
				" NSLeftMouseUp");
			WriteDestFileLn("#define MyNSEventTypeRightMouseDown"
				" NSRightMouseDown");
			WriteDestFileLn("#define MyNSEventTypeRightMouseUp"
				" NSRightMouseUp");
			WriteDestFileLn("#define MyNSEventTypeOtherMouseDown"
				" NSOtherMouseDown");
			WriteDestFileLn("#define MyNSEventTypeOtherMouseUp"
				" NSOtherMouseUp");
			WriteDestFileLn("#define MyNSEventTypeMouseMoved"
				" NSMouseMoved");
			WriteDestFileLn("#define MyNSEventTypeLeftMouseDragged"
				" NSLeftMouseDragged");
			WriteDestFileLn("#define MyNSEventTypeRightMouseDragged"
				" NSRightMouseDragged");
			WriteDestFileLn("#define MyNSEventTypeOtherMouseDragged"
				" NSOtherMouseDragged");
			WriteDestFileLn("#define MyNSEventTypeKeyDown"
				" NSKeyDown");
			WriteDestFileLn("#define MyNSEventTypeKeyUp"
				" NSKeyUp");
			WriteDestFileLn("#define MyNSEventTypeFlagsChanged"
				" NSFlagsChanged");
			WriteDestFileLn("#define MyNSEventTypeApplicationDefined"
				" NSApplicationDefined");
			WriteDestFileLn("#define MyNSAnyEventMask"
				" NSAnyEventMask");
		}
	} else if (gbk_apifam_xwn == gbo_apifam) {
		blnr HaveAppPathLink = falseblnr;
		blnr HaveSysctlPath = (gbk_targfam_fbsd == gbo_targfam);

		switch (gbo_targfam) {
			case gbk_targfam_linx:
			case gbk_targfam_nbsd:
			case gbk_targfam_dbsd:
			case gbk_targfam_oind:
				HaveAppPathLink = trueblnr;
				break;
			default:
				break;
		}

		if (gbk_targfam_minx == gbo_targfam) {
			WriteDestFileLn(
				"/* get nanosleep and gettimeofday. ugh */");
			WriteDestFileLn("#define _POSIX_SOURCE 1");
			WriteDestFileLn("#define _POSIX_C_SOURCE 200112L");
		}
		WriteDestFileLn("#include <stdio.h>");
		WriteDestFileLn("#include <stdlib.h>");
		WriteDestFileLn("#include <string.h>");
		WriteDestFileLn("#include <time.h>");
		WriteDestFileLn("#include <sys/time.h>");
		WriteDestFileLn("#include <sys/times.h>");
		WriteDestFileLn("#include <X11/Xlib.h>");
		WriteDestFileLn("#include <X11/Xutil.h>");
		WriteDestFileLn("#include <X11/keysym.h>");
		WriteDestFileLn("#include <X11/keysymdef.h>");
		WriteDestFileLn("#include <X11/Xatom.h>");
#if 1
		WriteDestFileLn("#include <fcntl.h>");
#endif
		/* if (WantActvCode) */ {
			/* also now used for export file */
			WriteDestFileLn("#include <sys/stat.h>");
		}
#if MayUseSound
		if ((gbk_sndapi_alsa == gbo_sndapi)
			|| (gbk_sndapi_ddsp == gbo_sndapi)
			|| CurUseAllFiles)
		{
			WriteDestFileLn("#include <errno.h>");
		}
#endif
		if (HaveAppPathLink /* for readlink */
			|| WantLocalTalk
			|| CurUseAllFiles
#if MayUseSound
			|| (gbk_sndapi_ddsp == gbo_sndapi)
#endif
			) /* for write */
		{
			WriteDestFileLn("#include <unistd.h>");
		}
		if (HaveSysctlPath) {
			WriteDestFileLn("#include <sys/sysctl.h>");
		}
#if MayUseSound
		if (MySoundEnabled || CurUseAllFiles) {
			switch (gbo_sndapi) {
				case gbk_sndapi_alsa:
					WriteDestFileLn("#include <dlfcn.h>");
#if 0
					WriteDestFileLn("#include <alsa/asoundlib.h>");
#endif
					break;
				case gbk_sndapi_ddsp:
					WriteDestFileLn("#include <sys/ioctl.h>");
					if (gbk_targfam_obsd == gbo_targfam) {
						WriteDestFileLn("#include <soundcard.h>");
					} else {
						WriteDestFileLn("#include <sys/soundcard.h>");
					}
					break;
				default:
					break;
			}
		}
#endif
		if (WantLocalTalk || CurUseAllFiles) {
			WriteOSXLocalTalkCNFUIOSG();
		}

		WriteBlankLineToDestFile();
		WriteCompCondBool("CanGetAppPath",
			HaveAppPathLink || HaveSysctlPath);
		WriteCompCondBool("HaveAppPathLink", HaveAppPathLink);
		if (HaveAppPathLink) {
			WriteBgnDestFileLn();
			WriteCStrToDestFile("#define TheAppPathLink \"");
			switch (gbo_targfam) {
				case gbk_targfam_nbsd:
					WriteCStrToDestFile("/proc/curproc/exe");
					break;
				case gbk_targfam_dbsd:
					WriteCStrToDestFile("/proc/curproc/file");
					break;
				case gbk_targfam_oind:
					WriteCStrToDestFile("/proc/self/path/a.out");
					break;
				case gbk_targfam_linx:
				default:
					WriteCStrToDestFile("/proc/self/exe");
					break;
			}
			WriteCStrToDestFile("\"");
			WriteEndDestFileLn();
		}
		WriteCompCondBool("HaveSysctlPath", HaveSysctlPath);

#if MayUseSound
		if (MySoundEnabled || CurUseAllFiles) {
			if (gbk_sndapi_ddsp == gbo_sndapi) {
				WriteBgnDestFileLn();
				WriteCStrToDestFile("#define AudioDevPath \"");
				switch (gbo_targfam) {
					case gbk_targfam_nbsd:
					case gbk_targfam_obsd:
						WriteCStrToDestFile("/dev/audio");
						break;
					case gbk_targfam_fbsd:
					case gbk_targfam_dbsd:
					default:
						WriteCStrToDestFile("/dev/dsp");
						break;
				}
				WriteCStrToDestFile("\"");
				WriteEndDestFileLn();
			}
		}
#endif

	} else if (gbk_apifam_dos == gbo_apifam) {
		WriteDestFileLn("#include <stdio.h>");
		WriteDestFileLn("#include <stdlib.h>");
		WriteDestFileLn("#include <string.h>");
		WriteDestFileLn("#include <time.h>");
		WriteDestFileLn("#include <sys/time.h>");
		WriteDestFileLn("#include <sys/times.h>");
		WriteDestFileLn("#include <dpmi.h>");
		WriteDestFileLn("#include <pc.h>");
		WriteDestFileLn("#include <go32.h>");
		WriteDestFileLn("#include <sys/farptr.h>");
	} else if (gbk_apifam_nds == gbo_apifam) {
		WriteDestFileLn("#define ARM9 1");

		WriteDestFileLn("#include <nds.h>");
		WriteDestFileLn("#include <filesystem.h>");
		WriteDestFileLn("#include <fat.h>");

		WriteDestFileLn("#include <stdio.h>");
		WriteDestFileLn("#include <stdlib.h>");
		WriteDestFileLn("#include <string.h>");
		WriteDestFileLn("#include <time.h>");
		WriteDestFileLn("#include <sys/time.h>");
		WriteDestFileLn("#include <sys/times.h>");
		WriteDestFileLn("#include <fcntl.h>");
		WriteDestFileLn("#include <unistd.h>");
	} else if (gbk_apifam_gtk == gbo_apifam) {
		WriteDestFileLn("#include <gtk/gtk.h>");
		WriteDestFileLn("#include <gdk/gdkkeysyms.h>");
		WriteDestFileLn("#include <stdio.h>");
		WriteDestFileLn("#include <stdlib.h>");
		WriteDestFileLn("#include <string.h>");
		WriteDestFileLn("#include <time.h>");
		WriteDestFileLn("#include <sys/time.h>");
		WriteDestFileLn("#include <sys/times.h>");
	} else if (gbk_apifam_sdl == gbo_apifam) {
		WriteDestFileLn("#include <SDL/SDL.h>");
		WriteDestFileLn("#include <stdio.h>");
		WriteDestFileLn("#include <stdlib.h>");
		WriteDestFileLn("#include <string.h>");
	} else if (gbk_apifam_sd2 == gbo_apifam) {
		WriteDestFileLn("#include <SDL2/SDL.h>");
		WriteDestFileLn("#include <stdio.h>");
		WriteDestFileLn("#include <stdlib.h>");
		WriteDestFileLn("#include <string.h>");
	} else if (gbk_apifam_win == gbo_apifam) {
		if ((gbk_ide_mvc == cur_ide)
			&& (gbk_targfam_wnce == gbo_targfam))
		{
			WriteDestFileLn("#define WIN32 1");
			WriteDestFileLn("#define _WIN32 1");
			WriteDestFileLn("#define WINNT 1");
			WriteDestFileLn("#define UNDER_CE 1");
			WriteDestFileLn("#define __CEGCC__ 1");
			WriteDestFileLn("#define __CEGCC32__ 1");
			WriteDestFileLn("#define __MINGW32__ 1");
			WriteDestFileLn("#define __MINGW32CE__ 1");
			WriteDestFileLn("#define __COREDLL__ 1");
			WriteDestFileLn("#define UNICODE 1");
			WriteDestFileLn("#define _UNICODE 1");
			WriteDestFileLn("#define _M_ARM 1");
			WriteBlankLineToDestFile();
		}
		if (gbk_ide_mw8 == cur_ide) {
			WriteDestFileLn("#include <Win32Headers.h>");
		} else
		{
			WriteDestFileLn("#include <windows.h>");
			WriteDestFileLn("#include <time.h>");
			if (gbk_ide_lcc == cur_ide) {
				WriteDestFileLn("#include <shellapi.h>");
				WriteDestFileLn("#include <mmsystem.h>");
			}
		}
		WriteDestFileLn("#include <shlobj.h>");
		WriteDestFileLn("#include <tchar.h>");
		if (gbk_targfam_wnce == gbo_targfam) {
			WriteDestFileLn("#include <aygshell.h>");
			WriteDestFileLn("#include <commdlg.h>");
		}
		if (WantLocalTalk || CurUseAllFiles) {
			WriteDestFileLn("#include <winsock.h>");
			WriteDestFileLn("#define use_SO_REUSEPORT 0");
			WriteDestFileLn("#define use_winsock 1");
		}
		if (gbk_ide_mvc == cur_ide) {
			WriteBlankLineToDestFile();
			WriteDestFileLn("#define _tWinMain WinMain");
		}
		if (gbk_ide_plc == cur_ide) {
			WriteDestFileLn("#define _MAX_PATH MAX_PATH");
		}
	} else {
		if (gbk_ide_mw8 == cur_ide) {
			WriteDestFileLn("#include <MacHeaders.h>");
			WriteDestFileLn("#include <CursorDevices.h>");
			WriteDestFileLn("#define ShouldDefineQDGlobals 0");
		} else
		if (gbk_ide_mpw == cur_ide) {
			WriteDestFileLn("#include <MacTypes.h>");
			if (gbk_cpufam_68k != gbo_cpufam) {
				WriteDestFileLn("#include <MixedMode.h>");
			}
			WriteDestFileLn("#include <Gestalt.h>");
			WriteDestFileLn("#include <MacErrors.h>");
			WriteDestFileLn("#include <MacMemory.h>");
			WriteDestFileLn("#include <OSUtils.h>");
			WriteDestFileLn("#include <QuickdrawText.h>");
			WriteDestFileLn("#include <QuickDraw.h>");
			if (gbk_cpufam_68k == gbo_cpufam) {
				WriteDestFileLn("#include <SegLoad.h>");
			}
			WriteDestFileLn("#include <IntlResources.h>");
			WriteDestFileLn("#include <Events.h>");
			WriteDestFileLn("#include <Script.h>");
			WriteDestFileLn("#include <Files.h>");
			WriteDestFileLn("#include <Resources.h>");
			WriteDestFileLn("#include <Fonts.h>");
			WriteDestFileLn("#include <TextUtils.h>");
			WriteDestFileLn("#include <FixMath.h>");
			WriteDestFileLn("#include <ToolUtils.h>");
			WriteDestFileLn("#include <Menus.h>");
			WriteDestFileLn("#include <Scrap.h>");
			WriteDestFileLn("#include <Controls.h>");
			WriteDestFileLn("#include <ControlDefinitions.h>");
			WriteDestFileLn("#include <AppleEvents.h>");
			WriteDestFileLn("#include <Processes.h>");
			WriteDestFileLn("#include <EPPC.h>");
			WriteDestFileLn("#include <MacWindows.h>");
			WriteDestFileLn("#include <TextEdit.h>");
			WriteDestFileLn("#include <Dialogs.h>");
			WriteDestFileLn("#include <Devices.h>");
			WriteDestFileLn("#include <Palettes.h>");
			WriteDestFileLn("#include <StandardFile.h>");
			WriteDestFileLn("#include <Aliases.h>");
			WriteDestFileLn("#include <Folders.h>");
			WriteDestFileLn("#include <Balloons.h>");
			WriteDestFileLn("#include <DiskInit.h>");
			WriteDestFileLn("#include <LowMem.h>");
			WriteDestFileLn("#include <Appearance.h>");
			WriteDestFileLn("#include <Navigation.h>");
			WriteDestFileLn("#include <Sound.h>");
			WriteDestFileLn("#include <CursorDevices.h>");
			WriteDestFileLn("#include <Traps.h>");
		}
	}

	if ((gbk_ide_msv == cur_ide) && (ide_vers >= 6000)) {
		WriteBlankLineToDestFile();
		WriteDestFileLn("/* restore warnings */");
		WriteDestFileLn("#pragma warning(pop)");
	}

	WriteBlankLineToDestFile();

	if (gbk_cpufam_68k == gbo_cpufam) {
		if (gbk_ide_mpw == cur_ide) {
			WriteDestFileLn("#define ShouldUnloadDataInit 1");
			WriteDestFileLn("#define Windows85APIAvail 0");
			WriteDestFileLn("#define NeedLongGlue 1");
		}
	}

#if MayUseSound
	if (MySoundEnabled || CurUseAllFiles) {
		if (gbk_sndapi_alsa == gbo_sndapi)
		if (gbk_cpufam_arm == gbo_cpufam)
		{
			WriteDestFileLn("#define RaspbianWorkAround 1");
		}
	}
#endif

	if (gbk_targfam_wnce == gbo_targfam) {
		WriteBlankLineToDestFile();
		WriteDestFileLn("#define EnableShellLinks 0");
		WriteDestFileLn("#define EnableDragDrop 0");
		WriteDestFileLn("#define UseTimerThread 0");
	} else if (gbk_targfam_lnds == gbo_targfam || gbk_targfam_mdos == gbo_targfam) {
		WriteDestFileLn("#define EnableDragDrop 0");
	} else {
		WriteDestFileLn("#define EnableDragDrop 1");
	}

	if (HaveMacBundleApp) {
		WriteDestFileLn("#define MyAppIsBundle 1");
	}
	if ((gbk_apifam_mac == gbo_apifam)
		|| (gbk_apifam_osx == gbo_apifam))
	{
		WriteBgnDestFileLn();
		WriteCStrToDestFile("#define kMacCreatorSig ");
		WriteSingleQuoteToDestFile();
		WriteCStrToDestFile(kMacCreatorSig);
		WriteSingleQuoteToDestFile();
		WriteEndDestFileLn();
	}
}


LOCALPROC WriteCommonCNFUDOSGContents(void)
{
	WriteDestFileLn("/*");
	++DestFileIndent;
		WriteDestFileLn(
			"see comment in OSGCOMUD.h");
		WriteConfigurationWarning();
	--DestFileIndent;
	WriteDestFileLn("*/");

	WriteBlankLineToDestFile();

	if (WantUnTranslocate) {
		WriteDestFileLn("#define WantUnTranslocate 1");
	}
	if (WantIconMaster) {
		WriteDestFileLn("#define InstallFileIcons 1");
	}
}
