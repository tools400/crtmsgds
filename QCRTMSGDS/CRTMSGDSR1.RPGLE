**free
// ===================================================================
//
//  Kurzdokumentation :
//
//  Bereich . . . : CRTMSGDS
//  Objekt  . . . : CRTMSGDSR1
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
//  10.01.2003  Th.Raddatz    Removed special character Ä from source.
//
//  02.02.2022  Th.Raddatz    Converted source code to /free.
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
ctl-opt nomain;
/COPY QCRTMSGDS,H_SPEC
/COPY QCRTMSGDS,COPYRIGHT
// ===================================================================

//  Qualified object name
dcl-ds qObj_t qualified based(pdummy);
  name char(10);
  lib char(10);
end-ds;

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

//  Program entry point

//***************************************************************
//  resolve message id
//***************************************************************
dcl-proc CRTMSGDSR1 export;
  dcl-pi *n;
    XMSGL char(10) const; // Msg-Lib
    XMSGF char(10) const; // Msg-File
    XMSGI char(7) const; // Msg-Id
    XRTVO char(7) const; // Retrieve option
    XMSGR char(7); // Msg-Id Returned
    XERRID char(7); // Error-Id
    XERRDT char(80); // Error-Data
  end-pi;


  dcl-ds errCode qualified;
    bytPrv int(10) inz;
    bytAvl int(10) inz;
    excID char(7) inz;
    reserved_1 char(1) inz;
    excDta char(16) inz;
  end-ds;

  dcl-ds qMsgF likeds(qobj_t) inz;

  dcl-ds rtvm0300 qualified;
    msgId char(7) pos(27);
  end-ds;

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

end-proc;
