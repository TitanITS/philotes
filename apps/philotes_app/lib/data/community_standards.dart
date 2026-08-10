import '../models/community_standard.dart';

abstract final class CommunityStandardsData {
  static const String version = '1.0';

  static const List<CommunityStandard> standards = [
    CommunityStandard(
      number: 1,
      title: 'Friendship Comes First',
      summary:
          'Philotes is for genuine friendship, shared interests, and '
          'community - not dating or hookups.',
      details: '''Philotes exists to help people build genuine friendships,
discover shared interests, participate in activities, and create meaningful
social connections.

Members should use Philotes with friendship and community as their purpose.
Philotes is not intended to be a dating, hookup, or sexually focused platform.

We understand that friendships between adults can sometimes naturally develop
into something more. Philotes is not here to police genuine relationships that
develop naturally between consenting adults. However, members may not use
Philotes primarily to pursue dates, sexual encounters, romantic partners, or
repeatedly make unwanted romantic or sexual advances toward other members.

If another member tells you that they are not interested in a romantic or
sexual relationship, respect that boundary immediately.''',
      simpleTerms:
          'Come to Philotes looking for friends. Treat anything beyond '
          'friendship as something that must develop naturally, mutually, '
          'and respectfully - not as the purpose of using the community.',
    ),
    CommunityStandard(
      number: 2,
      title: 'Be Yourself',
      summary:
          'Be truthful about who you are. Impersonation, deceptive profiles, '
          'and fraudulent identities are not allowed.',
      details: '''Trust begins with knowing that the people you meet are
representing themselves honestly.

Members must provide truthful information about themselves and may not
impersonate another person, create a deliberately false identity, misrepresent
themselves in ways intended to deceive others, or use another person's
photographs as their own.

Do not create accounts intended to mislead, manipulate, scam, harass, or
secretly monitor another person.

Members also may not create additional accounts to evade a suspension,
restriction, block, safety measure, or other action taken by Philotes.

We do not expect every profile to tell a person's entire life story. Members
remain in control of what personal information they choose to share, subject to
information Philotes may require for account or safety purposes. Privacy is not
dishonesty.''',
      simpleTerms:
          'You do not have to tell everyone everything about yourself - but '
          'what you do represent about yourself should be genuine.',
    ),
    CommunityStandard(
      number: 3,
      title: 'Treat People With Respect',
      summary:
          'Every member deserves to participate without harassment, bullying, '
          'threats, hate, sexual misconduct, or persistent unwanted contact.',
      details: '''Philotes should be a place where people with different
personalities, backgrounds, abilities, experiences, and interests can meet one
another with dignity and respect.

Harassment, bullying, intimidation, credible threats, stalking behavior,
hateful conduct, targeted humiliation, sexual harassment, and deliberately
abusive behavior are not acceptable.

Do not repeatedly contact someone who has clearly asked you to stop. Do not
pressure another member into conversations, activities, relationships, sharing
information, or physical contact they do not want.

Disagreements will happen. Members are allowed to disagree, end friendships,
leave conversations, decline invitations, and decide that they simply do not
get along.

Disagreement itself is not misconduct.

The expectation is that members handle those situations without harassment,
retaliation, threats, humiliation, or attempts to turn other members against
someone.''',
      simpleTerms:
          'You do not have to like everyone you meet on Philotes. You do have '
          'to treat them with basic dignity and respect.',
    ),
    CommunityStandard(
      number: 4,
      title: 'Respect Boundaries and Privacy',
      summary:
          'Respect personal boundaries and never expose, threaten to expose, '
          'or misuse another person\'s private information.',
      details: '''Every member has the right to control their own personal
information and establish reasonable boundaries around how they interact with
others.

Do not pressure another member to provide their phone number, home address,
workplace, personal email address, precise location, photographs, social-media
accounts, financial information, family information, or other private details.

Never publish, distribute, reveal, or threaten to reveal another person's
private or identifying information without their permission when doing so could
violate their privacy, expose them to unwanted contact, intimidate them, harass
them, or place them at risk.

This includes doxing.

Examples may include another person's home address, private phone number,
workplace information, personal email address, precise location, private
photographs, family details, financial information, identifying documents, or
other sensitive personal information.

This protection does not disappear simply because you knew the person before
encountering them on Philotes. Information learned outside Philotes may not be
weaponized against someone through the Philotes community.

Likewise, information another member trusted you with privately should not be
used to embarrass, threaten, control, retaliate against, or endanger them.

Respect people's decisions about communication and real-world interaction. If
someone does not want to exchange contact information, meet in person, continue
a conversation, or maintain a friendship, respect that decision.''',
      simpleTerms:
          'Someone trusting you with access to their life does not give you '
          'ownership of their information or their boundaries.',
    ),
    CommunityStandard(
      number: 5,
      title: 'Put Safety First',
      summary:
          'Make thoughtful, safe choices online and when meeting people in '
          'person - especially during first gatherings.',
      details: '''Philotes is intended to help online connections develop into
meaningful friendships and shared activities, but personal safety should always
come first.

Take time to get to know someone before deciding to meet them in person. For
initial meetings, Philotes encourages members to choose appropriate public
places and use good judgment about when, where, and how they meet.

Never pressure another member into meeting privately, changing a meeting
location, entering a home or vehicle, consuming alcohol or other substances,
participating in an activity they are uncomfortable with, or remaining
somewhere they want to leave.

Every member has the right to change their mind about a gathering or leave an
interaction at any time.

Do not use Philotes to facilitate violence, exploitation, fraud, coercion,
predatory behavior, or other conduct that could place another person in danger.

Philotes can provide safety tools and encourage safer choices, but no platform
can guarantee another person's behavior. Members should continue using their
own judgment and take reasonable precautions when interacting online and in
person.

If something feels unsafe, members should prioritize their immediate safety
and use Philotes' blocking and reporting tools when appropriate.''',
      simpleTerms:
          'A friendship opportunity is never more important than your safety '
          'or someone else\'s.',
    ),
    CommunityStandard(
      number: 6,
      title: 'Help Protect the Community',
      summary:
          'Use Philotes\' safety tools responsibly and help us address '
          'behavior that threatens members or the community.',
      details: '''A safe community depends on both responsible members and
responsible moderation.

Philotes will provide tools that allow members to block people they no longer
wish to interact with and report behavior they believe violates Community
Standards or creates a safety concern.

If you experience or witness concerning behavior, you may report it. Reports
should be made honestly and in good faith.

Knowingly submitting false reports to punish, intimidate, retaliate against, or
harass another member is itself an abuse of the community's safety systems.

Philotes may review reported behavior and take appropriate action based on the
circumstances. Depending on the seriousness and available information, actions
may include warnings, restrictions, removal of content or privileges, temporary
suspension, or permanent removal from the community.

Immediate or serious safety situations may require actions beyond Philotes'
internal tools. Philotes' reporting system is not a replacement for emergency
services or appropriate authorities when someone faces an immediate real-world
danger.

Members should not attempt to organize public retaliation, harassment, or
vigilante action against someone they believe violated the rules. Report the
concern and allow the appropriate process to address it.''',
      simpleTerms:
          'Protect yourself, look out for others, report genuine concerns, '
          'and do not misuse safety tools to hurt someone.',
    ),
  ];
}
