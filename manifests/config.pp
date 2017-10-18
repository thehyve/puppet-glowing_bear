# Copyright 2017 The Hyve.
class glowing_bear::config inherits glowing_bear::params {
    include ::glowing_bear

    $app_root = $::glowing_bear::params::app_root
    $env_location = $::glowing_bear::params::env_location
    $config_location = $::glowing_bear::params::config_location

    File {
        owner   => $::glowing_bear::params::user,
        group   => $::glowing_bear::params::user,
        require => Archive::Nexus[$::glowing_bear::params::app_archive],
    }

    file { $env_location:
        ensure  => file,
        content => template('glowing_bear/env.json.erb'),
        mode    => '0444',
    }

    file { $config_location:
        ensure  => file,
        content => template('glowing_bear/config.json.erb'),
        mode    => '0444',
    }

}

