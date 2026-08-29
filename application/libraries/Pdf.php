<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - Pure-PHP Multi-Page PDF Generator.
 *
 * Produces standards-compliant multi-page A4 PDFs from a simple structured document model.
 * Zero external dependencies.
 *
 * Features:
 *  - Supports single and multi-page documents with automatic page overflow handling
 *  - Repeated table headers on new pages
 *  - Text wrapping for notes and multi-line fields
 *  - Running headers and footers with dynamic "Page X of Y" page numbering
 *  - Clean typography (Helvetica & Helvetica-Bold), styling, rule lines, and table cell alignment
 */
class Pdf
{
    /**
     * Build the PDF binary.
     *
     * @param array $doc {
     *   @var string $title
     *   @var string $subtitle
     *   @var string $meta_left   Lines printed top-left under the title (e.g. site info)
     *   @var string $meta_right  Lines printed top-right (e.g. quote #, date)
     *   @var array  $columns     [ ['label' => '...', 'width' => 0..1, 'align' => 'L|C|R'], ... ]
     *   @var array  $rows        [ [col1, col2, ...], ... ]
     *   @var string $notes       Optional notes block (plain text, multi-line)
     *   @var string $footer      Footer text
     * }
     * @return string Binary PDF content
     */
    public function build(array $doc): string
    {
        $title    = (string) ($doc['title']    ?? 'Document');
        $subtitle = (string) ($doc['subtitle'] ?? '');
        $metaL    = (array)  ($doc['meta_left']  ?? []);
        $metaR    = (array)  ($doc['meta_right'] ?? []);
        $columns  = (array)  ($doc['columns']    ?? []);
        $rows     = (array)  ($doc['rows']       ?? []);
        $notes    = (string) ($doc['notes']      ?? '');
        $footer   = (string) ($doc['footer']     ?? '');

        // A4 portrait dimensions: 595.28 x 841.89 pt
        $W = 595.28;
        $H = 841.89;
        $ml = 50.0;
        $mr = 50.0;
        $mt = 50.0;
        $mb = 50.0;
        $contentW = $W - $ml - $mr;
        $pageBreakAt = $mb + 40.0; // Margin threshold for page break

        // Column widths setup
        $colWidths = [];
        if (!empty($columns)) {
            $totalWeight = 0.0;
            foreach ($columns as $c) {
                $w = (float) ($c['width'] ?? 1);
                $totalWeight += $w;
                $colWidths[] = $w;
            }
            if ($totalWeight > 0) {
                $colWidths = array_map(function ($w) use ($totalWeight, $contentW) {
                    return ($w / $totalWeight) * $contentW;
                }, $colWidths);
            } else {
                $colWidths = array_fill(0, count($columns), $contentW / count($columns));
            }
        }

        // We accumulate stream chunks per page
        $pages = [];
        $currentPage = 0;
        $pages[$currentPage] = "q\n";

        $cursorY = $H - $mt;

        // Helper to advance Y on current page
        $advanceY = function (float $delta) use (&$cursorY) {
            $cursorY -= $delta;
        };

        // Helper to draw column header row
        $drawColumnHeaders = function (&$stream, float $y) use ($columns, $colWidths, $ml, $contentW, $W, $mr) {
            if (empty($columns)) return;
            // Background box
            $stream .= sprintf("0.93 0.96 1.0 rg %.2f %.2f %.2f %.2f re f\n", $ml, $y - 4.0, $contentW, 16.0);
            $x = $ml;
            foreach ($columns as $i => $c) {
                $align = strtoupper((string) ($c['align'] ?? 'L'));
                $targetX = ($align === 'R') ? ($x + $colWidths[$i] - 4.0) : (($align === 'C') ? ($x + $colWidths[$i] / 2.0) : ($x + 2.0));
                $this->pdfText($stream, (string) ($c['label'] ?? ''), $targetX, $y, 9.0, true, '0.1 0.2 0.4 rg', $align);
                $x += $colWidths[$i];
            }
            // Bottom rule
            $stream .= sprintf("0.75 0.82 0.95 RG 0.75 w %.2f %.2f m %.2f %.2f l S\n", $ml, $y - 4.0, $W - $mr, $y - 4.0);
        };

        // Helper to trigger a new page
        $startNewPage = function () use (&$pages, &$currentPage, &$cursorY, $H, $mt, $ml, $W, $mr, $title, $drawColumnHeaders) {
            $currentPage++;
            $pages[$currentPage] = "q\n";
            $cursorY = $H - $mt;

            // Running title on continuing pages
            $this->pdfText($pages[$currentPage], $title . ' (continued)', $ml, $cursorY, 13.0, true, '0.18 0.47 1.0 rg');
            $cursorY -= 16.0;
            $pages[$currentPage] .= sprintf("0.85 0.85 0.85 RG 0.5 w %.2f %.2f m %.2f %.2f l S\n", $ml, $cursorY, $W - $mr, $cursorY);
            $cursorY -= 14.0;

            // Redraw table headers if we are in table context
            $drawColumnHeaders($pages[$currentPage], $cursorY);
            $cursorY -= 18.0;
        };

        // ==========================================
        // PAGE 1: HEADER & METADATA
        // ==========================================
        // Main Document Title
        $this->pdfText($pages[$currentPage], $title, $ml, $cursorY, 22.0, true, '0.08 0.35 0.75 rg');
        $advanceY(26.0);

        if ($subtitle !== '') {
            $this->pdfText($pages[$currentPage], $subtitle, $ml, $cursorY, 10.0, false, '0.4 0.4 0.4 rg');
            $advanceY(16.0);
        }

        // Meta Box: Left and Right blocks
        $metaCount = max(count($metaL), count($metaR));
        if ($metaCount > 0) {
            foreach ($metaL as $i => $line) {
                $this->pdfText($pages[$currentPage], (string) $line, $ml, $cursorY - ($i * 13.5), 8.5, false, '0.2 0.2 0.2 rg');
            }
            foreach ($metaR as $i => $line) {
                $isBold = ($i === 0);
                $this->pdfText($pages[$currentPage], (string) $line, $W - $mr, $cursorY - ($i * 13.5), 8.5, $isBold, '0.2 0.2 0.2 rg', 'R');
            }
            $advanceY(($metaCount * 13.5) + 8.0);
        }

        // Divider rule
        $pages[$currentPage] .= sprintf("0.18 0.47 1.0 RG 1.0 w %.2f %.2f m %.2f %.2f l S\n", $ml, $cursorY, $W - $mr, $cursorY);
        $advanceY(16.0);

        // ==========================================
        // TABLE COLUMNS & ROWS
        // ==========================================
        if (!empty($columns)) {
            $drawColumnHeaders($pages[$currentPage], $cursorY);
            $advanceY(18.0);
        }

        $rowHeight = 16.0;
        foreach ($rows as $rowIndex => $r) {
            if ($cursorY - $rowHeight < $pageBreakAt) {
                $startNewPage();
            }

            // Alternating subtle row background
            if ($rowIndex % 2 === 1) {
                $pages[$currentPage] .= sprintf("0.98 0.98 0.99 rg %.2f %.2f %.2f %.2f re f\n", $ml, $cursorY - 4.0, $contentW, $rowHeight);
            }

            $x = $ml;
            $col = 0;
            foreach ($r as $cell) {
                $cellStr = (string) $cell;
                $align = strtoupper((string) ($columns[$col]['align'] ?? 'L'));
                $targetX = ($align === 'R') ? ($x + ($colWidths[$col] ?? 0) - 4.0) : (($align === 'C') ? ($x + ($colWidths[$col] ?? 0) / 2.0) : ($x + 2.0));
                $this->pdfText($pages[$currentPage], $cellStr, $targetX, $cursorY, 8.5, false, '0.15 0.15 0.15 rg', $align);
                $x += ($colWidths[$col] ?? 0);
                $col++;
            }

            // Row bottom line
            $pages[$currentPage] .= sprintf("0.90 0.90 0.90 RG 0.3 w %.2f %.2f m %.2f %.2f l S\n", $ml, $cursorY - 4.0, $W - $mr, $cursorY - 4.0);
            $advanceY($rowHeight);
        }

        // ==========================================
        // NOTES BLOCK
        // ==========================================
        if ($notes !== '') {
            $advanceY(12.0);
            if ($cursorY - 40.0 < $pageBreakAt) {
                $startNewPage();
            }

            $this->pdfText($pages[$currentPage], 'Notes & Terms', $ml, $cursorY, 10.0, true, '0.1 0.2 0.4 rg');
            $advanceY(14.0);

            $wrappedLines = [];
            foreach (explode("\n", $notes) as $rawLine) {
                $rawLine = rtrim($rawLine);
                if ($rawLine === '') {
                    $wrappedLines[] = '';
                    continue;
                }
                $wrapped = wordwrap($rawLine, 95, "\n", true);
                foreach (explode("\n", $wrapped) as $wLine) {
                    $wrappedLines[] = $wLine;
                }
            }

            foreach ($wrappedLines as $line) {
                if ($cursorY - 12.0 < $pageBreakAt) {
                    $startNewPage();
                }
                if ($line !== '') {
                    $this->pdfText($pages[$currentPage], $line, $ml, $cursorY, 8.5, false, '0.3 0.3 0.3 rg');
                }
                $advanceY(12.0);
            }
        }

        // ==========================================
        // FOOTERS (FOR EVERY PAGE WITH PAGE NUMBERS)
        // ==========================================
        $totalPages = count($pages);
        $footerY = $mb - 15.0;

        for ($p = 0; $p < $totalPages; $p++) {
            // Footer divider line
            $pages[$p] .= sprintf("0.85 0.85 0.85 RG 0.5 w %.2f %.2f m %.2f %.2f l S\n", $ml, $footerY + 16.0, $W - $mr, $footerY + 16.0);

            // Left footer text
            if ($footer !== '') {
                $this->pdfText($pages[$p], $footer, $ml, $footerY, 7.5, false, '0.5 0.5 0.5 rg');
            }

            // Right page number (e.g. Page 1 of 2)
            $pageStr = sprintf("Page %d of %d", $p + 1, $totalPages);
            $this->pdfText($pages[$p], $pageStr, $W - $mr, $footerY, 7.5, false, '0.5 0.5 0.5 rg', 'R');

            // Restore graphics state
            $pages[$p] .= "Q\n";
        }

        // ==========================================
        // ASSEMBLE PDF STRUCTURE & OBJECTS
        // ==========================================
        $objects = [];
        $addObj = function (string $body) use (&$objects) {
            $id = count($objects) + 1;
            $objects[$id] = $body;
            return $id;
        };

        // 1. Font Objects
        $fontObjId  = $addObj("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>");
        $fontBoldId = $addObj("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>");

        // 2. Reserve /Pages ID
        $pagesObjId = count($objects) + 1;
        $objects[$pagesObjId] = ""; // placeholder

        // 3. Content Streams & Page Objects
        $pageObjIds = [];
        foreach ($pages as $streamContent) {
            $streamLen = strlen($streamContent);
            $contentObjId = $addObj("<< /Length " . $streamLen . " >>\nstream\n" . $streamContent . "endstream");

            $pageObjId = $addObj(sprintf(
                "<< /Type /Page /Parent %d 0 R /MediaBox [0 0 %.2f %.2f] /Resources << /Font << /F1 %d 0 R /F2 %d 0 R >> >> /Contents %d 0 R >>",
                $pagesObjId,
                $W,
                $H,
                $fontObjId,
                $fontBoldId,
                $contentObjId
            ));
            $pageObjIds[] = $pageObjId;
        }

        // 4. Populate Pages Dictionary Object
        $kidsStr = implode(" 0 R ", $pageObjIds) . " 0 R";
        $objects[$pagesObjId] = sprintf("<< /Type /Pages /Kids [ %s ] /Count %d >>", $kidsStr, count($pageObjIds));

        // 5. Catalog Root Object
        $catalogId = $addObj("<< /Type /Catalog /Pages " . $pagesObjId . " 0 R >>");

        // 6. Build Cross-Reference Table and Trailer
        $pdf = "%PDF-1.4\n%\xE2\xE3\xCF\xD3\n";
        $offsets = [0];
        for ($id = 1; $id <= count($objects); $id++) {
            $offsets[$id] = strlen($pdf);
            $pdf .= $id . " 0 obj\n" . $objects[$id] . "\nendobj\n";
        }

        $xrefStart = strlen($pdf);
        $totalObjs = count($objects) + 1;
        $pdf .= "xref\n0 " . $totalObjs . "\n";
        $pdf .= "0000000000 65535 f \n";
        for ($i = 1; $i <= count($objects); $i++) {
            $pdf .= sprintf("%010d 00000 n \n", $offsets[$i]);
        }
        $pdf .= "trailer\n<< /Size " . $totalObjs . " /Root " . $catalogId . " 0 R >>\nstartxref\n" . $xrefStart . "\n%%EOF\n";

        return $pdf;
    }

