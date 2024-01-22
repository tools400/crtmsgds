/* =================================================================== */
/*                                                                     */
/*  Kurzdokumentation :                                                */
/*                                                                     */
/*  Bereich . . . : CRTMSGDS                                           */
/*  Objekt  . . . : CRTMSGDS                                           */
/*  Beschreibung  : Create Message Data Structure - Eng                */
/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      */
/*  Datum . . . . : 01.06.2002                                         */
/*                                                                     */
/* =================================================================== */
/*                                                                     */
/*  This software is free software, you can redistribute it and/or     */
/*  modify it under the terms of the GNU General Public License (GPL)  */
/*  as published by the Free Software Foundation.                      */
/*                                                                     */
/*  See GNU General Public License for details.                        */
/*          http://www.opensource.org                                  */
/*          http://www.opensource.org/licenses/gpl-license.html        */
/*                                                                     */
/* =================================================================== */
/*  History:                                                           */
/*                                                                     */
/*  Datum       Name          Änderung                                 */
/*  ----------  ------------  ---------------------------------------  */
/*                                                                     */
/* =================================================================== */
/* >>PRE-COMPILER<<                                                    */
/*                                                                     */
/*   >>CRTCMD<< CRTCMD       CMD(&LI/CRTMSGDS) +                       */
/*                           SRCFILE(&SL/&SF) +                        */
/*                           SRCMBR(&SM);                              */
/*                                                                     */
/*   >>COMPILE<<                                                       */
/*     >>PARM<< PGM(&LI/CRTMSGDSC);                                    */
/*     >>PARM<< HLPPNLGRP(&LI/CRTMSGDSP);                              */
/*     >>PARM<< HLPID(CRTMSGDS);                                       */
/*   >>END-COMPILE<<                                                   */
/*                                                                     */
/*   >>EXECUTE<<                                                       */
/*                                                                     */
/* >>END-PRE-COMPILER<<                                                */
/* =================================================================== */

             CMD        PROMPT('Create Message Data Structure')

             PARM       KWD(RANGE)                                  +
                          TYPE(QMSGR)                               +
                          SNGVAL(                                   +
                            (*ALL ))                                +
                          PROMPT('Range of message identifiers')

             PARM       KWD(MSGF)                                   +
                          TYPE(QMSGF)                               +
                          CHOICE(*NONE)                             +
                          PROMPT('Message file')

             PARM       KWD(FILE)                                   +
                          TYPE(QCPYF)                               +
                          PROMPT('File')

             PARM       KWD(MBR)                                    +
                          TYPE(*NAME)                               +
                          DFT(*GEN)                                 +
                          SPCVAL((*GEN))                            +
                          PROMPT('Member')

             PARM       KWD(REPLACE)                                +
                          TYPE(*CHAR)                               +
                          LEN(1)                                    +
                          RSTD(*YES)                                +
                          DFT(*NO)                                  +
                          SPCVAL((*NO     N)                        +
                                 (*YES    Y))                       +
                          MIN(0)                                    +
                          PROMPT('Replace member')

             PARM       KWD(TYPE)                                   +
                          TYPE(*CHAR)                               +
                          LEN(1)                                    +
                          RSTD(*YES)                                +
                          DFT(*ILERPG)                              +
                          SPCVAL(                                   +
                                 (*FREE   7)                        +
                                 (*ILERPG 4)                        +
                                 (*RPG    3)                        +
                                 (*CL     8)                        +
                                 (*C      5)                        +
                                 (*CLP    1)                        +
                                 (*CLLE   6)                        +
                                 (*SCRIPT 2)                        +
                                            )                       +
                          MIN(0)                                    +
                          PROMPT('Source type')

             PARM       KWD(DEFINE)                                 +
                          TYPE(*CHAR)                               +
                          LEN(1)                                    +
                          RSTD(*YES)                                +
                          DFT(*NO )                                 +
                          SPCVAL((*YES    1)                        +
                                 (*NO     0))                       +
                          MIN(0)                                    +
                          PMTCTL(PMTCTL1)                           +
                          PROMPT('Add DEFINE specifications')

             PARM       KWD(CRTMSGF)                                +
                          TYPE(*CHAR)                               +
                          LEN(1)                                    +
                          RSTD(*YES)                                +
                          DFT(*NO )                                 +
                          SPCVAL((*YES    1)                        +
                                 (*NO     0))                       +
                          MIN(0)                                    +
                          PMTCTL(PMTCTL2)                           +
                          PROMPT('Add CRTMSGF command')

QMSGF:       QUAL       TYPE(*NAME)                                 +
                          LEN(10)                                   +
                          DFT(QCPFMSG)                              +
                          EXPR(*YES)
             QUAL       TYPE(*NAME)                                 +
                          LEN(10)                                   +
                          DFT(*LIBL)                                +
                          SPCVAL((*LIBL    )                        +
                                 (*CURLIB  ))                       +
                          EXPR(*YES)                                +
                          PROMPT('Library')

QCPYF:       QUAL       TYPE(*NAME)                                 +
                          LEN(10)                                   +
                          DFT(QCOPYLE)                              +
                          EXPR(*YES)
             QUAL       TYPE(*NAME)                                 +
                          LEN(10)                                   +
                          DFT(*LIBL)                                +
                          SPCVAL((*LIBL    )                        +
                                 (*CURLIB  ))                       +
                          EXPR(*YES)                                +
                          PROMPT('Library')

QMSGR:       ELEM       TYPE(*NAME)                                 +
                          LEN(7)                                    +
                          DFT(*FIRST)                               +
                          SPCVAL((*FIRST   ))                       +
                          FULL(*YES)                                +
                          EXPR(*YES)                                +
                          PROMPT('Lower value')
             ELEM       TYPE(*NAME)                                 +
                          LEN(7)                                    +
                          DFT(*ONLY)                                +
                          SPCVAL((*ONLY    )                        +
                                 (*LAST    ))                       +
                          FULL(*YES)                                +
                          EXPR(*YES)                                +
                          PROMPT('Upper value')

 /* Einblenden DEFINE         */
 PMTCTL1:    PMTCTL     CTL(TYPE)                                   +
                          COND((*EQ 4)                              +
                               (*EQ 5))                             +
                          NBRTRUE(*EQ 1)

 /* Einblenden CRTMSGF        */
 PMTCTL2:    PMTCTL     CTL(TYPE)                                   +
                          COND((*EQ 1)                              +
                               (*EQ 6))                             +
                          NBRTRUE(*EQ 1)

