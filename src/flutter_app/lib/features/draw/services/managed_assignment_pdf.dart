import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// PDF individual para un participante gestionado (solo datos ya autorizados en pantalla).
class ManagedAssignmentPdf {
  ManagedAssignmentPdf._();

  static Future<Uint8List> buildDocument({
    required String headline,
    required String forLabel,
    required String managedName,
    required String groupLabel,
    required String groupName,
    required String giftHeading,
    required String receiverName,
    required String? receiverSubgroupLine,
    required String footerSecret,
    required String footerBrand,
  }) async {
    pw.ImageProvider? logo;
    try {
      final data = await rootBundle.load('assets/brand/TarciSecret_Icono.png');
      logo = pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {}

    final plum = PdfColor.fromHex('#5C3D4E');
    final plumSoft = PdfColor.fromHex('#8B5A6B');
    final cream = PdfColor.fromHex('#FFF9F4');
    final blush = PdfColor.fromHex('#F8E8EE');

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(18),
              gradient: pw.LinearGradient(
                colors: [cream, blush],
                begin: pw.Alignment.topLeft,
                end: pw.Alignment.bottomRight,
              ),
              border: pw.Border.all(color: plumSoft, width: 0.8),
            ),
            padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    if (logo != null)
                      pw.Image(logo, width: 52, height: 52)
                    else
                      pw.Text(
                        'Tarci Secret',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: plum,
                        ),
                      ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  headline,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: plum,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: const PdfColor(1, 1, 1, 0.65),
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '$forLabel: $managedName',
                        style: pw.TextStyle(fontSize: 11, color: plumSoft),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        '$groupLabel: $groupName',
                        style: pw.TextStyle(fontSize: 11, color: plumSoft),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  giftHeading,
                  style: pw.TextStyle(
                    fontSize: 13,
                    color: plumSoft,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  receiverName,
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: plum,
                  ),
                ),
                if (receiverSubgroupLine != null &&
                    receiverSubgroupLine.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 12),
                  pw.Text(
                    receiverSubgroupLine,
                    style: pw.TextStyle(fontSize: 12, color: plumSoft),
                  ),
                ],
                pw.Spacer(),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColor(plum.red, plum.green, plum.blue, 0.12),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Text(
                    footerSecret,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: plum,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  footerBrand,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 9, color: plumSoft),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> previewAndShare({
    required Uint8List bytes,
    required String documentName,
  }) {
    return Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: '$documentName.pdf',
    );
  }
}