    /**
     * Emit a text run into the content stream.
     * $align: 'L' (left), 'C' (center), 'R' (right). Coordinates are for the baseline.
     */
    private function pdfText(string &$stream, string $text, float $x, float $y, float $size, bool $bold, string $color, string $align = 'L'): void
    {
        $escaped = $this->pdfEscape($text);
        if ($escaped === '') return;
        $font = $bold ? '/F2' : '/F1';
        $stream .= "BT\n" . $color . "\n" . $font . " " . sprintf('%.2f', $size) . " Tf\n";
        if ($align !== 'L') {
            // Approximate text width using Helvetica average character width metric (~0.52em)
            $w = strlen($text) * $size * 0.52;
            if ($align === 'R') {
                $stream .= sprintf("1 0 0 1 %.2f %.2f Tm\n", $x - $w, $y);
            } else { // Center
                $stream .= sprintf("1 0 0 1 %.2f %.2f Tm\n", $x - ($w / 2.0), $y);
            }
        } else {
            $stream .= sprintf("1 0 0 1 %.2f %.2f Tm\n", $x, $y);
        }
        $stream .= "(" . $escaped . ") Tj\nET\n";
    }

    /**
     * Escape special characters in PDF literal strings.
     */
    private function pdfEscape(string $s): string
    {
        // Strip non-printable/control characters except standard printable ASCII
        $clean = '';
        $len = strlen($s);
        for ($i = 0; $i < $len; $i++) {
            $ord = ord($s[$i]);
            if ($ord >= 32 && $ord <= 126) {
                $clean .= $s[$i];
            } elseif ($ord === 10 || $ord === 13 || $ord === 9) {
                $clean .= ' ';
            }
        }
        return str_replace(['\\', '(', ')'], ['\\\\', '\\(', '\\)'], $clean);
    }
}
