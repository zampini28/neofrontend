import 'package:flutter/material.dart';
import 'package:physioapp/models/chat/connected_user.dart';
import 'package:physioapp/screens/individual_chat_screen.dart';
import 'package:physioapp/repositories/relationship_repository.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RelationshipProvider>(context, listen: false).fetchConnections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RelationshipProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              'Conversas',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildSearchBar(provider),
              ),
            ),
          ),

          if (provider.isLoadingConnections)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (provider.connections.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final user = provider.connections[index];
                  return _buildUserTile(context, user);
                },
                childCount: provider.connections.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(RelationshipProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: provider.searchConnections,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, ConnectedUser user) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualChatScreen(
              patientName: user.fullname,
              patientId: user.id,
              patientImage: user.imageProvider,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  backgroundImage: user.imageProvider,
                  child: user.profileImageBase64 == null
                      ? Text(user.initials, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))
                      : null,
                ),
                // Positioned(
                //   right: 0,
                //   bottom: 0,
                //   child: Container(
                //     width: 14,
                //     height: 14,
                //     decoration: BoxDecoration(
                //       color: Colors.green,
                //       shape: BoxShape.circle,
                //       border: Border.all(color: Colors.white, width: 2),
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          user.fullname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '', 
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma conexão encontrada',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Provider.of<RelationshipProvider>(context, listen: false).fetchConnections(),
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }
}
