/*
------------------------------------------------------
К155ИР13
Синхронный регистр сдвига

     --------------
11 -| C  | RG |    |
    |----|    |    |
 2 -| DR |    | Q0 |- 4
22 -| DL |    | Q1 |- 6
    |----|    | Q2 |- 8
 3 -| D0 |    | Q3 |- 10
 5 -| D1 |    | Q4 |- 14
 7 -| D2 |    | Q5 |- 16
 9 -| D3 |    | Q6 |- 18
15 -| D4 |    | Q7 |- 20
17 -| D5 |    |    |
19 -| D6 |    |    |
21 -| D7 |    |    |
    |----|    |    |
 1 -| S0 |    |    |
23 -| S1 |    |    |
    |----|    |    |
13 -o R  |    |    |
     --------------

  P3 P8 P6 P4           +5V  P5 P7 P9 P2 
  |  |  |  |     ------  |   |  |  |  |
  |  |  |  *-1 -|*     |-*24 |  |  |  |
  |  |  *----2 -|      |- 23-*  |  |  |
  |  *-------3 -|      |- 22----*  |  |
  |       *--4 -|      |- 21-*     |  |
  |       *--5 -|      |- 20-|-----*  |
  |     *----6 -|      |- 19-|--*     |
  |     *----7 -|      |- 18-*  |     |
  |       *--8 -|      |- 17----|--*  |
  |       *--9 -|      |- 16----*  |  |
  |    *----10 -|      |- 15--*    |  |
  *----|----11 -|      |- 14--|----*  |
       |    12*-|      |- 13--|-------*
       |      |  ------       |
       |      GND             |
       *---------------------*
-----------------------------------------------------
*/
#ifdef IR13

typedef struct _ir13_Record_
{
  byte R;
  byte C;
  byte S0;
  byte S1;
  byte DR;
  byte DL;
  byte D0;
  byte Q7;
} IR13_Record;

IR13_Record ir13_params[] = 
{
  //R  C  S0 S1 DR DL D0 Q7
  { 0, 0, 0, 0, 0, 0, 0, 0 }, // RESET
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 1
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 2
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 3
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 4
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 5
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 6
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 7
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 1 }, // 8
  { 1, 0, 1, 1, 0, 0, 1, 1 },
  { 0, 0, 0, 0, 0, 0, 0, 0 },
  { 1, 0, 1, 1, 0, 0, 1, 0 },
  { 1, 1, 1, 1, 0, 0, 1, 0 }, // 1
  { 1, 0, 0, 1, 0, 0, 0, 0 },
  { 1, 1, 0, 1, 0, 0, 0, 0 },//shift left
  { 1, 0, 0, 1, 0, 1, 0, 0 },
  { 1, 1, 0, 1, 0, 1, 0, 1 },//shift left
  { 1, 0, 0, 0, 0, 0, 0, 1 },
  { 0, 0, 0, 0, 0, 0, 0, 0 }, // RESET
  { 1, 0, 0, 0, 0, 0, 0, 0 },

};

void setup_Ir13()
{
  pinMode(P2, OUTPUT); //R
  pinMode(P3, OUTPUT); //C
  pinMode(P4, OUTPUT); //S0
  pinMode(P5, OUTPUT); //S1
  pinMode(P6, OUTPUT); //DR
  pinMode(P7, OUTPUT); //DL
  pinMode(P8, OUTPUT); //D0
  
  pinMode(P9, INPUT);  //Q7
}

bool step_Ir13(uint16_t i)
{
  IR13_Record p = ir13_params[i];

  digitalWrite(P2, p.R);
  digitalWrite(P3, p.C);
  digitalWrite(P4, p.S0);
  digitalWrite(P5, p.S1);
  digitalWrite(P6, p.DR);
  digitalWrite(P7, p.DL);
  digitalWrite(P8, p.D0);

  Serial.print(F("R="));
  Serial.print(p.R);
  Serial.print(F(",C="));
  Serial.print(p.C);
  Serial.print(F(",S0="));
  Serial.print(p.S0);
  Serial.print(F(",S1="));
  Serial.print(p.S1);
  Serial.print(F(",DR="));
  Serial.print(p.DR);
  Serial.print(F(",DL="));
  Serial.print(p.DL);
  Serial.print(F(",D0="));
  Serial.print(p.D0);
  Serial.print(F(" -> "));

  byte q = digitalRead(P9);
  if (q == p.Q7)
  {
    Serial.println(F("Passed"));
  }
  else
  {
    Serial.println(F("Error"));
    Serial.println(q);
  }
  return q == p.Q7;
}

void loop_Ir13()
{
  Serial.println(F("START"));
  for (uint16_t i = 0; i < sizeof(ir13_params)/sizeof(ir13_params[0]); i++)
    if (!step_Ir13(i))
    {
      Serial.print(F("step = "));
      Serial.print(i);
      Serial.println(F(" ERROR!!!"));
      for (; ; );
    }
}

#endif
