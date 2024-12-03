import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vault_mobile/constants/color_values.dart';
import 'package:vault_mobile/controllers/theme_controller.dart';
import 'package:vault_mobile/models/document_model.dart';
import 'package:vault_mobile/pages/home/otp_qr_scanner.dart';
import 'package:vault_mobile/pages/home/pdf_view.dart';
import 'package:vault_mobile/widgets/custom_infputfield.dart';
import '../../controllers/document_controller.dart';
import '../../models/document_log_model.dart';
import '../../widgets/circular_button.dart';
import '../../widgets/purpose_dropdown.dart';

class DocumentDetails extends StatefulWidget {
  final DocumentModel document;

  const DocumentDetails({Key? key, required this.document}) : super(key: key);

  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  late DocumentModel _document;
  final _themecController = Get.put(ThemeController());
  final DocumentController _controller = Get.put(DocumentController());
  final TextEditingController _remarksController = TextEditingController();
  bool _isCopyOnly = false;

  @override
  void initState() {
    super.initState();
    _document = widget.document;
    _controller.fetchDataFromAPI(_document.documentNumber);
  }

  Future<void> _refreshDocumentDetails() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final newDocument =
          await _controller.fetchDataFromAPI(_document.documentNumber);

      Navigator.of(context).pop();

      if (newDocument != null) {
        setState(() {
          _document = newDocument;
        });
      }
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh document details: $e'),
        ),
      );
    }
  }

  Future<void> _fetchAndShowDocumentLogs() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<DocumentLog>>(
          future: _controller.fetchDocumentLogs(_document.documentNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching logs: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No logs found.'),
              );
            } else {
              final logs = snapshot.data!;

              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];

                  // Format the date as "MMM dd, yyyy hh:mm:ss a"
                  String formattedDate = DateFormat('MMM dd, yyyy hh:mm:ss a')
                      .format(log.dateActed);

                  return ExpansionTile(
                    leading: const Icon(Icons.history),
                    title: Row(
                      children: [
                        Text(log.actionLabel),
                        const SizedBox(
                          width: 16,
                        ),
                        log.actionId == 3
                            ? const Icon(
                                Icons.file_copy,
                                size: 12,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    subtitle:
                        Text('By: ${log.actedBy} of ${log.actorOfficeCode}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 4,
                              'Details:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Action: ${log.actionLabel}'),
                            const SizedBox(height: 4),
                            Text('Acted By: ${log.actedBy}'),
                            const SizedBox(height: 4),
                            Text('Office: ${log.actorOffice}'),
                            const SizedBox(height: 4),
                            Text('Acted On: $formattedDate'),
                            const SizedBox(height: 4),
                            log.actionId == 3
                                ? Text('Delivered By: ${log.deliveredBy}')
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Get.offAllNamed('/home');
    return true;
  }

  void _showActionReleaseModal(int actionId, String actionLabel) {
    _controller.copyOnly(false);
    _controller.selectedPurpose.value = null;
    _controller.scannedOTP.value = '';
    _remarksController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(actionLabel),
          content: SingleChildScrollView(
            child: Form(
              key: _controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actionId == 2) PurposeDropDown(),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    textController: _remarksController,
                    hintText: 'Remarks (Optional)',
                    maxLines: 3,
                  ),
                  if (actionId == 2)
                    Row(
                      children: [
                        Obx(() {
                          return _controller.selectedPurpose.value?.id == 3
                              ? Checkbox(
                                  value: false,
                                  onChanged: (bool? value) {},
                                )
                              : Checkbox(
                                  value: _controller.copyOnly.value,
                                  onChanged: (bool? value) {
                                    _controller.copyOnly.value = value ?? false;
                                  },
                                );
                        }),
                        const Text('Copy only'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_controller.formKey.currentState!.validate()) {
                  // Close the modal dialog
                  Navigator.of(context).pop();

                  // Show loading dialog
                  Get.dialog(
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    barrierDismissible: false,
                  );

                  var result = false;
                  try {
                    // Perform the release document action
                    result = await _controller.releaseDocument(
                      widget.document.documentNumber,
                      actionId,
                      _remarksController.text,
                    );
                  } finally {
                    // Dismiss the loading dialog
                    if (Get.isDialogOpen ?? false) {
                      Get.back();
                    }
                  }
                  Get.snackbar(
                    result ? 'Success' : 'Error',
                    _controller.updateMessage,
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  if (result) {
                    _refreshDocumentDetails();
                  }
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showActionReceiveModal(int actionId, String actionLabel) async {
    _controller.copyOnly(false);
    _controller.selectedPurpose.value = null;
    _controller.scannedOTP.value = '';
    _remarksController.clear();
    String deliveryOTP = await Get.to(const OTP_QRCodeScannerScreen()) ?? '';

    if (deliveryOTP.isNotEmpty) {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      var result = false;
      try {
        // Perform the release document action
        result = await _controller.receiveDocument(
            widget.document.documentNumber,
            actionId,
            _remarksController.text,
            widget.document.purposeId as int,
            deliveryOTP);
      } finally {
        // Dismiss the loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
      Get.snackbar(
        result ? 'Success' : 'Error',
        _controller.updateMessage,
        snackPosition: SnackPosition.BOTTOM,
      );

      if (result) {
        _refreshDocumentDetails();
      }
    }
    // Get.snackbar(
    //   'Scan Result',
    //   otp,
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }

  void _showActionOtherActionModal(int actionId, String actionLabel) {
    _controller.copyOnly(false);
    _controller.selectedPurpose.value = null;
    _controller.scannedOTP.value = '';
    _remarksController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(actionLabel),
          content: SingleChildScrollView(
            child: Form(
              key: _controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actionId == 2) PurposeDropDown(),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    textController: _remarksController,
                    hintText: 'Remarks (Optional)',
                    maxLines: 3,
                  ),
                  if (actionId == 2)
                    Row(
                      children: [
                        Obx(() {
                          return _controller.selectedPurpose.value?.id == 3
                              ? Checkbox(
                                  value: false,
                                  onChanged: (bool? value) {},
                                )
                              : Checkbox(
                                  value: _controller.copyOnly.value,
                                  onChanged: (bool? value) {
                                    _controller.copyOnly.value = value ?? false;
                                  },
                                );
                        }),
                        const Text('Copy only'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_controller.formKey.currentState!.validate()) {
                  // Close the modal dialog
                  Navigator.of(context).pop();

                  // Show loading dialog
                  Get.dialog(
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    barrierDismissible: false,
                  );

                  var result = false;
                  try {
                    // Perform the release document action
                    result = await _controller.receiveDocument(
                        widget.document.documentNumber,
                        actionId,
                        _remarksController.text,
                        0,
                        '');
                  } finally {
                    // Dismiss the loading dialog
                    if (Get.isDialogOpen ?? false) {
                      Get.back();
                    }
                  }
                  Get.snackbar(
                    result ? 'Success' : 'Error',
                    _controller.updateMessage,
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  if (result) {
                    _refreshDocumentDetails();
                  }
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String formattedDate =
        DateFormat('MMM dd, yyyy hh:mm:ss a').format(_document.lastUpdated);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor:
            _themecController.isDarkMode.value ? Colors.blueGrey : Colors.blue,
        appBar: AppBar(
          backgroundColor: _themecController.isDarkMode.value
              ? Colors.blueGrey
              : Colors.blue,
          elevation: 0,
          centerTitle: true,
          title: Text(
            _document.documentNumber,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
              onPressed: _refreshDocumentDetails,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        floatingActionButton: Obx(() {
          return _controller.isLoading.value
              ? const SizedBox()
              : Visibility(
                  visible: _controller.actions.isNotEmpty,
                  child: SpeedDial(
                    icon: Icons.apps,
                    activeIcon: Icons.close,
                    backgroundColor:
                        _themecController.isDarkMode.value ? null : Colors.blue,
                    foregroundColor: _themecController.isDarkMode.value
                        ? null
                        : Colors.white,
                    children: _controller.actions.map<SpeedDialChild>((action) {
                      return SpeedDialChild(
                        child: Icon(_getActionIcon(action.action_id)),
                        foregroundColor: Colors.white,
                        backgroundColor: _getActionColor(action.action_id),
                        label: action.label.toUpperCase(),
                        onTap: () => action.action_id == 3
                            ? _showActionReceiveModal(
                                action.action_id, action.label)
                            : action.action_id == 2
                                ? _showActionReleaseModal(
                                    action.action_id, action.label)
                                : _showActionOtherActionModal(
                                    action.action_id, action.label),
                      );
                    }).toList(),
                  ),
                );
        }),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(() {
                return Container(
                  width: size.width,
                  height: size.height - 110,
                  padding: const EdgeInsets.only(right: 12, left: 12, top: 36),
                  decoration: BoxDecoration(
                    color: _themecController.isDarkMode.value
                        ? Colors.black
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        textController:
                            TextEditingController(text: _document.title),
                        readOnly: true,
                        hintText: 'Title',
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        textController:
                            TextEditingController(text: _document.description),
                        hintText: 'Description',
                        readOnly: true,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        textController:
                            TextEditingController(text: _document.documentType),
                        readOnly: true,
                        hintText: 'Document Type',
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: !(_document.purpose == null),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                'Purpose: ${_document.purpose}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              'Origin: ${_document.originName}',
                              maxLines: 4,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child:
                                  Text('Location: ${_document.locationName}')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child:
                                  Text('Created By: ${_document.createdBy}')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Security: ${_document.securityDescription}'),
                          const SizedBox(
                            width: 16,
                          ),
                          _document.securityId == 1
                              ? const Icon(Icons.public)
                              : _document.securityId == 2
                                  ? const Icon(Icons.safety_check)
                                  : const Icon(Icons.lock),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                                'Status: ${_document.actionDisplay} @ ${formattedDate}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircularButton(
                      icon: Icons.history,
                      fn: _fetchAndShowDocumentLogs,
                    ),
                    const SizedBox(width: 8),
                    CircularButton(
                      icon: Icons.picture_as_pdf,
                      fn: () {
                        Get.to(
                            () => PdfViewPage(code: _document.documentNumber));
                        debugPrint('Navigate file view');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActionIcon(int actionId) {
    switch (actionId) {
      case 6:
        return Icons.check;
      case 2:
        return Icons.send;
      case 3:
        return Icons.download;
      case 4:
        return Icons.thumb_up;
      case 5:
        return Icons.thumb_down;
      default:
        return Icons.restore;
    }
  }

  Color _getActionColor(int actionId) {
    switch (actionId) {
      case 6:
        return colorSuccess;
      case 2:
        return colorWarning;
      case 3:
        return colorDefault;
      case 4:
        return Colors.green;
      case 5:
        return colorDanger;
      default:
        return Colors.grey;
    }
  }
}
