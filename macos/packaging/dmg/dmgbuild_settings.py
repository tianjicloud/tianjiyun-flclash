# dmgbuild settings for the TianjiCloud installer DMG.
# setup.dart repackages the .app with dmgbuild after flutter_distributor
# builds it, because the background alias appdmg writes is not resolved by
# current Finder versions. Paths arrive via environment variables.
import os

app = os.environ.get('TIANJI_APP_PATH', '')
background = os.environ.get(
    'TIANJI_BG_PATH',
    os.path.join(os.path.dirname(os.path.abspath(__file__)), 'background.png'),
)

files = [app] if app else []
symlinks = {'Applications': '/Applications'}

icon_locations = {
    'TianjiCloud.app': (200, 310),
    'Applications': (520, 310),
}
window_rect = ((100, 100), (720, 480))
icon_size = 112

format = 'UDZO'
default_view = 'icon'
show_status_bar = False
show_tab_view = False
show_toolbar = False
show_pathbar = False
show_sidebar = False
