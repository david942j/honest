from __future__ import absolute_import, print_function

import glob
import sys

class Diff():
    def __init__(self, repo_path, pkg_path):
        self.repo_path = repo_path
        self.pkg_path = pkg_path + '/data/'

    def run(self):
        self.check_metadata_files()
        self.check_files_presented()
        self.check_hash()

    def check_metadata_files(self):
        info_path, files_generator = self.get_info_obj()

    def check_files_presented(self):
        pass

    def check_hash(self):
        pass

    def get_info_obj(self):
        dist = glob.glob(self.pkg_path + '*.dist-info')
        if dist:
            # wheel
            return dist[0], self.wheel_filename_generator(dist[0])
        egg = glob.glob(self.pkg_path + '*.egg-info')
        if egg:
            # EGG
            return egg[0], self.egg_filename_generator(egg[0])
        # Fatal
        exit(2)

    def wheel_filename_generator(self, dist_info_dir):
        for line in open(dist_info_dir + '/RECORD', 'r').readlines():
            # XXX: What would happen to pip if filename contains ',' ?
            filename, _sha, _line_count = line.split(',')
            yield filename


    def egg_filename_generator(self):
        pass

if __name__ == '__main__':
    if len(sys.argv) != 3:
        exit(1)
    Diff(sys.argv[1], sys.argv[2]).run()
