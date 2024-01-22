      // ---------------------------------------------------------------
      //  Data structure for message ID: USR0001
      //  A test message with replacement variables.
     d USR0001         ds
     d  USR00011                     10A   inz(*BLANKS)
     d  USR00012                     20A   inz(*BLANKS)
     d  USR00013                     12A   inz(*BLANKS)
     d  USR00014                     15P 5 inz(*ZEROS )
     d  USR00015                     20I 0 inz(*ZEROS )
     d  USR00016                     10I 0 inz(*ZEROS )
     d  USR00017                      5I 0 inz(*ZEROS )
     d  USR00018                     20U   inz(*ZEROS )
     d  USR00019                     10U   inz(*ZEROS )
     d  USR0001A                      5U   inz(*ZEROS )
     d USR0001_SIZE    s             10I 0 inz(78)
      // ---------------------------------------------------------------
      //  Data structure for message ID: USR0002
      //  A test message without replacement variables.
     d USR0002         ds
      //  No replacement variables available!
     d USR0002_SIZE    s             10I 0 inz(0)
