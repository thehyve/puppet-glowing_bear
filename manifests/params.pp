# Copyright 2017 The Hyve.
class glowing_bear::params(
    String[1] $user                             = lookup('glowing_bear::user', String, first, 'glowingbear'),
    Optional[String[2]] $user_home              = lookup('glowing_bear::user_home', Optional[String[2]], first, undef),
    String[1] $version                          = lookup('glowing_bear::version', String, first, '0.0.1-SNAPSHOT'),
    String[1] $nexus_url                        = lookup('glowing_bear::nexus_url', String, first, 'https://repo.thehyve.nl'),
    Enum['snapshots', 'releases'] $repository   = lookup('glowing_bear::repository', Enum['snapshots','releases'], first, 'snapshots'),

    String[1] $hostname                         = lookup('glowing_bear::hostname', String),
    Integer[1,65535] $port                      = lookup('glowing_bear::port', Integer[1,65535], first, 80),
    Optional[String[1]] $app_url                = lookup('glowing_bear::app_url', Optional[String], first, undef),
    String[1] $transmart_url                    = lookup('glowing_bear::transmart_url', String),

    Enum['dev', 'prod'] $env                    = lookup('glowing_bear::env', Enum['dev','prod'], first, 'prod'),

    Optional[Boolean] $tree_node_counts_update                  = lookup('glowing_bear::tree_node_counts_update', Optional[Boolean], first, undef),
    Optional[Boolean] $autosave_subject_sets                    = lookup('glowing_bear::autosave_subject_sets', Optional[Boolean], first, undef),
    Optional[Enum['default', 'surveyTable']] $export_data_view  = lookup('glowing_bear::export_data_view', Optional[Enum['default','surveyTable']], first, undef),
) {

    if $app_url != undef {
        $application_url = $app_url
    } else {
        notify { "Warning: Glowing Bear on ${hostname} is configured without SSL!": }
        $application_url = "http://${hostname}"
    }

    # Set glowingbear user home directory
    if $user_home == undef {
        $gbuser_home = "/home/${user}"
    } else {
        $gbuser_home = $user_home
    }

    $app_archive = "${gbuser_home}/glowing-bear-${version}.tar"
    $app_root = "${gbuser_home}/glowing-bear-${version}"
    $env_location = "${app_root}/app/config/env.json"
    $config_location = "${app_root}/app/config/config.${env}.json"

}

