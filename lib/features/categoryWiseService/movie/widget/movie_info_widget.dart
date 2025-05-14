import 'package:flutter/material.dart';

class MovieInfoWidget extends StatelessWidget {
  const MovieInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('SHAMBHALA'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple, Colors.blue],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.calendar_today, '2024-09-13'),
                  _buildInfoRow(Icons.movie, 'Drama, Adventure'),
                  _buildInfoRow(Icons.access_time, '2 hrs 50 mins'),
                  const SizedBox(height: 16),
                  Text(
                    'Synopsis',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'In a Himalayan polyandrous village, pregnant PEMA faces scrutiny as her husband vanishes. With her monk brother-in-law, her de facto spouse, she seeks him in the wild, unraveling her own self-discovery along the journey.\n(WITH ENGLISH SUBTITLES)',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.person, 'Director: Min Bahadur Bham'),
                  _buildInfoRow(Icons.people,
                      'Cast: Thinley Lhamo, Sonam Topden, Karma Shakya'),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement trailer playback
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Watch Trailer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
