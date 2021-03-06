/*
*  Copyright 2018 Michail Vourlakos <mvourlakos@gmail.com>
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

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.latte 0.2 as Latte

import "../../code/ColorizerTools.js" as ColorizerTools

Loader{
    id: manager

    //! the loader loads the backgroundTracker component
    active: root.themeColors === Latte.Types.SmartThemeColors

    readonly property bool backgroundIsBusy: item ? item.isBusy : false

    readonly property real themeTextColorBrightness: ColorizerTools.colorBrightness(theme.textColor)
    readonly property color minimizedDotColor: themeTextColorBrightness > 127.5 ? Qt.darker(theme.textColor, 1.7) : Qt.lighter(theme.textColor, 7)

    readonly property bool mustBeShown: (applyTheme && applyTheme !== theme)

    readonly property real currentBackgroundBrightness: item ? item.currentBrightness : -1000

    readonly property bool applyingWindowColors: (root.windowColors === Latte.Types.ActiveWindowColors && latteView.windowsTracker.activeWindowScheme)
                                                 || (root.windowColors === Latte.Types.TouchingWindowColors && latteView.windowsTracker.touchingWindowScheme)

    property QtObject applyTheme: {
        if (!root.hasExpandedApplet) {
            if (root.windowColors === Latte.Types.ActiveWindowColors && latteView.windowsTracker.activeWindowScheme) {
                return latteView.windowsTracker.activeWindowScheme;
            }

            if (root.windowColors === Latte.Types.TouchingWindowColors && latteView.windowsTracker.touchingWindowScheme) {
                //! we must track touching windows and when they are not ative
                //! the active window scheme is used for convenience
                if (latteView.windowsTracker.existsWindowTouching
                        && !latteView.windowsTracker.activeWindowTouching
                        && latteView.windowsTracker.activeWindowScheme) {
                    return latteView.windowsTracker.activeWindowScheme;
                }

                return latteView.windowsTracker.touchingWindowScheme;
            }
        }

        if (themeExtended) {
            if (root.userShowPanelBackground && root.plasmaBackgroundForPopups && root.hasExpandedApplet /*for expanded popups when it is enabled*/
                    || (root.themeColors === Latte.Types.SmartThemeColors /*for Smart theming that Windows colors are not used and the user wants solidness at some cases*/
                        && root.windowColors === Latte.Types.NoneWindowColors
                        && root.forceSolidPanel) ) {
                /* plasma style*/
                return theme;
            }

            if (root.themeColors === Latte.Types.ReverseThemeColors) {
                return themeExtended.isLightTheme ? themeExtended.darkTheme : themeExtended.lightTheme;
            }

            if (root.themeColors === Latte.Types.SmartThemeColors && !root.editMode) {
                if (currentBackgroundBrightness > 127.5) {
                    return themeExtended.lightTheme;
                } else {
                    return themeExtended.darkTheme;
                }
            }
        }

        return theme;
    }

    property color applyColor: textColor

    readonly property color backgroundColor:applyTheme.backgroundColor
    readonly property color textColor: applyTheme.textColor

    readonly property color inactiveBackgroundColor: applyTheme === theme ? theme.backgroundColor : applyTheme.inactiveBackgroundColor
    readonly property color inactiveTextColor: applyTheme === theme ? theme.textColor : applyTheme.inactiveTextColor

    readonly property color highlightColor: theme.highlightColor
    readonly property color highlightedTextColor: theme.highlightedTextColor
    readonly property color positiveTextColor: applyTheme.positiveTextColor
    readonly property color neutralTextColor: applyTheme.neutralTextColor
    readonly property color negativeTextColor: applyTheme.negativeTextColor

    readonly property color buttonTextColor: theme.buttonTextColor
    readonly property color buttonBackgroundColor: theme.buttonBackgroundColor
    readonly property color buttonHoverColor: theme.buttonHoverColor
    readonly property color buttonFocusColor: theme.buttonFocusColor

    readonly property string scheme: {
        if (applyTheme===theme || !mustBeShown) {
            if (themeExtended) {
                return themeExtended.defaultTheme.schemeFile;
            } else {
                return "kdeglobals";
            }
        }

        return applyTheme.schemeFile;
    }

    sourceComponent: Latte.BackgroundTracker {
        activity: managedLayout ? managedLayout.lastUsedActivity : ""
        location: plasmoid.location
        screenName: latteView && latteView.positioner ? latteView.positioner.currentScreenName : ""
    }
}
