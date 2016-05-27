import dork_compose.plugin
import os


class Plugin(dork_compose.plugin.Plugin):

    def environment(self):
        return {
            'DORK_DBGP_NAME': self.env.get('DORK_DBGP_NAME', 'dork_aux_dbgp')
        }

    @property
    def auxiliary_project(self):
        return os.path.dirname(os.path.expanduser("%s/drupal-fancy/plugins/dbgp/" % self.env['DORK_LIBRARY_PATH']))
