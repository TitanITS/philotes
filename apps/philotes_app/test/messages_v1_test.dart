import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/data/development/development_member_fixture.dart';
import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/app/philotes_shell_screen.dart';

void main() {
  setUp(() {
    final profile = OnboardingProfileData.instance;

    profile.reset();

    DevelopmentMemberFixture.seedMissingProfileData();
  });

  Future<void> openMessages(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('navMessages')));

    await tester.pumpAndSettle();
  }

  testWidgets('Messages opens from main navigation', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    expect(find.byKey(const Key('messagesScreen')), findsOneWidget);

    expect(find.text('Recent Conversations'), findsOneWidget);
  });

  testWidgets('Unread conversations are emphasized', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    expect(find.byKey(const Key('unreadBadge-thread-jordan')), findsOneWidget);

    expect(
      find.byKey(const Key('unreadBadge-thread-bowling-night')),
      findsOneWidget,
    );
  });

  testWidgets('Unread badge clears immediately when thread opens', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    expect(find.byKey(const Key('unreadBadge-thread-jordan')), findsOneWidget);

    final jordan = find.byKey(const Key('messageThread-thread-jordan'));

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);

    //
    // Pump the navigation transition.
    //
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('conversationScreen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('backToMessagesButton')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('unreadBadge-thread-jordan')), findsNothing);
  });

  testWidgets('Direct conversation opens', (WidgetTester tester) async {
    await openMessages(tester);

    final jordan = find.byKey(const Key('messageThread-thread-jordan'));

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('conversationScreen')), findsOneWidget);

    expect(find.text('Are you free Saturday?'), findsOneWidget);

    expect(find.byKey(const Key('sendMessageButton')), findsOneWidget);
  });

  testWidgets('Message can be composed locally', (WidgetTester tester) async {
    await openMessages(tester);

    final jordan = find.byKey(const Key('messageThread-thread-jordan'));

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('messageComposerField')),
      'Testing Philotes messaging.',
    );

    await tester.tap(find.byKey(const Key('sendMessageButton')));

    await tester.pumpAndSettle();

    expect(find.text('Testing Philotes messaging.'), findsOneWidget);
  });

  testWidgets('Create Message opens friend selector', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    await tester.tap(find.byKey(const Key('createMessageButton')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('newMessageScreen')), findsOneWidget);

    expect(find.text('Jordan'), findsOneWidget);

    expect(find.text('Taylor'), findsOneWidget);

    expect(find.text('Morgan'), findsOneWidget);
  });

  testWidgets('Multiple friends create group mode', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    await tester.tap(find.byKey(const Key('createMessageButton')));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('messageFriendChoice-dev-jordan')));

    await tester.tap(find.byKey(const Key('messageFriendChoice-dev-taylor')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('groupNameField')), findsOneWidget);

    expect(find.text('Create Group Message'), findsOneWidget);
  });

  testWidgets('Direct message cannot add participants', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    final jordan = find.byKey(const Key('messageThread-thread-jordan'));

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);
    await tester.pumpAndSettle();

    expect(find.text('Add Person'), findsNothing);

    expect(find.text('Add People'), findsNothing);
  });

  testWidgets('Home unread conversations opens Messages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    final unread = find.byKey(const Key('openMessagesFromHomeButton'));

    await tester.ensureVisible(unread);
    await tester.tap(unread);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('messagesScreen')), findsOneWidget);
  });
  testWidgets('Messages bulk selection marks threads read and unread', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    await tester.ensureVisible(find.byKey(const Key('messagesOptionsMenu')));

    await tester.tap(find.byKey(const Key('messagesOptionsMenu')));

    await tester.pumpAndSettle();

    await tester.tap(find.text('Select Conversations'));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('messageSelectionToolbar')), findsOneWidget);

    final jordan = find.byKey(const Key('messageThread-thread-jordan'));

    final bowling = find.byKey(const Key('messageThread-thread-bowling-night'));

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);
    await tester.pumpAndSettle();

    await tester.ensureVisible(bowling);
    await tester.tap(bowling);
    await tester.pumpAndSettle();

    final markReadButton = find.byKey(const Key('bulkMarkReadButton'));

    await tester.ensureVisible(markReadButton);
    await tester.tap(markReadButton);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('unreadBadge-thread-jordan')), findsNothing);

    expect(
      find.byKey(const Key('unreadBadge-thread-bowling-night')),
      findsNothing,
    );

    await tester.ensureVisible(find.byKey(const Key('messagesOptionsMenu')));

    await tester.tap(find.byKey(const Key('messagesOptionsMenu')));

    await tester.pumpAndSettle();

    await tester.tap(find.text('Select Conversations'));

    await tester.pumpAndSettle();

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);
    await tester.pumpAndSettle();

    final markUnreadButton = find.byKey(const Key('bulkMarkUnreadButton'));

    await tester.ensureVisible(markUnreadButton);
    await tester.tap(markUnreadButton);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('unreadBadge-thread-jordan')), findsOneWidget);
  });

  testWidgets('Long press enters Messages selection mode', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    final jordan = find.byKey(const Key('messageThread-thread-jordan'));

    await tester.longPress(jordan);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('messageSelectionToolbar')), findsOneWidget);

    expect(
      find.byKey(const Key('messageCheckbox-thread-jordan')),
      findsOneWidget,
    );
  });

  testWidgets('Conversation menu toggles Mark Unread and Mark Read', (
    WidgetTester tester,
  ) async {
    await openMessages(tester);

    final jordan = find.byKey(const Key('messageThread-thread-jordan'));

    await tester.tap(jordan);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('conversationOptionsMenu')));

    await tester.pumpAndSettle();

    expect(find.text('Mark Unread'), findsOneWidget);

    await tester.tap(find.text('Mark Unread'));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('conversationOptionsMenu')));

    await tester.pumpAndSettle();

    expect(find.text('Mark Read'), findsOneWidget);
  });
}
