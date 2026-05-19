# CRTMSGDS - A Tools/400 Utility

CRTMSGDS is a utility that was first developed for generating RPG data
structures for the parameters of IBM i message descriptions. Meanwhile
it has been enhanced to also generate CL source members with ADDMSGD
commands.

## Dependencies

Dependencies:

None.

## Installation

Compile members with the following PDM option:

   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO)
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)
     USER1(*LIST) USER2(*FULL)

Members of type MAKPGM or BND are used for linking programs (MAKPGM)
and service programs (BND).

The [STRPREPRC](https://github.com/tools400/strpreprc) utility is used for compiling the members. The utility retrieves object creation parameters from the source member that is compiled and building and executing the final object creation command.

---

2018, Thomas Raddatz
