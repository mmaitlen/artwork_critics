import 'package:flutter/material.dart';

import 'package:art_critique/features/critique/domain/entities/persona_critique.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';

class PersonaCritiqueCard extends StatelessWidget {
  final PersonaId personaId;
  final PersonaCritique? critique;
  final bool isLoading;
  final String? error;

  const PersonaCritiqueCard({
    super.key,
    required this.personaId,
    this.critique,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              personaId.label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              personaId.roleDescription,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const Divider(height: 24),
            _buildBody(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (isLoading) {
      return const _LoadingShimmer();
    }
    if (error != null) {
      return Text(
        'Unable to generate critique.',
        style: TextStyle(color: theme.colorScheme.error),
      );
    }
    if (critique != null) {
      return Text(
        critique!.critiqueText,
        style: theme.textTheme.bodyMedium,
      );
    }
    return Text(
      'Upload an artwork to receive a critique.',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.outline,
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerLine(1.0),
        const SizedBox(height: 8),
        _shimmerLine(0.85),
        const SizedBox(height: 8),
        _shimmerLine(0.7),
      ],
    );
  }

  Widget _shimmerLine(double widthFactor) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 14,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

extension on PersonaId {
  String get roleDescription {
    switch (this) {
      case PersonaId.buyer:
        return 'Collector · Investment lens';
      case PersonaId.admirer:
        return 'Enthusiast · Emotional response';
      case PersonaId.skeptic:
        return 'Critic · Challenges value';
    }
  }
}
