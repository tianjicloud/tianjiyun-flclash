"""Generate installation, Windows tray, Android notification and in-app icons from the
天机云 brand mark.

The mark is a raster with gradients and a soft glow, so unlike upstream's
vector glyph it is rendered to bitmaps per density. Run from the repository
root with Pillow installed:

    python3 tool/generate_brand_icons.py
"""

import argparse
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / 'assets_source/images/icon/tianjiyun-mark.png'
APP_RES = ROOT / 'android/app/src/main/res'
SERVICE_RES = ROOT / 'android/service/src/main/res'
MACOS_TRAY_RES = ROOT / 'assets/images/tray/macos'
MACOS_COLOR_TRAY_RES = MACOS_TRAY_RES / 'color'

# Matches @color/ic_launcher_background, which the splash screen shares.
BACKGROUND = (0xF7, 0xF9, 0xFB, 255)
TEXT = (0x0F, 0x17, 0x2A, 255)
BANNER_FONT = '/usr/share/fonts/noto-cjk/NotoSansCJK-Medium.ttc'
# Face 2 of the Noto Sans CJK collection is Simplified Chinese.
BANNER_FONT_INDEX = 2

DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
# The glow is drawn below this alpha; masks keep only the solid shape.
SILHOUETTE_ALPHA = 220

# Widths of the mark as a share of its canvas.
ADAPTIVE_WIDTH = 0.50  # fits the 66dp circle of a 108dp adaptive layer
TV_WIDTH = 0.50
LEGACY_WIDTH = 0.66
SMALL_ICON_WIDTH = 0.92


def load_mark():
    image = Image.open(SOURCE).convert('RGBA')
    visible = image.getchannel('A').point(lambda v: 255 if v > 8 else 0)
    return image.crop(visible.getbbox())


def silhouette(mark):
    alpha = mark.getchannel('A').point(
        lambda v: 255 if v >= SILHOUETTE_ALPHA else 0
    )
    solid = Image.new('RGBA', mark.size, (255, 255, 255, 255))
    solid.putalpha(alpha)
    return solid.crop(alpha.getbbox())


