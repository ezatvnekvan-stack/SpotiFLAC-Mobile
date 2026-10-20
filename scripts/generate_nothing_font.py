"""Generate the original, freely redistributable 5x7 display typeface.

Requires fonttools. Lowercase uses the same dot glyphs as uppercase; unsupported
scripts use the app's normal font fallback. UI strings themselves are unchanged.
"""
from pathlib import Path
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen

PATTERNS = {
 'A':'01110/10001/10001/11111/10001/10001/10001',
 'B':'11110/10001/10001/11110/10001/10001/11110',
 'C':'01111/10000/10000/10000/10000/10000/01111',
 'D':'11110/10001/10001/10001/10001/10001/11110',
 'E':'11111/10000/10000/11110/10000/10000/11111',
 'F':'11111/10000/10000/11110/10000/10000/10000',
 'G':'01111/10000/10000/10111/10001/10001/01110',
 'H':'10001/10001/10001/11111/10001/10001/10001',
 'I':'11111/00100/00100/00100/00100/00100/11111',
 'J':'00111/00010/00010/00010/10010/10010/01100',
 'K':'10001/10010/10100/11000/10100/10010/10001',
 'L':'10000/10000/10000/10000/10000/10000/11111',
 'M':'10001/11011/10101/10101/10001/10001/10001',
 'N':'10001/11001/11001/10101/10011/10011/10001',
 'O':'01110/10001/10001/10001/10001/10001/01110',
 'P':'11110/10001/10001/11110/10000/10000/10000',
 'Q':'01110/10001/10001/10001/10101/10010/01101',
 'R':'11110/10001/10001/11110/10100/10010/10001',
 'S':'01111/10000/10000/01110/00001/00001/11110',
 'T':'11111/00100/00100/00100/00100/00100/00100',
 'U':'10001/10001/10001/10001/10001/10001/01110',
 'V':'10001/10001/10001/10001/10001/01010/00100',
 'W':'10001/10001/10001/10101/10101/11011/10001',
 'X':'10001/10001/01010/00100/01010/10001/10001',
 'Y':'10001/10001/01010/00100/00100/00100/00100',
 'Z':'11111/00001/00010/00100/01000/10000/11111',
 '0':'01110/10001/10011/10101/11001/10001/01110',
 '1':'00100/01100/00100/00100/00100/00100/01110',
 '2':'01110/10001/00001/00010/00100/01000/11111',
 '3':'11110/00001/00001/01110/00001/00001/11110',
 '4':'00010/00110/01010/10010/11111/00010/00010',
 '5':'11111/10000/10000/11110/00001/00001/11110',
 '6':'01110/10000/10000/11110/10001/10001/01110',
 '7':'11111/00001/00010/00100/01000/01000/01000',
 '8':'01110/10001/10001/01110/10001/10001/01110',
 '9':'01110/10001/10001/01111/00001/00001/01110',
 '.':'00000/00000/00000/00000/00000/00110/00110',
 ':':'00000/00100/00100/00000/00100/00100/00000',
 '-':'00000/00000/00000/11111/00000/00000/00000',
 '/':'00001/00001/00010/00100/01000/10000/10000',
 '(':'00010/00100/01000/01000/01000/00100/00010',
 ')':'01000/00100/00010/00010/00010/00100/01000',
 '+':'00000/00100/00100/11111/00100/00100/00000',
 '&':'01100/10010/10100/01000/10101/10010/01101',
 '!':'00100/00100/00100/00100/00100/00000/00100',
 '?':'01110/10001/00001/00010/00100/00000/00100',
 ',':'00000/00000/00000/00000/00110/00100/01000',
 "'":'00100/00100/00000/00000/00000/00000/00000',
}

def glyph(pattern):
    pen = TTGlyphPen(None)
    for row, line in enumerate(pattern.split('/')):
        for col, bit in enumerate(line):
            if bit != '1':
                continue
            x, y, r = 85 + col * 120, 790 - row * 120, 43
            k = r * 0.55228475
            pen.moveTo((x + r, y))
            pen.qCurveTo((x + r, y + k), (x + k, y + r), (x, y + r))
            pen.qCurveTo((x - k, y + r), (x - r, y + k), (x - r, y))
            pen.qCurveTo((x - r, y - k), (x - k, y - r), (x, y - r))
            pen.qCurveTo((x + k, y - r), (x + r, y - k), (x + r, y))
            pen.closePath()
    return pen.glyph()

def main():
    fb = FontBuilder(1000, isTTF=True)
    names = ['.notdef', 'space'] + ['uni%04X' % ord(c) for c in PATTERNS]
    fb.setupGlyphOrder(names)
    cmap = {ord(c): 'uni%04X' % ord(c) for c in PATTERNS}
    cmap.update({ord(c.lower()): cmap[ord(c)] for c in PATTERNS if c.isalpha()})
    cmap[32] = 'space'
    fb.setupCharacterMap(cmap)
    glyphs = {'.notdef': TTGlyphPen(None).glyph(), 'space': TTGlyphPen(None).glyph()}
    glyphs.update({cmap[ord(c)]: glyph(p) for c, p in PATTERNS.items()})
    fb.setupGlyf(glyphs)
    fb.setupHorizontalMetrics({name: (650 if name != 'space' else 340, 0) for name in names})
    fb.setupHorizontalHeader(ascent=940, descent=-160)
    fb.setupNameTable({'familyName':'Nothing Dot','styleName':'Regular','uniqueFontIdentifier':'SpotiFLAC Nothing Dot 1.0','fullName':'Nothing Dot Regular','psName':'NothingDot-Regular','version':'Version 1.0','licenseDescription':'MIT License. Original glyph artwork, 2026.'})
    fb.setupOS2(sTypoAscender=940, sTypoDescender=-160, usWinAscent=940, usWinDescent=160)
    fb.setupPost()
    target = Path(__file__).resolve().parents[1] / 'assets/fonts/NothingDot.ttf'
    target.parent.mkdir(parents=True, exist_ok=True)
    fb.save(target)
    print(target)

if __name__ == '__main__':
    main()
