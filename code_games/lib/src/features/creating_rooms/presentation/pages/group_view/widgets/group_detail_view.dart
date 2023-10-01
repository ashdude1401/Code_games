import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_games/src/features/creating_rooms/domain/entity/group_entity.dart';

class GroupDetailView extends StatefulWidget {
  const GroupDetailView({Key? key, required this.group}) : super(key: key);

  final GroupEntity group;

  @override
  State<GroupDetailView> createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends State<GroupDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.group.groupImg),
                radius: 50,
              ),
              const SizedBox(height: 20),
              Text(
                widget.group.groupName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.group.groupDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildExpansionTile('Challenge Details', _buildChallenges()),
              const SizedBox(height: 20),
              _buildListTile('Group Members', _buildMembers()),
              const SizedBox(height: 20),
              _buildListTile('Administrators', _buildAdmins()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, Widget content) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: [content],
    );
  }

  Widget _buildListTile(String title, Widget content) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: content,
      ),
    );
  }

  Widget _buildChallenges() {
    return Column(
      children: widget.group.challengeList
          .map(
            (challenge) => ListTile(
              title: Text(challenge.challengeName),
              subtitle: Text(challenge.challengeDescription),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMembers() {
    return Column(
      children: widget.group.groupMembers
          .map(
            (member) => ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(member.userImg),
              ),
              title: Text(member.userName),
              subtitle: Text(member.email),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAdmins() {
    return Column(
      children: widget.group.admins
          .map(
            (admin) => ListTile(
              title: Text(admin),
            ),
          )
          .toList(),
    );
  }
}
