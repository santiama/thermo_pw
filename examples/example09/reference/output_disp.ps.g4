%!PS-Adobe-2.0
%%Title: output_disp.ps.g4
%%Creator: gnuplot 4.2 patchlevel 6 
%%CreationDate: Fri May 15 10:39:17 2015
%%DocumentFonts: (atend)
%%BoundingBox: 50 50 554 770
%%Orientation: Landscape
%%Pages: (atend)
%%EndComments
%%BeginProlog
/gnudict 256 dict def
gnudict begin
%
% The following 6 true/false flags may be edited by hand if required
% The unit line width may also be changed
%
/Color true def
/Blacktext false def
/Solid true def
/Dashlength 1 def
/Landscape true def
/Level1 false def
/Rounded false def
/TransparentPatterns false def
/gnulinewidth 5.000 def
/userlinewidth gnulinewidth def
%
/vshift -66 def
/dl1 {
  10.0 Dashlength mul mul
  Rounded { currentlinewidth 0.75 mul sub dup 0 le { pop 0.01 } if } if
} def
/dl2 {
  10.0 Dashlength mul mul
  Rounded { currentlinewidth 0.75 mul add } if
} def
/hpt_ 31.5 def
/vpt_ 31.5 def
/hpt hpt_ def
/vpt vpt_ def
Level1 {} {
/SDict 10 dict def
systemdict /pdfmark known not {
  userdict /pdfmark systemdict /cleartomark get put
} if
SDict begin [
  /Title (output_disp.ps.g4)
  /Subject (gnuplot plot)
  /Creator (gnuplot 4.2 patchlevel 6 )
  /Author (espresso)
%  /Producer (gnuplot)
%  /Keywords ()
  /CreationDate (Fri May 15 10:39:17 2015)
  /DOCINFO pdfmark
end
} ifelse
/reencodeISO15 {
dup dup findfont dup length dict begin
{ 1 index /FID ne { def }{ pop pop } ifelse } forall
currentdict /CharStrings known {
	CharStrings /Idieresis known {
		/Encoding ISOLatin15Encoding def } if
} if
currentdict end definefont
} def
/ISOLatin15Encoding [
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/space/exclam/quotedbl/numbersign/dollar/percent/ampersand/quoteright
/parenleft/parenright/asterisk/plus/comma/minus/period/slash
/zero/one/two/three/four/five/six/seven/eight/nine/colon/semicolon
/less/equal/greater/question/at/A/B/C/D/E/F/G/H/I/J/K/L/M/N
/O/P/Q/R/S/T/U/V/W/X/Y/Z/bracketleft/backslash/bracketright
/asciicircum/underscore/quoteleft/a/b/c/d/e/f/g/h/i/j/k/l/m
/n/o/p/q/r/s/t/u/v/w/x/y/z/braceleft/bar/braceright/asciitilde
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/dotlessi/grave/acute/circumflex/tilde/macron/breve
/dotaccent/dieresis/.notdef/ring/cedilla/.notdef/hungarumlaut
/ogonek/caron/space/exclamdown/cent/sterling/Euro/yen/Scaron
/section/scaron/copyright/ordfeminine/guillemotleft/logicalnot
/hyphen/registered/macron/degree/plusminus/twosuperior/threesuperior
/Zcaron/mu/paragraph/periodcentered/zcaron/onesuperior/ordmasculine
/guillemotright/OE/oe/Ydieresis/questiondown
/Agrave/Aacute/Acircumflex/Atilde/Adieresis/Aring/AE/Ccedilla
/Egrave/Eacute/Ecircumflex/Edieresis/Igrave/Iacute/Icircumflex
/Idieresis/Eth/Ntilde/Ograve/Oacute/Ocircumflex/Otilde/Odieresis
/multiply/Oslash/Ugrave/Uacute/Ucircumflex/Udieresis/Yacute
/Thorn/germandbls/agrave/aacute/acircumflex/atilde/adieresis
/aring/ae/ccedilla/egrave/eacute/ecircumflex/edieresis/igrave
/iacute/icircumflex/idieresis/eth/ntilde/ograve/oacute/ocircumflex
/otilde/odieresis/divide/oslash/ugrave/uacute/ucircumflex/udieresis
/yacute/thorn/ydieresis
] def
%
% Gnuplot Prolog Version 4.2 (August 2006)
%
/M {moveto} bind def
/L {lineto} bind def
/R {rmoveto} bind def
/V {rlineto} bind def
/N {newpath moveto} bind def
/Z {closepath} bind def
/C {setrgbcolor} bind def
/f {rlineto fill} bind def
/vpt2 vpt 2 mul def
/hpt2 hpt 2 mul def
/Lshow {currentpoint stroke M 0 vshift R 
	Blacktext {gsave 0 setgray show grestore} {show} ifelse} def
/Rshow {currentpoint stroke M dup stringwidth pop neg vshift R
	Blacktext {gsave 0 setgray show grestore} {show} ifelse} def
/Cshow {currentpoint stroke M dup stringwidth pop -2 div vshift R 
	Blacktext {gsave 0 setgray show grestore} {show} ifelse} def
/UP {dup vpt_ mul /vpt exch def hpt_ mul /hpt exch def
  /hpt2 hpt 2 mul def /vpt2 vpt 2 mul def} def
/DL {Color {setrgbcolor Solid {pop []} if 0 setdash}
 {pop pop pop 0 setgray Solid {pop []} if 0 setdash} ifelse} def
/BL {stroke userlinewidth 2 mul setlinewidth
	Rounded {1 setlinejoin 1 setlinecap} if} def
/AL {stroke userlinewidth 2 div setlinewidth
	Rounded {1 setlinejoin 1 setlinecap} if} def
/UL {dup gnulinewidth mul /userlinewidth exch def
	dup 1 lt {pop 1} if 10 mul /udl exch def} def
/PL {stroke userlinewidth setlinewidth
	Rounded {1 setlinejoin 1 setlinecap} if} def
% Default Line colors
/LCw {1 1 1} def
/LCb {0 0 0} def
/LCa {0 0 0} def
/LC0 {1 0 0} def
/LC1 {0 1 0} def
/LC2 {0 0 1} def
/LC3 {1 0 1} def
/LC4 {0 1 1} def
/LC5 {1 1 0} def
/LC6 {0 0 0} def
/LC7 {1 0.3 0} def
/LC8 {0.5 0.5 0.5} def
% Default Line Types
/LTw {PL [] 1 setgray} def
/LTb {BL [] LCb DL} def
/LTa {AL [1 udl mul 2 udl mul] 0 setdash LCa setrgbcolor} def
/LT0 {PL [] LC0 DL} def
/LT1 {PL [4 dl1 2 dl2] LC1 DL} def
/LT2 {PL [2 dl1 3 dl2] LC2 DL} def
/LT3 {PL [1 dl1 1.5 dl2] LC3 DL} def
/LT4 {PL [6 dl1 2 dl2 1 dl1 2 dl2] LC4 DL} def
/LT5 {PL [3 dl1 3 dl2 1 dl1 3 dl2] LC5 DL} def
/LT6 {PL [2 dl1 2 dl2 2 dl1 6 dl2] LC6 DL} def
/LT7 {PL [1 dl1 2 dl2 6 dl1 2 dl2 1 dl1 2 dl2] LC7 DL} def
/LT8 {PL [2 dl1 2 dl2 2 dl1 2 dl2 2 dl1 2 dl2 2 dl1 4 dl2] LC8 DL} def
/Pnt {stroke [] 0 setdash gsave 1 setlinecap M 0 0 V stroke grestore} def
/Dia {stroke [] 0 setdash 2 copy vpt add M
  hpt neg vpt neg V hpt vpt neg V
  hpt vpt V hpt neg vpt V closepath stroke
  Pnt} def
/Pls {stroke [] 0 setdash vpt sub M 0 vpt2 V
  currentpoint stroke M
  hpt neg vpt neg R hpt2 0 V stroke
 } def
/Box {stroke [] 0 setdash 2 copy exch hpt sub exch vpt add M
  0 vpt2 neg V hpt2 0 V 0 vpt2 V
  hpt2 neg 0 V closepath stroke
  Pnt} def
/Crs {stroke [] 0 setdash exch hpt sub exch vpt add M
  hpt2 vpt2 neg V currentpoint stroke M
  hpt2 neg 0 R hpt2 vpt2 V stroke} def
/TriU {stroke [] 0 setdash 2 copy vpt 1.12 mul add M
  hpt neg vpt -1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt 1.62 mul V closepath stroke
  Pnt} def
/Star {2 copy Pls Crs} def
/BoxF {stroke [] 0 setdash exch hpt sub exch vpt add M
  0 vpt2 neg V hpt2 0 V 0 vpt2 V
  hpt2 neg 0 V closepath fill} def
/TriUF {stroke [] 0 setdash vpt 1.12 mul add M
  hpt neg vpt -1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt 1.62 mul V closepath fill} def
/TriD {stroke [] 0 setdash 2 copy vpt 1.12 mul sub M
  hpt neg vpt 1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt -1.62 mul V closepath stroke
  Pnt} def
/TriDF {stroke [] 0 setdash vpt 1.12 mul sub M
  hpt neg vpt 1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt -1.62 mul V closepath fill} def
/DiaF {stroke [] 0 setdash vpt add M
  hpt neg vpt neg V hpt vpt neg V
  hpt vpt V hpt neg vpt V closepath fill} def
/Pent {stroke [] 0 setdash 2 copy gsave
  translate 0 hpt M 4 {72 rotate 0 hpt L} repeat
  closepath stroke grestore Pnt} def
/PentF {stroke [] 0 setdash gsave
  translate 0 hpt M 4 {72 rotate 0 hpt L} repeat
  closepath fill grestore} def
/Circle {stroke [] 0 setdash 2 copy
  hpt 0 360 arc stroke Pnt} def
/CircleF {stroke [] 0 setdash hpt 0 360 arc fill} def
/C0 {BL [] 0 setdash 2 copy moveto vpt 90 450 arc} bind def
/C1 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 0 90 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C2 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 90 180 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C3 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 0 180 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C4 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 180 270 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C5 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 0 90 arc
	2 copy moveto
	2 copy vpt 180 270 arc closepath fill
	vpt 0 360 arc} bind def
