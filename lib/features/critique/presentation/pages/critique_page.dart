import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:art_critique/core/di/injection.dart';
import 'package:art_critique/features/critique/domain/entities/artwork.dart';
import 'package:art_critique/features/critique/domain/entities/persona_id.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_bloc.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_event.dart';
import 'package:art_critique/features/critique/presentation/bloc/critique_state.dart';
import 'package:art_critique/features/critique/presentation/widgets/persona_critique_card.dart';

class CritiquePage extends StatelessWidget {
  const CritiquePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CritiqueBloc>(),
      child: const CritiqueView(),
    );
  }
}

class CritiqueView extends StatefulWidget {
  const CritiqueView({super.key});

  @override
  State<CritiqueView> createState() => _CritiqueViewState();
}

class _CritiqueViewState extends State<CritiqueView> {
  final _picker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (file == null) return;

    setState(() => _selectedImage = file);

    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    if (mounted) {
      context.read<CritiqueBloc>().add(
            UploadArtworkAndCritique(
              Artwork(base64Image: base64Image, fileName: file.name),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Critique'),
        centerTitle: true,
      ),
      body: BlocListener<CritiqueBloc, CritiqueState>(
        listener: (context, state) {
          if (state is CritiqueError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ImagePreview(
                    selectedImage: _selectedImage,
                    onPickImage: _pickImage,
                  ),
                  const SizedBox(height: 24),
                  _CritiquePanels(selectedImage: _selectedImage),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final XFile? selectedImage;
  final VoidCallback onPickImage;

  const _ImagePreview({
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedImage != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              selectedImage!.path,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          )
        else
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No artwork selected',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onPickImage,
          icon: const Icon(Icons.upload_outlined),
          label: Text(
            selectedImage == null ? 'Upload Artwork' : 'Change Artwork',
          ),
        ),
      ],
    );
  }
}

class _CritiquePanels extends StatelessWidget {
  final XFile? selectedImage;

  const _CritiquePanels({required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CritiqueBloc, CritiqueState>(
      builder: (context, state) {
        final isLoading = state is CritiqueLoading;
        final critiques = state is CritiqueLoaded ? state.critiques : null;
        final errorMessage = state is CritiqueError ? state.message : null;

        return Column(
          children: PersonaId.values.map((personaId) {
            final critique = critiques?.firstWhere(
              (c) => c.personaId == personaId,
              orElse: () => throw StateError('Missing persona $personaId'),
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PersonaCritiqueCard(
                personaId: personaId,
                critique: critique,
                isLoading: isLoading,
                error: errorMessage,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
