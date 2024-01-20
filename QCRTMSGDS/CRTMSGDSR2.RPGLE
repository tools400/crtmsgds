**free
// ===================================================================
//
//  Kurzdokumentation :
//
//  Bereich . . . : CRTMSGDS
//  Objekt  . . . : CRTMSGDSR2
//  Beschreibung  : Create Message Data Structure
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>
//  Datum . . . . : ?
//
//=====================================================================
//
//  This software is free software, you can redistribute it and/or
//  modify it under the terms of the GNU General Public License (GPL)
//  as published by the Free Software Foundation.
//
//  See GNU General Public License for details.
//          http://www.opensource.org
//          http://www.opensource.org/licenses/gpl-license.html
//
//=====================================================================
//  History:
//
//  Datum       Name          Änderung
//  ----------  ------------  ---------------------------------------
//  07.09.2001  Th.Raddatz    Fixed a bug when field length is *ZEROS.
//
//  10.01.2003  Th.Raddatz    Removed special character Ä from source.
//
//  08.03.2005  Th.Raddatz    Fixed problem that trailing blanks of
//                            message help text were dropped.
//
//  21.06.2005  Th.Raddatz    Renamed XMSGT to XMBRT to avoid
//                            confusion.
//                            Increment cL within RPLHPN to fix bug
//                            that message text was truncated.
//
//  18.04.2008  Th.Raddatz    Datenstruktur MS0300 von 1024 auf 8192
//                            Byte vergrößert.
//
//  26.01.2009  Th.Raddatz    Code des generierten CLP Programms
//                            geändert. Bibliothek kann jetzt als
//                            optionaler Parameter übergeben werden.
//                            Befehlsparameter TYPE um Auswahl
//                            *CLLE erweitert.
//
//  06.10.2009  Th.Raddatz    Replaced special character '#' by
//                            '_SIZE' when generating RPGLE copy
//                            books.
//
//  09.01.2011  Th.Raddatz    Fixed problem that the field length of
//                            a sub field of a generated data structure
//                            was restricted to 3 bytes.
//
//  04.04.2014  D.Storch      Support of *BIN-Fields  8-Bytes long.
//                            Generating I-Fields instead of B-Fields
//                            in ILE-RPG.
//
//  30.03.2016  Th.Raddatz    Changed to create the message file and
//                            to add a STRPREPRC header for type *CLP
//                            and *CLLE.
//
//  22.12.2016  Th.Raddatz    Fixed problem, that the CRTMSGF command
//                            was not properly produced for 50-char
//                            descriptions.
//
//  30.10.2017  Th.Raddatz    Removed illegal semicolon from the
//                            'CRTMSGF' command, when generating a
//                            'CLP' or 'CLLE' source.
//
//  30.10.2017  Th.Raddatz    Changed generated STRPREPRC header to
//                            let STRPREPRC change the object
//                            description of a 'compiled' message file.
//
//  24.12.2018  Th.Raddatz    Converted source code to /free.
//
//  29.08.2019  Th.Raddatz    Fixed RNX0100 (Length or start position
//                            is out of range) in doubleHyphens().
//
//  25.11.2019  Th.Raddatz    Fixed problem that splittLine did not
//                            work properly, when the buffer length
//                            WAS LINE_LENGTH + 1.
//
//  17.01.2021  Th.Raddatz    Added support for /free message data
//                            structures.
//
//  02.02.2022  Th.Raddatz    Converted source code to /free.
//
//  02.02.2022  Th.Raddatz    Removed empty lines from generated
//                            data structures.
//
//  20.01.2024  Th.Raddatz    Added data type *UBIN.
//
// ===================================================================
// >>PRE-COMPILER<<
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +
//                           SRCFILE(&SL/&SF) SRCMBR(&SM);
//   >>IMPORTANT<<
//     >>PARM<< DBGVIEW(*LIST);
//     >>PARM<< TRUNCNBR(*NO);
//     >>PARM<< OPTION(*EVENTF);
//   >>END-IMPORTANT<<
//   >>EXECUTE<<
// >>END-PRE-COMPILER<<
// ===================================================================
//
//  Attention: If you have applied one of the PTFs listed
//             below or if you are running V4R3 or above
//             you should set constant OFS to 1.
//             Otherwise you should set OFS to 0.
//
//             V3R1M0 - SF51811
//             V3R2M0 - SF51812
//             V3R6M0 - SF51813
//             V3R7M0 - SF51814
//             V4R1M0 - SF51815
//             V4R2M0 - SF51817
//
// ===================================================================
ctl-opt nomain;
/COPY QCRTMSGDS,H_SPEC
/COPY QCRTMSGDS,COPYRIGHT
// ===================================================================
dcl-f SRC disk(256) usage(*output) usropn  infds(fileinfo);

dcl-ds fileInfo qualified;
  name char(10) pos(83);
  library char(10);
  member char(10) pos(129);
end-ds;

//  Record format of file SRC
dcl-ds FSRC qualified;
  SRCSEQ zoned(6: 2) inz(0) pos(1);
  SRCDAT zoned(6) inz(0) pos(7);
  SRCDTA char(244) inz pos(13);
end-ds;

dcl-s ORD char(1) dim(35) ctdata perrcd(35); // Num.f.Feldn.
dcl-s RPG char(80) dim(15) ctdata perrcd(1); // Sourcezeilen
dcl-s IRPG char(80) dim(15) ctdata perrcd(1); // Sourcezeilen
dcl-s FREE char(80) dim(12) ctdata perrcd(1); // Sourcezeilen
dcl-s CLP char(80) dim(33) ctdata perrcd(1); // Sourcezeilen
dcl-s C char(80) dim(10) ctdata perrcd(1); // Sourcezeilen
dcl-s STRPREPRC char(80) dim(11) ctdata perrcd(1); // Sourcezeilen

dcl-s srcLine_t like(fsrc.srcdta);

//  Qualified object name
dcl-ds qObj_t qualified based(pdummy);
  name char(10);
  lib char(10);
end-ds;

dcl-c GENTYPE_FREE '*FREE';
dcl-c GENTYPE_ILERPG '*ILERPG';
dcl-c GENTYPE_RPG '*RPG';
dcl-c GENTYPE_C '*C';
dcl-c GENTYPE_CLP '*CLP';
dcl-c GENTYPE_CLLE '*CLLE';
dcl-c GENTYPE_SCRIPT '*SCRIPT';

dcl-c INDENT_1 16;
dcl-c INDENT_2 20;

dcl-c FALSE *off;
dcl-c TRUE *on;

dcl-s isBinaryFieldWarning ind;

dcl-c C_DELIM ';';
dcl-c MSGID '%%MSGID';
dcl-c MSGTXT '%%MSGTXT';
dcl-c MSGF '%%MSGF';
dcl-c MSGL '%%MSGL';
dcl-c PGM '%%PGM';
dcl-c VARTYPE '%%VARTYPE';
dcl-c VARNAME '%%VARNAME';
dcl-c DELIMITER '%%DELIMITER';
dcl-c STRUCTNAME '%%STRUCTNAME';
dcl-c DS_NAME '%%DS';
dcl-c INIT_VALUE '%%IV';
dcl-c FIELD_NAME '%%FLDNME';
dcl-c FROM '%%FR';
dcl-c TO '%%TO';
dcl-c LENGTH '%%LN';
dcl-c TYPE '%%TYPE';

//  Offset for SUBST
//  ... PTF applied or version V4R3 and above
dcl-c PTF_OFFSET 1;

// Exported Procedures
dcl-pr getPrdLib char(10) extproc(*DCLCASE);
end-pr;

dcl-pr sndMsgToCmdLine;
  i_msgId   char(7) const;
  i_msgDta  char(512) options(*nopass) const;
end-pr;

/DEFINE SDS_EXTENDED
/COPY QCRTMSGDS,SDS

