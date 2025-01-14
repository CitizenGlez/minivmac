/*
	BLDUTIL3.i
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
	BuiLD system UTILities part 3
*/


#define src_d_name "src"
#define cfg_d_name "cfg"

#define obj_d_name "bld"
	/* not "obj", so as to work in freebsd make */

LOCALVAR blnr HaveAltSrc;

LOCALPROC WritepDtString(void)
{
	WriteCStrToDestFile((char *)pDt);
}

LOCALPROC WriteMaintainerName(void)
{
	WriteCStrToDestFile(vMaintainerName);
}

LOCALPROC WriteHomePage(void)
{
	WriteCStrToDestFile(vHomePage);
}

/* end of default value of options */

LOCALPROC WriteVersionStr(void)
{
	WriteDec2CharToOutput(MajorVersion);
	WriteCStrToDestFile(".");
	WriteDec2CharToOutput(MinorVersion);
}

LOCALPROC WriteAppVariationStr(void)
{
	if (nullpr != vVariationName) {
		WriteCStrToDestFile(vVariationName);
	} else {
		WriteCStrToDestFile(vStrAppAbbrev);
		WriteCStrToDestFile("-");
		WriteNUimrToDestFile(MajorVersion, 2);
		WriteCStrToDestFile(".");
		WriteNUimrToDestFile(MinorVersion, 2);
		WriteCStrToDestFile("-");
		/* WriteCStrToDestFile(GetIdeName(cur_ide)); */
		WriteCStrToDestFile(GetTargetName(cur_targ));
		/* WriteCStrToDestFile(GetDbgLvlName(gbo_dbg)); */
	}
}

LOCALPROC WriteAppCopyrightYearStr(void)
{
	WriteCStrToDestFile(kStrCopyrightYear);
}

LOCALPROC WriteGetInfoString(void)
{
	WriteAppVariationStr();
	WriteCStrToDestFile(", Copyright ");
	WriteAppCopyrightYearStr();
	WriteCStrToDestFile(" maintained by ");
	WriteMaintainerName();
	WriteCStrToDestFile(".");
}

LOCALPROC WriteLProjName(void)
{
	WriteCStrToDestFile(GetLProjName(gbo_lang));
}

/* --- XML utilities --- */

LOCALPROC WriteXMLtagBegin(char *s)
{
	WriteCStrToDestFile("<");
	WriteCStrToDestFile(s);
	WriteCStrToDestFile(">");
}

LOCALPROC WriteXMLtagEnd(char *s)
{
	WriteCStrToDestFile("</");
	WriteCStrToDestFile(s);
	WriteCStrToDestFile(">");
}

LOCALPROC WriteBeginXMLtagLine(char *s)
{
	WriteBgnDestFileLn();
	WriteXMLtagBegin(s);
	WriteEndDestFileLn();
	++DestFileIndent;
}

LOCALPROC WriteEndXMLtagLine(char *s)
{
	--DestFileIndent;
	WriteBgnDestFileLn();
	WriteXMLtagEnd(s);
	WriteEndDestFileLn();
}

LOCALPROC WriteXMLtagBeginValEndLine(char *t, char *v)
{
	WriteBgnDestFileLn();
	WriteXMLtagBegin(t);
	WriteCStrToDestFile(v);
	WriteXMLtagEnd(t);
	WriteEndDestFileLn();
}

LOCALPROC WriteXMLtagBeginProcValEndLine(char *t, MyProc v)
{
	WriteBgnDestFileLn();
	WriteXMLtagBegin(t);
	v();
	WriteXMLtagEnd(t);
	WriteEndDestFileLn();
}

LOCALPROC WriteXMLtaggedLines(char *s, MyProc p)
{
	WriteBeginXMLtagLine(s);
		if (NULL != p) {
			p();
		}
	WriteEndXMLtagLine(s);
}

