/*
  TextArea
 This widget is an input field for text
 */


class TextArea extends SelectableWidget {
  int cursPos;
  TextArea(PVector relPos, PVector size, AppWidget parent) {
    super(relPos, size, parent, "");
    cursPos=0;
  }
  //Draws text char by char , might be unnecesarry with a mono font
  @Override
    void drawText() {
    if (selected) {
      widgetTheme.toFill(TColor.FOREGROUND2);
    } else {
      widgetTheme.toFill(TColor.FOREGROUND1);
    }
    textAlign(LEFT);
    int strIndex = 0;
    for (int x = 10; x < size.x-20; x += TEXTSIZE/2.2) {
      if (strIndex < text.length()) {
        text(text.charAt(strIndex), x, size.y/2 + TEXTSIZE/4);
        strIndex ++;
      }
    }
    //Draw the cursor
    line((TEXTSIZE/2.2 * cursPos)+6, (size.y/3*2), TEXTSIZE/2.2 * cursPos+6, (size.y/3));
  }

  //This is how the input can be extracted
  String getTextData() {
    return text.trim();
  }
  //Update function
  Response update(EventType evt, Object... args) {
    switch(evt) {
    case MOUSEMV:
      //Select on mouse hover
      if (!selected && hasPos(new PVector((float) args[0], (float) args[1])) ) {
        return Response.ASKSELECT;
      }
      break;
    case KEYTYPE:
      //Passing chars, space and backspace
      char inChar = (char) args[0];
      //Pass actual characters as characters
      if ((int) inChar > 40 && (int) inChar < 126) {
        text += args[0];
        cursPos++;
        //Remove one character before the cursor with BACKSPACE
      } else if (inChar == BACKSPACE) {
        if (cursPos  > 0) {
          text = text.substring(0, cursPos-1) + text.substring(cursPos, text.length());
          cursPos --;
        }
        //Remove one character after the cursor with DELETE
      } else if (inChar == DELETE) {
        if (cursPos  < text.length()+1) {
          text = text.substring(0, cursPos) + text.substring(cursPos+1, text.length());
          cursPos --;
        }
        //Passing the space
      } else if (inChar == ' ') {
        text += ' ';
        cursPos++;
      }
      break;
    case KEYPRES:
      //Passing the movement keys
      int inKCode = (int) args[0];
      if (inKCode == LEFT) {
        cursPos --;
        if (cursPos < 0) {
          cursPos = text.length();
        }
      } else if (inKCode == RIGHT) {
        if (cursPos < text.length()) {
          cursPos ++;
        }
      }
      break;
    default:
      break;
    }
    return Response.SUCCESS;
  }
}
