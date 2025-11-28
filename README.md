# ansible-stuff

Miscellaneous Ansible playbooks and roles.

## Note for Fedora users

On recent Fedora versions (42+), the default Ansible package is now `ansible-core`, which does **not** include most collections by default.

If you get errors about missing modules (e.g., `community.general.lvol`, `ansible.posix.selinux`, etc.), install the required collections:

```bash
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general