       // =================================================================== *
       //                                                                     *
       //  Kurzdokumentation :                                                *
       //                                                                     *
       //  Bereich . . . : CRTMSGDS                                           *
       //  Objekt  . . . : CRTMSGDSR1                                         *
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
       //  10.01.2003  Th.Raddatz    Removed special character Ä from source. *
       //                                                                     *
       //  24.12.2018  Th.Raddatz    Converted source code to /free.          *
       //                                                                     *
       // =================================================================== *
       // >>PRE-COMPILER<<                                                    *
       //   >>CRTCMD<< CRTBNDRPG    PGM(&LI/&OB) +                            *
       //                           SRCFILE(&SL/&SF) SRCMBR(&SM);             *
       //   >>IMPORTANT<<                                                     *
       //     >>PARM<< DBGVIEW(*LIST);                                        *
       //     >>PARM<< OPTION(*EVENTF);                                       *
       //     >>PARM<< DFTACTGRP(*NO);                                        *
       //     >>PARM<< ACTGRP(*CALLER );                                      *
       //   >>END-IMPORTANT<<                                                 *
       //   >>EXECUTE<<                                                       *
       // >>END-PRE-COMPILER<<                                                *
       // =================================================================== *
      /COPY QCRTMSGDS,H_SPEC
      /COPY QCRTMSGDS,COPYRIGHT
       // =================================================================== *

       //  Qualified object name
     d qObj_t          ds                  qualified based(pDummy)
     d  name                         10a
     d  lib                          10a

       //  Retrieve Message (QMHRTVM) API
     d QMHRTVM...
     d                 pr                  extpgm('QMHRTVM')
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
     D rtvm0300        DS                  qualified
     D msgId                  27     33

       // API error code structure
     D errCode         DS                  qualified
     D  bytPrv                       10I 0 INZ
     D  bytAvl                       10I 0 INZ
     D  excID                         7A   INZ
     D  reserved_1                    1A   INZ
     D  excDta                       16A   INZ

       // Global variable: message file
     D qMsgF           ds                  likeds(qObj_t) inz

       //  Program entry point
     D CRTMSGDSR1...
     D                 pr                  extpgm('CRTMSGDSR1')
     D  XMSGL                        10A   const                                Msg-Lib
     D  XMSGF                        10A   const                                Msg-File
     D  XMSGI                         7A   const                                Msg-Id
     D  XRTVO                         7A   const                                Retrieve option
     D  XMSGR                         7A                                        Msg-Id Returned
     D  XERRID                        7A                                        Error-Id
     D  XERRDT                       80A                                        Error-Data

     D CRTMSGDSR1...
     D                 pi
     D  XMSGL                        10A   const                                Msg-Lib
     D  XMSGF                        10A   const                                Msg-File
     D  XMSGI                         7A   const                                Msg-Id
     D  XRTVO                         7A   const                                Retrieve option
     D  XMSGR                         7A                                        Msg-Id Returned
     D  XERRID                        7A                                        Error-Id
     D  XERRDT                       80A                                        Error-Data
      /free

       // Initialize return values
       XMSGR  = '';
       XERRID = '';
       XERRDT = '';

       // Call the retrieve message description API
       clear errCode;

       qMsgF.name = XMSGF;
       qMsgF.lib = XMSGL;

       callp(E) QMHRTVM(rtvm0300: %size(rtvm0300): 'RTVM0300'
               : XMSGI: qMsgF: '': 0: '*NO'
               : '*NO': errCode: XRTVO: 0
               : 0);

       // Check error indicator
       if (%error());
          XERRID = 'CPF9897';
          XERRDT = 'Error: ' + %trim(qMsgF.lib) + '/' +
                              %trim(qMsgF.name) +
                  ' Id: ' + %trim(XMSGI) +
                  ' Opt: ' + %trim(XRTVO);
       else;
          if (errCode.bytAvl > 0);
             XERRID = errCode.excID;
             XERRDT = errCode.excDta;
          else;
             XMSGR = rtvm0300.msgId;
          endif;
       endif;

       return;

      /end-free
