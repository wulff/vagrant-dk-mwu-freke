Vagrant: Freke
==============

Makes it possible to set up a local copy of freke.mwu.dk.

    apt-get update
    apt-get install puppet
    puppet apply --modulepath=puppet/modules/ puppet/manifests/site.pp

The current version of the manifest installs the following useful applications:

* apticron
* htop
* ncdu
* screen
* vim

Settings
--------

To use the included manifests, you need to add a `settings.pp` file to the `puppet/manifests` directory. It should define the following variables:

    $user_name = 'johndoe'
    $user_comment = 'John Doe'
    $user_authorized_key = '<id_rsa.pub>'

    $ssh_allowusers = 'johndoe vagrant'

    $irssi_real_name = 'John Doe'
    $irssi_user_name = 'johndoe'
    $irssi_user_pass = 'secret'
    $irssi_user_nick = 'jdoe'

    $apticron_recipients = 'jdoe@example.com'
