# Copyright 2017 The Hyve.
class glowing_bear::params(
    String[1] $hostname                         = lookup('glowing_bear::hostname', String),
    String[1] $transmart_url                    = lookup('glowing_bear::transmart_url', String),
    Optional[String[1]] $gb_backend_url                   = lookup('glowing_bear::gb_backend_url', Optional[String[1]], first, undef),

    String[1] $user                             = lookup('glowing_bear::user', String, first, 'glowingbear'),
    Optional[String[2]] $user_home              = lookup('glowing_bear::user_home', Optional[String[2]], first, undef),
    String[1] $version                          = lookup('glowing_bear::version', String, first, '0.0.1-SNAPSHOT'),
    String[1] $nexus_url                        = lookup('glowing_bear::nexus_url', String, first, 'https://repo.thehyve.nl'),
    Enum['snapshots', 'releases'] $repository   = lookup('glowing_bear::repository', Enum['snapshots','releases'], first, 'snapshots'),

    Integer[1,65535] $port                      = lookup('glowing_bear::port', Integer[1,65535], first, 80),
    Optional[String[1]] $app_url                = lookup('glowing_bear::app_url', Optional[String], first, undef),

    Enum['default', 'dev', 'transmart'] $env    = lookup('glowing_bear::env', Enum['default', 'dev', 'transmart'], first, 'dev'),

    Optional[Boolean] $tree_node_counts_update                  = lookup('glowing_bear::tree_node_counts_update', Optional[Boolean], first, undef),
    Optional[Boolean] $autosave_subject_sets                    = lookup('glowing_bear::autosave_subject_sets', Optional[Boolean], first, undef),

    Boolean $show_observation_counts            = lookup('glowing_bear::show_observation_counts', Boolean, first, true),
    Boolean $include_data_table                 = lookup('glowing_bear::include_data_table', Boolean, first, true),
    Boolean $include_cohort_subscription         = lookup('glowing_bear::include_cohort_subscription', Boolean, first, false),

    Enum['transmart', 'oidc'] $authentication_service_type = lookup('glowing_bear::authentication_service_type', Enum['transmart', 'oidc'], first, 'transmart'),
    Optional[String] $oidc_server_url           = lookup('glowing_bear::oidc_server_url', Optional[String], first, undef),
    String[1] $oidc_client_id                   = lookup('glowing_bear::oidc_client_id', String, first, 'glowingbear-js'),
    String[1] $export_name                      = lookup('glowing_bear::export_name', String, first, 'transmart'),
    String[1] $export_data_view                 = lookup('glowing_bear::export_data_view', String, first, 'dataTable'),
    Optional[String[1]] $export_url             = lookup('glowing_bear::export_url', Optional[String], first, undef),
    Boolean $enable_fractalis_analysis          = lookup('glowing_bear::enable_fractalis_analysis', Boolean, first, false),
    Optional[String[1]] $fractalis_url          = lookup('glowing_bear::fractalis_url', Optional[String], first, undef),
    Optional[String[1]] $fractalis_datasource_url               = lookup('glowing_bear::fractalis_datasource_url', Optional[String], first, $transmart_url),
) {

    if $app_url != undef {
        $application_url = $app_url
    } else {
        notify { "Warning: Glowing Bear on ${hostname} is configured without SSL!": }
        $application_url = "http://${hostname}"
    }

    if $authentication_service_type == 'oidc' {
        # Check authentication settings
        if $oidc_server_url == undef {
            fail('No OpenID Connect server configured. Please configure glowing_bear::oidc_server_url')
        }
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
    $default_config_location = "${app_root}/app/config/config.default.json"
    $config_location = "${app_root}/app/config/config.${env}.json"

    if $export_name == 'packer' {
        if $export_url == undef {
            fail('export_name set to packer, but no url specified. Please configure glowing_bear::export_url')
        }
    }

    if $enable_fractalis_analysis {
        if $fractalis_url  == undef {
            fail('fractalis analysis is enabled, but no url specified. Please configure glowing_bear::fractalis_url')
        }
    }
}
