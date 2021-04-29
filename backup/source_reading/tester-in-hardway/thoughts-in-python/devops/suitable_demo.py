# encoding: utf-8
"""
# Suitable for Ansible API
[suitable](https://suitable.readthedocs.io/en/latest/api.html)

- Installation
- Usage

## Suitable Installation

```python
pip install suitable
```

"""
from suitable import Api

# servers
api=Api(['server1','server2'],environment={"PGPORT":"5432"},extra_vars={"home",'~/workspace'})

api.file(dest="dest",state='touch')

with api.valid_return_codes(0, 1):
    api.shell('test -e /tmp/log && rm /tmp/log')


# suitable.api.install_strategy_plugins(directories)