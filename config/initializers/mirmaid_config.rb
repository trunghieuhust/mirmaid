
module Mirmaid
  class Config

    attr :mirbase_data_dir
    attr :mirbase_version
    attr :mirbase_local_data
    attr :mirbase_remote_data
    attr :web_relative_url_root
    attr :ferret_enabled, true
    attr :ferret_models, true
    attr :google_analytics_tracker
    attr :log_level
    
    def initialize
      setup = YAML.load_file(RAILS_ROOT + "/config/mirmaid_config.yml") || raise("Missing config/mirmaid_config.yml file")
      
      # mirmaid
      @log_level = setup['mirmaid']['log_level'] || "error"
      ActiveRecord::Base.logger.level = ActiveSupport::BufferedLogger.const_get(@log_level.upcase)
            
      # mirbase
      @mirbase_version = setup['mirbase']['version'] || "CURRENT"
      @mirbase_data_dir = RAILS_ROOT + "/tmp/mirbase_data/"
      @mirbase_local_data = setup['mirbase']['local_data']
      @mirbase_remote_data = setup['mirbase']['remote_data']
      
      # web
      @ferret_enabled = setup['web']['ferret']
      @ferret_models = [Species,Mature,Precursor]
      # as of passenger 2.2.3, there is no need to set
      # relative_url_root anymore: http://code.google.com/p/phusion-passenger/issues/detail?id=169
      @web_relative_url_root = setup['web']['relative_url_root']
      @google_analytics_tracker = setup['web']['google_analytics']
      if @google_analytics_tracker
        Rubaidh::GoogleAnalytics.tracker_id = @google_analytics_tracker
      else
        Rubaidh::GoogleAnalytics.tracker_id = "disabled"
        Rubaidh::GoogleAnalytics.formats = [] # disable
      end

      # described routes
      require 'described_routes/rails_controller'
      hide_routes = [/^ferret_search\S*$/,/^pubmed_papers$/,/^home$/,/^root$/,/^search$/]
      DescribedRoutes::RailsRoutes.parsed_hook = lambda {|a| a.reject{|h| hide_routes.any?{|x| h["name"] =~ x}}}

    end
  end
end

MIRMAID_CONFIG = Mirmaid::Config.new()

#overload ferret_enabled?
#class ActiveRecord::Base
#  def self.ferret_enabled?
#    MIRMAID_CONFIG.ferret_enabled
#  end
#end
