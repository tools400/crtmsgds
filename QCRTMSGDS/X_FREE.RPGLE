**free
// ---------------------------------------------------------------
//  Data structure for message ID: USR0001
//  A test message with replacement variables.
dcl-ds USR0001 qualified;
  var1  char(10) inz;
  var2  char(20) inz;
  var3  char(12) inz;
  var4  packed(15:5) inz;
  var5  int(20) inz;
  var6  int(10) inz;
  var7  int(5) inz;
  var8  uns(20) inz;
  var9  uns(10) inz;
  varA  uns(5) inz;
end-ds;
**free
// ---------------------------------------------------------------
//  Data structure for message ID: USR0002
//  A test message without replacement variables.
dcl-ds USR0002 qualified;
      //  No replacement variables available!
end-ds;