LOCALPROC WriteXMLtaglinewithprops(char *s, MyProc p)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("<");
	WriteCStrToDestFile(s);
	WriteEndDestFileLn();
	++DestFileIndent;
		if (NULL != p) {
			p();
		}
	--DestFileIndent;
	WriteDestFileLn("/>");
}

LOCALPROC WriteXMLtaggedLinesWithProps(char *s, MyProc pp, MyProc p)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("<");
	WriteCStrToDestFile(s);
	WriteEndDestFileLn();
	++DestFileIndent;
		if (NULL != pp) {
			pp();
		}
		WriteDestFileLn(">");
		if (NULL != p) {
			p();
		}
	WriteEndXMLtagLine(s);
}

LOCALPROC WriteXMLtaggedLinesWith1LnProps(char *s, MyProc pp, MyProc p)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("<");
	WriteCStrToDestFile(s);
	if (NULL != pp) {
		pp();
	}
	WriteCStrToDestFile(">");
	WriteEndDestFileLn();
	++DestFileIndent;
		if (NULL != p) {
			p();
		}
	WriteEndXMLtagLine(s);
}

/* --- end XML utilities --- */

/* --- c preprocessor utilities --- */

LOCALPROC WriteCompCondBool(char *s, blnr v)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("#define ");
	WriteCStrToDestFile(s);
	if (v) {
		WriteCStrToDestFile(" 1");
	} else {
		WriteCStrToDestFile(" 0");
	}
	WriteEndDestFileLn();
}

LOCALPROC WriteDefineUimr(char *s, uimr v)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("#define ");
	WriteCStrToDestFile(s);
	WriteSpaceToDestFile();
	WriteUnsignedToOutput(v);
	WriteEndDestFileLn();
}

LOCALPROC WriteCDefQuote(char *s, MyProc p)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("#define ");
	WriteCStrToDestFile(s);
	WriteSpaceToDestFile();
	WriteQuoteToDestFile();
	p();
	WriteQuoteToDestFile();
	WriteEndDestFileLn();
}

LOCALPROC WriteWrongCNFUIALL(void)
{
	WriteDestFileLn("#error \"wrong CNFUIALL.h\"");
}

LOCALPROC WriteCheckPreDef(char *s)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("#ifndef ");
	WriteCStrToDestFile(s);
	WriteEndDestFileLn();
	WriteWrongCNFUIALL();
	WriteDestFileLn("#endif");
}

LOCALPROC WriteCheckPreNDef(char *s)
{
	WriteBgnDestFileLn();
	WriteCStrToDestFile("#ifdef ");
	WriteCStrToDestFile(s);
	WriteEndDestFileLn();
	WriteWrongCNFUIALL();
	WriteDestFileLn("#endif");
}

/* --- end c preprocessor utilities --- */

LOCALPROC WritePathInDirToDestFile0(MyProc p, MyProc ps,
	blnr isdir)
{
	switch (cur_ide) {
		case gbk_ide_mpw:
		case gbk_ide_mw8:
			if (p != NULL) {
				p();
			} else {
				WriteCStrToDestFile(":");
			}
			ps();
			if (isdir) {
				WriteCStrToDestFile(":");
			}
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_xcd:
		case gbk_ide_snc:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			if (p != NULL) {
				p();
			}
			ps();
			if (isdir) {
				WriteCStrToDestFile("/");
			}
			break;
		case gbk_ide_msv:
		case gbk_ide_lcc:
		case gbk_ide_dmc:
		case gbk_ide_plc:
			if (p != NULL) {
				p();
				WriteBackSlashToDestFile();
			} else {
				if (gbk_ide_lcc == cur_ide) {
					if (! UseCmndLine) {
						WriteCStrToDestFile("c:\\output\\");
					}
				} else if ((gbk_ide_msv == cur_ide)
					&& (ide_vers >= 7100)
					&& (ide_vers < 10000))
				{
					WriteCStrToDestFile(".\\");
				}
			}
			ps();
			break;
		case gbk_ide_mgw:
			if (p != NULL) {
				p();
				WriteCStrToDestFile("/");
			}
			ps();
			break;
		case gbk_ide_dvc:
			if (p != NULL) {
				p();
				if (UseCmndLine) {
					WriteCStrToDestFile("/");
				} else {
					WriteBackSlashToDestFile();
				}
			}
			ps();
			break;
	}
}