//***************************************************************
//  Main procedure
//***************************************************************
dcl-proc CRTMSGDSR2 export;
  dcl-pi *n;
    gi_msgFLib char(10) const; // Msg-Lib
    gi_msgF char(10) const; // Msg-File
    gi_msgFText char(50) const; // Msg-File-Text
    gi_msgId char(7) const; // Msg-ID
    gi_copyFLib char(10) const; // Cpy-Lib
    gi_copyF char(10) const; // Cpy-File
    gi_genType char(10) const; // Gener.Art
    gi_isDefine ind const; // Define-Best.
    gi_isCrtMsgF ind const; // CrtMsgF-Befehl
    gi_isFirstId ind const; // 1. Msg-ID
    gi_isLastId ind const; // Letzte Msg-ID
    go_mbrText char(80); // MbrText
    go_excId char(7); // Error-ID
    go_excDta char(80); // Error-Data
  end-pi;

  dcl-s srcLine like(srcline_t);

  //  Retrieve Message (QMHRTVM) API
  dcl-pr QMHRTVM extpgm('QMHRTVM');
    *n char(65535) options(*varsize); // o_msgInf
    *n int(10) const; // i_msgInfLen
    *n char(8) const; // i_format
    *n char(7) const; // i_msgID
    *n const  likeds(qobj_t); // i_qMsgF
    *n char(65535) const  options(*varsize ); // i_rplData
    *n int(10) const; // i_rpldataLen
    *n char(10) const; // i_rplVars
    *n char(10) const; // i_rtnCtrlChrs
    *n char(65535) options(*varsize ); // io_ErrCode
    *n char(10) const  options(*nopass  ); // i_rtvOpt  | OptGrp 1
    *n int(10) const  options(*nopass  ); // i_toCcsid  |
    *n int(10) const  options(*nopass  ); // i_ccsidRplDta  |
  end-pr;

  //  Record format RTVM0300
  dcl-ds MS0300;
    M3TRTN int(10);
    M3TVAL int(10);
    M3MSSV int(10);
    M3ALID int(10);
    M3ALOP char(9);
    M3LGIN char(1);
    M3MGID char(7);
    M3RES1 char(3);
    M3NSVF int(10);
    M3CSIT int(10);
    M3CSIR int(10);
    M3CCIT int(10);
    M3OFDR int(10);
    M3LGDR int(10);
    M3LDRA int(10);
    M3OFMG int(10);
    M3LGMR int(10);
    M3LMRA int(10);
    M3OFMH int(10);
    M3LGMH int(10);
    M3LMHA int(10);
    M3OFVF int(10);
    M3LGVF int(10);
    M3LVFA int(10);
    M3LVFE int(10);
    M3RES2 char(152);
    M3DATA char(7936);
  end-ds;

  // Format of replacement variable
  dcl-ds MS030F;
    M3FLGD int(10);
    M3FFSZ int(10);
    M3FTYP char(10);
    M3FRS1 char(238);
    M3FRS2 char(256);
  end-ds;

  // Generic API error structure
  dcl-ds errCode qualified;
    bytPrv int(10) inz;
    bytAvl int(10) inz;
    excID char(7) inz;
    reserved_1 char(1) inz;
    excDta char(16) inz;
  end-ds;

  // Message ID parts
  dcl-ds msgIdDS qualified;
    prfx char(3) inz;
    prfx1ch char(1) inz overlay(prfx);
    nbr char(4) inz;
  end-ds;

  // 6-char RPG field name
  dcl-ds field6 qualified;
    prfx char(1);
    nbr char(4);
    count char(3);
  end-ds;

  // 10-char ILE-RPG field name
  dcl-ds field10 qualified;
    prfx char(3);
    nbr char(4);
    count char(5);
  end-ds;

  // C field name and type
  dcl-s c_fldName char(40);
  dcl-s c_fldType char(40);

  // Return format control characters *YES or *NO
  dcl-s rtnFmtCtrlChrs char(10);

  // Various buffers for message description data
  dcl-s msgText char(8192);
  dcl-s msgHelp char(8192);
  dcl-s rplcVars char(8192);

  // General purpose index variable
  dcl-s i int(10);

  // Buffer for building temporary strings
  dcl-s tmpStr varchar(80);

  //  Global variable: message file
  dcl-ds qMsgF likeds(qobj_t);

  // Offset replacement variables
  dcl-s rplcVarOffs int(10);

  // Sub-field counter
  dcl-s OD int(10);

  // laufender Zähler Variablenverarbeitung
  dcl-s rplcVarIdx int(10);

  // Total length of data structure
  dcl-s lenStruct int(10);

  // Total number of replacement variables
  dcl-s rplcVarCount int(10);

  // Type and length of replacement variable
  dcl-ds rplcVar qualified;
    length int(10);
    packedLen int(10);
    fraction int(10);
    type char(1);
  end-ds;

  // Buffer for generating message text and message help
  dcl-s buffer varchar(8192);

  // Name for DEFINE compiler directive
  dcl-s defineName varchar(20);

  // Generic message file name
  dcl-ds qGenMsgF likeds(qobj_t);

  // Initialize return values

  go_mbrText  = '';
  go_excId = '';
  go_excDta = '';

  IF (gi_isFirstId = TRUE);
    CLEAR FSRC;
    FSRC.SRCSEQ = 0;
  ENDIF;

  // Open SRC file
  OPEN SRC;

  // Splitt message id into prefix and number
  msgIdDS = gi_msgId;

  // Call the retrieve message description API
  // to return format control characters ...
  IF (gi_genType = GENTYPE_CLP
      or gi_genType = GENTYPE_CLLE
      or gi_genType = GENTYPE_SCRIPT);
    rtnFmtCtrlChrs = '*YES';
  ELSE;
    rtnFmtCtrlChrs = '*NO';
  ENDIF;

  CLEAR errCode;

  qMsgF.name = gi_msgF;
  qMsgF.lib = gi_msgFLib;

  CALLP(E) QMHRTVM(MS0300: %size(MS0300): 'RTVM0300'
          : gi_msgId: qMsgF: '':  0: '*NO': rtnFmtCtrlChrs
          : errCode);

  // Check error indicator
  IF (%error());
    go_excId = 'CPF9897';
    go_excDta = 'Error: ' + %trim(qMsgF.lib) + '/' +
                        %trim(qMsgF.name) +
            ' Id: ' + %trim(gi_msgId);
  ELSE;

    IF (errCode.bytAvl > 0);
      go_excId = errCode.excID;
      go_excDta = errCode.excDta;
    ELSE;

      // Retrieve: message text
      IF M3LGMR > *ZERO;
        msgText = %subst(MS0300: PTF_OFFSET + M3OFMG: M3LGMR);
      ELSE;
        msgText = '';
      ENDIF;

      go_mbrText = msgText;

      // Retrieve: message help text
      IF M3LGMH > *ZERO;
        msgHelp = %subst(MS0300: PTF_OFFSET + M3OFMH: M3LGMH);
      ELSE;
        msgHelp = '';
      ENDIF;

      // Retrieve: replacement variables
      IF M3LGVF > *ZERO;
        rplcVars = %subst(MS0300: PTF_OFFSET + M3OFVF: M3LGVF);
      ELSE;
        rplcVars = '';
      ENDIF;

      // Generate source
      EXSR performOperation;
    ENDIF;
  ENDIF;

  // Close SRC file
  CLOSE SRC;

  RETURN;

  //****************************************************
  // Select the type of source that is generated
  //****************************************************
  BEGSR performOperation;

    SELECT;

    WHEN gi_genType = GENTYPE_RPG;
      qGenMsgF.lib = gi_msgFLib;
      qGenMsgF.name = gi_msgF;
      EXSR performRPG3;

    WHEN gi_genType = GENTYPE_ILERPG;
      qGenMsgF.lib = gi_msgFLib;
      qGenMsgF.name = gi_msgF;
      EXSR performRPG4;

    WHEN gi_genType = GENTYPE_FREE;
      qGenMsgF.lib = gi_msgFLib;
      qGenMsgF.name = gi_msgF;
      EXSR performFree;

    WHEN gi_genType = GENTYPE_CLP
       OR gi_genType = GENTYPE_CLLE;
      qGenMsgF.lib = '&LIB';
      qGenMsgF.name = '&OBJ';
      EXSR performCLP;

    WHEN gi_genType = GENTYPE_C;
      EXSR performC;

    // Process *SCRIPT as *CLP but drop some statements
    WHEN gi_genType = GENTYPE_SCRIPT;
      qGenMsgF.lib = '&LI';
      qGenMsgF.name = '&SF';
      EXSR performCLP;

    OTHER;

    ENDSL;

  ENDSR;

  //****************************************************
  // Generate RPG source code
  //****************************************************
  BEGSR performRPG3;

    // Comment line (dashes)
    writeLine(RPG(1));

    // Comment line with message ID
    writeLine(%trimr(RPG(2)) + ' ' + gi_msgId);

    // Comment line with message text
    writeLine(%trimr(RPG(3)) + ' ' + %subst(msgText: 1: 59));

    // Generate data structure
    EXSR genStructRPG3;
    IF (go_excId <> '');
      LEAVESR;
    ENDIF;

    // Add total length of data structure
    EXSR genTotalLenRPG3;

  ENDSR;

  //****************************************************
  // Generate ILE-RPG source code
  //****************************************************
  BEGSR performRPG4;

    // Generate DEFINE compiler directive
    EXSR genStartDefineRPG4;

    // Comment line (dashes)
    writeLine(IRPG(1));

    // Comment line with message ID
    writeLine(%trimr(IRPG(2)) + ' ' + gi_msgId);

    // Comment line with message text
    writeLine(%trimr(IRPG(14)) + '  ' + %subst(msgText: 1: 59));

    // Generate data structure
    EXSR genStructRPG4;
    IF (go_excId <> '');
      LEAVESR;
    ENDIF;

    // Add total length of data structure
    EXSR genTotalLenRPG4;

    // Generate ENDIF compiler directive
    EXSR genEndDefineRPG4;

  ENDSR;

  //****************************************************
  // Generate ILE-RPG /free source code
  //****************************************************
  BEGSR performFree;

    // Write: **free
    writeLine(FREE(1));

    // Generate DEFINE compiler directive
    EXSR genStartDefineFree;

    // Comment line (dashes)
    writeLine(FREE(2));

    // Comment line with message ID
    writeLine(%trimr(FREE(3)) + ' ' + gi_msgId);

    // Comment line with message text
    writeLine(%trimr(FREE(11)) + '  ' + %subst(msgText: 1: 59));

    // Generate data structure
    EXSR genStructFree;
    IF (go_excId <> '');
      LEAVESR;
    ENDIF;

    // Generate ENDIF compiler directive
    EXSR genEndDefineFree;

  ENDSR;

  //****************************************************
  // Generate CLP source code.
  //****************************************************
  BEGSR performCLP;

    IF (gi_isFirstId = TRUE);
      IF (gi_genType <> GENTYPE_SCRIPT);
        // STRPREPRC Header
        FOR i = 1 to %elem(STRPREPRC);
          srcLine = STRPREPRC(i);
          SELECT;
          WHEN %scan('%CMD': srcLine) > 0;
            IF gi_genType = GENTYPE_CLP;
              tmpStr = 'CRTCLPGM';
            ELSE;
              tmpStr = 'CRTBNDCL';
            ENDIF;
            srcLine = replace(srcLine: '%CMD': tmpStr);
          WHEN %scan('%TEXT': srcLine) > 0;
            tmpStr = 'TEXT(''' + %trim(gi_msgFText) + ''');';
            srcLine = replace(srcLine: '%TEXT': tmpStr);
          ENDSL;
          writeLine(srcLine);
        ENDFOR;

        // PGM
        writeLine(CLP(5));

        // Empty line
        writeLine('');

        // DCL &I_LIB
        writeLine(CLP(15));

        // DCL &I_OBJ
        writeLine(CLP(16));

        // DCL &LIB
        writeLine(CLP(17));

        // DCL &OBJ
        writeLine(CLP(18));

        // Empty line
        writeLine('');

        // CHGVAR &LIB
        writeLine(CLP(19));

        // MONMSG
        writeLine(CLP(20));

        // RMVMSG
        writeLine(CLP(21));

        // CHGVAR
        //**                EVAL      SRCDTA = f_replace(CLP(22): '%LIB': qGenMsgF.lib)
        //**                EXSR      WRTLINE
        // SNDPGMMSG: Usage ...
        writeLine(CLP(30));

        writeLine(replace(CLP(31): PGM: %trim(fileInfo.member)));

        writeLine(CLP(32));

        writeLine(CLP(33));

        // ENDDO
        writeLine(CLP(23));

        // Empty line
        writeLine('');

        // CHGVAR &OBJ
        writeLine(CLP(24));

        // MONMSG
        writeLine(CLP(20));

        // RMVMSG
        writeLine(CLP(21));

        // CHGVAR
        writeLine(replace(CLP(25): '%OBJ': gi_msgF));

        // ENDDO
        writeLine(CLP(23));

        IF (gi_isCrtMsgF = TRUE);

          // Empty line
          writeLine('');

          // DLTMSGF
          writeLine(CLP(26));

          // MONMSG
          writeLine(CLP(27));

          // RMVMSG
          writeLine(CLP(21));

          // ENDDO
          writeLine(CLP(23));

          // Empty line
          writeLine('');

          // CRTMSGF
          writeLine(CLP(28));

          srcLine = CLP(29);
          tmpStr = 'TEXT(''' + %trim(gi_msgFText) + ''')';
          srcLine = replace(srcLine: '%TEXT': tmpStr);
          writeLine(srcLine);

        ENDIF;

        // Empty line
        writeLine('');
      ENDIF;
    ELSE;
    //  Not for 2nd, 3rd, etc. message description
    ENDIF;

    // Comment line (dashes)
    writeLine(CLP(1));

    // Comment line with message ID
    writeLine(replace(CLP(2): MSGID: gi_msgId));

    // Comment line with message text
    writeLine(replace(CLP(3): MSGTXT: msgText));

    // Comment line (dashes)
    writeLine(CLP(1));

    IF (gi_isCrtMsgF = FALSE);

      // Empty line
      writeLine('');

      // RMVMSGD
      //                  MOVEA(P)  CLP(7)        TXT
      //                  MOVEA     XMSGI         TXT(28)
      //                  MOVEA     qGenMsgF.lib        TXT(42)
      //                  MOVEA(P)  TXT           SRCDTA
      //                  CAT       '/':0         SRCDTA
      //                  CAT       qGenMsgF.name:0      SRCDTA
      //                  CAT       ')':0         SRCDTA
      srcLine = replace(CLP(7): MSGID: %trimr(gi_msgId));
      srcLine = replace(srcLine: MSGL: %trimr(qGenMsgF.lib));
      srcLine = replace(srcLine: MSGF: %trimr(qGenMsgF.name));
      writeLine(srcLine);

      // MONMSG (1)
      writeLine(CLP(8));

    // MONMSG (2)
    //******              MOVELCLP,9     SRCDTA    P
    //******              EXSR WRTLINE
    //
    ENDIF;

    // Empty line
    writeLine('');

    // Generate replacement variables
    EXSR genCmdADDMSGD;
    IF (go_excId <> '');
      LEAVESR;
    ENDIF;

  ENDSR;

  //****************************************************
  // Generate C source code.
  //****************************************************
  BEGSR performC;

    // Generate DEFINE compiler directive
    EXSR genStartDefineC;

    // Comment line (dashes)
    writeLine(c(1));

    // Comment line with message ID
    writeLine(replace(c(2): MSGID: gi_msgId));

    // Comment line with message text
    writeLine(replace(c(3): MSGTXT: msgText));

    // Comment line (dashes)
    writeLine(c(4));

    // Comment line
    writeLine('');

    // Generate replacement variables
    EXSR genStructC;
    IF (go_excId <> '');
      LEAVESR;
    ENDIF;

    // Generate ENDIF compiler directive
    EXSR genEndDefineC;

  ENDSR;

  //****************************************************
  // Generate DEFINE compiler directive, part 1
  //****************************************************
  BEGSR genStartDefineRPG4;

    IF (gi_isDefine = FALSE);
      // User did not select generating the DEFINE compiler directive
      LEAVESR;
    ENDIF;

    // /IF NOT DEFINED(UNDEFINE_ALL)
    writeLine(IRPG(11));

    // Produce name for DEFINE compiler directive
    defineName = %trimr(gi_msgId) + '_MSG';

    // /IF NOT DEFINED(msgid_MSG)
    writeLine(%trimr(IRPG(8)) + defineName + ')');

    // /DEFINE msgid_MSG
    writeLine(%trimr(IRPG(9)) + ' ' + defineName);

  ENDSR;

  //****************************************************
  // Generate DEFINE compiler directive, part 2
  //****************************************************
  BEGSR genEndDefineRPG4;

    IF (gi_isDefine = FALSE);
      // User did not select generating the DEFINE compiler directive
      LEAVESR;
    ENDIF;

    // /ENDIF
    writeLine(IRPG(10));

    // /ENDIF
    writeLine(IRPG(10));

    // Empty comment line
    writeLine(IRPG(3));

    // /IF DEFINED(UNDEFINE_ALL)
    writeLine(IRPG(12));

    // /UNDEFINE msgid_MSG
    writeLine(%trimr(IRPG(13)) + ' ' + defineName);

    // /ENDIF
    writeLine(IRPG(10));

  ENDSR;

  //****************************************************
  // Generate DEFINE compiler directive, part 1 (/free)
  //****************************************************
  BEGSR genStartDefineFree;

    IF (gi_isDefine = FALSE);
      // User did not select generating the DEFINE compiler directive
      LEAVESR;
    ENDIF;

    // Produce name for DEFINE compiler directive
    defineName = %trimr(gi_msgId) + '_MSG';

    // /IF NOT DEFINED(msgid_MSG)
    writeLine(%trimr(FREE(8)) + defineName + ')');

    // /DEFINE msgid_MSG
    writeLine(%trimr(FREE(9)) + ' ' + defineName);

  ENDSR;

  //****************************************************
  // Generate DEFINE compiler directive, part 2 (/free)
  //****************************************************
  BEGSR genEndDefineFree;

    IF (gi_isDefine = FALSE);
      // User did not select generating the DEFINE compiler directive
      LEAVESR;
    ENDIF;

    // /ENDIF
    writeLine(FREE(10));

  ENDSR;

  //****************************************************
  // Generate DEFINE compiler directive, part 1
  //****************************************************
  BEGSR genStartDefineC;

    IF (gi_isDefine = FALSE);
      // User did not select generating the DEFINE compiler directive
      LEAVESR;
    ENDIF;

    // #ifndef
    writeLine(replace(c(8): STRUCTNAME: '__' + getStructName(gi_msgId)));

    // #define
    writeLine(replace(c(9): STRUCTNAME: '__' + getStructName(gi_msgId)));

  ENDSR;

  //****************************************************
  // Generate DEFINE compiler directive, part 2
  //****************************************************
  BEGSR genEndDefineC;

    IF (gi_isDefine = FALSE);
      // User did not select generating the DEFINE compiler directive
      LEAVESR;
    ENDIF;

    // #endif
    writeLine(c(10));

  ENDSR;

  //****************************************************
  // Generate replacement variables, C source code.
  //****************************************************
  BEGSR genStructC;

    // Line with struct name
    writeLine(c(5));

    // Determine number of replacement variables
    EXSR getRplVarCount;

    IF (rplcVarCount <= 0);
      // ... no replacement variables available
      srcLine = replace(c(6): VARNAME: 'dummy');
      srcLine = replace(srcLine: VARTYPE: 'char');
      srcLine = replace(srcLine: DELIMITER: ';');
      writeLine(srcLine);
    ELSE;

      EVAL rplcVarOffs = 1;

      FOR rplcVarIdx = 1 TO rplcVarCount;

        // Get replacement variable
        EXSR getRplVar;

        // Check data type
        EXSR chkRplVarType;
        IF (go_excId <> '');
          LEAVESR;
        ENDIF;

        // Prepare output
        srcLine = c(6);

        // Produce field name
        c_fldName = 'd' + ord(rplcVarIdx);

        // Set decimal positions
        EXSR getVarType;

        SELECT;
        WHEN rplcVar.type = 'A';
          c_fldType = 'char';
          c_fldName = %trim(c_fldName)
                 + '['
                 + %trimr(str(rplcVar.length))
                 + ']';
        WHEN rplcVar.type = 'P';
          c_fldType = 'decimal'
                 + '('
                 + %trimr(str(rplcVar.length))
                 + ','
                 + %trimr(str(rplcVar.fraction))
                 + ')';
        WHEN rplcVar.type = 'B';
          SELECT;
          WHEN rplcVar.length = 18;
            c_fldType = 'long long';
          WHEN rplcVar.length = 9;
            c_fldType = 'long';
          WHEN rplcVar.length = 4;
            c_fldType = 'short';
          OTHER;
            c_fldType = '*error';
          ENDSL;
        WHEN rplcVar.type = 'U';
          SELECT;
          WHEN rplcVar.length = 18;
            c_fldType = 'unsigned long long';
          WHEN rplcVar.length = 9;
            c_fldType = 'unsigned long';
          WHEN rplcVar.length = 4;
            c_fldType = 'unsigned short';
          OTHER;
            c_fldType = '*error';
          ENDSL;
        ENDSL;

        srcLine = replace(c(6): VARNAME: c_fldName);
        srcLine = replace(srcLine: VARTYPE: c_fldType);
        srcLine = replace(srcLine: DELIMITER: C_DELIM);

        IF rplcVar.length = 0;
          %SUBST(srcLine: 2:  2) = '/*';
          %SUBST(srcLine:40: 10) = 'Length = 0';
          %SUBST(srcLine:51:  2) = '*/';
        ENDIF;

        // Append replacement variable
        writeLine(srcLine);

      ENDFOR;

    ENDIF;

    writeLine(
       replace(c(7): STRUCTNAME: getStructName(gi_msgId) + C_DELIM));

  ENDSR;

  //****************************************************
  // Generate sub-field, RPG.
  //****************************************************
  BEGSR genStructRPG3;

    isBinaryFieldWarning = FALSE;

    // Line with struct name
    writeLine(replace(RPG(11): DS_NAME: msgIdDS.prfx1ch + msgIdDS.nbr));

    // Determine number of replacement variables
    EXSR getRplVarCount;

    IF (rplcVarCount <= 0);
      // ... no replacement variables available
      lenStruct = 0;
      writeLine(RPG(15));
    ELSE;

      rplcVarOffs = 1;
      OD = 1;
      lenStruct = 0;

      FOR rplcVarIdx = 1 TO rplcVarCount;

        // Get replacement variable
        EXSR getRplVar;

        // Check data type
        EXSR chkRplVarType;
        IF (go_excId <> '');
          LEAVESR;
        ENDIF;

        // Produce field name
        CLEAR field6;
        field6.prfx = msgIdDS.prfx1ch;
        field6.nbr = msgIdDS.nbr;
        field6.count = ORD(rplcVarIdx);

        // Get type and size
        EXSR getVarType;

        // Field has no length
        IF (rplcVar.length = 0);
          srcLine = replace(RPG(14): FIELD_NAME: field6);
        ELSE;
          srcLine = replace(RPG(12): FIELD_NAME: field6);

          IF (rplcVar.type = 'A');
            rplcVar.type = '';
          ENDIF;

          // Change unsigned binary to binary because
          // RPG-III lacks an unsigned type
          IF (rplcVar.type = 'U');
            rplcVar.type = 'B';
            isBinaryFieldWarning = TRUE;
          ENDIF;

          // Set type of variables (B or P)
          srcLine = replace(srcLine: '?': rplcVar.type: 1);

          // Set fraction of variables of type 'packed' and 'binary'
          IF (rplcVar.type = 'P' OR rplcVar.type = 'B' OR rplcVar.type = 'U');
            srcLine = replace(
                        srcLine: '!': toChar1(rplcVar.fraction): 1);
          ELSE;
            // Clear fraction
            srcLine = replace(srcLine: '!': ' ': 1);
          ENDIF;

          // Set 'from' position
          srcLine = replace(srcLine: FROM: toChar4(OD: ' '));

          OD = OD + rplcVar.packedLen;

          // Set 'to' position
          srcLine = replace(srcLine: TO: toChar4(OD - 1: ' '));

          // Count total length of structure
          lenStruct = lenStruct + rplcVar.packedLen;
        ENDIF;

        // Append sub-field
        writeLine(srcLine);

      ENDFOR;

    ENDIF;

    IF (isBinaryFieldWarning);
      sndMsgToCmdLine('USR0003');
    ENDIF;

  ENDSR;

  //****************************************************
  // Generate field with total length of structure, RPG.
  //****************************************************
  BEGSR genTotalLenRPG3;

    // Produce structure without a name
    writeLine(replace(RPG(11): DS_NAME: ''));

    // Create sub-field with total length of strucure
    srcLine = replace(RPG(13): INIT_VALUE: toChar4(lenStruct: ' '));

    // Produce field name
    CLEAR field6;
    field6.prfx = msgIdDS.prfx1ch;
    field6.nbr = msgIdDS.nbr;
    field6.count = 'L';
    srcLine = replace(srcLine: FIELD_NAME: field6);

    writeLine(srcLine);

  ENDSR;

  //****************************************************
  // Generate sub-field, ILE-RPG /free.
  //****************************************************
  BEGSR genStructFree;

    // Line with struct name
    writeLine(replace(FREE(4): DS_NAME: gi_msgId));

    // Determine number of replacement variables
    EXSR getRplVarCount;

    IF (rplcVarCount <= 0);
      // ... no replacement variables available
      lenStruct = 0;
      writeLine(IRPG(7));
    ELSE;

      rplcVarOffs = 1;
      lenStruct = 0;
      FOR rplcVarIdx = 1 TO rplcVarCount;

        // Get replacement variable
        EXSR getRplVar;

        // Check data type
        EXSR chkRplVarType;
        IF (go_excId <> '');
          LEAVESR;
        ENDIF;

        // Produce field name
        //         CLEAR field10;
        //         field10.prfx = msgIdDS.prfx;
        //         field10.nbr = msgIdDS.nbr;
        //         field10.count = ORD(rplcVarIdx);
        field10 = 'var' + ORD(rplcVarIdx);

        // Get type and size
        EXSR getVarType;

        // Field has no length
        IF (rplcVar.length = 0);
          srcLine = replace(FREE(12): FIELD_NAME: field10);
        ELSE;
          srcLine = replace(FREE(5): FIELD_NAME: field10);

          // Adjust length for binary and unsigned binary fields
          IF (rplcVar.type = 'B' or rplcVar.type = 'U');
            SELECT;
            WHEN (rplcVar.length >= 10);
              rplcVar.length = 20;
            WHEN (rplcVar.length >= 5);
              rplcVar.length = 10;
            OTHER;
              rplcVar.length = 5;
            ENDSL;
          ENDIF;

          // Set 'length' and 'fraction'
          //            srcLine = replace(srcLine:LENGTH:toChar4(rplcVar.length));
          SELECT;
          WHEN rplcVar.type = 'A';
            srcLine =
               replace(srcLine: TYPE
                       : 'char(' + %char(rplcVar.length) + ')');
          WHEN rplcVar.type = 'P';
            srcLine =
               replace(srcLine: TYPE
                       : 'packed(' +
                            %char(rplcVar.length) + ':' +
                            %char(rplcVar.fraction) +
                         ')');
          WHEN rplcVar.type = 'B';
            srcLine =
               replace(srcLine: TYPE
                       : 'int(' + %char(rplcVar.length) + ')');
          WHEN rplcVar.type = 'U';
            srcLine =
               replace(srcLine: TYPE
                       : 'uns(' + %char(rplcVar.length) + ')');
          OTHER;
            srcLine =
               replace(srcLine: TYPE
                       : '*ERROR');
          ENDSL;

          // Set initial value
          //            SELECT;
          //            WHEN rplcVar.type = 'A';
          //               srcLine = replace(srcLine: INIT_VALUE: '*BLANKS');
          //            WHEN rplcVar.type = 'P';
          //               srcLine = replace(srcLine: INIT_VALUE: '*ZEROS');
          //            WHEN rplcVar.type = 'B';
          //               srcLine = replace(srcLine: INIT_VALUE: '*ZEROS');
          //            OTHER;
          //               srcLine = replace(srcLine: INIT_VALUE: '*ERROR');
          //            ENDSL;

          // Set data type
          //            IF rplcVar.type = 'B';
          //               srcLine = replace(srcLine: '?': 'I': 1);
          //            ELSE;
          //               srcLine = replace(srcLine: '?': rplcVar.type: 1);
          //            ENDIF;

          // Set fraction
          //            IF (rplcVar.type = 'P' OR rplcVar.type = 'B');
          //               srcLine = replace(
          //                           srcLine: '!!': toChar2(rplcVar.fraction): 2);
          //            ELSE;
          //               srcLine = replace(srcLine: '!!': ' ': 2);
          //            ENDIF;

          // Count total length of structure
          lenStruct = lenStruct + rplcVar.packedLen;
        ENDIF;

        // Zeile wegschreiben
        writeLine(srcLine);

      ENDFOR;

    ENDIF;

    // End structure
    writeLine(replace(FREE(6): DS_NAME: gi_msgId));

  ENDSR;

  //****************************************************
  // Generate field with total length of structure, ILE-RPG.
  //****************************************************
  BEGSR genTotalLenRPG4;

    // Produce field name
    CLEAR field10;
    field10.prfx = msgIdDS.prfx;
    field10.nbr = msgIdDS.nbr;
    field10.count = '_SIZE';

    // Produce structure without a name
    srcLine = replace(IRPG(6): FIELD_NAME: field10);

    // Insert total length of structure
    srcLine = replace(srcLine: INIT_VALUE: str(lenStruct));

    writeLine(srcLine);

  ENDSR;


  //****************************************************
  // Generate sub-field, ILE-RPG.
  //****************************************************
  BEGSR genStructRPG4;

    // Line with struct name
    writeLine(replace(IRPG(4): DS_NAME: gi_msgId));

    // Determine number of replacement variables
    EXSR getRplVarCount;

    IF (rplcVarCount <= 0);
      // ... no replacement variables available
      lenStruct = 0;
      writeLine(IRPG(7));
    ELSE;

      rplcVarOffs = 1;
      lenStruct = 0;
      FOR rplcVarIdx = 1 TO rplcVarCount;

        // Get replacement variable
        EXSR getRplVar;

        // Check data type
        EXSR chkRplVarType;
        IF (go_excId <> '');
          LEAVESR;
        ENDIF;

        // Produce field name
        CLEAR field10;
        field10.prfx = msgIdDS.prfx;
        field10.nbr = msgIdDS.nbr;
        field10.count = ORD(rplcVarIdx);

        // Get type and size
        EXSR getVarType;

        // Field has no length
        IF (rplcVar.length = 0);
          srcLine = replace(IRPG(15): FIELD_NAME: field10);
        ELSE;
          srcLine = replace(IRPG(5): FIELD_NAME: field10);

          // Adjust length for binary and unsigned binary fields
          IF (rplcVar.type = 'B' or rplcVar.type = 'U');
            SELECT;
            WHEN (rplcVar.length >= 10);
              rplcVar.length = 20;
            WHEN (rplcVar.length >= 5);
              rplcVar.length = 10;
            OTHER;
              rplcVar.length = 5;
            ENDSL;
          ENDIF;

          // Set 'length'
          srcLine = replace(srcLine: LENGTH: toChar4(rplcVar.length));

          // Set initial value
          SELECT;
          WHEN rplcVar.type = 'A';
            srcLine = replace(srcLine: INIT_VALUE: '*BLANKS');
          WHEN rplcVar.type = 'P';
            srcLine = replace(srcLine: INIT_VALUE: '*ZEROS');
          WHEN rplcVar.type = 'B';
            srcLine = replace(srcLine: INIT_VALUE: '*ZEROS');
          WHEN rplcVar.type = 'U';
            srcLine = replace(srcLine: INIT_VALUE: '*ZEROS');
          OTHER;
            srcLine = replace(srcLine: INIT_VALUE: '*ERROR');
          ENDSL;

          // Set data type
          IF rplcVar.type = 'B';
            srcLine = replace(srcLine: '?': 'I': 1);
          ELSE;
            srcLine = replace(srcLine: '?': rplcVar.type: 1);
          ENDIF;

          // Set fraction
          IF (rplcVar.type = 'P' OR rplcVar.type = 'B');
            srcLine = replace(
                        srcLine: '!!': toChar2(rplcVar.fraction): 2);
          ELSE;
            srcLine = replace(srcLine: '!!': ' ': 2);
          ENDIF;

          // Count total length of structure
          lenStruct = lenStruct + rplcVar.packedLen;
        ENDIF;

        // Zeile wegschreiben
        writeLine(srcLine);

      ENDFOR;

    ENDIF;

  ENDSR;
  //****************************************************
  // Generate replacement variables, CLP source code.
  //****************************************************
  BEGSR genCmdADDMSGD;

    // ADDMSGD
    writeLine(%trimr(CLP(11)) + ' +');

    // MSGID()
    srcLine = spaces(INDENT_1) + 'MSGID';
    EXSR addOpenBracket;
    srcLine = %trimr(srcLine) + gi_msgId;
    EXSR addCloseBracket;
    writeLine(srcLine);

    // MSGF()
    srcLine = spaces(INDENT_1) + 'MSGF';
    EXSR addOpenBracket;
    srcLine = %trimr(srcLine) +
            %trim(qGenMsgF.lib) + '/' + %trim(qGenMsgF.name);
    EXSR addCloseBracket;
    writeLine(srcLine);

    // MSG()
    IF (M3LGMR > 0);
      srcLine = spaces(INDENT_1) + 'MSG';
      EXSR addOpenBracket;
      srcLine = %trimr(srcLine) + ' +';
      writeLine(srcLine);

      buffer = %subst(MS0300: M3OFMG + 1: M3LGMR);

      buffer = doubleHyphens(buffer);
      buffer = '''' + buffer + '''';

      splittLine(buffer);

      writeLine(spaces(INDENT_1) + ') +');
    ENDIF;

    // SECLVL()
    IF (M3LGMH > 0);
      srcLine = spaces(INDENT_1) + 'SECLVL';
      EXSR addOpenBracket;
      srcLine = %trimr(srcLine) + ' +';
      writeLine(srcLine);

      buffer = %subst(MS0300: M3OFMH + 1: M3LGMH);

      buffer = doubleHyphens(buffer);
      buffer = '''' + buffer + '''';

      splittLine(buffer);

      writeLine(spaces(INDENT_1) + ') +');
    ENDIF;

    // SEV()
    srcLine = spaces(INDENT_1) + 'SEV';
    EXSR addOpenBracket;
    srcLine = %trimr(srcLine) + str(M3MSSV);
    EXSR addCloseBracket;
    writeLine(srcLine);

    // Determine number of replacement variables
    EXSR getRplVarCount;

    IF (rplcVarCount <= 0);
      // ... no replacement variables available
      writeLine(CLP(14));
    ELSE;

      // FMT()
      srcLine = spaces(INDENT_1) + 'FMT';
      EXSR addOpenBracket;
      srcLine = %trimr(srcLine) + ' +';
      writeLine(srcLine);

      rplcVarOffs = 1;
      FOR rplcVarIdx = 1 TO rplcVarCount;

        // %SUBST(SRCDTA: INDENT_2: 1) = '(';
        srcLine = spaces(INDENT_2) + '(';

        // Get replacement variable
        EXSR getRplVar;

        // Check data type
        EXSR chkRplVarType;
        IF (go_excId <> '');
          LEAVESR;
        ENDIF;

        // Get type and size
        EXSR getVarType;

        IF (rplcVar.type = 'B' or rplcVar.type = 'U');

          IF (rplcVar.type = 'B');
            srcLine = %trimr(srcLine) + '*BIN';
          ELSEIF (rplcVar.type = 'U');
            srcLine = %trimr(srcLine) + '*UBIN';
          ENDIF;

        // Adjust length for binary and unsigned binary fields
          SELECT;
          WHEN rplcVar.length >= 10;
            rplcVar.length = 8;
          WHEN rplcVar.length >= 5;
            rplcVar.length = 4;
          OTHER;
            rplcVar.length = 2;
          ENDSL;
        ELSE;
          srcLine = %trimr(srcLine) + M3FTYP;
        ENDIF;

        // ... field length
        srcLine = %trimr(srcLine) + ' ' + str(rplcVar.length);

        // ... fraction
        IF (rplcVar.type = 'P' OR rplcVar.type = 'B' OR rplcVar.type = 'U');
          srcLine = %trimr(srcLine) + ' ' + str(rplcVar.fraction);
        ENDIF;

        // Append source line
        EXSR addCloseBracket;
        writeLine(srcLine);

      ENDFOR;

      writeLine(spaces(INDENT_1) + ') +');
    ENDIF;

    // ALROPT()
    srcLine = spaces(INDENT_1) + 'ALROPT';
    EXSR addOpenBracket;
    srcLine = %trimr(srcLine) + M3ALOP;
    IF (M3ALID >= 1 AND M3ALID <= 99);
      srcLine = %trimr(srcLine) + ' ' + str(M3ALID);
    ENDIF;
    EXSR addCloseBracket;
    writeLine(srcLine);

    // CCSID()
    srcLine = spaces(INDENT_1) + 'CCSID';
    EXSR addOpenBracket;
    srcLine = %trimr(srcLine) + str(M3CCIT);
    EXSR addCloseBracket;
    writeLine(srcLine);

    // EOF
    writeLine(spaces(INDENT_1) + '/*  -EOF-  */');

    // Empty line
    writeLine('');

    IF (gi_isLastId = TRUE AND gi_genType <> GENTYPE_SCRIPT);
      // RCLRSC
      writeLine(CLP(12));

      // Empty line
      writeLine('');

      // ENDPGM
      writeLine(CLP(13));
    ENDIF;

  ENDSR;

  //****************************************************
  // Adds a "Open bracket".
  //****************************************************
  BEGSR addOpenBracket;

    srcLine =
      %trimr(srcLine) + '(';

  ENDSR;

  //****************************************************
  // Adds a "Close bracket".
  //****************************************************
  BEGSR addCloseBracket;

    srcLine = %trimr(srcLine) + ') +';

  ENDSR;

  //****************************************************
  // Verifies the data type of a given replacement variable
  //****************************************************
  BEGSR chkRplVarType;

    IF (M3FTYP <> '*QTDCHAR' and
       M3FTYP <> '*CHAR' and
       M3FTYP <> '*DEC' and
       M3FTYP <> '*HEX' and
       M3FTYP <> '*UBIN' and
       M3FTYP <> '*BIN');
      go_excId = 'CPF9897';
      go_excDta = 'MSG-ID: ' + %trim(M3MGID) +
              ' unknown data type: ' +
              %trim(M3FTYP);
    ENDIF;

  ENDSR;

  //****************************************************
  // Returns the number of replacement variables
  //****************************************************
  BEGSR getRplVarCount;

    IF (M3LGVF > 0);
      rplcVarCount = M3LGVF / M3LVFE;
    ELSE;
      rplcVarCount = 0;
    ENDIF;

  ENDSR;

  //****************************************************
  // Returns a replacement variable
  //****************************************************
  BEGSR getRplVar;

    CLEAR MS030F;
    MS030F = %subst(rplcVars: rplcVarOffs: M3LVFE);
    rplcVarOffs = rplcVarOffs + M3LVFE;

  ENDSR;

  //****************************************************
  // Returns the length and type of the current
  // replacement variable.
  //****************************************************

  BEGSR getVarType;

    rplcVar.length = M3FLGD; // length
    rplcVar.packedLen = M3FLGD; // length of packed field

    SELECT;
    WHEN (M3FTYP = '*QTDCHAR');
      rplcVar.fraction = -1;
      rplcVar.type = 'A';

    WHEN (M3FTYP = '*CHAR');
      rplcVar.fraction = -1;
      rplcVar.type = 'A';

    WHEN (M3FTYP = '*HEX');
      rplcVar.fraction = -1;
      rplcVar.type = 'A';

    WHEN (M3FTYP = '*DEC');
      rplcVar.fraction = M3FFSZ;
      // calculate length of packed data type
      rplcVar.packedLen = rplcVar.length / 2 + 1;
      rplcVar.type = 'P';

    WHEN (M3FTYP = '*BIN');
      SELECT;
      WHEN (rplcVar.length = 8);
        rplcVar.length = 18;
      WHEN (rplcVar.length = 4);
        rplcVar.length = 9;
      OTHER;
        rplcVar.length = 4;
      ENDSL;
      rplcVar.type = 'B';
      rplcVar.fraction = 0;

    WHEN (M3FTYP = '*UBIN');
      SELECT;
      WHEN (rplcVar.length = 8);
        rplcVar.length = 18;
      WHEN (rplcVar.length = 4);
        rplcVar.length = 9;
      OTHER;
        rplcVar.length = 4;
      ENDSL;
      rplcVar.type = 'U';
      rplcVar.fraction = 0;

    ENDSL;

  ENDSR;

  //****************************************************
  // Error handler
  //****************************************************
  BEGSR *PSSR;

    DUMP;

  ENDSR;

end-proc;

//****************************************************
// Appends a line to the source file.
//****************************************************
dcl-proc writeLine;
  dcl-pi *n;
    io_srcLine const like(srcline_t);
  end-pi;

  FSRC.SRCSEQ = FSRC.SRCSEQ + ,01;
  FSRC.SRCDAT = 0;
  FSRC.SRCDTA = io_srcLine;
  WRITE SRC FSRC;

end-proc;

//****************************************************
// Splitts a given string to multiple lines
//****************************************************
dcl-proc splittLine;
  dcl-pi *n;
    buffer varchar(8192) value;
  end-pi;

  dcl-c LINE_LENGTH 70;
  dcl-s spX int(10);

  dcl-s srcLine like(srcline_t);

  spX = 0;

  DOW (buffer <> '');

    if (%len(buffer) > LINE_LENGTH);
      srcLine = %subst(buffer: 1: LINE_LENGTH);
      buffer = %subst(buffer: LINE_LENGTH + 1);
    ELSE;
      srcLine = buffer;
      buffer = '';
    ENDIF;

    //  Add continuation character
    spX = 1 + LINE_LENGTH;

    IF buffer = *BLANKS;
      %subst(srcLine: spX: 1) = '+';
    ELSE;
      %subst(srcLine: spX: 1) = '-';
    ENDIF;

    //  Append source line
    writeLine(srcLine);
  ENDDO;

end-proc;
//****************************************************
// Replaces the hyphens of a given strin with
// double-hyphens.
//****************************************************
dcl-proc doubleHyphens;
  dcl-pi *n varchar(8192);
    buffer varchar(8192) value;
  end-pi;

  dcl-s dhF int(10);
  dcl-s dhL int(10);

  dhF = 1;

  DOU (dhF <= 0 or dhF > %len(buffer));

    dhF = %scan('''': buffer: dhF);
    IF (dhF > 0);
      IF (dhF < %size(buffer)-2);
        //  Insert single quote
        buffer = %replace('''': buffer: dhF: 0);
        dhF = dhF + 2;
        dhL = dhL + 1;
      ENDIF;
    ENDIF;

  ENDDO;

  return buffer;

end-proc;

//***************************************************************
//  Replace variables
//***************************************************************
dcl-proc replace;
  dcl-pi *n char(256);
    i_string char(256) value;
    i_var char(20) value;
    i_value char(256) value;
    i_length int(10) value options(*nopass);
  end-pi;

  dcl-c p_length 4;

  dcl-s length like(i_length);

  dcl-s start int(10) inz;
  dcl-s lenRpl int(10) inz;
  dcl-s lenVal int(10) inz;
  dcl-s i int(10) inz;
  //---------------------------------------------------------------

  IF (%parms() >= p_length);
    length = i_length;
  ELSE;
    length = %len(%trimr(i_value));
  ENDIF;

  start = %scan(%trimr(i_var): i_string);

  DOW start > 0;
    lenVal = length;
    lenRpl = %len(%trimr(i_var));
    i = start + lenRpl;
    DOW (i <= %len(i_string) and
       %subst(i_string: i: 1) = '>');
      lenRpl = lenRpl + 1;
      lenVal = lenRpl;
      i = i + 1;
    ENDDO;
    i_string = %replace(
                 %subst(i_value: 1: lenVal)
                 : i_string
                 : start
                 : lenRpl);
    start = %scan(%trimr(i_var): i_string);
  ENDDO;

  RETURN i_string;

end-proc;

//***************************************************************
//  set to lower
//***************************************************************
dcl-proc lcase;
  dcl-pi *n char(256);
    i_string char(256) value;
  end-pi;

  dcl-c uc const('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  dcl-c lc const('abcdefghijklmnopqrstuvwxyz');
  //---------------------------------------------------------------

  %SUBST(i_string:1:%SIZE(i_string)) =
  %XLATE(uc:lc:i_string);

  RETURN i_string;

end-proc;

//***************************************************************
//  convert to char
//***************************************************************
dcl-proc str;
  dcl-pi *n char(256);
    i_value int(10) value;
  end-pi;
  //---------------------------------------------------------------

  IF (i_value = 0);
    RETURN '0';
  ENDIF;

  RETURN %triml(%editc(i_value: 'Z'));

end-proc;

//***************************************************************
//  c structure name
//***************************************************************
dcl-proc getStructName;
  dcl-pi *n varchar(20);
    i_msgId char(7) const;
  end-pi;
  //---------------------------------------------------------------

  RETURN %trim(lcase(i_msgId)) + '_t';

end-proc;

//***************************************************************
//  convert integer to character 1, edit code 3
//***************************************************************
dcl-proc toChar1;
  dcl-pi *n char(1);
    i_integer int(10) const;
  end-pi;
  //---------------------------------------------------------------

  RETURN %editc(%dec(i_integer: 1: 0): '3');

end-proc;

//***************************************************************
//  convert integer to character 2, edit code 3
//***************************************************************
dcl-proc toChar2;
  dcl-pi *n char(2);
    i_integer int(10) const;
    i_rplcSpace char(1) const options(*nopass);
  end-pi;
  //---------------------------------------------------------------

  IF (%parms() >= 2);
    RETURN %xlate(' ': i_rplcSpace :%editc(%dec(i_integer: 2: 0): '3'));
  ELSE;
    RETURN %editc(%dec(i_integer: 2: 0): '3');
  ENDIF;

end-proc;

//***************************************************************
//  convert integer to character 4, edit code 3
//***************************************************************
dcl-proc toChar4;
  dcl-pi *n char(4);
    i_integer int(10) const;
    i_rplcSpace char(1) const options(*nopass);
  end-pi;
  //---------------------------------------------------------------

  IF (%parms() >= 2);
    RETURN %xlate(' ': i_rplcSpace :%editc(%dec(i_integer: 4: 0): '3'));
  ELSE;
    RETURN %editc(%dec(i_integer: 4: 0): '3');
  ENDIF;

end-proc;

//***************************************************************
//  returns a string of spaces
//***************************************************************
dcl-proc spaces;
  dcl-pi *n varchar(256);
    i_length int(10) const;
  end-pi;

  dcl-s SPACES char(256) inz;
  //---------------------------------------------------------------

  RETURN %subst(SPACES: 1: i_length);

end-proc;

//***************************************************************
//  returns the name of the product library
//***************************************************************
dcl-proc getPrdLib export;
  dcl-pi *n char(10) end-pi;
  //---------------------------------------------------------------

  RETURN sds.pgmLib;

end-proc;

//***************************************************************
//  sends a message to the command line.
//***************************************************************
dcl-proc sndMsgToCmdLine export;
  dcl-pi *N;
    i_msgId   char(7) const;
    i_msgDta  char(512) options(*nopass) const;
  end-pi;

  //  Local fields
  dcl-s msgkey      char(4);
  dcl-s msgDta      like(i_msgDta);

  dcl-ds qMsgF qualified inz;
    name            char(10);
    lib             char(10);
  end-ds;

  dcl-ds errCode qualified            inz;
    bytPrv          int(10);
    bytAvl          int(10);
    excId           char(7);
    reserved        char(1);
    excDta          char(256);
  end-ds;

  dcl-pr qmhsndpm extpgm('QMHSNDPM');
    i_msgId         char(7) const;
    i_qMsgF         char(20) const;
    i_msgData       char(32767) const  options(*varsize );
    i_length        int(10) const;
    i_msgType       char(10) const;
    i_callStkE      char(256) const;
    i_callStkC      int(10) const;
    o_msgKey        char(4);
    io_errCode      char(32767) options(*varsize);
    i_lenStkE       int(10) const  options(*nopass);   // optGrp 1
    i_callStkEQ     char(20) const  options(*nopass);  //
    i_wait          int(10) const  options(*nopass);   //
    i_callStkEDT    char(10) const  options(*nopass);  // optGrp 2
    i_ccsid         int(10) const  options(*nopass);   //
  end-pr;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= %parmnum(i_msgDta));
    msgDta = i_msgDta;
  else;
    msgDta = '';
  endif;

  clear qMsgF;
  qMsgF.name = 'CRTMSGDS';
  qMsgF.lib  = '*LIBL';

  clear errCode;
  errCode.bytPrv = %size(errCode);

  qmhsndpm(i_msgId: qMsgF: msgDta: %size(msgDta): '*INFO'
           : '*CTLBDY': 1: msgkey: errCode);

end-proc;

**  ORD
123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  RPG
      *---------------------------------------------------------------
      * Data structure for message ID:
      *
      *
      *
      *
      *
      *
      *
      *
     I%%DS>       DS
     I I                                  ?%%FR%%TO!%%FLDNME
     I I            %%IV                  B   1   40%%FLDNME
      *                                    00000000 %%FLDNMELength = 0
      *   No replacement variables available!
**  IRPG
      // ---------------------------------------------------------------
      //  Data structure for message ID:

     d %%DS>>>>>>>>    ds
     d  %%FLDNME>>>>               %%LN?!! inz(%%IV>>>)
     d %%FLDNME>>>>    s             10I 0 inz(%%IV)
      //  No replacement variables available!
      /if not defined(
      /define
      /endif
      /if not defined(UNDEFINE_ALL)
      /if defined(UNDEFINE_ALL)
      /undefine
      //
      // %%FLDNME>>                 0000A   inz(*BLANKS)  Length = 0
**  FREE
**free
// ---------------------------------------------------------------
//  Data structure for message ID:
dcl-ds %%DS qualified;
  %%FLDNME  %%TYPE inz;
end-ds;
//  No replacement variables available!
/if not defined(
/define
/endif
//
  // %%FLDNME ==> Length = 0
**  CLP
     /*-------------------------------------------------------------*/
     /*   Cmd-ADDMSGD für Message-ID :   %%MSGID                    */
     /* %%MSGTXT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
     /*-------------------------------------------------------------*/
             PGM        PARM(&I_LIB &I_OBJ)

             RMVMSGD MSGID(%%MSGID) MSGF(%%MSGL/%%MSGF)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */
 wird nicht abgefangen     CPF2407)     /* MsgF  nicht gefunden */

             ADDMSGD
             RCLRSC LVL(*)
             ENDPGM
     /*   No replacement variables defined!                         */ +
             DCL        VAR(&I_LIB     ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&I_OBJ     ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB       ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ       ) TYPE(*CHAR) LEN(10)
             CHGVAR     VAR(&LIB       ) VALUE(&I_LIB)
             MONMSG     MSGID(MCH3601) EXEC(DO)
               RMVMSG     PGMQ(*SAME (*)) CLEAR(*ALL)
               CHGVAR     VAR(&LIB) VALUE('%LIB>>>>>>')
             ENDDO
             CHGVAR     VAR(&OBJ       ) VALUE(&I_OBJ)
               CHGVAR     VAR(&OBJ) VALUE('%OBJ>>>>>>')
             DLTMSGF MSGF(&LIB/&OBJ)
             MONMSG     MSGID(CPF2105)  EXEC(DO) /* Object not found */
             CRTMSGF MSGF(&LIB/&OBJ) +
               %TEXT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
               SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                            MSGDTA('Usage: CALL PGM(%%PGM) +
                                    PARM(libName [msgFName)') +
                            TOPGMQ(*PRV (*PGMBDY)) MSGTYPE(*ESCAPE)
**  C
  /* --------------------------------------------------------------------- */
  /*   Data structure for message-ID : %%MSGID                             */
  /*   %%MSGTXT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   */
  /* --------------------------------------------------------------------- */
  typedef _Packed struct {
    %%VARTYPE>>>>>>>>>>  %%VARNAME%%DELIMITER
  } %%STRUCTNAME
#ifndef    %%STRUCTNAME
  #define  %%STRUCTNAME
#endif
**  STRPREPRC
     /*-----------------------------------------------------------------------*/
     /* STRPREPRC Compile Options:                                            */
     /* >>PRE-COMPILER<<                                                      */
     /*   >>CRTCMD<<  CALL       PGM(QTEMP/&OB) PARM(&LI &OB);                */
     /*   >>CMD<<     %CMD>>>>>> PGM(QTEMP/&OB) +                             */
     /*                          SRCFILE(&SL/&SF) SRCMBR(&SM) +               */
     /*               %TEXT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
     /*   >>EXECUTE<<                                                         */
     /*   >>CMD<<     DLTPGM PGM(QTEMP/&OB);                                  */
     /* >>END-PRE-COMPILER<<                                                  */
     /*-----------------------------------------------------------------------*/
