require 'spec_helper'

describe port(8000) do
  it { should be_listening }
end

describe command('curl -s -H \'Accept: text/html\' http://0.0.0.0:8000/') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to contain '<h1>Listing Todos</h1>' }
end
