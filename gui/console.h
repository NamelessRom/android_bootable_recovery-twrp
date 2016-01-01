/*
	Copyright 2012 bigbiff/Dees_Troy TeamWin
	This file is part of TWRP/TeamWin Recovery Project.

	TWRP is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	TWRP is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with TWRP.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _CONSOLE_HEADER
#define _CONSOLE_HEADER

#include <stdio.h>

#ifdef __cplusplus
#include "twmsg.hpp"

void gui_msg(const char* text);
void gui_warn(const char* text);
void gui_err(const char* text);
void gui_highlight(const char* text);
void gui_msg(Message msg);

extern "C" {
#endif

void __gui_print(const char *color, char *buf);
void gui_print(const char *fmt, ...);
void gui_print_color(const char *color, const char *fmt, ...);
void gui_set_FILE(FILE* f);

#ifdef __cplusplus
}
#endif

#endif  // _CONSOLE_HEADER
