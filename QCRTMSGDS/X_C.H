  /* --------------------------------------------------------------------- */
  /*   Data structure for message-ID : USR0001                             */
  /*   A test message with replacement variables.                          */
  /* --------------------------------------------------------------------- */

  typedef _Packed struct {
    char                 d1[10];
    char                 d2[20];
    char                 d3[12];
    decimal(15,5)        d4;
    long long            d5;
    long                 d6;
    short                d7;
    unsigned long long   d8;
    unsigned long        d9;
    unsigned short       dA;
  } usr0001_t;
  /* --------------------------------------------------------------------- */
  /*   Data structure for message-ID : USR0002                             */
  /*   A test message without replacement variables.                       */
  /* --------------------------------------------------------------------- */

  typedef _Packed struct {
    char                 dummy;
  } usr0002_t;