/C6 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 90 270 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C7 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 0 270 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C8 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 270 360 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C9 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 270 450 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C10 {BL [] 0 setdash 2 copy 2 copy moveto vpt 270 360 arc closepath fill
	2 copy moveto
	2 copy vpt 90 180 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C11 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 0 180 arc closepath fill
	2 copy moveto
	2 copy vpt 270 360 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C12 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 180 360 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C13 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 0 90 arc closepath fill
	2 copy moveto
	2 copy vpt 180 360 arc closepath fill
	vpt 0 360 arc closepath} bind def
/C14 {BL [] 0 setdash 2 copy moveto
	2 copy vpt 90 360 arc closepath fill
	vpt 0 360 arc} bind def
/C15 {BL [] 0 setdash 2 copy vpt 0 360 arc closepath fill
	vpt 0 360 arc closepath} bind def
/Rec {newpath 4 2 roll moveto 1 index 0 rlineto 0 exch rlineto
	neg 0 rlineto closepath} bind def
/Square {dup Rec} bind def
/Bsquare {vpt sub exch vpt sub exch vpt2 Square} bind def
/S0 {BL [] 0 setdash 2 copy moveto 0 vpt rlineto BL Bsquare} bind def
/S1 {BL [] 0 setdash 2 copy vpt Square fill Bsquare} bind def
/S2 {BL [] 0 setdash 2 copy exch vpt sub exch vpt Square fill Bsquare} bind def
/S3 {BL [] 0 setdash 2 copy exch vpt sub exch vpt2 vpt Rec fill Bsquare} bind def
/S4 {BL [] 0 setdash 2 copy exch vpt sub exch vpt sub vpt Square fill Bsquare} bind def
/S5 {BL [] 0 setdash 2 copy 2 copy vpt Square fill
	exch vpt sub exch vpt sub vpt Square fill Bsquare} bind def
