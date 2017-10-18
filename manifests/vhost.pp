# Copyright 2017 The Hyve.
class glowing_bear::vhost inherits glowing_bear::params {
    include ::glowing_bear

    $user = $::glowing_bear::params::user
    $hostname = $::glowing_bear::params::hostname
    $app_root = $::glowing_bear::params::app_root

    class { 'apache': }

    apache::vhost { $hostname:
        port          => '80',
        docroot       => $app_root,
        docroot_owner => $user,
        docroot_group => $user,
        require       => Archive::Nexus[$::glowing_bear::params::app_archive],
    }

}

