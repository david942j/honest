from __future__ import absolute_import, print_function

import glob
import hashlib
import os
import sys

class UnhonestError(Exception):
    pass

class Diff():
    def __init__(self, source_path, pkg_path):
        self.source_path = source_path
        self.pkg_path = pkg_path + '/data/'
        self.load()

    def run(self):
        self.check_metadata_files()
        self.check_files_present()
        self.check_hash()

    def check_metadata_files(self):
        record = self.record_files
        present = []
        for root, dirnames, filenames in os.walk(self.pkg_path):
            for filename in filenames:
                present.append(os.path.relpath(os.path.join(root, filename), self.pkg_path))
        extra = [x for x in present if x not in record]
        missing = [x for x in record if x not in present]
        if any(extra):
            self.unhonest('Extra files in package: {}.', extra)
        if any(missing):
            self.unhonest('Missing files in package: {}.', missing)

    def check_files_present(self):
        missing = [f for f in filter(lambda f: not os.path.isfile(os.path.join(self.source_path, f)), self.normal_files)]
        if any(missing):
            self.unhonest('Files in package but not in source: {}.', missing)

    def check_hash(self):
        for f in self.normal_files:
            source = self.hash_of(os.path.join(self.source_path, f))
            pkg = self.hash_of(os.path.join(self.pkg_path, f))
            if source != pkg:
                exit(1)

    def load(self):
        info_dir, files = self.get_info_obj()
        self.record_files = files
        rel = os.path.relpath(info_dir, self.pkg_path)
        self.normal_files = [f for f in filter(lambda f: not f.startswith(rel) and f != 'PKG-INFO', self.record_files)]

    def get_info_obj(self):
        dist = glob.glob(self.pkg_path + '*.dist-info')
        if dist:
            # wheel
            return dist[0], self.wheel_filenames(dist[0])
        egg = glob.glob(self.pkg_path + '*.egg-info')
        if egg:
            # EGG
            return egg[0], self.egg_filenames(egg[0])
        # Fatal
        exit(2)

    def wheel_filenames(self, dist_info_dir):
        # XXX: What would happen to pip if filename contains ',' ?
        return [line.split(',')[0] for line in open(os.path.join(dist_info_dir, 'RECORD'), 'r').readlines()]

    def egg_filenames(self, dist_info_dir):
        filenames = [line.strip('\n') for line in open(os.path.join(dist_info_dir, 'SOURCES.txt'), 'r').readlines()]
        # This will not be record into SOURCES.txt
        filenames.append('PKG-INFO')
        return filenames

    def hash_of(self, filename):
        return hashlib.sha256(open(filename, 'rb').read()).hexdigest()

    def unhonest(self, fmt, ary):
        raise UnhonestError(fmt.format(', '.join(map(repr, ary))))

if __name__ == '__main__':
    if len(sys.argv) != 3:
        exit(1)
    try:
        Diff(sys.argv[1], sys.argv[2]).run()
    except UnhonestError as err:
        print('{}'.format(err), file=sys.stderr)
        exit(1)
