# KalkSpace Getränkekasse Tablet Setup

We are using an Armbian/Ubuntu Jammy based setup

## Preparation

Install Armbian as described in their documentation.
After installing you should be able to ssh using root to the machine

## Installing the setup for the first time

Adjust the IP in `inventory.ini`. Be sure to check public_hostname.
For local development use "localhost". Otherwise "getraenkekasse.kalk.space".

`ansible-playbook tablet.yml -v -i inventory.ini --ask-pass -K`

## Post work

Finally once the kiosk is running, attach a keyboard, hit ctrl-+ a few times so zoom level is ok

(should be automated)

## Updating

After deploying for the first time the following command will update everything

`ansible-playbook tablet.yml -i inventory.ini`

The browser is currently unfortunately caching the old version. If you updated the frontend please connect a keyboard and press ctrl+r so the browser fetches the new version
