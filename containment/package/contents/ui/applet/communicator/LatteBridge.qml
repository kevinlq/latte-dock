/*
*  Copyright 2018  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7

Item{
    id: settings

    // NAME: version
    //   USAGE: read-only
    //   EXPLANATION: Latte communication version in order for the applet to use only properties
    //       and parameters that are valid
    // @since: 0.9
    readonly property int version: 9

    // NAME: inEditMode
    //   USAGE: read-only
    //   EXPLANATION: Latte sets it to true when this applet is in a Latte containment and Latte
    //       is also in EditMode, that means when the user is altering applets and Latte latteView settings
    // @since: 0.9
    readonly property bool inEditMode: root.editMode

    // NAME: palette
    //   USAGE: read-only
    //   EXPLANATION: Latte updates it to its coloring palette in order for the applet
    //       to take responsibility of its coloring.
    //   USE CASE: when Latte is transparent and applets colors need to be adjusted in order
    //       to look consistent with the underlying desktop background
    // @since: 0.9
    readonly property QtObject palette: !latteSideColoringEnabled ? colorizerManager : null

    // NAME: applyPalette
    //   USAGE: read-only
    //   EXPLANATION: Latte updates it to TRUE when the applet must use the provided
    //       Latte "palette" and FALSE otherwise
    //   USE CASE: when Latte is transparent and applets colors need to be adjusted in order
    //       to look consistent with the underlying desktop background
    // @since: 0.9
    readonly property bool applyPalette: !latteSideColoringEnabled ? colorizerManager.mustBeShown : false

    // NAME: applyPalette
    //   USAGE: read-only
    //   EXPLANATION: The current icon size used in the Latte View
    //   USE CASE: it can be used from applets that want their size to be always
    //       relevant to the view icon size
    // @since: 0.9
    readonly property int iconSize: root.iconSize

    property Item actions: Actions{}


    // NAME: latteSideColoringEnabled
    // TYPE: bool
    //   USAGE: writable through actions.setProperty
    //   EXPLANATION: when is FALSE, Latte is not painting/colorizing this applet
    //       in any case. In such case the applet can use 'palette'
    //       in order to access the color palette used at all cases from Latte
    //   USE CASE: when Latte is transparent and applets colors need to be adjusted in order
    //       to look consistent with the underlying desktop background OR the applet
    //       is not using monochromatic icons but rather colorful ones.
    // @since: 0.9


    // NAME: latteIconOverlayEnabled
    // TYPE: bool
    //   USAGE: writable through actions.setProperty
    //   EXPLANATION: when is FALSE, Latte is not overlaying any icons above
    //       the applet or alters the applet visual in any sense.
    //       That means that the applet is responsible to provide a coherent
    //       parabolic effect experience.
    // @since: 0.9

    // NAME: activeIndicatorEnabled
    // TYPE: bool
    //   USAGE: writable through actions.setProperty
    //   EXPLANATION: when is TRUE, Latte can show its own Active Indicator
    //       when needed. For FALSE, the Latte Active Indicator is not drawn
    //       or used for that applet.
    // @since: 0.9

    // NAME: parabolicEffectEnabled
    // TYPE: bool
    //   USAGE: writable through actions.setProperty
    //   EXPLANATION: when is TRUE, Latte can use Parabolic Effect in order
    //       to draw that applet. For FALSE, this applet is considered locked
    //       and can not be zoomed.
    // @since: 0.9

    //! Initialize

    Component.onCompleted: {
        appletRootItem.latteBridge = settings;
    }
}
