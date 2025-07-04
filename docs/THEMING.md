# Theme System Documentation

## Overview
The Lore Scanner app now includes a comprehensive theming system that supports light mode, dark mode, and system-based theme switching. The theme system is built using Flutter's Material 3 design principles and provides a consistent, modern user interface.

## Features

### Theme Modes
- **Light Mode**: Clean, bright interface perfect for well-lit environments
- **Dark Mode**: Easy on the eyes for low-light conditions and battery saving
- **System Mode**: Automatically follows the device's system theme setting

### Design Improvements
- **Material 3 Design**: Modern design language with better colors, typography, and spacing
- **Consistent Spacing**: Improved padding and margins throughout the app
- **Better Typography**: Enhanced text styles with proper hierarchy
- **Improved Cards**: Rounded corners, proper elevation, and shadows
- **Better Empty States**: Informative placeholders when no data is available
- **Enhanced Iconography**: More intuitive and consistent icons

## Usage

### Switching Themes
1. Open the app and navigate to the "Einstellungen" (Settings) tab
2. Look for the "Design" section at the top
3. Tap on "Design" to open the theme selection dialog
4. Choose from:
   - **Hell** (Light): Always use light theme
   - **Dunkel** (Dark): Always use dark theme
   - **System**: Follow device system setting

### Theme Persistence
The app automatically saves your theme preference and will remember it when you restart the app.

## Technical Implementation

### ThemeProvider
The `ThemeProvider` class manages the app's theme state:
- Extends `ChangeNotifier` for reactive state management
- Uses `SharedPreferences` for persistent storage
- Provides methods to toggle between themes

### Theme Configuration
Both light and dark themes are pre-configured with:
- Proper color schemes based on Material 3 guidelines
- Consistent component theming (buttons, cards, dialogs)
- Appropriate shadow and elevation settings
- Accessible color contrast ratios

### Integration
The theme system is integrated throughout the app:
- Main app wrapper with `Consumer<ThemeProvider>`
- All screens use theme-aware colors instead of hardcoded values
- Consistent styling across components

## Benefits
- **Better User Experience**: Users can choose their preferred visual style
- **Accessibility**: Dark mode reduces eye strain in low-light conditions
- **Modern Design**: Up-to-date Material 3 design language
- **Consistency**: Unified visual language across the entire app
- **Maintainability**: Centralized theme management makes updates easier