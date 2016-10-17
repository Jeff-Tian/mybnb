require 'spec_helper'
require 'rest_spec_helper'
require 'rhc/commands/deployment'

describe RHC::Commands::Deployment do

  DEPLOYMENT_APP_NAME = 'mock_app_deploy'

  let!(:rest_client) { MockRestClient.new }

  before do
    user_config
    @rest_app = rest_client.add_domain("mock_domain").add_application(DEPLOYMENT_APP_NAME, 'ruby-1.8.7')
    @rest_app.stub(:ssh_url).and_return("ssh://user@test.domain.com")
    @targz_filename = File.dirname(__FILE__) + '/' + DEPLOYMENT_APP_NAME + '.tar.gz'
    FileUtils.cp(File.expand_path('../../assets/targz_sample.tar.gz', __FILE__), @targz_filename)
    File.chmod 0644, @targz_filename unless File.executable? @targz_filename
  end

  after do
    File.delete @targz_filename if File.exist? @targz_filename
  end

  describe "configure app" do
    context "manual deployment keeping a history of 10" do
      let(:arguments) {['app', 'configure', '--app', DEPLOYMENT_APP_NAME, '--no-auto-deploy', '--keep-deployments', '10']}
      it "should succeed" do
        expect{ run }.to exit_with_code(0)
        run_output.should match(/Configuring application '#{DEPLOYMENT_APP_NAME}' .../)
        run_output.should match(/done/)
        @rest_app.auto_deploy.should == false
        @rest_app.keep_deployments.should == 10
        run_output.should match(/Your application '#{DEPLOYMENT_APP_NAME}' is now configured as listed above/)
      end
    end

    context "with no configuration options" do
      let(:arguments) {['app', 'configure', '--app', DEPLOYMENT_APP_NAME]}
      it "should display the current configuration" do
        expect{ run }.to exit_with_code(0)
        run_output.should_not match(/Configuring application '#{DEPLOYMENT_APP_NAME}' .../)
        run_output.should_not match(/done/)
        run_output.should match(/Your application '#{DEPLOYMENT_APP_NAME}' is configured as listed above/)
      end
    end
  end

  describe "deploy" do
    context "git ref successfully" do
      before { Net::SSH.should_receive(:start).exactly(3).times.with('test.domain.com', 'user', :compression=>false) }
      let(:arguments) {['app', 'deploy', 'master', '--app', DEPLOYMENT_APP_NAME]}
      it "should succeed" do
        expect{ run }.to exit_with_code(0)
        run_output.should match(/Deployment of git ref 'master' in progress for application #{DEPLOYMENT_APP_NAME} .../)
        run_output.should match(/Success/)
      end
    end

    context "binary file successfully" do
      before do
        @rest_app.stub(:deployment_type).and_return('binary')
        ssh = double(Net::SSH)
        session = double(Net::SSH::Connection::Session)
        channel = double(Net::SSH::Connection::Channel)
        exit_status = double(Net::SSH::Buffer)
        exit_status.stub(:read_long).and_return(0)
        Net::SSH.should_receive(:start).exactly(3).times.with('test.domain.com', 'user', :compression=>false).and_yield(session)
        session.should_receive(:open_channel).exactly(3).times.and_yield(channel)
        channel.should_receive(:exec).exactly(3).times.with("oo-binary-deploy").and_yield(nil, nil)
        channel.should_receive(:on_data).exactly(3).times.and_yield(nil, 'foo')
        channel.should_receive(:on_extended_data).exactly(3).times.and_yield(nil, nil, '')
        channel.should_receive(:on_close).exactly(3).times.and_yield(nil)
        channel.should_receive(:on_request).exactly(3).times.with("exit-status").and_yield(nil, exit_status)
        lines = ''
        File.open(@targz_filename, 'rb') do |file|
          file.chunk(1024) do |chunk|
            lines << chunk
          end
        end
        channel.should_receive(:send_data).exactly(3).times.with(lines)
        channel.should_receive(:eof!).exactly(3).times
        session.should_receive(:loop).exactly(3).times
      end
      let(:arguments) {['app', 'deploy', @targz_filename, '--app', DEPLOYMENT_APP_NAME]}
      it "should succeed" do
        expect{ run }.to exit_with_code(0)
        run_output.should match(/Deployment of file '#{@targz_filename}' in progress for application #{DEPLOYMENT_APP_NAME} .../)
        run_output.should match(/Success/)
      end
    end

    [URI('http://foo.com/path/to/file/' + DEPLOYMENT_APP_NAME + '.tar.gz'),
     URI('https://foo.com/path/to/file/' + DEPLOYMENT_APP_NAME + '.tar.gz')].each do |uri|
      context "url file successfully" do
        before do
        @rest_app.stub(:deployment_type).and_return('binary')
          ssh = double(Net::SSH)
          session = double(Net::SSH::Connection::Session)
          channel = double(Net::SSH::Connection::Channel)
          exit_status = double(Net::SSH::Buffer)
          exit_status.stub(:read_long).and_return(0)
          Net::SSH.should_receive(:start).exactly(3).times.with('test.domain.com', 'user', :compression=>false).and_yield(session)
          session.should_receive(:open_channel).exactly(3).times.and_yield(channel)
          channel.should_receive(:exec).exactly(3).times.with("oo-binary-deploy").and_yield(nil, nil)
          channel.should_receive(:on_data).exactly(3).times.and_yield(nil, 'foo')
          channel.should_receive(:on_extended_data).exactly(3).times.and_yield(nil, nil, '')
          channel.should_receive(:on_close).exactly(3).times.and_yield(nil)
          channel.should_receive(:on_request).exactly(3).times.with("exit-status").and_yield(nil, exit_status)
          lines = ''
          File.open(@targz_filename, 'rb') do |file|
            file.chunk(1024) do |chunk|
              lines << chunk
            end
          end
          stub_request(:get, uri.to_s).to_return(:status => 200, :body => lines, :headers => {})
          channel.should_receive(:send_data).exactly(3).times.with(lines)
          channel.should_receive(:eof!).exactly(3).times
          session.should_receive(:loop).exactly(3).times
        end
        let(:arguments) {['app', 'deploy', uri.to_s, '--app', DEPLOYMENT_APP_NAME]}
        it "should succeed" do
          expect{ run }.to exit_with_code(0)
          run_output.should match(/Deployment of file '#{uri.to_s}' in progress for application #{DEPLOYMENT_APP_NAME} .../)
          run_output.should match(/Success/)
        end
      end
    end

    context "binary file with corrupted file" do
      before do
        @rest_app.stub(:deployment_type).and_return('binary')
        ssh = double(Net::SSH)
        session = double(Net::SSH::Connection::Session)
        channel = double(Net::SSH::Connection::Channel)
        exit_status = double(Net::SSH::Buffer)
        exit_status.stub(:read_long).and_return(255)
        Net::SSH.should_receive(:start).exactly(3).times.with('test.domain.com', 'user', :compression=>false).and_yield(session)
        session.should_receive(:open_channel).exactly(3).times.and_yield(channel)
        channel.should_receive(:exec).exactly(3).times.with("oo-binary-deploy").and_yield(nil, nil)
        channel.should_receive(:on_data).exactly(3).times.and_yield(nil, 'foo')
        channel.should_receive(:on_extended_data).exactly(3).times.and_yield(nil, nil, 'Invalid file')
        channel.should_receive(:on_close).exactly(3).times.and_yield(nil)
        channel.should_receive(:on_request).exactly(3).times.with("exit-status").and_yield(nil, exit_status)
        lines = ''
        File.open(@targz_filename, 'rb') do |file|
          file.chunk(1024) do |chunk|
            lines << chunk
          end
        end
        channel.should_receive(:send_data).exactly(3).times.with(lines)
        channel.should_receive(:eof!).exactly(3).times
        session.should_receive(:loop).exactly(3).times
      end
      let(:arguments) {['app', 'deploy', @targz_filename, '--app', DEPLOYMENT_APP_NAME]}
      it "should not succeed" do
        expect{ run }.to exit_with_code(133)
        run_output.should match(/Deployment of file '#{@targz_filename}' in progress for application #{DEPLOYMENT_APP_NAME} .../)
        run_output.should match(/Invalid file/)
      end
    end

    context "fails when deploying git ref" do
      before (:each) { Net::SSH.should_receive(:start).and_raise(Errno::ECONNREFUSED) }
      let(:arguments) {['app', 'deploy', 'master', '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(1)
      end
    end

    context "fails when deploying binary file" do
      before (:each) do
        @rest_app.stub(:deployment_type).and_return('binary')
        Net::SSH.should_receive(:start).and_raise(Errno::ECONNREFUSED)
      end
      let(:arguments) {['app', 'deploy', @targz_filename, '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(1)
      end
    end

    context "fails when deploying binary file" do
      before (:each) do
        @rest_app.stub(:deployment_type).and_return('binary')
        Net::SSH.should_receive(:start).and_raise(SocketError)
      end
      let(:arguments) {['app', 'deploy', @targz_filename, '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(1)
      end
    end

    context "fails when deploying url file" do
      before (:each) do
        @rest_app.stub(:deployment_type).and_return('binary')
        Net::SSH.should_receive(:start).and_raise(Errno::ECONNREFUSED)
      end
      let(:arguments) {['app', 'deploy', 'http://foo.com/deploy.tar.gz', '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(1)
      end
    end

    context "fails when deploying url file" do
      before (:each) do
        @rest_app.stub(:deployment_type).and_return('binary')
        Net::SSH.should_receive(:start).and_raise(SocketError)
      end
      let(:arguments) {['app', 'deploy', 'http://foo.com/deploy.tar.gz', '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(1)
      end
    end

    context 'when run against an unsupported server' do
      before {
        @rest_app.links.delete 'UPDATE'
        @rest_app.links.delete 'DEPLOY'
      }
      let(:arguments) {['app', 'deploy', 'master', '--app', DEPLOYMENT_APP_NAME]}
      it "should raise not supported exception" do
        expect{ run }.to exit_with_code(132)
        run_output.should match(/The server does not support deployments/)
      end
    end

    context "ssh authentication failure" do
      before (:each) { Net::SSH.should_receive(:start).exactly(2).times.and_raise(Net::SSH::AuthenticationFailed) }
      let(:arguments) {['app', 'deploy', 'master', '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(1)
        run_output.should match(/Authentication to server test.domain.com with user user failed/)
      end
    end

    context "fails when deploying git reference on an app configured to deployment_type = binary" do
      before { @rest_app.stub(:deployment_type).and_return('binary') }
      let(:arguments) {['app', 'deploy', 'master', '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(133)
      end
    end

    context "fails when deploying file on an app configured to deployment_type = git" do
      before { @rest_app.stub(:deployment_type).and_return('git') }
      let(:arguments) {['app', 'deploy', @targz_filename, '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(133)
      end
    end

    [URI('http://foo.com/path/to/file/' + DEPLOYMENT_APP_NAME + '.tar.gz'),
     URI('https://foo.com/path/to/file/' + DEPLOYMENT_APP_NAME + '.tar.gz')].each do |uri|
      context "fails when deploying url on an app configured to deployment_type = git" do
        before { @rest_app.stub(:deployment_type).and_return('git') }
        let(:arguments) {['app', 'deploy', uri.to_s, '--app', DEPLOYMENT_APP_NAME]}
        it "should exit with error" do
          expect{ run }.to exit_with_code(133)
        end
      end
    end
  end

  describe "activate deployment" do
    context "activates 123456" do
      before { Net::SSH.should_receive(:start).exactly(3).times.with('test.domain.com', 'user', :compression => false) }
      let(:arguments) {['deployment', 'activate', '123456', '--app', DEPLOYMENT_APP_NAME]}
      it "should succeed" do
        expect{ run }.to exit_with_code(0)
        run_output.should match(/Activating deployment '123456' on application #{DEPLOYMENT_APP_NAME} .../)
        run_output.should match(/Success/)
      end
    end

    context "fails with ssh error" do
      before (:each) { Net::SSH.should_receive(:start).and_raise(Errno::ECONNREFUSED) }
      let(:arguments) {['deployment', 'activate', '123456', '--app', DEPLOYMENT_APP_NAME]}
      it "should exit with error" do
        expect{ run }.to exit_with_code(1)
      end
    end
  end

  describe "list deployments" do
    context "simple" do
      let(:arguments) {['deployment', 'list', DEPLOYMENT_APP_NAME]}
      it "should succeed" do
        expect{ run }.to exit_with_code(0)
        run_output.should match(/Jan 01\, 2000  1\:00 AM\, deployment 0000001/)
        run_output.should match(/Jan 01\, 2000  2\:00 AM\, deployment 0000002/)
        run_output.should match(/Jan 01\, 2000  3\:00 AM\, deployment 0000003 \(rolled back\)/)
        run_output.should match(/Jan 01\, 2000  4\:00 AM\, deployment 0000004 \(rolled back\)/)
        run_output.should match(/Jan 01\, 2000  5\:00 AM\, deployment 0000003 \(rollback to Jan 01\, 2000  3\:00 AM\, rolled back\)/)
        run_output.should match(/Jan 01\, 2000  5\:00 AM\, deployment 0000005 \(rolled back\)/)
        run_output.should match(/Jan 01\, 2000  6\:00 AM\, deployment 0000002 \(rollback to Jan 01\, 2000  2\:00 AM\)/)
      end
    end
  end

  describe "show deployment" do
    context "simple" do
      let(:arguments) {['deployment', 'show', '0000001', '--app', DEPLOYMENT_APP_NAME]}
      it "should succeed" do
        expect{ run }.to exit_with_code(0)
        run_output.should match(/Deployment ID 0000001/)
      end
    end

    context "fails when deployment is not found" do
      let(:arguments) {['deployment', 'show', 'zee', '--app', DEPLOYMENT_APP_NAME]}
      it "should succeed" do
        expect{ run }.to exit_with_code(131)
        run_output.should match(/Deployment ID 'zee' not found for application #{DEPLOYMENT_APP_NAME}/)
      end
    end
  end

  describe "show configuration" do
    context "simple" do
      let(:arguments) {['app', 'show', '--app', DEPLOYMENT_APP_NAME, '--configuration']}
      it "should succeed" do
        expect{ run }.to exit_with_code(0)
        #run_output.should match(/Deployment ID 1/)
      end
    end
  end

end