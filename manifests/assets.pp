# Copyright 2017 The Hyve.
class glowing_bear::assets inherits glowing_bear::params {
    include ::glowing_bear
    include ::archive

    $user = $::glowing_bear::params::user
    $home = $::glowing_bear::params::gbuser_home
    $version = $::glowing_bear::params::version
    $app_archive = $::glowing_bear::params::app_archive
    $app_root = $::glowing_bear::params::app_root

    # Download and untar glowing-bear
    archive::nexus { $app_archive:
        user         => $user,
        group        => $user,
        url          => $::glowing_bear::params::nexus_url,
        gav          => "nl.thehyve:glowing-bear:${::glowing_bear::params::version}",
        repository   => $::glowing_bear::params::repository,
        packaging    => 'tar',
        extract      => true,
        extract_path => $home,
        require      => File[$home],
        notify       => [
            File[$::glowing_bear::params::env_location],
            Glowing_Bear_Config[$::glowing_bear::params::config_location],
        ],
    }

    if $::glowing_bear::params::run_cypress_tests {
	    archive::nexus { $cypress_tests_archive:
		user         => $user,
		group        => $user,
		url          => $::glowing_bear::params::nexus_url,
		gav          => "nl.thehyve:glowing-bear-cypress-tests:${::glowing_bear::params::version}",
		repository   => $::glowing_bear::params::repository,
		packaging    => 'zip',
		extract      => true,
		extract_path => $home,
		require      => File[$home],
		subscribe    => archive::nexus[$app_archive],
		#notify       => [
		#	1. generate cypress file
		#	2. run cypress tests
		#	3. in case of failure notify developers
		#],
	    }
    }


}

