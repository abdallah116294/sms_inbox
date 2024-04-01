import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:sms_inbox/message_list.dart';
import 'package:permission_handler/permission_handler.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS  Example'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _messages.isNotEmpty
            ? MessagesListView(
                messages: _messages,
              )
            : Center(
                child: Text(
                  'No messages to show.\n Tap refresh button...',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission = await Permission.sms.status;
          if (permission.isGranted) {
            final messages = await _query.querySms(
              kinds: [
                SmsQueryKind.inbox,
                SmsQueryKind.sent,
              ],
              //You must right your address here to get all sms message send and inbox from it 
              //If you want edit code call me
            address: '+201559871964',
              count: _messages.length,
            );
            debugPrint('sms inbox messages: ${messages.length}');

            setState(() => _messages = messages);
          } else {
            await Permission.sms.request();
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
