import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/user.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  void _openEdit(BuildContext context, User user) {
    final cubit = context.read<ProfileCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: EditProfilePage(user: user),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().logout();
      if (context.canPop()) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (p, c) => p.user != c.user,
            builder: (context, state) {
              final user = state.user;
              if (user == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () => _openEdit(context, user),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProfileStatus.failure && state.user == null) {
            return _ErrorView(
              message: state.failure?.message ?? 'Error loading profile',
              onRetry: () => context.read<ProfileCubit>().load(),
            );
          }
          final user = state.user;
          if (user == null) return const SizedBox.shrink();
          return RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Header(user: user),
                const SizedBox(height: 24),
                _InfoCard(user: user),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log out'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final User user;
  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            user.initials,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(user.fullName, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          '@${user.username}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final User user;
  const _InfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _InfoRow(icon: Icons.email_outlined, label: 'Email', value: user.email),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: user.phone,
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: '${user.street}, ${user.city}',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon),
      title: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
      subtitle: Text(value, style: theme.textTheme.bodyLarge),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 72,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
