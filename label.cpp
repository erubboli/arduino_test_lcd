#include "WProgram.h"
#include "label.h"
#include "font.h"
#include "LCD_driver.h"

Label::Label(int _xpos, int _ypos, int _length, int _col){
  xpos=_xpos;
  ypos=_ypos;
  length=_length;
  color = _col;
}

void Label::set_value(char _value[]){
  strcpy(value,_value);
}

void Label::set_value(int _value){
  //  improve this
  sprintf(value, "%04u", _value);
}

void Label::print(){

  int pos,y;
  for(pos=0; pos<length;pos++){
    int xshift = pos * 8;
    
    int character = value[pos];
    for(y=0; y<8; y++){
      int c = font[character-32][y];
      line_to_dots(c, xpos+y, ypos+xshift);
    }
  }
}

void Label::line_to_dots(int c, int base_x, int base_y ){
  int x;
  for(x=0; x<8; x++){
    if ( c & (1<<x) ){
      LCDSetPixel(color, base_y-x+8, base_x);
    }
  }
}
