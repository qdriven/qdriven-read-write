# -*- coding: utf-8 -*-
import unittest
from unittest import TestCase

from index_generator import MkdocsGenerator


class TestMkdocGenerator(TestCase):
    def setUp(self):
        self.generator = MkdocsGenerator()

    def test_load_yaml_setting(self):
        with open('mkdocs.yml', 'r') as f:
            self.generator.load_yaml_setting(f)

        assert self.generator.yaml_setting['site_name']=='Leanring Testing in a Hard way!'

    def test_read_all_notes(self):
        self.generator.generate_mkdocs_yaml()
        print(self.generator)
