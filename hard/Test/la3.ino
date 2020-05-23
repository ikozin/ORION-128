/*
------------------------------------------------------
КР1533ЛА3
4 элемента 2И-НЕ
     -----
 1 -| &   |
    |     o- 3
 2 -|     |
     -----
     -----
 4 -| &   |
    |     o- 6
 5 -|     |
     -----
     -----
 9 -| &   |
    |     o- 8
10 -|     |
     -----
     -----
12 -| &   |
    |     o- 11
13 -|     |
     -----

     D2 D3         +5V   D2 D3
     |  |      ---  |    |  |
     *--|--1 -|*  |-*14  |  |
     |  *--2 -|   |- 13--|--*
D4 --|--|--3 -|   |- 12--*  |
     *--|--4 -|   |- 11--|--|-- D7
        *--5 -|   |- 10--|--*
D5 --------6 -|   |- 9---*
           7*-|   |- 8--------- D6
            |  ---
           GND
------------------------------------------------------
*/
#ifdef LA3

typedef struct _la3_Record_
{
  byte D0;
  byte D1;
  byte Q;
} LA3_Record;

LA3_Record la3_params[] = 
{
  //D0 D1 Q
  { 0, 0, 1 },
  { 1, 0, 1 },
  { 0, 0, 1 },
  { 1, 1, 0 },
};

void setup_La3()
{
  pinMode(P2, OUTPUT);
  pinMode(P3, OUTPUT);

  pinMode(P4, INPUT);
}

bool step_La3(uint16_t i)
{
  LA3_Record p = la3_params[i];

  digitalWrite(P2, p.D0);
  digitalWrite(P3, p.D1);

  Serial.print(F("D0="));
  Serial.print(p.D0);
  Serial.print(F(",D1="));
  Serial.print(p.D1);
  Serial.print(F(" -> "));

  byte q = digitalRead(P4);
  if (q == p.Q)
  {
    Serial.println(F("Passed"));
  }
  else
  {
    Serial.println(F("Error"));
    Serial.println(q);
  }
  return q == p.Q;
}

void loop_La3()
{
  Serial.println(F("START LA3 2AND-NOT"));
  for (uint16_t i = 0; i < sizeof(la3_params)/sizeof(la3_params[0]); i++)
    if (!step_La3(i))
    {
      Serial.print(F("step = "));
      Serial.print(i);
      Serial.println(F(" ERROR!!!"));
      for (; ; );
    }
}

#endif
