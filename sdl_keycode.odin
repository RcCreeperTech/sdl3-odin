package sdl3

/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2024 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/


// # CategoryKeycode
//
// Defines constants which identify keyboard keys and modifiers.
import "base:intrinsics"
import "core:c"

// The SDL virtual key representation.
//
// Values of this type are used to represent keyboard keys using the current
// layout of the keyboard. These values include Unicode values representing
// the unmodified character that would be generated by pressing the key, or an
// `SDLK_*` constant for those keys that do not generate characters.
//
// A special exception is the number keys at the top of the keyboard which map
// to SDLK_0...SDLK_9 on AZERTY layouts.
//
// \since This datatype is available since SDL 3.0.0.


SDLK_SCANCODE_MASK: c.int : (1 << 30)
SCANCODE_TO_KEYCODE :: #force_inline proc "c" (X: Scancode) -> Keycode {
	return transmute(Keycode)(c.int(X) | SDLK_SCANCODE_MASK)
}

Keycode :: enum c.uint32_t {
	SDLK_UNKNOWN              = 0x00000000, /* 0 */
	SDLK_RETURN               = 0x0000000d, /* '\r' */
	SDLK_ESCAPE               = 0x0000001b, /* '\x1B' */
	SDLK_BACKSPACE            = 0x00000008, /* '\b' */
	SDLK_TAB                  = 0x00000009, /* '\t' */
	SDLK_SPACE                = 0x00000020, /* ' ' */
	SDLK_EXCLAIM              = 0x00000021, /* '!' */
	SDLK_DBLAPOSTROPHE        = 0x00000022, /* '"' */
	SDLK_HASH                 = 0x00000023, /* '#' */
	SDLK_DOLLAR               = 0x00000024, /* '$' */
	SDLK_PERCENT              = 0x00000025, /* '%' */
	SDLK_AMPERSAND            = 0x00000026, /* '&' */
	SDLK_APOSTROPHE           = 0x00000027, /* '\'' */
	SDLK_LEFTPAREN            = 0x00000028, /* '(' */
	SDLK_RIGHTPAREN           = 0x00000029, /* ')' */
	SDLK_ASTERISK             = 0x0000002a, /* '*' */
	SDLK_PLUS                 = 0x0000002b, /* '+' */
	SDLK_COMMA                = 0x0000002c, /* ',' */
	SDLK_MINUS                = 0x0000002d, /* '-' */
	SDLK_PERIOD               = 0x0000002e, /* '.' */
	SDLK_SLASH                = 0x0000002f, /* '/' */
	SDLK_0                    = 0x00000030, /* '0' */
	SDLK_1                    = 0x00000031, /* '1' */
	SDLK_2                    = 0x00000032, /* '2' */
	SDLK_3                    = 0x00000033, /* '3' */
	SDLK_4                    = 0x00000034, /* '4' */
	SDLK_5                    = 0x00000035, /* '5' */
	SDLK_6                    = 0x00000036, /* '6' */
	SDLK_7                    = 0x00000037, /* '7' */
	SDLK_8                    = 0x00000038, /* '8' */
	SDLK_9                    = 0x00000039, /* '9' */
	SDLK_COLON                = 0x0000003a, /* ':' */
	SDLK_SEMICOLON            = 0x0000003b, /* ';' */
	SDLK_LESS                 = 0x0000003c, /* '<' */
	SDLK_EQUALS               = 0x0000003d, /* '=' */
	SDLK_GREATER              = 0x0000003e, /* '>' */
	SDLK_QUESTION             = 0x0000003f, /* '?' */
	SDLK_AT                   = 0x00000040, /* '@' */
	SDLK_LEFTBRACKET          = 0x0000005b, /* '[' */
	SDLK_BACKSLASH            = 0x0000005c, /* '\\' */
	SDLK_RIGHTBRACKET         = 0x0000005d, /* ']' */
	SDLK_CARET                = 0x0000005e, /* '^' */
	SDLK_UNDERSCORE           = 0x0000005f, /* '_' */
	SDLK_GRAVE                = 0x00000060, /* '`' */
	SDLK_A                    = 0x00000061, /* 'a' */
	SDLK_B                    = 0x00000062, /* 'b' */
	SDLK_C                    = 0x00000063, /* 'c' */
	SDLK_D                    = 0x00000064, /* 'd' */
	SDLK_E                    = 0x00000065, /* 'e' */
	SDLK_F                    = 0x00000066, /* 'f' */
	SDLK_G                    = 0x00000067, /* 'g' */
	SDLK_H                    = 0x00000068, /* 'h' */
	SDLK_I                    = 0x00000069, /* 'i' */
	SDLK_J                    = 0x0000006a, /* 'j' */
	SDLK_K                    = 0x0000006b, /* 'k' */
	SDLK_L                    = 0x0000006c, /* 'l' */
	SDLK_M                    = 0x0000006d, /* 'm' */
	SDLK_N                    = 0x0000006e, /* 'n' */
	SDLK_O                    = 0x0000006f, /* 'o' */
	SDLK_P                    = 0x00000070, /* 'p' */
	SDLK_Q                    = 0x00000071, /* 'q' */
	SDLK_R                    = 0x00000072, /* 'r' */
	SDLK_S                    = 0x00000073, /* 's' */
	SDLK_T                    = 0x00000074, /* 't' */
	SDLK_U                    = 0x00000075, /* 'u' */
	SDLK_V                    = 0x00000076, /* 'v' */
	SDLK_W                    = 0x00000077, /* 'w' */
	SDLK_X                    = 0x00000078, /* 'x' */
	SDLK_Y                    = 0x00000079, /* 'y' */
	SDLK_Z                    = 0x0000007a, /* 'z' */
	SDLK_LEFTBRACE            = 0x0000007b, /* '{' */
	SDLK_PIPE                 = 0x0000007c, /* '|' */
	SDLK_RIGHTBRACE           = 0x0000007d, /* '}' */
	SDLK_TILDE                = 0x0000007e, /* '~' */
	SDLK_DELETE               = 0x0000007f, /* '\x7F' */
	SDLK_PLUSMINUS            = 0x000000b1, /* '\xB1' */
	SDLK_CAPSLOCK             = 0x40000039, /* SCANCODE_TO_KEYCODE(SCANCODE_CAPSLOCK) */
	SDLK_F1                   = 0x4000003a, /* SCANCODE_TO_KEYCODE(SCANCODE_F1) */
	SDLK_F2                   = 0x4000003b, /* SCANCODE_TO_KEYCODE(SCANCODE_F2) */
	SDLK_F3                   = 0x4000003c, /* SCANCODE_TO_KEYCODE(SCANCODE_F3) */
	SDLK_F4                   = 0x4000003d, /* SCANCODE_TO_KEYCODE(SCANCODE_F4) */
	SDLK_F5                   = 0x4000003e, /* SCANCODE_TO_KEYCODE(SCANCODE_F5) */
	SDLK_F6                   = 0x4000003f, /* SCANCODE_TO_KEYCODE(SCANCODE_F6) */
	SDLK_F7                   = 0x40000040, /* SCANCODE_TO_KEYCODE(SCANCODE_F7) */
	SDLK_F8                   = 0x40000041, /* SCANCODE_TO_KEYCODE(SCANCODE_F8) */
	SDLK_F9                   = 0x40000042, /* SCANCODE_TO_KEYCODE(SCANCODE_F9) */
	SDLK_F10                  = 0x40000043, /* SCANCODE_TO_KEYCODE(SCANCODE_F10) */
	SDLK_F11                  = 0x40000044, /* SCANCODE_TO_KEYCODE(SCANCODE_F11) */
	SDLK_F12                  = 0x40000045, /* SCANCODE_TO_KEYCODE(SCANCODE_F12) */
	SDLK_PRINTSCREEN          = 0x40000046, /* SCANCODE_TO_KEYCODE(SCANCODE_PRINTSCREEN) */
	SDLK_SCROLLLOCK           = 0x40000047, /* SCANCODE_TO_KEYCODE(SCANCODE_SCROLLLOCK) */
	SDLK_PAUSE                = 0x40000048, /* SCANCODE_TO_KEYCODE(SCANCODE_PAUSE) */
	SDLK_INSERT               = 0x40000049, /* SCANCODE_TO_KEYCODE(SCANCODE_INSERT) */
	SDLK_HOME                 = 0x4000004a, /* SCANCODE_TO_KEYCODE(SCANCODE_HOME) */
	SDLK_PAGEUP               = 0x4000004b, /* SCANCODE_TO_KEYCODE(SCANCODE_PAGEUP) */
	SDLK_END                  = 0x4000004d, /* SCANCODE_TO_KEYCODE(SCANCODE_END) */
	SDLK_PAGEDOWN             = 0x4000004e, /* SCANCODE_TO_KEYCODE(SCANCODE_PAGEDOWN) */
	SDLK_RIGHT                = 0x4000004f, /* SCANCODE_TO_KEYCODE(SCANCODE_RIGHT) */
	SDLK_LEFT                 = 0x40000050, /* SCANCODE_TO_KEYCODE(SCANCODE_LEFT) */
	SDLK_DOWN                 = 0x40000051, /* SCANCODE_TO_KEYCODE(SCANCODE_DOWN) */
	SDLK_UP                   = 0x40000052, /* SCANCODE_TO_KEYCODE(SCANCODE_UP) */
	SDLK_NUMLOCKCLEAR         = 0x40000053, /* SCANCODE_TO_KEYCODE(SCANCODE_NUMLOCKCLEAR) */
	SDLK_KP_DIVIDE            = 0x40000054, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_DIVIDE) */
	SDLK_KP_MULTIPLY          = 0x40000055, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MULTIPLY) */
	SDLK_KP_MINUS             = 0x40000056, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MINUS) */
	SDLK_KP_PLUS              = 0x40000057, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_PLUS) */
	SDLK_KP_ENTER             = 0x40000058, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_ENTER) */
	SDLK_KP_1                 = 0x40000059, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_1) */
	SDLK_KP_2                 = 0x4000005a, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_2) */
	SDLK_KP_3                 = 0x4000005b, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_3) */
	SDLK_KP_4                 = 0x4000005c, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_4) */
	SDLK_KP_5                 = 0x4000005d, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_5) */
	SDLK_KP_6                 = 0x4000005e, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_6) */
	SDLK_KP_7                 = 0x4000005f, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_7) */
	SDLK_KP_8                 = 0x40000060, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_8) */
	SDLK_KP_9                 = 0x40000061, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_9) */
	SDLK_KP_0                 = 0x40000062, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_0) */
	SDLK_KP_PERIOD            = 0x40000063, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_PERIOD) */
	SDLK_APPLICATION          = 0x40000065, /* SCANCODE_TO_KEYCODE(SCANCODE_APPLICATION) */
	SDLK_POWER                = 0x40000066, /* SCANCODE_TO_KEYCODE(SCANCODE_POWER) */
	SDLK_KP_EQUALS            = 0x40000067, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_EQUALS) */
	SDLK_F13                  = 0x40000068, /* SCANCODE_TO_KEYCODE(SCANCODE_F13) */
	SDLK_F14                  = 0x40000069, /* SCANCODE_TO_KEYCODE(SCANCODE_F14) */
	SDLK_F15                  = 0x4000006a, /* SCANCODE_TO_KEYCODE(SCANCODE_F15) */
	SDLK_F16                  = 0x4000006b, /* SCANCODE_TO_KEYCODE(SCANCODE_F16) */
	SDLK_F17                  = 0x4000006c, /* SCANCODE_TO_KEYCODE(SCANCODE_F17) */
	SDLK_F18                  = 0x4000006d, /* SCANCODE_TO_KEYCODE(SCANCODE_F18) */
	SDLK_F19                  = 0x4000006e, /* SCANCODE_TO_KEYCODE(SCANCODE_F19) */
	SDLK_F20                  = 0x4000006f, /* SCANCODE_TO_KEYCODE(SCANCODE_F20) */
	SDLK_F21                  = 0x40000070, /* SCANCODE_TO_KEYCODE(SCANCODE_F21) */
	SDLK_F22                  = 0x40000071, /* SCANCODE_TO_KEYCODE(SCANCODE_F22) */
	SDLK_F23                  = 0x40000072, /* SCANCODE_TO_KEYCODE(SCANCODE_F23) */
	SDLK_F24                  = 0x40000073, /* SCANCODE_TO_KEYCODE(SCANCODE_F24) */
	SDLK_EXECUTE              = 0x40000074, /* SCANCODE_TO_KEYCODE(SCANCODE_EXECUTE) */
	SDLK_HELP                 = 0x40000075, /* SCANCODE_TO_KEYCODE(SCANCODE_HELP) */
	SDLK_MENU                 = 0x40000076, /* SCANCODE_TO_KEYCODE(SCANCODE_MENU) */
	SDLK_SELECT               = 0x40000077, /* SCANCODE_TO_KEYCODE(SCANCODE_SELECT) */
	SDLK_STOP                 = 0x40000078, /* SCANCODE_TO_KEYCODE(SCANCODE_STOP) */
	SDLK_AGAIN                = 0x40000079, /* SCANCODE_TO_KEYCODE(SCANCODE_AGAIN) */
	SDLK_UNDO                 = 0x4000007a, /* SCANCODE_TO_KEYCODE(SCANCODE_UNDO) */
	SDLK_CUT                  = 0x4000007b, /* SCANCODE_TO_KEYCODE(SCANCODE_CUT) */
	SDLK_COPY                 = 0x4000007c, /* SCANCODE_TO_KEYCODE(SCANCODE_COPY) */
	SDLK_PASTE                = 0x4000007d, /* SCANCODE_TO_KEYCODE(SCANCODE_PASTE) */
	SDLK_FIND                 = 0x4000007e, /* SCANCODE_TO_KEYCODE(SCANCODE_FIND) */
	SDLK_MUTE                 = 0x4000007f, /* SCANCODE_TO_KEYCODE(SCANCODE_MUTE) */
	SDLK_VOLUMEUP             = 0x40000080, /* SCANCODE_TO_KEYCODE(SCANCODE_VOLUMEUP) */
	SDLK_VOLUMEDOWN           = 0x40000081, /* SCANCODE_TO_KEYCODE(SCANCODE_VOLUMEDOWN) */
	SDLK_KP_COMMA             = 0x40000085, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_COMMA) */
	SDLK_KP_EQUALSAS400       = 0x40000086, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_EQUALSAS400) */
	SDLK_ALTERASE             = 0x40000099, /* SCANCODE_TO_KEYCODE(SCANCODE_ALTERASE) */
	SDLK_SYSREQ               = 0x4000009a, /* SCANCODE_TO_KEYCODE(SCANCODE_SYSREQ) */
	SDLK_CANCEL               = 0x4000009b, /* SCANCODE_TO_KEYCODE(SCANCODE_CANCEL) */
	SDLK_CLEAR                = 0x4000009c, /* SCANCODE_TO_KEYCODE(SCANCODE_CLEAR) */
	SDLK_PRIOR                = 0x4000009d, /* SCANCODE_TO_KEYCODE(SCANCODE_PRIOR) */
	SDLK_RETURN2              = 0x4000009e, /* SCANCODE_TO_KEYCODE(SCANCODE_RETURN2) */
	SDLK_SEPARATOR            = 0x4000009f, /* SCANCODE_TO_KEYCODE(SCANCODE_SEPARATOR) */
	SDLK_OUT                  = 0x400000a0, /* SCANCODE_TO_KEYCODE(SCANCODE_OUT) */
	SDLK_OPER                 = 0x400000a1, /* SCANCODE_TO_KEYCODE(SCANCODE_OPER) */
	SDLK_CLEARAGAIN           = 0x400000a2, /* SCANCODE_TO_KEYCODE(SCANCODE_CLEARAGAIN) */
	SDLK_CRSEL                = 0x400000a3, /* SCANCODE_TO_KEYCODE(SCANCODE_CRSEL) */
	SDLK_EXSEL                = 0x400000a4, /* SCANCODE_TO_KEYCODE(SCANCODE_EXSEL) */
	SDLK_KP_00                = 0x400000b0, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_00) */
	SDLK_KP_000               = 0x400000b1, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_000) */
	SDLK_THOUSANDSSEPARATOR   = 0x400000b2, /* SCANCODE_TO_KEYCODE(SCANCODE_THOUSANDSSEPARATOR) */
	SDLK_DECIMALSEPARATOR     = 0x400000b3, /* SCANCODE_TO_KEYCODE(SCANCODE_DECIMALSEPARATOR) */
	SDLK_CURRENCYUNIT         = 0x400000b4, /* SCANCODE_TO_KEYCODE(SCANCODE_CURRENCYUNIT) */
	SDLK_CURRENCYSUBUNIT      = 0x400000b5, /* SCANCODE_TO_KEYCODE(SCANCODE_CURRENCYSUBUNIT) */
	SDLK_KP_LEFTPAREN         = 0x400000b6, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_LEFTPAREN) */
	SDLK_KP_RIGHTPAREN        = 0x400000b7, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_RIGHTPAREN) */
	SDLK_KP_LEFTBRACE         = 0x400000b8, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_LEFTBRACE) */
	SDLK_KP_RIGHTBRACE        = 0x400000b9, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_RIGHTBRACE) */
	SDLK_KP_TAB               = 0x400000ba, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_TAB) */
	SDLK_KP_BACKSPACE         = 0x400000bb, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_BACKSPACE) */
	SDLK_KP_A                 = 0x400000bc, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_A) */
	SDLK_KP_B                 = 0x400000bd, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_B) */
	SDLK_KP_C                 = 0x400000be, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_C) */
	SDLK_KP_D                 = 0x400000bf, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_D) */
	SDLK_KP_E                 = 0x400000c0, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_E) */
	SDLK_KP_F                 = 0x400000c1, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_F) */
	SDLK_KP_XOR               = 0x400000c2, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_XOR) */
	SDLK_KP_POWER             = 0x400000c3, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_POWER) */
	SDLK_KP_PERCENT           = 0x400000c4, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_PERCENT) */
	SDLK_KP_LESS              = 0x400000c5, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_LESS) */
	SDLK_KP_GREATER           = 0x400000c6, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_GREATER) */
	SDLK_KP_AMPERSAND         = 0x400000c7, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_AMPERSAND) */
	SDLK_KP_DBLAMPERSAND      = 0x400000c8, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_DBLAMPERSAND) */
	SDLK_KP_VERTICALBAR       = 0x400000c9, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_VERTICALBAR) */
	SDLK_KP_DBLVERTICALBAR    = 0x400000ca, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_DBLVERTICALBAR) */
	SDLK_KP_COLON             = 0x400000cb, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_COLON) */
	SDLK_KP_HASH              = 0x400000cc, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_HASH) */
	SDLK_KP_SPACE             = 0x400000cd, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_SPACE) */
	SDLK_KP_AT                = 0x400000ce, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_AT) */
	SDLK_KP_EXCLAM            = 0x400000cf, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_EXCLAM) */
	SDLK_KP_MEMSTORE          = 0x400000d0, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MEMSTORE) */
	SDLK_KP_MEMRECALL         = 0x400000d1, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MEMRECALL) */
	SDLK_KP_MEMCLEAR          = 0x400000d2, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MEMCLEAR) */
	SDLK_KP_MEMADD            = 0x400000d3, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MEMADD) */
	SDLK_KP_MEMSUBTRACT       = 0x400000d4, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MEMSUBTRACT) */
	SDLK_KP_MEMMULTIPLY       = 0x400000d5, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MEMMULTIPLY) */
	SDLK_KP_MEMDIVIDE         = 0x400000d6, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_MEMDIVIDE) */
	SDLK_KP_PLUSMINUS         = 0x400000d7, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_PLUSMINUS) */
	SDLK_KP_CLEAR             = 0x400000d8, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_CLEAR) */
	SDLK_KP_CLEARENTRY        = 0x400000d9, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_CLEARENTRY) */
	SDLK_KP_BINARY            = 0x400000da, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_BINARY) */
	SDLK_KP_OCTAL             = 0x400000db, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_OCTAL) */
	SDLK_KP_DECIMAL           = 0x400000dc, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_DECIMAL) */
	SDLK_KP_HEXADECIMAL       = 0x400000dd, /* SCANCODE_TO_KEYCODE(SCANCODE_KP_HEXADECIMAL) */
	SDLK_LCTRL                = 0x400000e0, /* SCANCODE_TO_KEYCODE(SCANCODE_LCTRL) */
	SDLK_LSHIFT               = 0x400000e1, /* SCANCODE_TO_KEYCODE(SCANCODE_LSHIFT) */
	SDLK_LALT                 = 0x400000e2, /* SCANCODE_TO_KEYCODE(SCANCODE_LALT) */
	SDLK_LGUI                 = 0x400000e3, /* SCANCODE_TO_KEYCODE(SCANCODE_LGUI) */
	SDLK_RCTRL                = 0x400000e4, /* SCANCODE_TO_KEYCODE(SCANCODE_RCTRL) */
	SDLK_RSHIFT               = 0x400000e5, /* SCANCODE_TO_KEYCODE(SCANCODE_RSHIFT) */
	SDLK_RALT                 = 0x400000e6, /* SCANCODE_TO_KEYCODE(SCANCODE_RALT) */
	SDLK_RGUI                 = 0x400000e7, /* SCANCODE_TO_KEYCODE(SCANCODE_RGUI) */
	SDLK_MODE                 = 0x40000101, /* SCANCODE_TO_KEYCODE(SCANCODE_MODE) */
	SDLK_SLEEP                = 0x40000102, /* SCANCODE_TO_KEYCODE(SCANCODE_SLEEP) */
	SDLK_WAKE                 = 0x40000103, /* SCANCODE_TO_KEYCODE(SCANCODE_WAKE) */
	SDLK_CHANNEL_INCREMENT    = 0x40000104, /* SCANCODE_TO_KEYCODE(SCANCODE_CHANNEL_INCREMENT) */
	SDLK_CHANNEL_DECREMENT    = 0x40000105, /* SCANCODE_TO_KEYCODE(SCANCODE_CHANNEL_DECREMENT) */
	SDLK_MEDIA_PLAY           = 0x40000106, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_PLAY) */
	SDLK_MEDIA_PAUSE          = 0x40000107, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_PAUSE) */
	SDLK_MEDIA_RECORD         = 0x40000108, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_RECORD) */
	SDLK_MEDIA_FAST_FORWARD   = 0x40000109, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_FAST_FORWARD) */
	SDLK_MEDIA_REWIND         = 0x4000010a, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_REWIND) */
	SDLK_MEDIA_NEXT_TRACK     = 0x4000010b, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_NEXT_TRACK) */
	SDLK_MEDIA_PREVIOUS_TRACK = 0x4000010c, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_PREVIOUS_TRACK) */
	SDLK_MEDIA_STOP           = 0x4000010d, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_STOP) */
	SDLK_MEDIA_EJECT          = 0x4000010e, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_EJECT) */
	SDLK_MEDIA_PLAY_PAUSE     = 0x4000010f, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_PLAY_PAUSE) */
	SDLK_MEDIA_SELECT         = 0x40000110, /* SCANCODE_TO_KEYCODE(SCANCODE_MEDIA_SELECT) */
	SDLK_AC_NEW               = 0x40000111, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_NEW) */
	SDLK_AC_OPEN              = 0x40000112, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_OPEN) */
	SDLK_AC_CLOSE             = 0x40000113, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_CLOSE) */
	SDLK_AC_EXIT              = 0x40000114, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_EXIT) */
	SDLK_AC_SAVE              = 0x40000115, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_SAVE) */
	SDLK_AC_PRINT             = 0x40000116, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_PRINT) */
	SDLK_AC_PROPERTIES        = 0x40000117, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_PROPERTIES) */
	SDLK_AC_SEARCH            = 0x40000118, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_SEARCH) */
	SDLK_AC_HOME              = 0x40000119, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_HOME) */
	SDLK_AC_BACK              = 0x4000011a, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_BACK) */
	SDLK_AC_FORWARD           = 0x4000011b, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_FORWARD) */
	SDLK_AC_STOP              = 0x4000011c, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_STOP) */
	SDLK_AC_REFRESH           = 0x4000011d, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_REFRESH) */
	SDLK_AC_BOOKMARKS         = 0x4000011e, /* SCANCODE_TO_KEYCODE(SCANCODE_AC_BOOKMARKS) */
	SDLK_SOFTLEFT             = 0x4000011f, /* SCANCODE_TO_KEYCODE(SCANCODE_SOFTLEFT) */
	SDLK_SOFTRIGHT            = 0x40000120, /* SCANCODE_TO_KEYCODE(SCANCODE_SOFTRIGHT) */
	SDLK_CALL                 = 0x40000121, /* SCANCODE_TO_KEYCODE(SCANCODE_CALL) */
	SDLK_ENDCALL              = 0x40000122, /* SCANCODE_TO_KEYCODE(SCANCODE_ENDCALL) */
}