def place(mark, size, width_share, background=(0, 0, 0, 0)):
    canvas = Image.new('RGBA', (size, size), background)
    width = round(size * width_share)
    height = round(width * mark.height / mark.width)
    scaled = mark.resize((width, height), Image.LANCZOS)
    canvas.alpha_composite(scaled, ((size - width) // 2, (size - height) // 2))
    return canvas


def clip(image, shape):
    mask = Image.new('L', image.size, 0)
    draw = ImageDraw.Draw(mask)
    box = [0, 0, image.width - 1, image.height - 1]
    if shape == 'circle':
        draw.ellipse(box, fill=255)
    else:
        draw.rounded_rectangle(box, radius=image.width // 6, fill=255)
    clipped = Image.new('RGBA', image.size, (0, 0, 0, 0))
    clipped.paste(image, (0, 0), mask)
    return clipped


def save(image, path, **options):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.suffix == '.webp':
        image.save(path, 'WEBP', lossless=True, **options)
    else:
        image.save(path, optimize=True, **options)


def banner(mark):
    # TV banners are 320x180 at xhdpi.
    canvas = Image.new('RGBA', (320, 180), BACKGROUND)
    height = 78
    width = round(height * mark.width / mark.height)
    scaled = mark.resize((width, height), Image.LANCZOS)
    font = ImageFont.truetype(BANNER_FONT, 46, index=BANNER_FONT_INDEX)
    text = '天机云'
    left, top, right, bottom = font.getbbox(text)
    gap = 18
    total = width + gap + (right - left)
    x = (320 - total) // 2
    canvas.alpha_composite(scaled, (x, (180 - height) // 2))
    draw = ImageDraw.Draw(canvas)
    draw.text(
        (x + width + gap - left, (180 - (bottom - top)) // 2 - top),
        text,
        font=font,
        fill=TEXT,
    )
    return canvas.convert('RGB')


def generate_windows_tray(mark):
    sizes = [(size, size) for size in [16, 20, 24, 32, 40, 48, 64, 128, 256]]
    for status, tint in [(1, '#8490a2'), (2, None), (3, '#13b89d'), (4, '#e99a23')]:
        icon = mark.copy()
        if tint is not None:
            icon = ImageOps.colorize(
                ImageOps.grayscale(mark), '#172235', tint
            ).convert('RGBA')
            icon.putalpha(mark.getchannel('A'))
        save(
            place(icon, 256, 0.96),
            ROOT / f'assets/images/tray/windows/status_{status}.ico',
            sizes=sizes,
        )


def generate_macos_tray(shape):
    status_colors = {1: '#8490a2', 2: '#1769d2', 3: '#13b89d'}
    for status, color in status_colors.items():
        _save_macos_tray_variants(
            MACOS_COLOR_TRAY_RES,
            f'status_{status}.png',
            _tint(shape, color),
        )
    _save_macos_tray_variants(
        MACOS_TRAY_RES,
        'status_1.png',
        _tint(shape, '#000000'),
    )


def _save_macos_tray_variants(directory, name, image):
    for scale in [1, 2, 3, 4]:
        scaled_dir = directory if scale == 1 else directory / f'{scale}.0x'
        save(place(image, 18 * scale, 0.92), scaled_dir / name)


def _tint(image, color):
    tinted = Image.new('RGBA', image.size, color)
    tinted.putalpha(image.getchannel('A'))
    return tinted


def main():
    mark = load_mark()
    shape = silhouette(mark)
    generate_macos_tray(shape)

    for density, scale in DENSITIES.items():
        adaptive = round(108 * scale)
        save(
            place(mark, adaptive, ADAPTIVE_WIDTH),
            APP_RES / f'drawable-{density}/ic_launcher_foreground.png',
        )
        save(
            place(shape, adaptive, ADAPTIVE_WIDTH),
            APP_RES / f'drawable-{density}/ic_launcher_monochrome.png',
        )
        save(
            place(mark, adaptive, TV_WIDTH),
            APP_RES / f'drawable-{density}/ic_launcher_foreground_tv.png',
        )

        legacy = round(48 * scale)
        full = place(mark, legacy, LEGACY_WIDTH, BACKGROUND)
        save(clip(full, 'square'), APP_RES / f'mipmap-{density}/ic_launcher.webp')
        save(
            clip(full, 'circle'),
            APP_RES / f'mipmap-{density}/ic_launcher_round.webp',
        )

        tv = round(80 * scale)
        save(
            place(mark, tv, LEGACY_WIDTH, BACKGROUND).convert('RGB'),
            APP_RES / f'mipmap-television-{density}/ic_launcher.webp',
        )

        small = round(24 * scale)
        small_icon = place(shape, small, SMALL_ICON_WIDTH)
        save(small_icon, SERVICE_RES / f'drawable-{density}/ic.png')
        save(small_icon, SERVICE_RES / f'drawable-{density}/ic_service.png')

    save(banner(mark), APP_RES / 'mipmap-xhdpi/ic_banner.png')
    app_icon = place(mark, 550, 0.96)
    save(app_icon, ROOT / 'assets/images/icon.png')
    save(
        place(mark, 512, LEGACY_WIDTH, BACKGROUND),
        ROOT / 'android/app/src/main/ic_launcher-playstore.png',
    )
    ico_sizes = [(size, size) for size in [16, 20, 24, 32, 40, 48, 64, 96, 128, 256]]
    for path in ['assets/images/icon.ico', 'windows/runner/resources/app_icon.ico']:
        save(app_icon, ROOT / path, sizes=ico_sizes)

    iconset = ROOT / 'macos/Runner/Assets.xcassets/AppIcon.appiconset'
    entries = json.loads((iconset / 'Contents.json').read_text())['images']
    for filename in sorted({entry['filename'] for entry in entries}):
        size = int(Path(filename).stem.removeprefix('app_icon_'))
        save(place(mark, size, 0.80), iconset / filename)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--tray-only', action='store_true', help='Only generate Windows tray icons')
    parser.add_argument(
        '--macos-tray-only',
        action='store_true',
        help='Only generate TianjiCloud macOS tray icons',
    )
    args = parser.parse_args()
    if args.macos_tray_only:
        generate_macos_tray(silhouette(load_mark()))
    else:
        generate_windows_tray(load_mark())
        if not args.tray_only:
            main()