/S6 {BL [] 0 setdash 2 copy exch vpt sub exch vpt sub vpt vpt2 Rec fill Bsquare} bind def
/S7 {BL [] 0 setdash 2 copy exch vpt sub exch vpt sub vpt vpt2 Rec fill
	2 copy vpt Square fill Bsquare} bind def
/S8 {BL [] 0 setdash 2 copy vpt sub vpt Square fill Bsquare} bind def
/S9 {BL [] 0 setdash 2 copy vpt sub vpt vpt2 Rec fill Bsquare} bind def
/S10 {BL [] 0 setdash 2 copy vpt sub vpt Square fill 2 copy exch vpt sub exch vpt Square fill
	Bsquare} bind def
/S11 {BL [] 0 setdash 2 copy vpt sub vpt Square fill 2 copy exch vpt sub exch vpt2 vpt Rec fill
	Bsquare} bind def
/S12 {BL [] 0 setdash 2 copy exch vpt sub exch vpt sub vpt2 vpt Rec fill Bsquare} bind def
/S13 {BL [] 0 setdash 2 copy exch vpt sub exch vpt sub vpt2 vpt Rec fill
	2 copy vpt Square fill Bsquare} bind def
/S14 {BL [] 0 setdash 2 copy exch vpt sub exch vpt sub vpt2 vpt Rec fill
	2 copy exch vpt sub exch vpt Square fill Bsquare} bind def
/S15 {BL [] 0 setdash 2 copy Bsquare fill Bsquare} bind def
/D0 {gsave translate 45 rotate 0 0 S0 stroke grestore} bind def
/D1 {gsave translate 45 rotate 0 0 S1 stroke grestore} bind def
/D2 {gsave translate 45 rotate 0 0 S2 stroke grestore} bind def
/D3 {gsave translate 45 rotate 0 0 S3 stroke grestore} bind def
/D4 {gsave translate 45 rotate 0 0 S4 stroke grestore} bind def
/D5 {gsave translate 45 rotate 0 0 S5 stroke grestore} bind def
/D6 {gsave translate 45 rotate 0 0 S6 stroke grestore} bind def
/D7 {gsave translate 45 rotate 0 0 S7 stroke grestore} bind def
/D8 {gsave translate 45 rotate 0 0 S8 stroke grestore} bind def
/D9 {gsave translate 45 rotate 0 0 S9 stroke grestore} bind def
/D10 {gsave translate 45 rotate 0 0 S10 stroke grestore} bind def
/D11 {gsave translate 45 rotate 0 0 S11 stroke grestore} bind def
/D12 {gsave translate 45 rotate 0 0 S12 stroke grestore} bind def
/D13 {gsave translate 45 rotate 0 0 S13 stroke grestore} bind def
/D14 {gsave translate 45 rotate 0 0 S14 stroke grestore} bind def
/D15 {gsave translate 45 rotate 0 0 S15 stroke grestore} bind def
/DiaE {stroke [] 0 setdash vpt add M
  hpt neg vpt neg V hpt vpt neg V
  hpt vpt V hpt neg vpt V closepath stroke} def
/BoxE {stroke [] 0 setdash exch hpt sub exch vpt add M
  0 vpt2 neg V hpt2 0 V 0 vpt2 V
  hpt2 neg 0 V closepath stroke} def
/TriUE {stroke [] 0 setdash vpt 1.12 mul add M
  hpt neg vpt -1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt 1.62 mul V closepath stroke} def
/TriDE {stroke [] 0 setdash vpt 1.12 mul sub M
  hpt neg vpt 1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt -1.62 mul V closepath stroke} def
/PentE {stroke [] 0 setdash gsave
  translate 0 hpt M 4 {72 rotate 0 hpt L} repeat
  closepath stroke grestore} def
/CircE {stroke [] 0 setdash 
  hpt 0 360 arc stroke} def
/Opaque {gsave closepath 1 setgray fill grestore 0 setgray closepath} def
/DiaW {stroke [] 0 setdash vpt add M
  hpt neg vpt neg V hpt vpt neg V
  hpt vpt V hpt neg vpt V Opaque stroke} def
/BoxW {stroke [] 0 setdash exch hpt sub exch vpt add M
  0 vpt2 neg V hpt2 0 V 0 vpt2 V
  hpt2 neg 0 V Opaque stroke} def
/TriUW {stroke [] 0 setdash vpt 1.12 mul add M
  hpt neg vpt -1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt 1.62 mul V Opaque stroke} def
/TriDW {stroke [] 0 setdash vpt 1.12 mul sub M
  hpt neg vpt 1.62 mul V
  hpt 2 mul 0 V
  hpt neg vpt -1.62 mul V Opaque stroke} def
/PentW {stroke [] 0 setdash gsave
  translate 0 hpt M 4 {72 rotate 0 hpt L} repeat
  Opaque stroke grestore} def
/CircW {stroke [] 0 setdash 
  hpt 0 360 arc Opaque stroke} def
/BoxFill {gsave Rec 1 setgray fill grestore} def
/Density {
  /Fillden exch def
  currentrgbcolor
  /ColB exch def /ColG exch def /ColR exch def
  /ColR ColR Fillden mul Fillden sub 1 add def
  /ColG ColG Fillden mul Fillden sub 1 add def
  /ColB ColB Fillden mul Fillden sub 1 add def
  ColR ColG ColB setrgbcolor} def