LOCALPROC WriteFileInDirToDestFile0(MyProc p, MyProc ps)
{
	WritePathInDirToDestFile0(p, ps, falseblnr);
}

LOCALPROC WriteSubDirToDestFile(MyProc p, MyProc ps)
{
	WritePathInDirToDestFile0(p, ps, trueblnr);
}

LOCALPROC Write_toplevel_f_ToDestFile(MyProc ps)
{
	WritePathInDirToDestFile0(NULL, ps, falseblnr);
}

LOCALPROC Write_toplevel_d_ToDestFile(MyProc ps)
{
	WritePathInDirToDestFile0(NULL, ps, trueblnr);
}

LOCALPROC Write_src_d_Name(void)
{
	WriteCStrToDestFile(src_d_name);
}

LOCALPROC Write_src_d_ToDestFile(void)
{
	Write_toplevel_d_ToDestFile(Write_src_d_Name);
}

LOCALPROC Write_cfg_d_Name(void)
{
	WriteCStrToDestFile(cfg_d_name);
}

LOCALPROC Write_cfg_d_ToDestFile(void)
{
	Write_toplevel_d_ToDestFile(Write_cfg_d_Name);
}

LOCALPROC Write_obj_d_Name(void)
{
	WriteCStrToDestFile(obj_d_name);
}

LOCALPROC Write_obj_d_ToDestFile(void)
{
	Write_toplevel_d_ToDestFile(Write_obj_d_Name);
}

LOCALPROC WriteLProjFolderName(void)
{
	WriteLProjName();
	WriteCStrToDestFile(".lproj");
}

LOCALPROC WriteLProjFolderPath(void)
{
	WriteSubDirToDestFile(Write_cfg_d_ToDestFile,
		WriteLProjFolderName);
}

LOCALPROC WriteStrAppAbbrev(void)
{
	WriteCStrToDestFile(vStrAppAbbrev);
}

LOCALPROC WriteAppNameStr(void)
{
	WriteStrAppAbbrev();
	switch (gbo_targfam) {
		case gbk_targfam_mach:
		case gbk_targfam_carb:
			if (HaveMacBundleApp) {
				WriteCStrToDestFile(".app");
			}
			break;
		case gbk_targfam_mswn:
		case gbk_targfam_wnce:
		case gbk_targfam_cygw:
			WriteCStrToDestFile(".exe");
			break;
		case gbk_targfam_lnds:
			WriteCStrToDestFile(".nds");
			break;
		default:
			break;
	}
}

LOCALPROC WriteAppNamePath(void)
{
	if (HaveMacBundleApp) {
		Write_toplevel_d_ToDestFile(WriteAppNameStr);
	} else {
		Write_toplevel_f_ToDestFile(WriteAppNameStr);
	}
}

LOCALPROC WriteStrAppUnabrevName(void)
{
	WriteCStrToDestFile(kStrAppName);
}

LOCALPROC Write_contents_d_Name(void)
{
	WriteCStrToDestFile("Contents");
}

LOCALPROC Write_machocontents_d_ToDestFile(void)
{
	WriteSubDirToDestFile(WriteAppNamePath,
		Write_contents_d_Name);
}

LOCALPROC Write_macos_d_Name(void)
{
	WriteCStrToDestFile("MacOS");
}

LOCALPROC Write_machomac_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_machocontents_d_ToDestFile,
		Write_macos_d_Name);
}

LOCALPROC Write_resources_d_Name(void)
{
	WriteCStrToDestFile("Resources");
}

LOCALPROC Write_machores_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_machocontents_d_ToDestFile,
		Write_resources_d_Name);
}

LOCALPROC WriteBinElfObjName(void)
{
	WriteStrAppAbbrev();
	WriteCStrToDestFile(".elf");
}

