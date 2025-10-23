# Project Rules
## Project Overview
- **Name**: MindRing - AI-powered self-awareness companion
- **Version**: MVP 1.0
- **Platforms**: iOS Native App + Web App
- **Core Feature**: Self-Awareness scoring with Alex AI companion

## Project Design
- `doc/MVP1.0_UI0.2_En.html`: Interactive UI prototype with Self-Awareness single metric focus and recording panel.
- `doc/MVP1.0_PRD0.2.md`: Product Requirements Document v0.2 with detailed specifications.
- `design/mindring-alex-avatar.png`: Alex avatar.
- `design/mindring-logo.png`: MindRing Product logo.

## Project development environment paths
- `web/`: /Volumes/project/software/mindringforweb/web
- `iosmobile/`: /Volumes/project/software/mindringforweb/iostrae/MindRingNew
- `server/`: /Volumes/project/software/mindringforweb/iostrae/backend

## Technology Stack
### iOS App
- **Framework**: SwiftUI
- **Language**: Swift
- **Design System**: `DesignSystem.swift` (centralized colors, typography, spacing)
- **Key Features**: Audio recording, speech recognition, AI chat with Alex

### Web App  
- **Framework**: Vanilla HTML/CSS/JavaScript
- **Styling**: CSS with custom design system in `styles.css`
- **Server**: Python HTTP server for development

### Backend
- **Runtime**: Node.js
- **Location**: `iostrae/backend/`

## Design System Reference
- **Colors**: Defined in both `DesignSystem.swift` (iOS) and `styles.css` (Web)
- **Primary Palette**: Forest (#2f5d3e), Moss (#5b8a72), Earth (#b97a3c), Fog (#f9f6ef)
- **Typography**: Inter font family, consistent sizing across platforms
- **Assets**: Shared images in `web/images/`, iOS assets in `Resources/Assets.xcassets`

## Development Guidelines
- **Asset Management**: Keep images in `web/images/` as source, copy to iOS when needed
- **Color Consistency**: Update both iOS and Web design systems when changing colors
- **File Naming**: Use kebab-case for web assets, camelCase for iOS code
- **Alex Avatar**: Use `mindring-alex` as resource name in iOS, ensure proper sizing (24x24, 48x48, 72x72)