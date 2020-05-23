/*
------------------------------------------------------
КР1533ИЕ5
4-х разрядный двоичный счетчик

     --------------
14 -| D0 | CT2 | 1 |- 12
 1 -| D1 |     | 2 |- 9
    |    |     | 4 |- 8
 2 -| R0 |     | 8 |- 11
 3 -| R1 |     |   | 
     --------------

        D3               D2
        |      ---       |
        *--1 -|*  |- 14--*
 D4 -------2 -|   |- 13
 D5 -------3 -|   |- 12-------- D6
           4 -|   |- 11-------- D9
+5V -------5 -|   |- 10-------- GND
           6 -|   |- 9--------- D7
           7 -|   |- 8--------- D8
               ---

------------------------------------------------------
*/
#ifdef IE5

typedef struct _ie5_Record_
{
  byte D0;
  byte D1;
  byte R0;
  byte R1;
  byte Q1;
  byte Q2;
  byte Q4;
  byte Q8;
} IE5_Record;

IE5_Record ie5_params[] = 
{
  //D0 D1 R0 R1 Q1 Q2 Q4 Q8
  { 0, 0, 1, 1, 0, 0, 0, 0 }, // reset
  { 0, 0, 0, 0, 0, 0, 0, 0 }, // 

  { 1, 0, 0, 0, 1, 0, 0, 0 },
  { 0, 0, 0, 0, 1, 0, 0, 0 },
  
  { 1, 0, 0, 0, 0, 0, 0, 0 },
  { 0, 0, 0, 0, 0, 0, 0, 0 },
  

  { 1, 1, 0, 0, 1, 1, 0, 0 },
  { 0, 0, 0, 0, 1, 1, 0, 0 },
  
  { 1, 1, 0, 0, 0, 1, 0, 0 },
  { 0, 0, 0, 0, 0, 1, 0, 0 },

  { 1, 0, 0, 0, 1, 0, 1, 0 },
  { 0, 0, 0, 0, 1, 0, 1, 0 },
  
  { 1, 0, 0, 0, 0, 0, 1, 0 },
  { 0, 0, 0, 0, 0, 0, 1, 0 },
};

void setup_Ie5()
{
  pinMode(P2, OUTPUT);
  pinMode(P3, OUTPUT);
  pinMode(P4, OUTPUT);
  pinMode(P5, OUTPUT);

  pinMode(P6, INPUT);
  pinMode(P7, INPUT);
  pinMode(P8, INPUT);
  pinMode(P9, INPUT);
}

bool step_Ie5(uint16_t i)
{
  IE5_Record p = ie5_params[i];

  digitalWrite(P2, p.D0);
  digitalWrite(P3, p.D1);
  digitalWrite(P4, p.R0);
  digitalWrite(P5, p.R1);

  Serial.print(F("D0="));
  Serial.print(p.D0);
  Serial.print(F(",D1="));
  Serial.print(p.D1);
  Serial.print(F(",R0="));
  Serial.print(p.R0);
  Serial.print(F(",R1="));
  Serial.print(p.R1);
  Serial.print(F(" -> "));

  int errorCount = 0;
  byte q1 = digitalRead(P6);
  byte q2 = digitalRead(P7);
  byte q4 = digitalRead(P8);
  byte q8 = digitalRead(P9);

  if (q1 != p.Q1) errorCount++;
  if (q2 != p.Q2) errorCount++;
  if (q4 != p.Q4) errorCount++;
  if (q8 != p.Q8) errorCount++;

  if (errorCount == 0)
  {
    Serial.println(F("Passed"));
  }
  else
  {
    Serial.println(F("Error"));
    Serial.println(q1);
    Serial.println(q2);
    Serial.println(q4);
    Serial.println(q8);
  }
  return errorCount == 0;
}

void loop_Ie5()
{
  Serial.println(F("START IE5"));
  for (uint16_t i = 0; i < sizeof(ie5_params)/sizeof(ie5_params[0]); i++)
    if (!step_Ie5(i))
    {
      Serial.print(F("step = "));
      Serial.print(i);
      Serial.println(F(" ERROR!!!"));
      for (; ; );
    }
}

#endif