LOCALPROC WriteBinElfObjObjPath(void)
{
	WriteFileInDirToDestFile0(Write_obj_d_ToDestFile,
		WriteBinElfObjName);
}

LOCALPROC WriteBinArmObjName(void)
{
	WriteStrAppAbbrev();
	WriteCStrToDestFile(".arm9");
}

LOCALPROC WriteBinArmObjObjPath(void)
{
	WriteFileInDirToDestFile0(Write_obj_d_ToDestFile,
		WriteBinArmObjName);
}

LOCALPROC Write_machobinpath_ToDestFile(void)
{
	if (HaveMacBundleApp) {
		WriteFileInDirToDestFile0(Write_machomac_d_ToDestFile,
			WriteStrAppAbbrev);
	} else {
		WriteAppNamePath();
	}
}

LOCALPROC Write_tmachobun_d_Name(void)
{
	WriteCStrToDestFile("AppTemp");
}

LOCALPROC Write_tmachobun_d_ToDestFile(void)
{
	Write_toplevel_d_ToDestFile(Write_tmachobun_d_Name);
}

LOCALPROC Write_tmachocontents_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_tmachobun_d_ToDestFile,
		Write_contents_d_Name);
}

LOCALPROC Write_tmachomac_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_tmachocontents_d_ToDestFile,
		Write_macos_d_Name);
}

LOCALPROC Write_tmachores_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_tmachocontents_d_ToDestFile,
		Write_resources_d_Name);
}

LOCALPROC Write_tmacholang_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_tmachores_d_ToDestFile,
		WriteLProjFolderName);
}

LOCALPROC Write_tmachobinpath_ToDestFile(void)
{
	WriteFileInDirToDestFile0(Write_tmachomac_d_ToDestFile,
		WriteStrAppAbbrev);
}

LOCALPROC Write_umachobun_d_Name(void)
{
	WriteStrAppAbbrev();
	WriteCStrToDestFile("_u.app");
}

LOCALPROC Write_umachobun_d_ToDestFile(void)
{
	Write_toplevel_d_ToDestFile(Write_umachobun_d_Name);
}

LOCALPROC Write_umachocontents_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_umachobun_d_ToDestFile,
		Write_contents_d_Name);
}

LOCALPROC Write_umachomac_d_ToDestFile(void)
{
	WriteSubDirToDestFile(Write_umachocontents_d_ToDestFile,
		Write_macos_d_Name);
}

LOCALPROC Write_umachobinpath_ToDestFile(void)
{
	WriteFileInDirToDestFile0(Write_umachomac_d_ToDestFile,
		WriteStrAppAbbrev);
}

LOCALPROC WriteInfoPlistFileName(void)
{
	WriteCStrToDestFile("Info.plist");
}

LOCALPROC WriteInfoPlistFilePath(void)
{
	WriteFileInDirToDestFile0(Write_cfg_d_ToDestFile,
		WriteInfoPlistFileName);
}

LOCALPROC WriteDummyLangFileName(void)
{
	WriteCStrToDestFile("dummy.txt");
}

LOCALPROC Write_tmachoLangDummyPath(void)
{
	WriteFileInDirToDestFile0(Write_tmacholang_d_ToDestFile,
		WriteDummyLangFileName);
}

LOCALPROC Write_tmachoLangDummyContents(void)
{
	WriteCStrToDestFile("dummy");
}

LOCALPROC Write_tmachoPkgInfoName(void)
{
	WriteCStrToDestFile("PkgInfo");
}

LOCALPROC Write_tmachoPkgInfoPath(void)
{
	WriteFileInDirToDestFile0(Write_tmachocontents_d_ToDestFile,
		Write_tmachoPkgInfoName);
}

LOCALPROC Write_MacCreatorSigOrGeneric(void)
{
	if (WantIconMaster) {
		WriteCStrToDestFile(kMacCreatorSig);
	} else {
		WriteCStrToDestFile("????");
	}
}