// Valid key modifiers (possibly OR'd together).
//
// \since This datatype is available since SDL 3.0.0.

Keymod :: enum c.uint16_t {
	NONE   = 0x0000, /**< no modifier is applicable. */
	LSHIFT = 0x0001, /**< the left Shift key is down. */
	RSHIFT = 0x0002, /**< the right Shift key is down. */
	LCTRL  = 0x0040, /**< the left Ctrl (Control) key is down. */
	RCTRL  = 0x0080, /**< the right Ctrl (Control) key is down. */
	LALT   = 0x0100, /**< the left Alt key is down. */
	RALT   = 0x0200, /**< the right Alt key is down. */
	LGUI   = 0x0400, /**< the left GUI key (often the Windows key) is down. */
	RGUI   = 0x0800, /**< the right GUI key (often the Windows key) is down. */
	NUM    = 0x1000, /**< the Num Lock key (may be located on an extended keypad) is down. */
	CAPS   = 0x2000, /**< the Caps Lock key is down. */
	MODE   = 0x4000, /**< the !AltGr key is down. */
	SCROLL = 0x8000, /**< the Scroll Lock key is down. */
	CTRL   = (LCTRL | RCTRL), /**< Any Ctrl key is down. */
	SHIFT  = (LSHIFT | RSHIFT), /**< Any Shift key is down. */
	ALT    = (LALT | RALT), /**< Any Alt key is down. */
	GUI    = (LGUI | RGUI), /**< Any GUI key is down. */
}