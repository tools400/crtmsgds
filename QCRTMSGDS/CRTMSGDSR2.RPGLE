       // =================================================================== *
       //                                                                     *
       //  Kurzdokumentation :                                                *
       //                                                                     *
       //  Bereich . . . : CRTMSGDS                                           *
       //  Objekt  . . . : CRTMSGDSR2                                         *
       //  Beschreibung  : Create Message Data Structure                      *
       //  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
       //  Datum . . . . : ?                                                  *
       //                                                                     *
       //=====================================================================*
       //                                                                     *
       //  This software is free software, you can redistribute it and/or     *
       //  modify it under the terms of the GNU General Public License (GPL)  *
       //  as published by the Free Software Foundation.                      *
       //                                                                     *
       //  See GNU General Public License for details.                        *
       //          http://www.opensource.org                                  *
       //          http://www.opensource.org/licenses/gpl-license.html        *
       //                                                                     *
       //=====================================================================*
       //  History:                                                           *
       //                                                                     *
       //  Datum       Name          Änderung                                 *
       //  ----------  ------------  ---------------------------------------  *
       //  07.09.2001  Th.Raddatz    Fixed a bug when field length is *ZEROS. *
       //                                                                     *
       //  10.01.2003  Th.Raddatz    Removed special character Ä from source. *
       //                                                                     *
       //  08.03.2005  Th.Raddatz    Fixed problem that trailing blanks of    *
       //                            message help text were dropped.          *
       //                                                                     *
       //  21.06.2005  Th.Raddatz    Renamed XMSGT to XMBRT to avoid          *
       //                            confusion.                               *
       //                            Increment cL within RPLHPN to fix bug    *
       //                            that message text was truncated.         *
       //                                                                     *
       //  18.04.2008  Th.Raddatz    Datenstruktur MS0300 von 1024 auf 8192   *
       //                            Byte vergrößert.                         *
       //                                                                     *
       //  26.01.2009  Th.Raddatz    Code des generierten CLP Programms       *
       //                            geändert. Bibliothek kann jetzt als      *
       //                            optionaler Parameter übergeben werden.   *
       //                            Befehlsparameter TYPE um Auswahl         *
       //                            *CLLE erweitert.                         *
       //                                                                     *
       //  06.10.2009  Th.Raddatz    Replaced special character '#' by        *
       //                            '_SIZE' when generating RPGLE copy       *
       //                            books.                                   *
       //                                                                     *
       //  09.01.2011  Th.Raddatz    Fixed problem that the field length of   *
       //                            a sub field of a generated data structure*
       //                            was restricted to 3 bytes.               *
       //                                                                     *
       //  04.04.2014  D.Storch      Support of *BIN-Fields  8-Bytes long.    *
       //                            Generating I-Fields instead of B-Fields  *
       //                            in ILE-RPG.                              *
       //                                                                     *
       //  30.03.2016  Th.Raddatz    Changed to create the message file and   *
       //                            to add a STRPREPRC header for type *CLP  *
       //                            and *CLLE.                               *
       //                                                                     *
       //  22.12.2016  Th.Raddatz    Fixed problem, that the CRTMSGF command  *
       //                            was not properly produced for 50-char    *
       //                            descriptions.                            *
       //                                                                     *
       //  30.10.2017  Th.Raddatz    Removed illegal semicolon from the       *
       //                            'CRTMSGF' command, when generating a     *
       //                            'CLP' or 'CLLE' source.                  *
       //                                                                     *
       //  30.10.2017  Th.Raddatz    Changed generated STRPREPRC header to    *
       //                            let STRPREPRC change the object          *
       //                            description of a 'compiled' message file.*
       //                                                                     *
       //  24.12.2018  Th.Raddatz    Converted source code to /free.          *
       //                                                                     *
       // =================================================================== *
       // >>PRE-COMPILER<<                                                    *
       //   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
       //                           SRCFILE(&SL/&SF) SRCMBR(&SM);             *
       //   >>IMPORTANT<<                                                     *
       //     >>PARM<< DBGVIEW(*LIST);                                        *
       //     >>PARM<< TRUNCNBR(*NO);                                         *
       //     >>PARM<< OPTION(*EVENTF);                                       *
       //   >>END-IMPORTANT<<                                                 *
       //   >>EXECUTE<<                                                       *
       // >>END-PRE-COMPILER<<                                                *
       // =================================================================== *
       //                                                                     *
       //  Attention: If you have applied one of the PTFs listed              *
       //             below or if you are running V4R3 or above               *
       //             you should set constant OFS to 1.                       *
       //             Otherwise you should set OFS to 0.                      *
       //                                                                     *
       //             V3R1M0 - SF51811                                        *
       //             V3R2M0 - SF51812                                        *
       //             V3R6M0 - SF51813                                        *
       //             V3R7M0 - SF51814                                        *
       //             V4R1M0 - SF51815                                        *
       //             V4R2M0 - SF51817                                        *
       //                                                                     *
       // =================================================================== *
     H nomain
      /COPY QCRTMSGDS,H_SPEC
      /COPY QCRTMSGDS,COPYRIGHT
       // =================================================================== *
     FSRC       O    F  256        DISK    USROPN
     F                                     INFDS(fileInfo)

     D fileInfo        DS                  qualified
     D  name                  83     92A
     D  library                      10A
     D  member               129    138A

       //  Record format of file SRC
     D FSRC            DS                  qualified
     D  SRCSEQ                 1      6  2 INZ(0)
     D  SRCDAT                 7     12  0 INZ(0)
     D  SRCDTA                13    256    INZ

     D ORD             S              1    DIM(35) CTDATA PERRCD(35)            Num.f.Feldn.
     D RPG             S             80    DIM(15) CTDATA PERRCD(1)             Sourcezeilen
     D IRPG            S             80    DIM(15) CTDATA PERRCD(1)             Sourcezeilen
     D CLP             S             80    DIM(33) CTDATA PERRCD(1)             Sourcezeilen
     D C               S             80    DIM(10) CTDATA PERRCD(1)             Sourcezeilen
     D STRPREPRC       S             80    DIM(11) CTDATA PERRCD(1)             Sourcezeilen

     D srcLine_t       S                   like(FSRC.SRCDTA)

       //  Prototypes
     D writeLine...
     D                 PR
     D                                     extproc('writeLine')
     D  i_srcLine                          const like(srcLine_t)

     D splittLine...
     D                 PR
     D                                     extproc('splittLine')
     D  buffer                     8192a   value varying

     D doubleHyphens...
     D                 PR          8192a   varying
     D                                     extproc('doubleHyphens')
     D  buffer                     8192a   value varying

     D replace...
     D                 PR           256a
     D                                     extproc('replace')
     D  i_string                    256a   value
     D  i_var                        20a   value
     D  i_value                     256a   value
     D  i_length                     10i 0 value options(*nopass)

     D lcase...
     D                 PR           256a
     D                                     extproc('lcase')
     D  i_string                    256a   value

     D str...
     D                 PR           256a
     D                                     extproc('str')
     D  i_value                      10i 0 value

     D getStructName...
     D                 PR            20a   varying
     D                                     extproc('getStructName')
     D  i_msgId                       7a   const

     D toChar1...
     D                 PR             1a
     D                                     extproc('toChar1')
     D  i_integer                    10i 0 const

     D toChar2...
     D                 PR             2a
     D                                     extproc('toChar2')
     D  i_integer                    10i 0 const
     D  i_rplcSpace                   1a   const options(*nopass)

     D toChar4...
     D                 PR             4a
     D                                     extproc('toChar4')
     D  i_integer                    10i 0 const
     D  i_rplcSpace                   1a   const options(*nopass)

     D spaces...
     D                 PR           256a   varying
     D                                     extproc('spaces')
     D  i_length                     10i 0 const

     D getPrdLib...
     D                 PR            10a   extproc('getPrdLib')

       //  Qualified object name
     d qObj_t          DS                  qualified based(pDummy)
     d  name                         10a
     d  lib                          10a

     D INDENT_1        C                   16
     D INDENT_2        C                   20

     D FALSE           C                   *off
     D TRUE            C                   *on

     D C_DELIM         C                   ';'
     D MSGID           C                   '%%MSGID'
     D MSGTXT          C                   '%%MSGTXT'
     D MSGF            C                   '%%MSGF'
     D MSGL            C                   '%%MSGL'
     D PGM             C                   '%%PGM'
     D VARTYPE         C                   '%%VARTYPE'
     D VARNAME         C                   '%%VARNAME'
     D DELIMITER       C                   '%%DELIMITER'
     D STRUCTNAME      C                   '%%STRUCTNAME'
     D DS_NAME         C                   '%%DS'
     D INIT_VALUE      C                   '%%IV'
     D FIELD_NAME      C                   '%%FLDNME'
     D FROM            C                   '%%FR'
     D TO              C                   '%%TO'
     D LENGTH          C                   '%%LN'

       //  Offset for SUBST
       //  ... PTF applied or version V4R3 and above
     D PTF_OFFSET      C                   1

       // Main procedure
     D CRTMSGDSR2...
     D                 pr
     D  gi_msgFLib                   10a   const                                Msg-Lib
     D  gi_msgF                      10a   const                                Msg-File
     D  gi_msgFText                  50a   const                                Msg-File-Text
     D  gi_msgId                      7a   const                                Msg-ID
     D  gi_copyFLib                  10a   const                                Cpy-Lib
     D  gi_copyF                     10a   const                                Cpy-File
     D  gi_genType                   10a   const                                Gener.Art
     D  gi_isDefine                    n   const                                Define-Best.
     D  gi_isCrtMsgF                   n   const                                CrtMsgF-Befehl
     D  gi_isFirstId                   n   const                                1. Msg-ID
     D  gi_isLastId                    n   const                                Letzte Msg-ID
     D  go_mbrText                   80a                                        MbrText
     D  go_excId                      7a                                        Error-ID
     D  go_excDta                    80a                                        Error-Data

      /DEFINE SDS_EXTENDED
      /COPY QCRTMSGDS,SDS

       //****************************************************************
       //  Main procedure
       //****************************************************************
     P CRTMSGDSR2...
     P                 b                   export
     D                 pi
     D  gi_msgFLib                   10a   const                                Msg-Lib
     D  gi_msgF                      10a   const                                Msg-File
     D  gi_msgFText                  50a   const                                Msg-File-Text
     D  gi_msgId                      7a   const                                Msg-ID
     D  gi_copyFLib                  10a   const                                Cpy-Lib
     D  gi_copyF                     10a   const                                Cpy-File
     D  gi_genType                   10a   const                                Gener.Art
     D  gi_isDefine                    n   const                                Define-Best.
     D  gi_isCrtMsgF                   n   const                                CrtMsgF-Befehl
     D  gi_isFirstId                   n   const                                1. Msg-ID
     D  gi_isLastId                    n   const                                Letzte Msg-ID
     D  go_mbrText                   80a                                        MbrText
     D  go_excId                      7a                                        Error-ID
     D  go_excDta                    80a                                        Error-Data

     D srcLine         S                   like(srcLine_t)

       //  Retrieve Message (QMHRTVM) API
     d QMHRTVM...
     d                 PR                  extpgm('QMHRTVM')
     d  o_msgInf                  65535a          options(*varsize)
     d  i_msgInfLen                  10i 0 const
     d  i_format                      8a   const
     d  i_msgID                       7a   const
     d  i_qMsgF                            const  likeds(qObj_t)
     d  i_rplData                 65535a   const  options(*varsize )
     d  i_rpldataLen                 10i 0 const
     d  i_rplVars                    10a   const
     d  i_rtnCtrlChrs                10a   const
     d  io_ErrCode                65535a          options(*varsize )
     d  i_rtvOpt                     10a   const  options(*nopass  )            | OptGrp 1
     d  i_toCcsid                    10i 0 const  options(*nopass  )            |
     d  i_ccsidRplDta                10i 0 const  options(*nopass  )            |

       //  Record format RTVM0300
     D MS0300          DS
     D M3TRTN                        10i 0
     D M3TVAL                        10i 0
     D M3MSSV                        10i 0
     D M3ALID                        10i 0
     D M3ALOP                         9a
     D M3LGIN                         1a
     D M3MGID                         7a
     D M3RES1                         3a
     D M3NSVF                        10i 0
     D M3CSIT                        10i 0
     D M3CSIR                        10i 0
     D M3CCIT                        10i 0
     D M3OFDR                        10i 0
     D M3LGDR                        10i 0
     D M3LDRA                        10i 0
     D M3OFMG                        10i 0
     D M3LGMR                        10i 0
     D M3LMRA                        10i 0
     D M3OFMH                        10i 0
     D M3LGMH                        10i 0
     D M3LMHA                        10i 0
     D M3OFVF                        10i 0
     D M3LGVF                        10i 0
     D M3LVFA                        10i 0
     D M3LVFE                        10i 0
     D M3RES2                       152a
     D M3DATA                      7936a

       // Format of replacement variable
     D MS030F          DS
     D M3FLGD                        10i 0
     D M3FFSZ                        10i 0
     D M3FTYP                        10a
     D M3FRS1                       238a
     D M3FRS2                       256a

       // Generic API error structure
     D errCode         DS                  qualified
     D  bytPrv                       10i 0 inz
     D  bytAvl                       10i 0 inz
     D  excID                         7a   inz
     D  reserved_1                    1a   inz
     D  excDta                       16a   inz

       // Message ID parts
     D msgIdDS         DS                  qualified
     D prfx                           3a   inz
     D  prfx1ch                       1a   inz overlay(prfx)
     D nbr                            4a   inz

       // 6-char RPG field name
     D field6          DS                  qualified
     D  prfx                          1a
     D  nbr                           4a
     D  count                         3a

       // 10-char ILE-RPG field name
     D field10         DS                  qualified
     D  prfx                          3a
     D  nbr                           4a
     D  count                         5a

      // C field name and type
     D c_fldName       S             40a
     D c_fldType       S             40a

      // Return format control characters *YES or *NO
     D rtnFmtCtrlChrs  S             10a

      // Various buffers for message description data
     D msgText         S           8192a
     D msgHelp         S           8192a
     D rplcVars        S           8192a

      // General purpose index variable
     D i               S             10i 0

      // Buffer for building temporary strings
     D tmpStr          S             80a   varying

       //  Global variable: message file
     D qMsgF           ds                  likeds(qObj_t)

       // Offset replacement variables
     D rplcVarOffs     S             10i 0

       // Sub-field counter
     D OD              S             10i 0

       // laufender Zähler Variablenverarbeitung
     D rplcVarIdx      S             10i 0

       // Total length of data structure
     D lenStruct       S             10i 0

       // Total number of replacement variables
     D rplcVarCount    S             10i 0

       // Type and length of replacement variable
     D rplcVar         DS                  qualified
     D  length                       10i 0
     D  packedLen                    10i 0
     D  fraction                     10i 0
     D  type                          1a

      // Buffer for generating message text and message help
     D buffer          S           8192a   varying

       // Name for DEFINE compiler directive
     D defineName      S             20a   varying

       // Generic message file name
     D qGenMsgF        ds                  likeds(qObj_t)
      /free

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
       IF (gi_genType = '*CLP'   )  or
          (gi_genType = '*CLLE'  )  or
          (gi_genType = '*SCRIPT');
          // Return format control characters
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

       //*****************************************************
       // Select the type of source that is generated
       //*****************************************************
       BEGSR performOperation;

          SELECT;

          WHEN gi_genType = '*RPG';
             qGenMsgF.lib = gi_msgFLib;
             qGenMsgF.name = gi_msgF;
             EXSR performRPG3;

          WHEN gi_genType = '*ILERPG';
             qGenMsgF.lib = gi_msgFLib;
             qGenMsgF.name = gi_msgF;
             EXSR performRPG4;

          WHEN gi_genType = '*CLP'
             OR gi_genType = '*CLLE';
             qGenMsgF.lib = '&LIB';
             qGenMsgF.name = '&OBJ';
             EXSR performCLP;

          WHEN gi_genType = '*C';
             EXSR performC;

             // Process *SCRIPT as *CLP but drop some statements
          WHEN gi_genType = '*SCRIPT';
             qGenMsgF.lib = '&LI';
             qGenMsgF.name = '&SF';
             EXSR performCLP;

          OTHER;

          ENDSL;

       ENDSR;

       //*****************************************************
       // Generate RPG source code
       //*****************************************************
       BEGSR performRPG3;

          // Comment line (dashes)
          writeLine(RPG(1));

          // Comment line with message ID
          writeLine(%trimr(RPG(2)) + ' ' + gi_msgId);

          // Empty comment line
          writeLine(RPG(3));

          // Comment line with message text
          writeLine(%trimr(RPG(3)) + ' ' + %subst(msgText: 1: 59));

          // Empty comment line
          writeLine(RPG(3));

          // Generate data structure
          EXSR genStructRPG3;
          IF (go_excId <> '');
             LEAVESR;
          ENDIF;

          // Add total length of data structure
          EXSR genTotalLenRPG3;

          // Empty comment line
          writeLine(RPG(3));

       ENDSR;

       //*****************************************************
       // Generate ILE-RPG source code
       //*****************************************************
       BEGSR performRPG4;

          // Generate DEFINE compiler directive
          EXSR genStartDefineRPG4;

          // Comment line (dashes)
          writeLine(IRPG(1));

          // Comment line with message ID
          writeLine(%trimr(IRPG(2)) + ' ' + gi_msgId);

          // Empty line
          writeLine(IRPG(3));

          // Comment line with message text
          writeLine(%trimr(IRPG(14)) + '  ' + %subst(msgText: 1: 59));

          // Empty line
          writeLine('');

          // Generate data structure
          EXSR genStructRPG4;
          IF (go_excId <> '');
             LEAVESR;
          ENDIF;

          // Add total length of data structure
          EXSR genTotalLenRPG4;

          // Empty line
          writeLine(IRPG(3));

          // Generate ENDIF compiler directive
          EXSR genEndDefineRPG4;

       ENDSR;

       //*****************************************************
       // Generate DEFINE compiler directive, part 1
       //*****************************************************
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

       //*****************************************************
       // Generate DEFINE compiler directive, part 2
       //*****************************************************
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

       //*****************************************************
       // Generate CLP source code.
       //*****************************************************
       BEGSR performCLP;

          IF (gi_isFirstId = TRUE);
             IF (gi_genType <> '*SCRIPT');
                // STRPREPRC Header
                FOR i = 1 to %elem(STRPREPRC);
                   srcLine = STRPREPRC(i);
                   SELECT;
                   WHEN %scan('%CMD': srcLine) > 0;
                      IF gi_genType = '*CLP';
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
          EXSR genADDMSGD;
          IF (go_excId <> '');
             LEAVESR;
          ENDIF;

       ENDSR;

       //*****************************************************
       // Generate C source code.
       //*****************************************************
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

       //*****************************************************
       // Generate DEFINE compiler directive, part 1
       //*****************************************************
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

       //*****************************************************
       // Generate DEFINE compiler directive, part 2
       //*****************************************************
       BEGSR genEndDefineC;

          IF (gi_isDefine = FALSE);
             // User did not select generating the DEFINE compiler directive
             LEAVESR;
          ENDIF;

          // #endif
          writeLine(c(10));

       ENDSR;

       //*****************************************************
       // Generate replacement variables, C source code.
       //*****************************************************
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
                   WHEN rplcVar.length = 9;
                      c_fldType = 'long';
                   WHEN rplcVar.length = 4;
                      c_fldType = 'short';
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

       //*****************************************************
       // Generate sub-field, RPG.
       //*****************************************************
       BEGSR genStructRPG3;

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

                   srcLine = replace(srcLine: '?': rplcVar.type: 1);

                   IF (rplcVar.type = 'P' OR rplcVar.type = 'B');
                      srcLine = replace(
                                  srcLine: '!': toChar1(rplcVar.fraction): 1);
                   ELSE;
                      srcLine = replace(srcLine: '!': ' ': 1);
                   ENDIF;

                   // Set 'from' position
                   srcLine = replace(srcLine: FROM: toChar4(OD: '0'));

                   OD = OD + rplcVar.packedLen;

                   // Set 'to' position
                   srcLine = replace(srcLine: TO: toChar4(OD - 1: '0'));

                   // Count total length of structure
                   lenStruct = lenStruct + rplcVar.packedLen;
                ENDIF;

                // Append sub-field
                writeLine(srcLine);

             ENDFOR;

          ENDIF;

       ENDSR;

       //*****************************************************
       // Generate field with total length of structure, RPG.
       //*****************************************************
       BEGSR genTotalLenRPG3;

          // Produce structure without a name
          writeLine(replace(RPG(11): DS_NAME: ''));

          // Create sub-field with total length of strucure
          srcLine = replace(RPG(13): INIT_VALUE: toChar4(lenStruct: '0'));

          // Produce field name
          CLEAR field6;
          field6.prfx = msgIdDS.prfx1ch;
          field6.nbr = msgIdDS.nbr;
          field6.count = 'L';
          srcLine = replace(srcLine: FIELD_NAME: field6);

          writeLine(srcLine);

       ENDSR;

       //*****************************************************
       // Generate sub-field, ILE-RPG.
       //*****************************************************
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

                   // Adjust length for binary fields
                   IF (rplcVar.type = 'B');
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

       //*****************************************************
       // Generate field with total length of structure, ILE-RPG.
       //*****************************************************
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

       //*****************************************************
       // Generate replacement variables, CLP source code.
       //*****************************************************
       BEGSR genADDMSGD;

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

                SELECT;
                WHEN rplcVar.type = 'B';
                   srcLine = %trimr(srcLine) + '*BIN';
                   SELECT;
                   WHEN rplcVar.length >= 10;
                      rplcVar.length = 8;
                   WHEN rplcVar.length >= 5;
                      rplcVar.length = 4;
                   OTHER;
                      rplcVar.length = 2;
                   ENDSL;
                OTHER;
                   srcLine = %trimr(srcLine) + M3FTYP;
                ENDSL;

                // ... field length
                srcLine = %trimr(srcLine) + ' ' + str(rplcVar.length);

                // ... fraction
                IF (rplcVar.type = 'P' OR rplcVar.type = 'B');
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

          IF (gi_isLastId = TRUE AND gi_genType <> '*SCRIPT');
             // RCLRSC
             writeLine(CLP(12));

             // Empty line
             writeLine('');

             // ENDPGM
             writeLine(CLP(13));
          ENDIF;

       ENDSR;

       //*****************************************************
       // Adds a "Open bracket".
       //*****************************************************
       BEGSR addOpenBracket;

          srcLine =
            %trimr(srcLine) + '(';

       ENDSR;

       //*****************************************************
       // Adds a "Close bracket".
       //*****************************************************
       BEGSR addCloseBracket;

          srcLine = %trimr(srcLine) + ') +';

       ENDSR;

       //*****************************************************
       // Verifies the data type of a given replacement variable
       //*****************************************************
       BEGSR chkRplVarType;

          IF (M3FTYP <> '*QTDCHAR' and
             M3FTYP <> '*CHAR' and
             M3FTYP <> '*DEC' and
             M3FTYP <> '*HEX' and
             M3FTYP <> '*BIN');
             go_excId = 'CPF9897';
             go_excDta = 'MSG-ID: ' + %trim(M3MGID) +
                     ' unknown data type: ' +
                     %trim(M3FTYP);
          ENDIF;

       ENDSR;

       //*****************************************************
       // Returns the number of replacement variables
       //*****************************************************
       BEGSR getRplVarCount;

          IF (M3LGVF > 0);
             rplcVarCount = M3LGVF / M3LVFE;
          ELSE;
             rplcVarCount = 0;
          ENDIF;

       ENDSR;

       //*****************************************************
       // Returns a replacement variable
       //*****************************************************
       BEGSR getRplVar;

          CLEAR MS030F;
          MS030F = %subst(rplcVars: rplcVarOffs: M3LVFE);
          rplcVarOffs = rplcVarOffs + M3LVFE;

       ENDSR;

       //*****************************************************
       // Returns the length and type of the current
       // replacement variable.
       //*****************************************************

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

          ENDSL;

       ENDSR;

       //*****************************************************
       // Error handler
       //*****************************************************
       BEGSR *PSSR;

          DUMP;

       ENDSR;

      /end-free
     P                 e

       //*****************************************************
       // Appends a line to the source file.
       //*****************************************************
     P writeLine...
     P                 B
     D                 PI
     D  io_srcLine                         const like(srcLine_t)
      /free

          FSRC.SRCSEQ = FSRC.SRCSEQ + ,01;
          FSRC.SRCDAT = 0;
          FSRC.SRCDTA = io_srcLine;
          WRITE SRC FSRC;

      /end-free
     P                 E

       //*****************************************************
       // Splitts a given string to multiple lines
       //*****************************************************
     P splittLine...
     P                 B
     D                 PI
     D  buffer                     8192a   value varying

     D LINE_LENGTH     C                   70
     D spX             S             10i 0
     D spS             S             10i 0

     D srcLine         S                   like(srcLine_t)
      /free

          spX = 0;

          DOW (buffer <> '');

             spS = 1;

             if (%len(buffer) >= LINE_LENGTH);
                srcLine = %subst(buffer: spS: LINE_LENGTH);
             ELSE;
                srcLine = buffer;
             ENDIF;

             spS = spS + LINE_LENGTH;
             IF (spS < %len(buffer));
                buffer = %subst(buffer: spS);
             ELSE;
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

      /end-free
     P                 E
       //*****************************************************
       // Replaces the hyphens of a given strin with
       // double-hyphens.
       //*****************************************************
     P doubleHyphens...
     P                 B
     D                 PI          8192a   varying
     D  buffer                     8192a   value varying

     D dhF             S             10i 0
     D dhL             S             10i 0
      /free

          dhF = 1;

          DOU (dhF <= 0);

             dhF = %scan('''': buffer: dhF);
             IF (dhF > 0);
                IF (dhF < %len(buffer));
                   //  Insert single quote
                   buffer = %replace('''': buffer: dhF: 0);
                   dhF = dhF + 2;
                   dhL = dhL + 1;
                ENDIF;
             ENDIF;

          ENDDO;

       return buffer;

      /end-free
     P                 E

       //****************************************************************
       //  Replace variables
       //****************************************************************
     P replace...
     P                 B
     D                 PI           256a
     D  i_string                    256a   value
     D  i_var                        20a   value
     D  i_value                     256a   value
     D  i_length                     10i 0 value options(*nopass)

     D p_length        C                   4

     D length          S                   like(i_length)

     D start           S             10i 0 inz
     D lenRpl          S             10i 0 inz
     D lenVal          S             10i 0 inz
     D i               S             10i 0 inz
       //---------------------------------------------------------------
      /free

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

      /end-free
     P                 E

       //****************************************************************
       //  set to lower
       //****************************************************************
     P lcase...
     P                 B
     D                 PI           256a
     D  i_string                    256a   value

     D uc              C                   const('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D lc              C                   const('abcdefghijklmnopqrstuvwxyz')
       //---------------------------------------------------------------
      /free

       %SUBST(i_string:1:%SIZE(i_string)) =
       %XLATE(uc:lc:i_string);

       RETURN i_string;

      /end-free
     P                 E

       //****************************************************************
       //  convert to char
       //****************************************************************
     P str...
     P                 B
     D                 PI           256a
     D  i_value                      10i 0 value
       //---------------------------------------------------------------
      /free

       IF (i_value = 0);
          RETURN '0';
       ENDIF;

       RETURN %triml(%editc(i_value: 'Z'));

      /end-free
     P                 E

       //****************************************************************
       //  c structure name
       //****************************************************************
     P getStructName...
     P                 B
     D                 PI            20a   varying
     D  i_msgId                       7a   const
       //---------------------------------------------------------------
      /free

       RETURN %trim(lcase(i_msgId)) + '_t';

      /end-free
     P                 E

       //****************************************************************
       //  convert integer to character 1, edit code 3
       //****************************************************************
     P toChar1...
     P                 B
     D                 PI             1a
     D  i_integer                    10i 0 const
       //---------------------------------------------------------------
      /free

       RETURN %editc(%dec(i_integer: 1: 0): '3');

      /end-free
     P                 E

       //****************************************************************
       //  convert integer to character 2, edit code 3
       //****************************************************************
     P toChar2...
     P                 B
     D                 PI             2a
     D  i_integer                    10i 0 const
     D  i_rplcSpace                   1a   const options(*nopass)
      //---------------------------------------------------------------
      /free

       IF (%parms() >= 2);
          RETURN %xlate(' ': i_rplcSpace :%editc(%dec(i_integer: 2: 0): '3'));
       ELSE;
          RETURN %editc(%dec(i_integer: 2: 0): '3');
       ENDIF;

      /end-free
     P                 E

       //****************************************************************
       //  convert integer to character 4, edit code 3
       //****************************************************************
     P toChar4...
     P                 B
     D                 PI             4a
     D  i_integer                    10i 0 const
     D  i_rplcSpace                   1a   const options(*nopass)
       //---------------------------------------------------------------
      /free

       IF (%parms() >= 2);
          RETURN %xlate(' ': i_rplcSpace :%editc(%dec(i_integer: 4: 0): '3'));
       ELSE;
          RETURN %editc(%dec(i_integer: 4: 0): '3');
       ENDIF;

      /end-free
     P                 E

       //****************************************************************
       //  returns a string of spaces
       //****************************************************************
     P spaces...
     P                 B
     D                 PI           256a   varying
     D  i_length                     10i 0 const

     D SPACES          S            256a   inz
       //---------------------------------------------------------------
      /free

       RETURN %subst(SPACES: 1: i_length);

      /end-free
     P                 E

       //****************************************************************
       //  returns the name of the product library
       //****************************************************************
     P getPrdLib...
     P                 B                   export
     D                 PI            10a
       //---------------------------------------------------------------
      /free

       RETURN sds.pgmLib;

      /end-free
     P                 E
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
      * %%FLDNME>>                 0000A   inz(*BLANKS)  Length = 0
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
