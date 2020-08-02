Before starting the project, you need to create two new objects in your org.

+ Sensor, with next fields:
  + Name(Text 80)
  + Max Vectors Difference (Roll up summary)

+ Sensor Event
  + Name (Autonumber)
  + Previous Event (Lookup(Sensor Event))
  + Modulus difference Vectors (Formula(Number = SQRT( (x\*x) + (y\*y) + (z*z) ) ))
  + x (Number)
  + y (Number)
  + z (Number)