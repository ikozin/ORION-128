/*
------------------------------------------------------
КР1533ЛЕ1
4 элемента 2ИЛИ-НЕ
     -----
 2 -| 1   |
    |     o- 1
 3 -|     |
     -----
     -----
 5 -| 1   |
    |     o- 4
 6 -|     |
     -----
     -----
 8 -| 1   |
    |     o- 10
 9 -|     |
     -----
     -----
11 -| 1   |
    |     o- 13
12 -|     |
     -----

     D2 D3         +5V   D2 D3
     |  |      ---  |    |  |
D1 --|--|--1 -|*  |-*14  |  |
     *--|--2 -|   |- 13--|--|-- D7
     |  *--3 -|   |- 12--|--*
В5 --|--|--4 -|   |- 11--*  |
     *--|--5 -|   |- 10--|--|-- D6
        *--6 -|   |- 9---|--*
           7*-|   |- 8---*
            |  ---
           GND
------------------------------------------------------
*/
#ifdef LE1

typedef struct _le1_Record_
{
  byte D0;
  byte D1;
  byte Q;
} LE1_Record;

LE1_Record le1_params[] = 
{
  //D0 D1 Q
  { 0, 0, 1 },
  { 1, 0, 0 },
  { 0, 1, 0 },
  { 1, 1, 0 },
};

void setup_Le1()
{
  pinMode(P2, OUTPUT);
  pinMode(P3, OUTPUT);

  pinMode(P4, INPUT);
}

bool step_Le1(uint16_t i)
{
  LE1_Record p = le1_params[i];

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

void loop_Le1()
{
  Serial.println(F("START LE1 2OR-NOT"));
  for (uint16_t i = 0; i < sizeof(le1_params)/sizeof(le1_params[0]); i++)
    if (!step_Le1(i))
    {
      Serial.print(F("step = "));
      Serial.print(i);
      Serial.println(F(" ERROR!!!"));
      for (; ; );
    }
}

#endif
