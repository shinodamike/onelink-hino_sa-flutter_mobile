import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:iov/api/api.dart';
import 'package:iov/utils/utils.dart';

class AgreementPage extends StatefulWidget {
  const AgreementPage(
      {super.key,
      this.agreementId = 0,
      this.agreementName = '',
      this.agreementDetail = '',
      this.effectiveDate = ''});

  final int? agreementId;
  final String? agreementName;
  final String? agreementDetail;
  final String? effectiveDate;

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool _isAgreed = false;
  bool _canAgree = false;
  bool _hasScrolledToBottom = false;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'ScrollHandler',
        onMessageReceived: (message) {
          setState(() {
            _hasScrolledToBottom = true;
            _canAgree = true;
          });
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _checkScrollPosition();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.agreementDetail ?? ''));
  }

  void _checkScrollPosition() {
    _controller.runJavaScript('''
      window.addEventListener('scroll', function() {
        var scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        var windowHeight = window.innerHeight;
        var documentHeight = Math.max(
          document.body.scrollHeight,
          document.body.offsetHeight,
          document.documentElement.clientHeight,
          document.documentElement.scrollHeight,
          document.documentElement.offsetHeight
        );
        
        if (scrollTop + windowHeight >= documentHeight - 50) {
          ScrollHandler.postMessage('scrolled_to_bottom');
        }
      });
    ''');
  }

  void _submitAgreement() async {
    if (_isAgreed) {
      var param = jsonEncode({
        'user_id': Api.profile?.userId.toString() ?? '',
        'agreement_id': widget.agreementId,
      });

      try {
        var response = await Api.put(context, Api.agreement_update, param);
        if (response != null) {
          Api.setProfileAgreement(_isAgreed);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/root', (route) => false);
        } else {
          Utils.showAlertDialog(context, 'Failed to submit agreement');
        }
      } catch (e) {
        Utils.showAlertDialog(context, 'Error submitting agreement');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agreementName ?? 'Agreement'),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CheckboxListTile(
                  value: _isAgreed,
                  onChanged: _hasScrolledToBottom ? (value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  } : null,
                  title: Text(
                    _hasScrolledToBottom 
                        ? 'I agree to the terms and conditions'
                        : 'Please scroll to the bottom to continue',
                    style: TextStyle(
                      color: _hasScrolledToBottom ? null : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isAgreed ? _submitAgreement : null,
                    child: const Text('Agree'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
