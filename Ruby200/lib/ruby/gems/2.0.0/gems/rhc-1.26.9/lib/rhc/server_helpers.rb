require 'rhc/servers'

module RHC
  module ServerHelpers
    def openshift_server
      to_host(openshift_raw_server)
    end

    def openshift_online_server?
      openshift_server =~ openshift_online_server_regex
    end

    def openshift_online_server
      'openshift.redhat.com'
    end

    def openshift_online_server_regex
      /^#{openshift_online_server.gsub(/\./, '\.')}$/i
    end

    def openshift_url
      "https://#{openshift_server}"
    end

    def openshift_rest_endpoint
      uri = to_uri(openshift_raw_server)
      uri.path = '/broker/rest/api' if uri.path.blank? || uri.path == '/'
      uri
    end

    def libra_server_env
      ENV['LIBRA_SERVER']
    end

    def rhc_server_env
      ENV['RHC_SERVER']
    end

    protected
      def openshift_raw_server
        server = (options.server rescue nil) || ENV['LIBRA_SERVER'] || (config['libra_server'] rescue nil) || openshift_online_server
        @servers ||= RHC::Servers.new
        (@servers.find(server).hostname rescue nil) || server
      end
  end
end
