import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../l10n/app_localizations.dart';
import '../../groups/domain/group_models.dart';
import 'team_result_text.dart';

/// PDF imprimible del reparto público de equipos.
class TeamResultPdf {
  TeamResultPdf._();

  static Future<Uint8List> buildDocument({
    required AppLocalizations l10n,
    required String headline,
    required String groupName,
    required String? eventDateLine,
    required int teamCount,
    required int participantCount,
    required List<TeamSnapshot> teams,
    required String Function(TeamMemberSnapshot member) displayNameFor,
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
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return [
            pw.Container(
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(18),
                gradient: pw.LinearGradient(
                  colors: [cream, blush],
                  begin: pw.Alignment.topLeft,
                  end: pw.Alignment.bottomRight,
                ),
                border: pw.Border.all(color: plumSoft, width: 0.8),
              ),
              padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      if (logo != null)
                        pw.Image(logo, width: 48, height: 48)
                      else
                        pw.Text(
                          'Tarci Secret',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: plum,
                          ),
                        ),
                    ],
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text(
                    headline,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: plum,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    groupName,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 14, color: plumSoft),
                  ),
                  if (eventDateLine != null && eventDateLine.trim().isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text(
                      eventDateLine,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 11, color: plumSoft),
                    ),
                  ],
                  pw.SizedBox(height: 16),
                  pw.Text(
                    l10n.teamsPdfSummary(teamCount, participantCount),
                    style: pw.TextStyle(fontSize: 11, color: plumSoft),
                  ),
                  pw.SizedBox(height: 20),
                  ...teams.map((team) {
                    final label = TeamResultText.unitLabel(l10n, team.teamIndex);
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 14),
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: const PdfColor(1, 1, 1, 0.7),
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              label,
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: plum,
                              ),
                            ),
                            pw.SizedBox(height: 6),
                            ...team.members.map(
                              (m) => pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 3),
                                child: pw.Text(
                                  '• ${displayNameFor(m)}',
                                  style: pw.TextStyle(fontSize: 12, color: plum),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    footerBrand,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 9, color: plumSoft),
                  ),
                ],
              ),
            ),
          ];
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
