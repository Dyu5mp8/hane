import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hane/login/logo.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return DrawerHeader(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(204, 225, 237, 1),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            width: 1,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user != null
              ? CircleAvatar(
                radius: 28,
                backgroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
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
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                child: Icon(
                  Icons.person,
                  size: 28,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
          const SizedBox(height: 16),
          const Logo(size: 20),
          const SizedBox(height: 4),
          Text(
            user != null ? 'Inloggad som ${user.email!}' : 'Inte inloggad',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
