# @summary Installs the faraday gem
class netscaler {
  package { 'faraday':
    ensure   => present,
    provider => 'puppet_gem',
  }
}
