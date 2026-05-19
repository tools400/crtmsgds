**FREE
// ---------------------------------------------------------------
//  Data structure for message ID: USR0001
//  A test message with replacement variables.
dcl-ds USR0001;
  USR00011        char(10) inz(*BLANKS);
  USR00012        char(20) inz(*BLANKS);
  USR00013        char(12) inz(*BLANKS);
  USR00014        packed(15:5) inz(*ZEROS );
  USR00015        int(20) inz(*ZEROS );
  USR00016        int(10) inz(*ZEROS );
  USR00017        int(5) inz(*ZEROS );
  USR00018        uns(20) inz(*ZEROS );
  USR00019        uns(10) inz(*ZEROS );
  USR0001A        uns(5) inz(*ZEROS );
end-ds;
dcl-s USR0001_SIZE    int(10) inz(78);
// ---------------------------------------------------------------
//  Data structure for message ID: USR0002
//  A test message without replacement variables.
dcl-ds USR0002;
end-ds;
//  No replacement variables available!
dcl-s USR0002_SIZE    int(10) inz(0);
