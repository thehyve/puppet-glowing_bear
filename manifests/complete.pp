# Copyright 2017 The Hyve.
class glowing_bear::complete inherits glowing_bear::params {
    include ::glowing_bear
    include ::glowing_bear::assets
    include ::glowing_bear::config
    include ::glowing_bear::vhost
}

