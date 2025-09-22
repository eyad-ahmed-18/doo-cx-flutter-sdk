# DOO CX Flutter SDK Testing Guide

This guide provides comprehensive testing procedures to verify that your DOO CX Flutter SDK integration is functioning correctly.

## Prerequisites

Before beginning testing, make sure you have:

1. Valid DOO CX account credentials
2. Access to a DOO CX inbox
3. Your website token and inbox identifier
4. A Flutter application with the DOO CX Flutter SDK properly installed

## Testing Workflow

### 1. Basic Connectivity Testing

**Objective**: Verify that the SDK can connect to the DOO CX backend.

**Steps**:
1. Initialize the DOO client with valid credentials:
   ```dart
   final client = await DOOClient.create(
     baseUrl: "https://cx.doo.ooo",
     inboxIdentifier: "your_inbox_identifier",
     user: DOOUser(
       identifier: "test_user",
       name: "Test User",
       email: "test@example.com",
     ),
     callbacks: dooCallbacks,
   );
   ```
2. Add an `onWelcome` callback to verify connection:
   ```dart
   final dooCallbacks = DOOCallbacks(
     onWelcome: () {
       print("Successfully connected to DOO CX");
     },
     onError: (error) {
       print("Connection error: ${error.cause}");
     },
   );
   ```

**Expected Result**: The `onWelcome` callback should be triggered, indicating successful connection.

### 2. Message Loading Testing

**Objective**: Verify that the SDK can load existing messages.

**Steps**:
1. Create a DOO client as in the previous test
2. Add an `onMessagesRetrieved` callback:
   ```dart
   final dooCallbacks = DOOCallbacks(
     onMessagesRetrieved: (messages) {
       print("Retrieved ${messages.length} messages");
     },
   );
   ```
3. Call `client.loadMessages()`

**Expected Result**: The `onMessagesRetrieved` callback should be triggered with any existing messages.

### 3. Message Sending Testing

**Objective**: Verify that the SDK can send messages to the DOO CX backend.

**Steps**:
1. Create a DOO client as in the previous tests
2. Add `onMessageSent` and `onMessageReceived` callbacks:
   ```dart
   final dooCallbacks = DOOCallbacks(
     onMessageSent: (message, echoId) {
       print("Message sent with ID: $echoId");
     },
     onMessageReceived: (message) {
       print("Message received: ${message.content}");
     },
   );
   ```
3. Send a test message:
   ```dart
   final echoId = await client.sendMessage(content: "Test message from Flutter SDK");
   ```

**Expected Result**: 
- The `onMessageSent` callback should be triggered with the sent message.
- If auto-responses are configured in DOO CX, the `onMessageReceived` callback should be triggered with the response.

### 4. Widget Display Testing

**Objective**: Verify that the DOO widget can be displayed and interacted with.

**Steps**:
1. Implement the DOO widget in your UI:
   ```dart
   DOOWidget(
     websiteToken: "your_website_token",
     baseUrl: "https://cx.doo.ooo",
     user: DOOUser(
       identifier: "test_user",
       name: "Test User",
       email: "test@example.com",
     ),
     locale: "en",
     closeWidget: () => Navigator.pop(context),
     onLoadCompleted: () {
       print("Widget loaded successfully");
     },
   )
   ```
2. Verify that the widget loads and displays properly
3. Try sending a message through the widget interface

**Expected Result**: 
- The widget should display without errors
- Messages sent through the widget should appear in the DOO CX dashboard

### 5. File Attachment Testing

**Objective**: Verify that file attachments work properly.

**Steps**:
1. Implement the file attachment handler:
   ```dart
   Future<List<String>> handleAttachFile() async {
     // Implementation using image_picker or file_picker
     // Return a list of file URIs
   }
   ```
2. Provide this handler to the DOO widget:
   ```dart
   DOOWidget(
     // Other parameters...
     onAttachFile: handleAttachFile,
   )
   ```
3. Test attaching and sending files through the widget

**Expected Result**: Files should be properly attached and sent to the DOO CX backend.

### 6. Persistence Testing

**Objective**: Verify that messages are properly persisted.

**Steps**:
1. Create a DOO client and send several messages
2. Close the application completely
3. Reopen the application and reinitialize the DOO client
4. Add an `onPersistedMessagesRetrieved` callback:
   ```dart
   final dooCallbacks = DOOCallbacks(
     onPersistedMessagesRetrieved: (persistedMessages) {
       print("Retrieved ${persistedMessages.length} persisted messages");
     },
   );
   ```

**Expected Result**: The `onPersistedMessagesRetrieved` callback should be triggered with the previously sent messages.

### 7. Error Handling Testing

**Objective**: Verify that the SDK properly handles errors.

**Steps**:
1. Create a DOO client with invalid credentials:
   ```dart
   final client = await DOOClient.create(
     baseUrl: "https://cx.doo.ooo",
     inboxIdentifier: "invalid_inbox",
     user: DOOUser(
       identifier: "test_user",
       name: "Test User",
       email: "test@example.com",
     ),
     callbacks: dooCallbacks,
   );
   ```
2. Add an `onError` callback:
   ```dart
   final dooCallbacks = DOOCallbacks(
     onError: (error) {
       print("Error: ${error.cause}");
     },
   );
   ```

**Expected Result**: The `onError` callback should be triggered with information about the authentication failure.

## Integration Testing

### Chat Dialog Testing

**Objective**: Verify that the Chat Dialog integration works properly.

**Steps**:
1. Show the chat dialog:
   ```dart
   DOOChatDialog.show(
     context,
     baseUrl: "https://cx.doo.ooo",
     inboxIdentifier: "your_inbox_identifier",
     title: "DOO Support",
     user: DOOUser(
       identifier: "test_user",
       name: "Test User",
       email: "test@example.com",
     ),
   );
   ```
2. Verify that the dialog displays and functions properly
3. Test sending and receiving messages

**Expected Result**: The dialog should display and allow message exchange with the DOO CX backend.

### Chat Page Testing

**Objective**: Verify that the Chat Page integration works properly.

**Steps**:
1. Navigate to the chat page:
   ```dart
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => DOOChatPage(
         baseUrl: "https://cx.doo.ooo",
         inboxIdentifier: "your_inbox_identifier",
         user: DOOUser(
           identifier: "test_user",
           name: "Test User",
           email: "test@example.com",
         ),
         appBar: AppBar(title: const Text('Chat Page')),
       ),
     ),
   );
   ```
2. Verify that the page displays and functions properly
3. Test sending and receiving messages

**Expected Result**: The page should display and allow message exchange with the DOO CX backend.

## Troubleshooting

If you encounter issues during testing, verify:

1. **Connectivity**: Ensure your device has a stable internet connection.
2. **Credentials**: Double-check your website token and inbox identifier.
3. **Backend Status**: Verify that your DOO CX backend is up and running.
4. **Logs**: Check application logs for any error messages.
5. **Permissions**: Ensure your app has proper permissions for file access if using file attachments.

## Additional Testing Resources

- Use the example app provided with the SDK to see working implementations
- Monitor the DOO CX dashboard to verify message receipt
- Test on both Android and iOS devices to ensure cross-platform compatibility