LOCALPROC Write_tmachoPkgInfoContents(void)
{
	WriteCStrToDestFile("APPL");
	Write_MacCreatorSigOrGeneric();
}

LOCALPROC Write_machoRsrcName(void)
{
	WriteStrAppAbbrev();
	WriteCStrToDestFile(".rsrc");
}

LOCALPROC Write_machoRsrcPath(void)
{
	WriteFileInDirToDestFile0(Write_machores_d_ToDestFile,
		Write_machoRsrcName);
}

LOCALPROC Write_AppIconName(void)
{
	WriteCStrToDestFile("ICONAPPO.icns");
}

LOCALPROC Write_machoAppIconPath(void)
{
	WriteFileInDirToDestFile0(Write_machores_d_ToDestFile,
		Write_AppIconName);
}

LOCALPROC Write_srcAppIconPath(void)
{
	WriteFileInDirToDestFile0(Write_src_d_ToDestFile,
		Write_AppIconName);
}

LOCALPROC WriteMainRsrcName(void)
{
	switch (cur_ide) {
		case gbk_ide_msv:
		case gbk_ide_dvc:
		case gbk_ide_cyg:
		case gbk_ide_mgw:
		case gbk_ide_lcc:
		case gbk_ide_dmc:
		case gbk_ide_dkp:
		case gbk_ide_plc:
			WriteCStrToDestFile("main.rc");
			break;
		case gbk_ide_mvc:
			switch (gbo_targfam) {
				case gbk_targfam_mswn:
				case gbk_targfam_wnce:
					WriteCStrToDestFile("main.rc");
					break;
				default:
					WriteCStrToDestFile("main.r");
					break;
			}
			break;
		default:
			WriteCStrToDestFile("main.r");
			break;
	}
}

LOCALPROC Write_Rsrc_d_ToDestFile(void)
{
	if ((gbk_targfam_mswn == gbo_targfam)
		|| (gbk_targfam_wnce == gbo_targfam))
	{
		Write_cfg_d_ToDestFile();
	} else
	{
		Write_src_d_ToDestFile();
	}
}

LOCALPROC WriteMainRsrcSrcPath(void)
{
	WriteFileInDirToDestFile0(Write_Rsrc_d_ToDestFile,
		WriteMainRsrcName);
}

LOCALPROC WriteMainRsrcObjName(void)
{
	switch (cur_ide) {
		case gbk_ide_msv:
		case gbk_ide_lcc:
		case gbk_ide_dvc:
		case gbk_ide_cyg:
		case gbk_ide_mgw:
		case gbk_ide_mvc:
		case gbk_ide_dmc:
		case gbk_ide_dkp:
		case gbk_ide_plc:
			WriteCStrToDestFile("main.res");
			break;
		case gbk_ide_mpw:
			WriteCStrToDestFile("main.rsrc");
			break;
	}
}

LOCALPROC WriteMainRsrcObjPath(void)
{
	WriteFileInDirToDestFile0(Write_obj_d_ToDestFile,
		WriteMainRsrcObjName);
}

LOCALPROC WriteCNFUIOSGName(void)
{
	WriteCStrToDestFile("CNFUIOSG.h");
}

LOCALPROC WriteCNFUIOSGPath(void)
{
	WriteFileInDirToDestFile0(Write_cfg_d_ToDestFile,
		WriteCNFUIOSGName);
}

LOCALPROC WriteCNFUIALLName(void)
{
	WriteCStrToDestFile("CNFUIALL.h");
}

LOCALPROC WriteCNFUIALLPath(void)
{
	WriteFileInDirToDestFile0(Write_cfg_d_ToDestFile,
		WriteCNFUIALLName);
}

