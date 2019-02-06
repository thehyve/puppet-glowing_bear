# Class: glowing_bear
# ===========================
#
# Full description of class glowing_bear here.
#
# Parameters
# ----------
#
# * `user`
# The system user to be created that runs the application (default: glowingbear).
#
# * `user_home`
# The home directory where the application files are stored (default: /home/${user}).
#
# * `version`
# Version of the Glowing Bear artefacts in Nexus (default: 0.0.1-SNAPSHOT).
#
# * `nexus_url`
# The url of the repository to fetch the artefacts from
# (default: https://repo.thehyve.nl).
#
# * `hostname`
# The hostname of the machine on which the application is hosted.
#
# * `app_url`
# The URL at which the Glowing Bear application is reachable.
#
# * `transmart_url`
# The URL of the TranSMART server Glowing Bear should connect to.
#
# * `gb_backend_url`
# The URL of the Glowing Bear backend.
#
# Examples
# --------
#
# @example
#    class { '::glowing_bear::params':
#        hostname       => 'glowingbear.example.com',
#        transmart_url  => 'https://transmart.example.com',
#        gb_backend_url => 'https://gb_backend.example.com',
#    }
#
#    include ::glowing_bear
#
# Authors
# -------
#
# Gijs Kant <gijs@thehyve.nl>
#
# Copyright
# ---------
#
# Copyright 2017  The Hyve B.V.
#
class glowing_bear inherits glowing_bear::params {

    $user = $::glowing_bear::params::user
    $home = $::glowing_bear::params::gbuser_home

    # Create glowingbear user.
    user { $user:
        ensure     => present,
        home       => $home,
        managehome => true,
    }
    # Make home only accessible for the user
    -> file { $home:
        ensure => directory,
        mode   => '0711',
        owner  => $user,
    }

}