/BoxColFill {gsave Rec PolyFill} def
/PolyFill {gsave Density fill grestore grestore} def
/h {rlineto rlineto rlineto gsave closepath fill grestore} bind def
%
% PostScript Level 1 Pattern Fill routine for rectangles
% Usage: x y w h s a XX PatternFill
%	x,y = lower left corner of box to be filled
%	w,h = width and height of box
%	  a = angle in degrees between lines and x-axis
%	 XX = 0/1 for no/yes cross-hatch
%
/PatternFill {gsave /PFa [ 9 2 roll ] def
  PFa 0 get PFa 2 get 2 div add PFa 1 get PFa 3 get 2 div add translate
  PFa 2 get -2 div PFa 3 get -2 div PFa 2 get PFa 3 get Rec
  gsave 1 setgray fill grestore clip
  currentlinewidth 0.5 mul setlinewidth
  /PFs PFa 2 get dup mul PFa 3 get dup mul add sqrt def
  0 0 M PFa 5 get rotate PFs -2 div dup translate
  0 1 PFs PFa 4 get div 1 add floor cvi
	{PFa 4 get mul 0 M 0 PFs V} for
  0 PFa 6 get ne {
	0 1 PFs PFa 4 get div 1 add floor cvi
	{PFa 4 get mul 0 2 1 roll M PFs 0 V} for
 } if
  stroke grestore} def
%
/languagelevel where
 {pop languagelevel} {1} ifelse
 2 lt
	{/InterpretLevel1 true def}
	{/InterpretLevel1 Level1 def}
 ifelse
%
% PostScript level 2 pattern fill definitions
%
/Level2PatternFill {
/Tile8x8 {/PaintType 2 /PatternType 1 /TilingType 1 /BBox [0 0 8 8] /XStep 8 /YStep 8}
	bind def
/KeepColor {currentrgbcolor [/Pattern /DeviceRGB] setcolorspace} bind def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop 0 0 M 8 8 L 0 8 M 8 0 L stroke} 
>> matrix makepattern
/Pat1 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop 0 0 M 8 8 L 0 8 M 8 0 L stroke
	0 4 M 4 8 L 8 4 L 4 0 L 0 4 L stroke}
>> matrix makepattern
/Pat2 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop 0 0 M 0 8 L
	8 8 L 8 0 L 0 0 L fill}
>> matrix makepattern
/Pat3 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop -4 8 M 8 -4 L
	0 12 M 12 0 L stroke}
>> matrix makepattern
/Pat4 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop -4 0 M 8 12 L
	0 -4 M 12 8 L stroke}
>> matrix makepattern
/Pat5 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop -2 8 M 4 -4 L
	0 12 M 8 -4 L 4 12 M 10 0 L stroke}
>> matrix makepattern
/Pat6 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop -2 0 M 4 12 L
	0 -4 M 8 12 L 4 -4 M 10 8 L stroke}
>> matrix makepattern
/Pat7 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop 8 -2 M -4 4 L
	12 0 M -4 8 L 12 4 M 0 10 L stroke}
>> matrix makepattern
/Pat8 exch def
<< Tile8x8
 /PaintProc {0.5 setlinewidth pop 0 -2 M 12 4 L
	-4 0 M 12 8 L -4 4 M 8 10 L stroke}
>> matrix makepattern
/Pat9 exch def
/Pattern1 {PatternBgnd KeepColor Pat1 setpattern} bind def
/Pattern2 {PatternBgnd KeepColor Pat2 setpattern} bind def
/Pattern3 {PatternBgnd KeepColor Pat3 setpattern} bind def
/Pattern4 {PatternBgnd KeepColor Landscape {Pat5} {Pat4} ifelse setpattern} bind def
/Pattern5 {PatternBgnd KeepColor Landscape {Pat4} {Pat5} ifelse setpattern} bind def
/Pattern6 {PatternBgnd KeepColor Landscape {Pat9} {Pat6} ifelse setpattern} bind def
/Pattern7 {PatternBgnd KeepColor Landscape {Pat8} {Pat7} ifelse setpattern} bind def
} def
%
%
%End of PostScript Level 2 code
%
/PatternBgnd {
  TransparentPatterns {} {gsave 1 setgray fill grestore} ifelse
} def
%
% Substitute for Level 2 pattern fill codes with
% grayscale if Level 2 support is not selected.
%
/Level1PatternFill {
/Pattern1 {0.250 Density} bind def
/Pattern2 {0.500 Density} bind def
/Pattern3 {0.750 Density} bind def
/Pattern4 {0.125 Density} bind def
/Pattern5 {0.375 Density} bind def
/Pattern6 {0.625 Density} bind def
/Pattern7 {0.875 Density} bind def
} def
%
% Now test for support of Level 2 code
%
Level1 {Level1PatternFill} {Level2PatternFill} ifelse
%
/Symbol-Oblique /Symbol findfont [1 0 .167 1 0 0] makefont
dup length dict begin {1 index /FID eq {pop pop} {def} ifelse} forall
currentdict end definefont pop
/MFshow {
   { dup 5 get 3 ge
     { 5 get 3 eq {gsave} {grestore} ifelse }
     {dup dup 0 get findfont exch 1 get scalefont setfont
     [ currentpoint ] exch dup 2 get 0 exch R dup 5 get 2 ne {dup dup 6
     get exch 4 get {show} {stringwidth pop 0 R} ifelse }if dup 5 get 0 eq
     {dup 3 get {2 get neg 0 exch R pop} {pop aload pop M} ifelse} {dup 5
     get 1 eq {dup 2 get exch dup 3 get exch 6 get stringwidth pop -2 div
     dup 0 R} {dup 6 get stringwidth pop -2 div 0 R 6 get
     show 2 index {aload pop M neg 3 -1 roll neg R pop pop} {pop pop pop
     pop aload pop M} ifelse }ifelse }ifelse }
     ifelse }
   forall} bind def
/MFwidth {0 exch { dup 5 get 3 ge { 5 get 3 eq { 0 } { pop } ifelse }
 {dup 3 get{dup dup 0 get findfont exch 1 get scalefont setfont
     6 get stringwidth pop add} {pop} ifelse} ifelse} forall} bind def
/MLshow { currentpoint stroke M
  0 exch R
  Blacktext {gsave 0 setgray MFshow grestore} {MFshow} ifelse } bind def
