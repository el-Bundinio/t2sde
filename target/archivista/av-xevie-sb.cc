
/*
   Copyright (C) 2006, Archivista GmbH, Rene Rebe
   Licensed under the GPL v2

   Based on Xevie documentation and example code.
 */

/* xeviedemo.c */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <X11/Xlib.h>
#include <X11/Xproto.h>
#include <X11/X.h>
#include <X11/extensions/Xevie.h>
#include <X11/Xutil.h>
#include <xorg/atKeynames.h>

#include <string>
#include <iostream>

static void
print_key_event (XEvent *ev)
{
  XKeyEvent *key_ev;
  char buffer[20];
  int bufsize = 19;
  KeySym key;
  XComposeStatus compose;
  int char_count;
  
  key_ev = (XKeyEvent *)ev;

  printf ("        State: 0x%x KeyCode: 0x%x(0x%x)\n",
	  key_ev->state & ShiftMask,
	  key_ev->keycode, key_ev->keycode - MIN_KEYCODE);
  char_count = XLookupString(key_ev, buffer, bufsize, &key, &compose);
  buffer[char_count] = '\0';
  printf ("        Char Count: %d KeySym: 0x%x char: |%c|\n", char_count, key, buffer[0]);
}

int main (int argc, char **argv)
{
  Display* dpy;
  int major, minor;
  XEvent  event;
  XClientMessageEvent *xcme;
  int ret;
  int debug = 0;
  
  std::string str;
  
  dpy = XOpenDisplay (NULL);
  XevieQueryVersion (dpy, &major, &minor);
  printf("major = %d, minor = %d\n", major, minor);
  if (XevieStart (dpy))
    printf("XevieStart(dpy) finished \n");
  else {
    printf("XevieStart(dpy) failed, only one client is allowed to do event interception\n");
    exit(1);
  }
  
  XevieSelectInput(dpy, KeyPressMask | KeyReleaseMask);
  while (1) {
    int pass_thru = 1;
    
    XNextEvent (dpy, &event);
    xcme = (XClientMessageEvent *)&event;
    /* for readOnly users, send events back to Xserver immediately */
    switch (event.type)
      {
      case KeyPress:
	if (debug) {
	  printf(" KeyPress\n");
	  print_key_event (&event);
	}
	
	{
	  XKeyEvent *key_ev;
	  key_ev = (XKeyEvent *)&event;
	  
	  char c = 0;
	  switch (key_ev->keycode - MIN_KEYCODE)
	    {
	    case KEY_KP_0: c = '0' ; break;
	    case KEY_KP_1: c = '1' ; break;
	    case KEY_KP_2: c = '2' ; break;
	    case KEY_KP_3: c = '3' ; break;
	    case KEY_KP_4: c = '4' ; break;
	    case KEY_KP_5: c = '5' ; break;
	    case KEY_KP_6: c = '6' ; break;
	    case KEY_KP_7: c = '7' ; break;
	    case KEY_KP_8: c = '8' ; break;
	    case KEY_KP_9: c = '9' ; break;
	    case KEY_KP_Enter: 
	      if (!str.empty()) {
		std::cout << "Would execute w/ str: " << str << std::endl;
		str.erase();
	      }
	      pass_thru = 0;
	      break;
	    case KEY_KP_Decimal:
	      str.clear();
	      pass_thru;
	      break;
	    }
	  if (c != 0) {
	    str.push_back(c);
	    pass_thru = 0;
	  }
	}
	
	break;
	
      case KeyRelease:
	if (debug) printf(" KeyRelease\n");
	  
	break;
	
      case ClientMessage:
	printf("ClientMessage: <%s>\n", &xcme->data.b[1]);
	break;

      default:
	printf(" unknown event %x\n", event.type);
	break;
      }
    
    if (pass_thru) {
      XevieSendEvent (dpy, &event, XEVIE_UNMODIFIED);
    }
  }
  XevieEnd (dpy);
  exit(0);
} 
