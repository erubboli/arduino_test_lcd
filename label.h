#ifndef Label_h
#define Label_h

#include "WProgram.h"


class Label
{
   public:
     Label(int _xpos, int _ypos, int _length, int _col);
     void set_value(char _value[]);
     void print();
   private:
     int xpos;
     int ypos;
     int color;
     int length;
     char value[20];
     void line_to_dots(int c, int base_x, int base_y);
};

#endif
