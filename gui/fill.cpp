/*
	Copyright 2015 TeamWin
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

// fill.cpp - GUIFill object

#include <stdbool.h>

#include "../minuitwrp/minui.h"
#include "../twcommon.h"
#include "objects.hpp"
#include "pages.hpp"
#include "rapidxml.hpp"

GUIFill::GUIFill(xml_node<>* node) : GUIObject(node)
{
	bool has_color = false;
	mColor = LoadAttrColor(node, "color", &has_color);
	if (!has_color) {
		LOGERR("No color specified for fill\n");
		return;
	}

	// Load the placement
	LoadPlacement(FindNode(node, "placement"), &mRenderX, &mRenderY, &mRenderW, &mRenderH);

	return;
}

int GUIFill::Render(void)
{
	if(!isConditionTrue())
		return 0;

	gr_color(mColor.red, mColor.green, mColor.blue, mColor.alpha);
	gr_fill(mRenderX, mRenderY, mRenderW, mRenderH);
	return 0;
}

