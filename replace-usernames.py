#!/usr/bin/env python

import csv
import re

_db = 'db.sql'
_users = 'usernames.csv'
_out = 'output.sql'

with open(_db, 'r') as _template: _data = _template.read()
_users = list(csv.reader(open(_users, 'rb'), delimiter='\t'))

for _u in _users:
        _comp = '(?<=["\s,\)])' + _u[0] + '(?=["\s,\)])'
        _data = re.sub(_comp, _u[1], _data, re.I)

with open(_out, 'w') as file: file.write(_data)
