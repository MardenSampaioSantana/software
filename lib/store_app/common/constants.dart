/*
 * Copyright (C) 2022 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'package:flutter/material.dart';

const pagePadding = 20.0;
const dialogWidth = 450.0;
const kGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  mainAxisExtent: 110,
  mainAxisSpacing: 15,
  crossAxisSpacing: 15,
  maxCrossAxisExtent: 550,
);
const positiveGreenLightTheme = Color.fromARGB(255, 51, 121, 63);
const positiveGreenDarkTheme = Color.fromARGB(255, 128, 211, 143);
