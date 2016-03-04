require 'spec_helper'

describe port(8000) do
  it { should be_listening }
end

describe command('curl -i -s -H \'Accept: text/html\' http://0.0.0.0:8000/') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to contain 'HTTP/1.1 200 OK' }
  its(:stdout) { is_expected.to contain '<h1>Listing Todos</h1>' }
end

1.upto(2) do|n|
  describe command("curl -i -s -H \'Accept: text/html\' http://0.0.0.0:8000/todos -d \'title=Test#{n}\'") do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to contain 'HTTP/1.1 302 FOUND' }
    its(:stdout) { is_expected.to contain 'Location: /todos' }
  end
end

describe command('curl -i -s -H \'Accept: text/html\' http://0.0.0.0:8000/todos') do
  its(:exit_status) { is_expected.to eq 0 }
  its(:stdout) { is_expected.to contain 'HTTP/1.1 200 OK' }
  its(:stdout) { is_expected.to contain '<h1>Listing Todos</h1>' }
  its(:stdout) { is_expected.to contain '<td>Test1</td>' }
  its(:stdout) { is_expected.to contain '<td>Test2</td>' }
  its(:stdout) { is_expected.to contain '<td><a href="/todos/0">Show</a></td>' }
  its(:stdout) { is_expected.to contain '<td><a href="/todos/1">Show</a></td>' }
end
