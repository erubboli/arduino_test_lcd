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

void Label::set_value(char* _value){
  value=_value;
}

void Label::print(void){
  int x,y;
  for(x=0; x<length;x++){
    int xshift = x * 8;
    for(y=0; y<8; y++){
      int c = font[value[x]-34][y];
      line_to_dots(c, xpos+y+xshift, ypos);
    }
  }
}

void Label::line_to_dots(int c, int base_x, int base_y ){
  int x;
  for(x=0; x<8; x++){
    int mask = 2^x+1;
    if ( c & mask){
      LCDSetPixel(color, base_x, base_y+x);
    } 
  }
}
