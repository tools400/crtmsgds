/* -------------------------------------------------------------------------- */
/* CRTMSGDS   - SCRIPT MEMBER                                                 */
/* Use commands  xmlgenINC (generate text for install pgm)                    */
/*               xmlgenMBR (to define source members                          */
/*               xmlgenCMD (execute qcmdexc at run time                       */
/* Put &TOLIB where you want user selected lib at run time.                   */
   DCL &TOLIB *CHAR 10
/* -------------------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QCRTMSGDS) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Select language (GER, ENG)') +
                          XVALUES(GER ENG) XVAR(&LANG)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QCRTMSGDS)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_ENG ) XMBRATR(CLP   ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_GER ) XMBRATR(CLP   ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*CMD    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CRTMSGDSG ) XMBRATR(CMD   ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*CMD    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CRTMSGDSE ) XMBRATR(CMD   ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*CMD    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CRTMSGDSC ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CRTMSGDSPG) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CRTMSGDSPE) XMBRATR(PNLGRP) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CRTMSGDSR1) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CRTMSGDSR2) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(H_SPEC    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QCRTMSGDS ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QCRTMSGDS ) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QCRTMSGDS) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&LANG'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

