//#define IE5
//#define LA1
//#define LA3
//#define LA7
//#define LE1
//#define LI1
//#define TM2
#define IR13

#define P2         (2)
#define P3         (3)
#define P4         (4)
#define P5         (5)
#define P6         (6)
#define P7         (7)
#define P8         (8)
#define P9         (9)
#define P10        (10)
#define P11        (11)
#define P12        (12)
#define P13        (13)

void setup()
{
  setup_Ir13();

  // Serial
  Serial.begin(9600);
  while (!Serial) {}
}

void loop()
{
  loop_Ir13();
}
