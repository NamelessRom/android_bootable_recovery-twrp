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

#include <stdio.h>

#include "../twcommon.h"
#include "rapidxml.hpp"

void rapidxml::parse_error_handler(const char *what, void *where)
{
	fprintf(stderr, "Parser error: %s\n", what);
	fprintf(stderr, "  Start of string: %s\n",(char *) where);
	LOGERR("Error parsing XML file.\n");
}
