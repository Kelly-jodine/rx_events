/// Single local/demo source of truth for the seeded events.
///
/// Dashboard, Events, Reports and Event Details all read from this list so
/// the same event always shows the same title, image and description.
/// Everything here is demo data - nothing is fetched from a backend.
class DemoEvents {
  DemoEvents._();

  static const List<Map<String, String>> all = [
    {
      'title': 'Annual Business Meetup',
      'date': '20 September 2026',
      'time': '10:00 AM - 4:00 PM',
      'location': 'Rajkot',
      'address': 'Rajkot Business Centre, Gujarat',
      'status': 'Upcoming',
      'image': 'assets/images/business_event.jpg',
      'attendees': '120',
      'capacity': '200',
      'summary':
          'A full-day meetup for founders, managers and partners to share '
          'updates and plan the year ahead.',
      'description':
          'The Annual Business Meetup brings together founders, managers and '
          'long-time partners for a full day of updates, panel discussions and '
          'networking. Sessions cover yearly results, new initiatives and '
          'collaboration opportunities, followed by an open networking hour '
          'with refreshments.',
    },
    {
      'title': 'Tech Conference 2026',
      'date': '28 September 2026',
      'time': '9:30 AM - 6:00 PM',
      'location': 'Ahmedabad',
      'address': 'Helix Convention Hall, Ahmedabad',
      'status': 'Upcoming',
      'image': 'assets/images/tech_event.jpg',
      'attendees': '320',
      'capacity': '500',
      'summary':
          'Annual technology conference bringing together startups, '
          'developers and innovators.',
      'description':
          'Tech Conference 2026 is a one-day conference for developers, '
          'product teams and startup founders. The programme includes keynote '
          'talks, hands-on workshops, a startup showcase and dedicated '
          'networking breaks so attendees can meet speakers and peers '
          'throughout the day.',
    },
    {
      'title': 'Corporate Event',
      'date': '12 October 2026',
      'time': '6:00 PM - 10:00 PM',
      'location': 'Rajkot',
      'address': 'Riverside Arena, Rajkot',
      'status': 'Upcoming',
      'image': 'assets/images/corporate_event.jpg',
      'attendees': '85',
      'capacity': '150',
      'summary':
          'An evening corporate gathering with product showcases, team '
          'awards and partner talks.',
      'description':
          'The Corporate Event is an evening programme for teams and '
          'partners, featuring a short product showcase, team awards and '
          'recognition, followed by dinner and informal networking.',
    },
    {
      'title': 'Music Festival',
      'date': '5 October 2026',
      'time': '4:00 PM - 11:00 PM',
      'location': 'Surat',
      'address': 'Surat Open Grounds, Gujarat',
      'status': 'Draft',
      'image': 'assets/images/music_festival.jpg',
      'attendees': '450',
      'capacity': '1000',
      'summary':
          'An open-air music festival with live bands, food stalls and '
          'headliner performances.',
      'description':
          'The Music Festival is an open-air evening with multiple stages, '
          'local and guest bands, food stalls and a headline performance. '
          'Gates open in the late afternoon and the programme runs until '
          'late night.',
    },
  ];

  /// Returns the seeded event matching [title].
  ///
  /// Falls back to the first seeded event so navigation never receives an
  /// empty map.
  static Map<String, String> byTitle(String title) {
    for (final event in all) {
      if (event['title'] == title) {
        return event;
      }
    }

    return all.first;
  }
}
