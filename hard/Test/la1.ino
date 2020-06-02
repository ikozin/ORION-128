/*
------------------------------------------------------
КР1533ЛА1
2 элемента 4И-НЕ
     -----
 1 -| &   |
    |     |
 2 -|     |
    |     o- 6
 4 -|     |
    |     |
 5 -|     |
     -----
     -----
 9 -| &   |
    |     |
10 -|     |
    |     o- 8
12 -|     |
    |     |
13 -|     |
     -----

     D2 D3 D4 D5         +5V   D2 D3 D4 D5
     |  |  |  |      ---  |    |  |  |  |
     *--|--|--|--1 -|*  |-*14  |  |  |  |
        *--|--|--2 -|   |- 13--|--|--|--*
           |  |  3 -|   |- 12--|--|--*  
           *--|--4 -|   |- 11  |  |
              *--5 -|   |- 10--|--*
D6 --------------6 -|   |- 9---*
                 7*-|   |- 8-------------- D7
                  |  ---
                 GND
------------------------------------------------------
*/
#ifdef LA1

typedef struct _la1_Record_
{
  byte D0;
  byte D1;
  byte D2;
  byte D3;
  byte Q;
} LA1_Record;

LA1_Record la1_params[] = 
{
  //D0 D1 D2 D3 Q
  { 0, 0, 0, 0, 1 },
  { 1, 0, 0, 0, 1 },
  { 1, 1, 0, 0, 1 },
  { 0, 0, 1, 0, 1 },
  { 1, 0, 1, 0, 1 },
  { 0, 1, 1, 0, 1 },
  { 1, 1, 1, 0, 1 },
  { 0, 0, 0, 1, 1 },
  { 1, 0, 0, 1, 1 },
  { 0, 1, 0, 1, 1 },
  { 1, 1, 0, 1, 1 },
  { 0, 0, 1, 1, 1 },
  { 1, 0, 1, 1, 1 },
  { 0, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 0 }
};

void setup_La1()
{
  pinMode(P2, OUTPUT);
  pinMode(P3, OUTPUT);
  pinMode(P4, OUTPUT);
  pinMode(P5, OUTPUT);

  pinMode(P6, INPUT);
}

bool step_La1(uint16_t i)
{
  LA1_Record p = la1_params[i];

  digitalWrite(P2, p.D0);
  digitalWrite(P3, p.D1);
  digitalWrite(P4, p.D2);
  digitalWrite(P5, p.D3);

  Serial.print(F("D0="));
  Serial.print(p.D0);
  Serial.print(F(",D1="));
  Serial.print(p.D1);
  Serial.print(F(",D2="));
  Serial.print(p.D2);
  Serial.print(F(",D3="));
  Serial.print(p.D3);
  Serial.print(F(" -> "));
            
  byte q = digitalRead(P6);
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

void loop_La1()
{
  Serial.println(F("LA1 4AND-NOT"));
  for (uint16_t i = 0; i < sizeof(la1_params)/sizeof(la1_params[0]); i++)
    if (!step_La1(i))
    {
      Serial.print(F("step = "));
      Serial.print(i);
      Serial.println(F(" ERROR!!!"));
      for (; ; );
    }
}

#endif