/MRshow { currentpoint stroke M
  exch dup MFwidth neg 3 -1 roll R
  Blacktext {gsave 0 setgray MFshow grestore} {MFshow} ifelse } bind def
/MCshow { currentpoint stroke M
  exch dup MFwidth -2 div 3 -1 roll R
  Blacktext {gsave 0 setgray MFshow grestore} {MFshow} ifelse } bind def
/XYsave    { [( ) 1 2 true false 3 ()] } bind def
/XYrestore { [( ) 1 2 true false 4 ()] } bind def
/AvantGarde-Book reencodeISO15 def
end
%%EndProlog
%%Page: 1 1
gnudict begin
gsave
50 50 translate
0.100 0.100 scale
90 rotate
0 -5040 translate
0 setgray
newpath
(AvantGarde-Book) findfont 200 scalefont setfont
2.000 UL
LTb
1220 240 M
63 0 V
5617 0 R
-63 0 V
stroke
1100 240 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 ( 0)]
] -66.7 MRshow
2.000 UL
LTb
1220 1084 M
63 0 V
5617 0 R
-63 0 V
stroke
1100 1084 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 ( 100)]
] -66.7 MRshow
2.000 UL
LTb
1220 1929 M
63 0 V
5617 0 R
-63 0 V
stroke
1100 1929 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 ( 200)]
] -66.7 MRshow
2.000 UL
LTb
1220 2773 M
63 0 V
5617 0 R
-63 0 V
stroke
1100 2773 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 ( 300)]
] -66.7 MRshow
2.000 UL
LTb
1220 3618 M
63 0 V
5617 0 R
-63 0 V
stroke
1100 3618 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 ( 400)]
] -66.7 MRshow
2.000 UL
LTb
1220 4462 M
63 0 V
5617 0 R
-63 0 V
stroke
1100 4462 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 ( 500)]
] -66.7 MRshow
2.000 UL
LTb
2.000 UL
LTb
1220 4800 N
0 -4560 V
5680 0 V
0 4560 V
-5680 0 V
Z stroke
LCb setrgbcolor
400 2520 M
currentpoint gsave translate 90 rotate 0 0 moveto
[ [(AvantGarde-Book) 200.0 0.0 true true 0 (Frequency \(cm)]
[(AvantGarde-Book) 160.0 100.0 true true 0 (-1)]
[(AvantGarde-Book) 200.0 0.0 true true 0 (\))]
] -86.7 MCshow
grestore
LTb
1.000 UP
1220 126 M
[ /Symbol reencodeISO15 def
[(Symbol) 200.0 0.0 true true 0 (G)]
] -66.7 MCshow
2547 126 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 (X)]
] -66.7 MCshow
3211 126 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 (W)]
] -66.7 MCshow
3874 126 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 (X)]
] -66.7 MCshow
4343 126 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 (K)]
] -66.7 MCshow
5751 126 M
[ [(Symbol) 200.0 0.0 true true 0 (G)]
] -66.7 MCshow
5751 126 M
[ [(Symbol) 200.0 0.0 true true 0 (G)]
] -66.7 MCshow
6900 126 M
[ [(AvantGarde-Book) 200.0 0.0 true true 0 (L)]
] -66.7 MCshow
2.000 UL
LTb
2.000 UL
LT0
1.00 0.00 0.00 C /AvantGarde-Book findfont 200 scalefont setfont
1220 240 M
33 108 V
33 108 V
34 108 V
33 108 V
33 107 V
33 107 V
33 106 V
33 106 V
34 105 V
33 104 V
33 104 V
33 102 V
33 100 V
33 100 V
34 98 V
33 96 V
33 95 V
33 93 V
33 91 V
34 90 V
33 88 V
33 86 V
33 84 V
33 83 V
33 81 V
34 79 V
33 78 V
33 76 V
33 74 V
33 73 V
33 71 V
34 70 V
33 68 V
33 66 V
33 64 V
33 62 V
34 61 V
33 58 V
33 57 V
33 54 V
stroke
LT1
0.00 1.00 1.00 C /AvantGarde-Book findfont 200 scalefont setfont
1220 4576 M
33 0 V
33 1 V
34 2 V
33 1 V
33 2 V
33 1 V
33 1 V
33 0 V
34 0 V
33 -2 V
33 -4 V
33 -5 V
33 -7 V
33 -10 V
34 -11 V
33 -14 V
33 -16 V
33 -18 V
33 -20 V
34 -23 V
33 -24 V
33 -25 V
33 -27 V
33 -29 V
33 -30 V
34 -31 V
33 -33 V
33 -33 V
33 -35 V
33 -36 V
33 -37 V
34 -38 V
33 -40 V
33 -41 V
33 -43 V
33 -45 V
34 -47 V
33 -48 V
33 -50 V
33 -53 V
stroke
LT2
1.00 0.00 1.00 C /AvantGarde-Book findfont 200 scalefont setfont
1220 240 M
33 58 V
33 58 V
34 58 V
33 59 V
33 58 V
33 59 V
33 59 V
33 59 V
34 58 V
33 58 V
33 58 V
33 56 V
33 55 V
33 53 V
34 51 V
33 48 V
33 46 V
33 43 V
33 39 V
34 36 V
33 32 V
33 29 V
33 26 V
33 22 V
33 19 V
34 17 V
33 14 V
33 12 V
33 11 V
33 10 V
33 8 V
34 8 V
33 7 V
33 7 V
33 5 V
33 5 V
34 4 V
33 3 V
33 2 V
33 0 V
-33 0 V
-33 -2 V
-33 -3 V
-34 -4 V
-33 -5 V
-33 -5 V
-33 -7 V
-33 -7 V
-34 -8 V
-33 -8 V
-33 -10 V
-33 -11 V
-33 -12 V
-33 -14 V
-34 -17 V
-33 -19 V
-33 -22 V
-33 -26 V
-33 -29 V
-33 -32 V
-34 -36 V
-33 -39 V
-33 -43 V
-33 -46 V
-33 -48 V
-34 -51 V
-33 -53 V
-33 -55 V
-33 -56 V
-33 -58 V
-33 -58 V
-34 -58 V
-33 -59 V
-33 -59 V
-33 -59 V
-33 -58 V
-33 -59 V
-34 -58 V
-33 -58 V
-33 -58 V
0 4336 V
33 -1 V
33 -2 V
34 -5 V
33 -6 V
33 -8 V
33 -10 V
33 -13 V
33 -14 V
34 -16 V
33 -19 V
33 -20 V
33 -22 V
33 -24 V
33 -26 V
34 -26 V
33 -27 V
33 -28 V
33 -28 V
33 -27 V
34 -26 V
33 -25 V
33 -23 V
33 -22 V
stroke 1983 4158 M
33 -19 V
33 -16 V
34 -15 V
33 -12 V
33 -9 V
33 -8 V
33 -6 V
33 -4 V
34 -2 V
33 -2 V
33 0 V
33 0 V
33 0 V
34 0 V
33 1 V
33 0 V
33 0 V
-33 0 V
-33 0 V
-33 -1 V
-34 0 V
-33 0 V
-33 0 V
-33 0 V
-33 2 V
-34 2 V
-33 4 V
-33 6 V
-33 8 V
-33 9 V
-33 12 V
-34 15 V
-33 16 V
-33 19 V
-33 22 V
-33 23 V
-33 25 V
-34 26 V
-33 27 V
-33 28 V
-33 28 V
-33 27 V
-34 26 V
-33 26 V
-33 24 V
-33 22 V
-33 20 V
-33 19 V
-34 16 V
-33 14 V
-33 13 V
-33 10 V
-33 8 V
-33 6 V
-34 5 V
-33 2 V
-33 1 V
stroke
LT3
1.00 0.00 0.00 C /AvantGarde-Book findfont 200 scalefont setfont
2547 1550 M
33 3 V
33 7 V
34 12 V
33 16 V
33 20 V
33 24 V
33 28 V
33 31 V
34 34 V
33 35 V
33 37 V
33 37 V
33 37 V
33 35 V
34 33 V
33 29 V
33 24 V
33 18 V
33 12 V
34 4 V
-34 -4 V
-33 -12 V
-33 -18 V
-33 -24 V
-33 -29 V
-34 -33 V
-33 -35 V
-33 -37 V
-33 -37 V
-33 -37 V
-33 -35 V
-34 -34 V
-33 -31 V
-33 -28 V
-33 -24 V
-33 -20 V
-33 -16 V
-34 -12 V
-33 -7 V
-33 -3 V
0 2159 V
33 -3 V
33 -8 V
34 -14 V
33 -19 V
33 -24 V
33 -27 V
33 -30 V
33 -33 V
34 -34 V
33 -36 V
33 -37 V
33 -37 V
33 -36 V
33 -34 V
34 -32 V
33 -28 V
33 -23 V
33 -18 V
33 -11 V
34 -4 V
-34 4 V
-33 11 V
-33 18 V
-33 23 V
-33 28 V
-34 32 V
-33 34 V
-33 36 V
-33 37 V
-33 37 V
-33 36 V
-34 34 V
-33 33 V
-33 30 V
-33 27 V
-33 24 V
-33 19 V
-34 14 V
-33 8 V
-33 3 V
0 357 V
33 0 V
33 2 V
34 3 V
33 3 V
33 4 V
33 3 V
33 3 V
33 2 V
34 2 V
33 1 V
33 1 V
33 0 V
33 0 V
33 0 V
34 -1 V
33 -1 V
33 0 V
33 -1 V
33 0 V
34 0 V
-34 0 V
-33 0 V
stroke 3144 4087 M
-33 1 V
-33 0 V
-33 1 V
-34 1 V
-33 0 V
-33 0 V
-33 0 V
-33 -1 V
-33 -1 V
-34 -2 V
-33 -2 V
-33 -3 V
-33 -3 V
-33 -4 V
-33 -3 V
-34 -3 V
-33 -2 V
-33 0 V
stroke
LT4
1.00 0.00 0.00 C /AvantGarde-Book findfont 200 scalefont setfont
3211 2026 M
33 -4 V
33 -12 V
33 -18 V
33 -24 V
33 -29 V
34 -33 V
33 -35 V
33 -37 V
33 -37 V
33 -37 V
33 -35 V
34 -34 V
33 -31 V
33 -28 V
33 -24 V
33 -20 V
34 -16 V
33 -12 V
33 -7 V
33 -3 V
-33 3 V
-33 7 V
-33 12 V
-34 16 V
-33 20 V
-33 24 V
-33 28 V
-33 31 V
-34 34 V
-33 35 V
-33 37 V
-33 37 V
-33 37 V
-33 35 V
-34 33 V
-33 29 V
-33 24 V
-33 18 V
-33 12 V
-33 4 V
0 1195 V
33 4 V
33 11 V
33 18 V
33 23 V
33 28 V
34 32 V
33 34 V
33 36 V
33 37 V
33 37 V
33 36 V
34 34 V
33 33 V
33 30 V
33 27 V
33 24 V
34 19 V
33 14 V
33 8 V
33 3 V
-33 -3 V
-33 -8 V
-33 -14 V
-34 -19 V
-33 -24 V
-33 -27 V
-33 -30 V
-33 -33 V
-34 -34 V
-33 -36 V
-33 -37 V
-33 -37 V
-33 -36 V
-33 -34 V
-34 -32 V
-33 -28 V
-33 -23 V
-33 -18 V
-33 -11 V
-33 -4 V
0 866 V
33 0 V
33 0 V
33 1 V
33 0 V
33 1 V
34 1 V
33 0 V
33 0 V
33 0 V
33 -1 V
33 -1 V
34 -2 V
33 -2 V
33 -3 V
33 -3 V
33 -4 V
34 -3 V
33 -3 V
33 -2 V
33 0 V
-33 0 V
-33 2 V
stroke 3808 4068 M
-33 3 V
-34 3 V
-33 4 V
-33 3 V
-33 3 V
-33 2 V
-34 2 V
-33 1 V
-33 1 V
-33 0 V
-33 0 V
-33 0 V
-34 -1 V
-33 -1 V
-33 0 V
-33 -1 V
-33 0 V
-33 0 V
stroke
LT5
1.00 0.00 0.00 C /AvantGarde-Book findfont 200 scalefont setfont
3874 3709 M
31 -3 V
32 -8 V
31 -13 V
31 -18 V
32 -22 V
31 -26 V
31 -29 V
31 -31 V
32 -34 V
31 -36 V
31 -38 V
31 -40 V
32 -40 V
31 -42 V
31 -43 V
35 -48 V
36 -49 V
35 -49 V
35 -50 V
35 -49 V
35 -50 V
36 -49 V
35 -49 V
35 -49 V
35 -49 V
35 -49 V
36 -50 V
35 -50 V
35 -52 V
35 -53 V
35 -55 V
35 -57 V
36 -59 V
35 -62 V
35 -66 V
35 -68 V
35 -73 V
36 -76 V
35 -80 V
35 -83 V
35 -88 V
35 -92 V
35 -95 V
36 -99 V
35 -102 V
35 -105 V
35 -108 V
35 -111 V
36 -113 V
35 -115 V
35 -117 V
35 -118 V
35 -119 V
36 -120 V
35 -120 V
0 4336 V
-35 -1 V
-36 -3 V
-35 -5 V
-35 -6 V
-35 -8 V
-35 -10 V
-36 -11 V
-35 -12 V
-35 -13 V
-35 -14 V
-35 -14 V
-36 -14 V
-35 -13 V
-35 -14 V
-35 -13 V
-35 -12 V
-35 -12 V
-36 -10 V
-35 -11 V
-35 -9 V
-35 -8 V
-35 -9 V
-36 -7 V
-35 -8 V
-35 -7 V
-35 -7 V
-35 -7 V
-35 -8 V
-36 -8 V
-35 -8 V
-35 -9 V
-35 -9 V
-35 -10 V
-36 -10 V
-35 -11 V
-35 -11 V
-35 -11 V
-35 -11 V
-36 -11 V
-35 -12 V
-31 -10 V
-31 -10 V
-32 -10 V
-31 -10 V
-31 -11 V
-31 -10 V
-32 -10 V
-31 -9 V
stroke 4093 4109 M
-31 -10 V
-31 -9 V
-32 -8 V
-31 -6 V
-31 -6 V
-32 -3 V
-31 -1 V
stroke
LT6
0.00 1.00 0.00 C /AvantGarde-Book findfont 200 scalefont setfont
3874 4066 M
31 0 V
32 0 V
31 0 V
31 -1 V
32 0 V
31 0 V
31 -1 V
31 0 V
32 0 V
31 0 V
31 0 V
31 1 V
32 1 V
31 1 V
31 2 V
35 3 V
36 3 V
35 5 V
35 6 V
35 7 V
35 8 V
36 9 V
35 11 V
35 13 V
35 14 V
35 15 V
36 17 V
35 18 V
35 19 V
35 20 V
35 20 V
35 22 V
36 21 V
35 22 V
35 22 V
35 22 V
35 21 V
36 20 V
35 20 V
35 18 V
35 18 V
35 16 V
35 15 V
36 14 V
35 13 V
35 11 V
35 9 V
35 9 V
36 7 V
35 6 V
35 5 V
35 4 V
35 2 V
36 2 V
35 0 V
stroke
LT7
0.00 0.00 1.00 C /AvantGarde-Book findfont 200 scalefont setfont
3874 1550 M
31 1 V
32 0 V
31 0 V
31 1 V
32 1 V
31 1 V
31 1 V
31 1 V
32 1 V
31 2 V
31 1 V
31 1 V
32 1 V
31 1 V
31 0 V
35 0 V
36 -1 V
35 -2 V
35 -3 V
35 -5 V
35 -6 V
36 -8 V
35 -9 V
35 -12 V
35 -15 V
35 -16 V
36 -19 V
35 -22 V
35 -25 V
35 -27 V
35 -29 V
35 -32 V
36 -35 V
35 -37 V
35 -39 V
35 -42 V
35 -43 V
36 -45 V
35 -46 V
35 -48 V
35 -49 V
35 -49 V
35 -51 V
36 -50 V
35 -51 V
35 -52 V
35 -51 V
35 -51 V
36 -51 V
35 -51 V
35 -50 V
35 -51 V
35 -50 V
36 -50 V
35 -50 V
stroke
LT8
0.00 1.00 1.00 C /AvantGarde-Book findfont 200 scalefont setfont
3874 1550 M
31 5 V
32 12 V
31 20 V
31 27 V
32 33 V
31 38 V
31 43 V
31 45 V
32 48 V
31 48 V
31 48 V
31 46 V
32 44 V
31 41 V
31 35 V
35 33 V
36 25 V
35 16 V
35 7 V
35 -1 V
35 -9 V
36 -15 V
35 -20 V
35 -24 V
35 -28 V
35 -31 V
36 -33 V
35 -37 V
35 -39 V
35 -42 V
35 -46 V
35 -49 V
36 -52 V
35 -55 V
35 -59 V
35 -63 V
35 -65 V
36 -68 V
35 -71 V
35 -72 V
35 -74 V
35 -75 V
35 -76 V
36 -75 V
35 -75 V
35 -73 V
35 -73 V
35 -71 V
36 -69 V
35 -68 V
35 -65 V
35 -64 V
35 -63 V
36 -62 V
35 -62 V
0 4336 V
-35 0 V
-36 0 V
-35 -1 V
-35 -2 V
-35 -3 V
-35 -4 V
-36 -5 V
-35 -8 V
-35 -10 V
-35 -12 V
-35 -16 V
-36 -20 V
-35 -23 V
-35 -26 V
-35 -31 V
-35 -35 V
-35 -39 V
-36 -43 V
-35 -46 V
-35 -50 V
-35 -53 V
-35 -56 V
-36 -58 V
-35 -60 V
-35 -61 V
-35 -62 V
-35 -62 V
-35 -62 V
-36 -60 V
-35 -58 V
-35 -56 V
-35 -51 V
-35 -46 V
-36 -40 V
-35 -31 V
-35 -23 V
-35 -14 V
-35 -3 V
-36 7 V
-35 15 V
-31 21 V
-31 25 V
-32 28 V
-31 31 V
-31 33 V
-31 32 V
-32 31 V
-31 30 V
stroke 4093 3599 M
-31 27 V
-31 25 V
-32 20 V
-31 16 V
-31 12 V
-32 8 V
-31 2 V
stroke
LT0
1.00 0.00 0.00 C /AvantGarde-Book findfont 200 scalefont setfont
5751 240 M
29 100 V
28 99 V
29 100 V
29 99 V
28 99 V
29 99 V
29 99 V
29 99 V
28 98 V
29 98 V
29 98 V
29 97 V
28 96 V
29 96 V
29 94 V
28 94 V
29 92 V
29 91 V
29 89 V
28 89 V
29 86 V
29 85 V
29 83 V
28 81 V
29 79 V
29 77 V
29 75 V
28 73 V
29 71 V
29 68 V
28 67 V
29 65 V
29 62 V
29 60 V
28 58 V
29 54 V
29 51 V
28 45 V
29 34 V
29 14 V
0 206 V
-29 12 V
-29 31 V
-28 39 V
-29 43 V
-29 44 V
-28 44 V
-29 45 V
-29 43 V
-29 43 V
-28 42 V
-29 41 V
-29 40 V
-28 39 V
-29 37 V
-29 35 V
-29 34 V
-28 32 V
-29 30 V
-29 28 V
-29 27 V
-28 24 V
-29 22 V
-29 21 V
-29 18 V
-28 16 V
-29 15 V
-29 13 V
-28 11 V
-29 10 V
-29 8 V
-29 7 V
-28 5 V
-29 5 V
-29 4 V
-29 2 V
-28 3 V
-29 1 V
-29 1 V
-28 1 V
-29 0 V
stroke
LT1
0.00 0.00 1.00 C /AvantGarde-Book findfont 200 scalefont setfont
5751 240 M
29 44 V
28 44 V
29 44 V
29 44 V
28 44 V
29 44 V
29 43 V
29 43 V
28 42 V
29 42 V
29 40 V
29 40 V
28 39 V
29 38 V
29 36 V
28 35 V
29 33 V
29 31 V
29 28 V
28 27 V
29 24 V
29 22 V
29 19 V
28 17 V
29 15 V
29 12 V
29 10 V
28 7 V
29 6 V
29 4 V
28 3 V
29 1 V
29 0 V
29 -1 V
28 -1 V
29 -1 V
29 -1 V
28 -1 V
29 -1 V
29 0 V
-29 0 V
-29 1 V
-28 1 V
-29 1 V
-29 1 V
-28 1 V
-29 1 V
-29 0 V
-29 -1 V
-28 -3 V
-29 -4 V
-29 -6 V
-28 -7 V
-29 -10 V
-29 -12 V
-29 -15 V
-28 -17 V
-29 -19 V
-29 -22 V
-29 -24 V
-28 -27 V
-29 -28 V
-29 -31 V
-29 -33 V
-28 -35 V
-29 -36 V
-29 -38 V
-28 -39 V
-29 -40 V
-29 -40 V
-29 -42 V
-28 -42 V
-29 -43 V
-29 -43 V
-29 -44 V
-28 -44 V
-29 -44 V
-29 -44 V
-28 -44 V
-29 -44 V
0 4336 V
29 0 V
28 -2 V
29 -2 V
29 -3 V
28 -4 V
29 -5 V
29 -5 V
29 -7 V
28 -7 V
29 -7 V
29 -9 V
29 -8 V
28 -9 V
29 -10 V
29 -10 V
28 -10 V
29 -10 V
29 -10 V
29 -9 V
28 -10 V
29 -9 V
29 -9 V
29 -8 V
stroke 6412 4413 M
28 -7 V
29 -7 V
29 -6 V
29 -6 V
28 -5 V
29 -4 V
29 -3 V
28 -3 V
29 -3 V
29 -2 V
29 -1 V
28 -1 V
29 -1 V
29 -1 V
28 0 V
29 -1 V
29 0 V
-29 0 V
-29 1 V
-28 0 V
-29 1 V
-29 1 V
-28 1 V
-29 1 V
-29 2 V
-29 3 V
-28 3 V
-29 3 V
-29 4 V
-28 5 V
-29 6 V
-29 6 V
-29 7 V
-28 7 V
-29 8 V
-29 9 V
-29 9 V
-28 10 V
-29 9 V
-29 10 V
-29 10 V
-28 10 V
-29 10 V
-29 10 V
-28 9 V
-29 8 V
-29 9 V
-29 7 V
-28 7 V
-29 7 V
-29 5 V
-29 5 V
-28 4 V
-29 3 V
-29 2 V
-28 2 V
-29 0 V
stroke
LTb
1220 4800 N
0 -4560 V
5680 0 V
0 4560 V
-5680 0 V
Z stroke
1.000 UP
2.000 UL
LTb
0.00 0.00 0.00 C 2547 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 3211 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 3874 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 5751 240 M
0 4560 V
stroke
1.000 UL
LTb
0.00 0.00 0.00 C 2547 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 3211 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 3874 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 4343 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 5751 240 M
0 4560 V
stroke
LTb
0.00 0.00 0.00 C 5751 240 M
0 4560 V
stroke
2.000 UL
LTb
stroke
grestore
end
showpage
%%Trailer
%%DocumentFonts: Symbol AvantGarde-Book
%%Pages: 1
