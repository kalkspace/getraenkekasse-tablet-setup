# KalkSpace Getränkekasse Tablet Setup

We are using an Armbian/Ubuntu Jammy based setup

## Preparation

Install Armbian as described in their documentation.
After installing you should be able to ssh using root to the machine

The vault needs a password to decrypt secrets. Members of the admin team can find this in our password manager. Place it in `~/.kalkspace_ansible_vault_pass`.

## Installing the setup for the first time

Adjust the IP in `inventory.ini`. Be sure to check public_hostname.
For local development use "localhost". Otherwise "getraenkekasse.kalk.space".

`ansible-playbook tablet.yml -v --ask-pass -K`

## Post work

Finally once the kiosk is running, attach a keyboard, hit ctrl-+ a few times so zoom level is ok

(should be automated)

## Updating

After deploying for the first time the following command will update everything

`ansible-playbook tablet.yml`

The browser is currently unfortunately caching the old version. If you updated the frontend please connect a keyboard and press ctrl+r so the browser fetches the new version
