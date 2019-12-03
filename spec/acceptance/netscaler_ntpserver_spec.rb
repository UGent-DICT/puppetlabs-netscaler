require 'spec_helper_acceptance'

describe 'ntpserver tests' do
  it 'makes an ntpserver' do
    pp = <<-EOS
      netscaler_ntpserver { 'test1':
        ensure                => present,
        minimum_poll_interval => '5',
        maximum_poll_interval => '10',
        auto_key              => true,
        preferred_ntp_server  => 'yes',
      }
    EOS
    make_site_pp(pp)
    run_device(allow_changes: true)
    run_device(allow_changes: false)
  end

  it 'makes and edits an ntpserver' do
    pp = <<-EOS
      netscaler_ntpserver { 'test2':
        ensure                => present,
        minimum_poll_interval => '5',
        maximum_poll_interval => '10',
        key                   => '55',
      }
    EOS

    pp2 = <<-EOS
      netscaler_ntpserver { 'test2':
        ensure                => present,
        minimum_poll_interval => '6',
        maximum_poll_interval => '11',
        key                   => '56',
      }
    EOS

    make_site_pp(pp)
    run_device(allow_changes: true)
    make_site_pp(pp2)
    run_device(allow_changes: true)
    run_device(allow_changes: false)
  end

  it 'makes and deletes an ntpserver' do
    pp = <<-EOS
      netscaler_ntpserver { 'test3':
        ensure                => present,
        minimum_poll_interval => '6',
        maximum_poll_interval => '10',
        auto_key              => true,
      }
    EOS

    pp2 = <<-EOS
      netscaler_ntpserver { 'test3':
        ensure  => absent,
      }
    EOS

    make_site_pp(pp)
    run_device(allow_changes: true)
    make_site_pp(pp2)
    run_device(allow_changes: true)
    run_device(allow_changes: false)
  end
end
