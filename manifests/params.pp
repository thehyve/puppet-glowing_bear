# Copyright 2017 The Hyve.
class glowing_bear::params(
    String[1] $user                             = hiera('glowing_bear::user', 'glowingbear'),
    Optional[String[2]] $user_home              = hiera('glowing_bear::user_home', undef),
    String[1] $version                          = hiera('glowing_bear::version', '0.0.1-SNAPSHOT'),
    String[1] $nexus_url                        = hiera('glowing_bear::nexus_url', 'https://repo.thehyve.nl'),
    Enum['snapshots', 'releases'] $repository   = hiera('glowing_bear::repository', 'snapshots'),

    String[1] $hostname                         = hiera('glowing_bear::hostname', undef),
    Numeric $port                               = hiera('glowing_bear::port', 80),
    Optional[String[1]] $app_url                = hiera('glowing_bear::app_url', undef),
    String[1] $transmart_url                    = hiera('glowing_bear::transmart_url', undef),

    Enum['dev', 'prod'] $env                    = hiera('glowing_bear::env', 'prod'),

    Optional[Boolean] $tree_node_counts_update                  = hiera('glowing_bear::tree_node_counts_update', undef),
    Optional[Boolean] $autosave_subject_sets                    = hiera('glowing_bear::autosave_subject_sets', undef),
    Optional[Enum['default', 'surveyTable']] $export_data_view  = hiera('glowing_bear::export_data_view', undef),
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

