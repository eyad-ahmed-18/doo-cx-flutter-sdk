# DOO CX Flutter SDK Example

This is a demonstration application for the DOO CX Flutter SDK, showcasing different integration methods and usage patterns.

## Features

This example app demonstrates:

1. **Webview Widget Integration** - Embedding the DOO CX chat widget directly in your app
2. **Chat Dialog Integration** - Showing a dialog with DOO CX chat functionality
3. **Chat Page Integration** - Navigating to a full-screen chat page
4. **Custom Client Integration** - Building a custom UI while using the DOO CX client

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- DOO CX account with a valid inbox

### Setup

1. Update the following values in the example app:
   - Replace `"your_website_token"` with your actual DOO CX website token
   - Replace `"your_inbox_identifier"` with your actual inbox identifier
   - Update the `baseUrl` if you're using a custom DOO CX installation

2. Run the app:
```bash
flutter pub get
flutter run
```

## Integration Examples

### Webview Widget

The simplest integration that embeds the DOO CX chat widget directly in your app.

```dart
DOOWidget(
  websiteToken: "your_website_token",
  baseUrl: "https://cx.doo.ooo",
  user: DOOUser(
    identifier: "user_id",
    name: "User Name",
    email: "user@example.com",
  ),
  locale: "en",
  closeWidget: () => Navigator.pop(context),
  onAttachFile: handleAttachFile,
)
```

### Chat Dialog

Show a dialog with DOO CX chat functionality:

```dart
DOOChatDialog.show(
  context,
  baseUrl: "https://cx.doo.ooo",
  inboxIdentifier: "your_inbox_identifier",
  title: "DOO Support",
  user: DOOUser(
    identifier: "user_id",
    name: "User Name",
    email: "user@example.com",
  ),
);
```

### Chat Page

Navigate to a full-screen chat page:

```dart
DOOChatPage(
  baseUrl: "https://cx.doo.ooo",
  inboxIdentifier: "your_inbox_identifier",
  user: DOOUser(
    identifier: "user_id",
    name: "User Name",
    email: "user@example.com",
  ),
  appBar: AppBar(title: const Text('Chat Page')),
)
```

### Custom Client

Build a custom UI while using the DOO CX client:

```dart
// Initialize client
_client = await DOOClient.create(
  baseUrl: "https://cx.doo.ooo",
  inboxIdentifier: "your_inbox_identifier",
  user: DOOUser(
    identifier: "user_id",
    name: "User Name",
    email: "user@example.com",
  ),
  callbacks: dooCallbacks,
);

// Send a message
await _client.sendMessage(content: "Hello from custom UI!");

// Load messages
await _client.loadMessages();
```

## File Attachments

The example app includes a sample implementation for handling file attachments using the `image_picker` package.

## License

See the main package license file.
