#!/bin/bash

#  clean-script.sh
#  Visafe
#
#
#   This file is part of Visafe for iOS (https://github.com/VisafeTeam/VisafeForiOS).
#   Copyright © Visafe Software Limited. All rights reserved.
#
#   Visafe for iOS is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   Visafe for iOS is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Visafe for iOS.  If not, see <http://www.gnu.org/licenses/>.


echo "Clean Script Running with ACTION=${ACTION}"

case $ACTION in
# NOTE: for some reason, it gets set to "" rather than "build" when
# doing a build.
"")
;;

"clean")
echo "Clean in \"${ACTION_RESOURCES_DIR}\""
rm -fRv "${ACTION_RESOURCES_DIR}"
exit 0
;;

esac

