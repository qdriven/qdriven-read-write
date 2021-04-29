# encoding: utf-8

"""
https://mitogen.networkgenomics.com/
"""

# IO Multiplexer
import mitogen

broker = mitogen.master.Broker()
router=mitogen.master.Router(broker)

bastion_host = router.ssh(
    hostname='jump-box.mycorp.com'
)

docker_host = router.ssh(
    via=bastion_host,
    hostname='docker-a.prod.mycorp.com'
)

sudo_account = router.sudo(
    via=docker_host,
    username='user_with_magic_ssh_key',
    password='sudo password',
)

internal_box = router.docker(
    via=sudo_account,
    container='billing0',
)

internal_box.call(os.system, './run-nightly-billing.py')