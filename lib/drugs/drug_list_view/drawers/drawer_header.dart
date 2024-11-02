import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user != null
              ? CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  child: Text(
                    user.email![0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
          const SizedBox(height: 16),
          Text(
            'AnestesiH',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                 
                ),
          ),
          const SizedBox(height: 4),
          Text(
            user != null ? 'Inloggad som ${user.email!}' : 'Inte inloggad',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }
}