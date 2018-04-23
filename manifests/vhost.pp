# Copyright 2017 The Hyve.
class glowing_bear::vhost inherits glowing_bear::params {
    include ::glowing_bear

    class { 'apache': }

    apache::vhost { $hostname:
        port          => $port,
        docroot       => $app_root,
        docroot_owner => $user,
        docroot_group => $user,
        rewrites      =>  [
          {
            comment      =>  'If an existing asset or directory is requested go to it as it is',
            rewrite_cond =>  [
              '%{DOCUMENT_ROOT}%{REQUEST_URI} -f [OR]',
              '%{DOCUMENT_ROOT}%{REQUEST_URI} -d',
            ],
            rewrite_rule =>  ['^ - [L]'],
          },
          {
            comment      =>  'If the requested resource doesn\'t exist, use index.html',
            rewrite_rule =>  ['^ /index.html'],
          }
        ],
        require       => Archive::Nexus[$::glowing_bear::params::app_archive],
    }

}