LOCALPROC WritePathArgInMakeCmnd(MyProc p)
{
	switch (cur_ide) {
		case gbk_ide_mpw:
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_msv:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteSpaceToDestFile();
			WriteQuoteToDestFile();
			p();
			WriteQuoteToDestFile();
			break;
		case gbk_ide_lcc:
			/* saw some glitches with quotes */
		case gbk_ide_dmc:
		case gbk_ide_plc:
		case gbk_ide_dvc:
		case gbk_ide_mgw:
			WriteSpaceToDestFile();
			p();
			break;
		default:
			break;
	}
}

LOCALPROC WriteMakeVar(char *s)
{
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteCStrToDestFile("{");
			WriteCStrToDestFile(s);
			WriteCStrToDestFile("}");
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_msv:
		case gbk_ide_lcc:
		case gbk_ide_dvc:
		case gbk_ide_mgw:
		case gbk_ide_dmc:
		case gbk_ide_plc:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteCStrToDestFile("$(");
			WriteCStrToDestFile(s);
			WriteCStrToDestFile(")");
			break;
		default:
			break;
	}
}

LOCALPROC WriteMakeDependFile(MyProc p)
{
	switch (cur_ide) {
		case gbk_ide_msv:
		case gbk_ide_mpw:
			WriteSpaceToDestFile();
			WriteQuoteToDestFile();
			p();
			WriteQuoteToDestFile();
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_lcc:
		case gbk_ide_dvc:
		case gbk_ide_mgw:
		case gbk_ide_dmc:
		case gbk_ide_plc:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteSpaceToDestFile();
			p();
			break;
		default:
			break;
	}
}

LOCALPROC WriteMainRsrcObjMSCdeps(void)
{
	WriteMakeDependFile(WriteMainRsrcSrcPath);
}

LOCALPROC WriteMakeRule(MyProc ptarg,
	MyProc pdeps, MyProc pbody)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteQuoteToDestFile();
			ptarg();
			WriteQuoteToDestFile();
			WriteCStrToDestFile(" \304");
			pdeps();
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_ccc:
			ptarg();
			WriteCStrToDestFile(" :");
			pdeps();
			break;
		case gbk_ide_msv:
			WriteQuoteToDestFile();
			ptarg();
			WriteQuoteToDestFile();
			WriteCStrToDestFile(" :");
			pdeps();
			break;
		case gbk_ide_lcc:
		case gbk_ide_dvc:
		case gbk_ide_mgw:
		case gbk_ide_dmc:
		case gbk_ide_plc:
		case gbk_ide_dkp:
			ptarg();
			WriteCStrToDestFile(":");
			pdeps();
			break;
		default:
			break;
	}
	WriteEndDestFileLn();
	++DestFileIndent;
		pbody();
	--DestFileIndent;
}

LOCALPROC WriteMkDir(MyProc p)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteCStrToDestFile("NewFolder");
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_ccc:
		case gbk_ide_dkp:
			WriteCStrToDestFile("mkdir");
			break;
		default:
			break;
	}
	WritePathArgInMakeCmnd(p);
	WriteEndDestFileLn();
}

LOCALPROC WriteRmDir(MyProc p)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteCStrToDestFile("Delete -i -y");
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_ccc:
		case gbk_ide_dkp:
			WriteCStrToDestFile("rm -fr");
			break;
		default:
			break;
	}
	WritePathArgInMakeCmnd(p);
	WriteEndDestFileLn();
}

LOCALPROC WriteRmFile(MyProc p)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteCStrToDestFile("Delete -i");
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_dvc:
		case gbk_ide_mgw:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteCStrToDestFile("rm -f");
			break;
		case gbk_ide_msv:
			WriteCStrToDestFile("-@erase");
			break;
		case gbk_ide_lcc:
		case gbk_ide_dmc:
		case gbk_ide_plc:
			WriteCStrToDestFile("del");
			break;
		default:
			break;
	}
	WritePathArgInMakeCmnd(p);
	WriteEndDestFileLn();
}

LOCALPROC WriteCopyFile(MyProc pfrom, MyProc pto)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteCStrToDestFile("Duplicate");
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteCStrToDestFile("cp");
			break;
		default:
			break;
	}
	WritePathArgInMakeCmnd(pfrom);
	WritePathArgInMakeCmnd(pto);
	WriteEndDestFileLn();
}

