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

#ifndef _GUI_HEADER
#define _GUI_HEADER

#ifdef __cplusplus
#include <string>

int gui_forceRender(void);
int gui_changePage(std::string newPage);
int gui_changeOverlay(std::string overlay);
std::string gui_parse_text(std::string str);
std::string gui_lookup(const std::string& resource_name, const std::string& default_value);

extern "C" {
#endif

int gui_init(void);
int gui_loadResources(void);
int gui_loadCustomResources(void);
int gui_start(void);
int gui_startPage(const char *page_name, const int allow_commands, int stop_on_page_done);
void set_scale_values(float w, float h);
int scale_theme_x(int initial_x);
int scale_theme_y(int initial_y);
int scale_theme_min(int initial_value);
float get_scale_w();
float get_scale_h();

#ifdef __cplusplus
}
#endif

#endif // _GUI_HEADER
