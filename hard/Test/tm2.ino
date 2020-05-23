/*
------------------------------------------------------
КР1533TM2
D триггер
     -----------
 4 -o S | T |   |
    |---|   | Q |- 5
 2 -| D |   |   |
 3 -| C |   | _ |
    |---|   | Q o- 6
 1 -o R |   |   |
    ------------
     -----------
10 -o S | T |   |
    |---|   | Q |- 9
12 -| D |   |   |
11 -| C |   | _ |
    |---|   | Q o- 8
13 -o R |   |   |
    ------------

     D5 D4 D3 D2         +5V   D2 D3 D4 D5
     |  |  |  |      ---  |    |  |  |  |
     |  |  |  *--1 -|*  |-*14  |  |  |  |
     |  |  *-----2 -|   |- 13--*  |  |  |
     |  *--------3 -|   |- 12-----*  |  |
     *-----------4 -|   |- 11--------*  |
D5 --------------5 -|   |- 10-----------*
D6 --------------6 -|   |- 9--------------- D5
                 7*-|   |- 8--------------- D6
                  |  ---
                 GND
------------------------------------------------------
*/
#ifdef TM2

typedef struct _tm2_Record_
{
  byte R;
  byte D;
  byte C;
  byte S;
  byte Q;
  byte notQ;
} TM2_Record;

TM2_Record tm2_params[] = 
{
  //R  D  C  S  Q notQ
  { 1, 0, 0, 0, 1, 0 },
  { 1, 0, 0, 1, 1, 0 },
  { 0, 0, 0, 1, 0, 1 },
  { 1, 0, 0, 1, 0, 1 },
  { 1, 0, 1, 1, 0, 1 },
  { 1, 0, 0, 1, 0, 1 },
  { 1, 1, 1, 1, 1, 0 },
  { 1, 1, 0, 1, 1, 0 },
  { 1, 0, 1, 1, 0, 1 },
  { 1, 0, 0, 1, 0, 1 },
};

void setup_Tm2()
{
  pinMode(P2, OUTPUT);
  pinMode(P3, OUTPUT);
  pinMode(P4, OUTPUT);
  pinMode(P5, OUTPUT);

  pinMode(P6, INPUT);
  pinMode(P7, INPUT);
}

bool step_Tm2(uint16_t i)
{
  TM2_Record p = tm2_params[i];

  digitalWrite(P2, p.R);
  digitalWrite(P3, p.D);
  digitalWrite(P4, p.C);
  digitalWrite(P5, p.S);

  Serial.print(F("R="));
  Serial.print(p.R);
  Serial.print(F(",D="));
  Serial.print(p.D);
  Serial.print(F(",C="));
  Serial.print(p.C);
  Serial.print(F(",S="));
  Serial.print(p.S);
  Serial.print(F(" -> "));

  byte q0 = digitalRead(P6);
  byte q1 = digitalRead(P7);
  if (q0 != q1 && q0 == p.Q)
  {
    Serial.println(F("Passed"));
  }
  else
  {
    Serial.println(F("Error"));
    Serial.println(q0);
    Serial.println(q1);
  }
  return q0 == p.Q;
}

void loop_Tm2()
{
  Serial.println(F("START D trigger"));
  for (uint16_t i = 0; i < sizeof(tm2_params)/sizeof(tm2_params[0]); i++)
    if (!step_Tm2(i))
    {
      Serial.print(F("step = "));
      Serial.print(i);
      Serial.println(F(" ERROR!!!"));
      for (; ; );
    }
}

#endif