LOCALPROC WriteMoveDir(MyProc pfrom, MyProc pto)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteCStrToDestFile("Move");
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_xcd:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteCStrToDestFile("mv");
			break;
		default:
			break;
	}
	WritePathArgInMakeCmnd(pfrom);
	WritePathArgInMakeCmnd(pto);
	WriteEndDestFileLn();
}

LOCALPROC WriteEchoToNewFile(MyProc ptext, MyProc pto, blnr newline)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
			WriteCStrToDestFile("Echo");
			if (! newline) {
				WriteCStrToDestFile(" -n");
			}
			WriteCStrToDestFile(" \"");
			ptext();
			WriteCStrToDestFile("\" >");
			WritePathArgInMakeCmnd(pto);
			break;
		case gbk_ide_cyg:
		case gbk_ide_snc:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteCStrToDestFile("echo");
			if (! newline) {
				WriteCStrToDestFile(" -n");
			}
			WriteCStrToDestFile(" \"");
			ptext();
			WriteCStrToDestFile("\" >");
			WritePathArgInMakeCmnd(pto);
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_xcd:
			WriteCStrToDestFile("printf \"");
			ptext();
			if (newline) {
				WriteCStrToDestFile("\\n");
			}
			WriteCStrToDestFile("\" >");
			WritePathArgInMakeCmnd(pto);
			break;
		default:
			break;
	}
	WriteEndDestFileLn();
}

LOCALPROC WriteCompileCExec(void)
{
	switch (cur_ide) {
		case gbk_ide_mpw:
			if (gbk_cpufam_68k == gbo_cpufam) {
				WriteCStrToDestFile("SC");
			} else if (gbk_cpufam_ppc == gbo_cpufam) {
				WriteCStrToDestFile("MrC");
			}
			break;
		case gbk_ide_bgc:
		case gbk_ide_mvc:
		case gbk_ide_cyg:
                        if (gbk_targfam_mdos  == gbo_targfam) {
				WriteCStrToDestFile("i586-pc-msdosdjgpp-gcc");
                        } else {
				WriteCStrToDestFile("gcc");
                        }
			break;
		case gbk_ide_xcd:
			if (ide_vers >= 12100) {
				WriteCStrToDestFile("clang");
			} else {
				WriteCStrToDestFile("gcc");
			}
			break;
		case gbk_ide_snc:
		case gbk_ide_ccc:
			WriteCStrToDestFile("cc");
			break;
		case gbk_ide_msv:
			if (gbk_cpufam_arm == gbo_cpufam) {
				WriteCStrToDestFile("clarm.exe");
			} else {
				WriteCStrToDestFile("cl.exe");
			}
			break;
		case gbk_ide_lcc:
			WriteCStrToDestFile("lcc.exe");
			break;
		case gbk_ide_dvc:
		case gbk_ide_mgw:
			WriteCStrToDestFile("gcc.exe");
			break;
		case gbk_ide_dkp:
			WriteCStrToDestFile("$(DEVKITARM)/bin/arm-eabi-gcc.exe");
			break;
		case gbk_ide_dmc:
			WriteCStrToDestFile("dmc.exe");
			break;
		case gbk_ide_plc:
			WriteCStrToDestFile("pocc.exe");
			break;
		default:
			break;
	}
}

