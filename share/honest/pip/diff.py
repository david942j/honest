from __future__ import absolute_import, print_function

import glob
import os
import sys

class UnhonestError(Exception):
    pass

class Diff():
    def __init__(self, repo_path, pkg_path):
        self.repo_path = repo_path
        self.pkg_path = pkg_path + '/data/'
        self.load()

    def run(self):
        self.check_metadata_files()
        self.check_files_presented()
        self.check_hash()

    def check_metadata_files(self):
        record = self.record_files
        presented = []
        for root, dirnames, filenames in os.walk(self.pkg_path):
            for filename in filenames:
                presented.append(os.path.relpath(os.path.join(root, filename), self.pkg_path))
        extra = [x for x in presented if x not in record]
        missing = [x for x in record if x not in presented]
        if any(extra):
            self.unhonest('Extra files in package: {}.', extra)
        if any(missing):
            self.unhonest('Missing files in package: {}.', missing)

    def check_files_presented(self):
        pass

    def check_hash(self):
        pass

    def load(self):
        _, gen = self.get_info_obj()
        self.record_files = [ f for f in gen]

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

    def unhonest(self, fmt, ary):
        raise UnhonestError(fmt.format(', '.join(map(repr, ary))))

if __name__ == '__main__':
    if len(sys.argv) != 3:
        exit(1)
    try:
        Diff(sys.argv[1], sys.argv[2]).run()
    except UnhonestError as err:
        print('Unhonest! {}'.format(err))
        exit(1)

