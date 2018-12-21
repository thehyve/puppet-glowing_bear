# Copyright 2017 The Hyve.
class glowing_bear::config inherits glowing_bear::params {
    include ::glowing_bear

    $app_root = $::glowing_bear::params::app_root
    $env_location = $::glowing_bear::params::env_location
    $default_config_location = $::glowing_bear::params::default_config_location
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

    # Set properties to be overridden
    $custom_properties = {
        'api-url'                     => $::glowing_bear::params::transmart_url,
        'app-url'                     => $::glowing_bear::params::application_url,
        'show-observation-counts'     => $::glowing_bear::params::show_observation_counts,
        'include-data-table'          => $::glowing_bear::params::include_data_table,
        'include-query-subscription'  => $::glowing_bear::params::include_query_subscription,
        'authentication-service-type' => $::glowing_bear::params::authentication_service_type,
        'enable-fractalis-analysis'   => $::glowing_bear::params::enable_fractalis_analysis,
        'fractalis-url'               => $::glowing_bear::params::fractalis_url,
        'fractalis-datasource-url'    => $::glowing_bear::params::fractalis_datasource_url,
        'export-mode'                 => {
            'name'                    => $::glowing_bear::params::export_name,
            'data-view'               => $::glowing_bear::params::export_data_view,
        } + ($::glowing_bear::params::export_url ? {
            undef => {},
            default => {
                'export-url' => $::glowing_bear::params::export_url
            }
        })
    } + ($::glowing_bear::params::authentication_service_type ? {
        'oidc' => {
            'oidc-server-url' => $::glowing_bear::params::oidc_server_url,
            'oidc-client-id'  => $::glowing_bear::params::oidc_client_id,
        },
        default => {}
    }) + ($::glowing_bear::params::tree_node_counts_update ? {
        undef     => {},
        default => {
            'tree-node-counts-update' => $::glowing_bear::params::tree_node_counts_update,
        }
    }) + ($::glowing_bear::params::autosave_subject_sets ? {
        undef     => {},
        default => {
            'autosave-subject-sets' => $::glowing_bear::params::autosave_subject_sets,
        }
    })

    # Merge default configuration with custom properties
    glowing_bear_config { $config_location:
        default_path      => $default_config_location,
        custom_properties => $custom_properties,
        require           => Archive::Nexus[$::glowing_bear::params::app_archive],
    }

}