LOCALPROC WriteCompileC(MyProc psrc, MyProc pobj,
	blnr UseAPI, blnr Fast)
{
	WriteBgnDestFileLn();
	switch (cur_ide) {
		case gbk_ide_mpw:
		case gbk_ide_bgc:
		case gbk_ide_cyg:
		case gbk_ide_xcd:
		case gbk_ide_snc:
		case gbk_ide_dvc:
		case gbk_ide_mgw:
		case gbk_ide_dkp:
		case gbk_ide_ccc:
			WriteCompileCExec();
			WritePathArgInMakeCmnd(psrc);
			WriteCStrToDestFile(" -o");
			WritePathArgInMakeCmnd(pobj);
			WriteSpaceToDestFile();
			if (! UseAPI) {
				if (Fast
					&& (CurOfficialBin)
					&& (gbk_ide_xcd == cur_ide)
					&& (gbk_cpufam_a64 == gbo_cpufam))
				{
					WriteMakeVar("mk_COptionsFast");
				} else {
					WriteMakeVar("mk_COptions");
				}
			} else {
				if (gbk_ide_xcd == cur_ide)
				{
					WriteMakeVar("mk_COptionsOSGLU");
				} else {
					WriteMakeVar("mk_COptions");
				}
				if (gbk_apifam_xwn == gbo_apifam) {
#if 0
					if (gbk_targfam_fbsd == gbo_targfam) {
						WriteCStrToDestFile(" -I/usr/local/include");
						/*
							this is location in latest PC-BSD,
							but in old PC-BSD need
								/usr/X11R6/include/
							and in latest PC-BSD
								/usr/X11R6/ links to /usr/local/
							so just use old location.
						*/
					}
#endif
					if ((gbk_ide_xcd == cur_ide)
						|| (gbk_targfam_fbsd == gbo_targfam)
						|| (gbk_targfam_obsd == gbo_targfam)
						|| (gbk_targfam_oind == gbo_targfam))
					{
						WriteCStrToDestFile(" -I/usr/X11R6/include/");
					} else if (gbk_targfam_nbsd == gbo_targfam) {
						WriteCStrToDestFile(" -I/usr/X11R7/include/");
					} else if (gbk_targfam_dbsd == gbo_targfam) {
						WriteCStrToDestFile(" -I/usr/pkg/include/");
					} else if (gbk_targfam_minx == gbo_targfam) {
						WriteCStrToDestFile(
							" -I/usr/pkg/X11R6/include/");
					}
				} else if (gbk_apifam_sdl == gbo_apifam) {
					if (gbk_targfam_mach == gbo_targfam) {
						WriteCStrToDestFile(" -I/usr/local/include/"
							" -D_GNU_SOURCE=1 -D_THREAD_SAFE");
					}
				} else if (gbk_apifam_sd2 == gbo_apifam) {
					if (gbk_targfam_mach == gbo_targfam) {
						WriteCStrToDestFile(
							" -D_GNU_SOURCE=1 -D_THREAD_SAFE");
					}
				} else if (gbk_apifam_nds == gbo_apifam) {
					WriteCStrToDestFile(
						" -I$(DEVKITPRO)/libnds/include");
				} else if (gbk_apifam_gtk == gbo_apifam) {
					WriteCStrToDestFile(
						" `pkg-config --cflags gtk+-2.0`");
				}
			}
			break;
		case gbk_ide_msv:
			WriteCompileCExec();
			WritePathArgInMakeCmnd(psrc);
			WriteSpaceToDestFile();
			WriteMakeVar("mk_COptions");
			break;
		case gbk_ide_lcc:
			WriteCompileCExec();
			WritePathArgInMakeCmnd(psrc);
			WriteCStrToDestFile(" -Fo");
			pobj();
			WriteSpaceToDestFile();
			WriteMakeVar("mk_COptions");
			break;
		case gbk_ide_dmc:
			WriteCompileCExec();
			WritePathArgInMakeCmnd(psrc);
			WriteCStrToDestFile(" -o");
			pobj();
			WriteSpaceToDestFile();
			WriteMakeVar("mk_COptions");
			break;
		case gbk_ide_plc:
			WriteCompileCExec();
			WritePathArgInMakeCmnd(psrc);
			WriteCStrToDestFile(" -Fo");
			WriteQuoteToDestFile();
			pobj();
			WriteQuoteToDestFile();
			WriteSpaceToDestFile();
			WriteMakeVar("mk_COptions");
			break;
		default:
			break;
	}
	WriteEndDestFileLn();
}