/*
------------------------------------------------------
КР1533ЛИ1
4 элемента 2И
     -----
 1 -| &   |
    |     |- 3
 2 -|     |
     -----
     -----
 4 -| &   |
    |     |- 6
 5 -|     |
     -----
     -----
 9 -| &   |
    |     |- 8
10 -|     |
     -----
     -----
12 -| &   |
    |     |- 11
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
#ifdef LI1

typedef struct _li1_Record_
{
  byte D0;
  byte D1;
  byte Q;
} LI1_Record;

LI1_Record li1_params[] = 
{
  //D0 D1 Q
  { 0, 0, 0 },
  { 1, 0, 0 },
  { 0, 1, 0 },
  { 1, 1, 1 },
};

void setup_Li1()
{
  pinMode(P2, OUTPUT);
  pinMode(P3, OUTPUT);

  pinMode(P4, INPUT);
}

bool step_Li1(uint16_t i)
{
  LI1_Record p = li1_params[i];

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

void loop_Li1()
{
  Serial.println(F("START LI1 2AND-NOT"));
  for (uint16_t i = 0; i < sizeof(li1_params)/sizeof(li1_params[0]); i++)
    if (!step_Le1(i))
    {
      Serial.print(F("step = "));
      Serial.print(i);
      Serial.println(F(" ERROR!!!"));
      for (; ; );
    }
}

#endif
