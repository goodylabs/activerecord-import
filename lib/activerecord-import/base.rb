require "pathname"
require "active_record"
require "active_record/version"

module ActiveRecord::Import
  ADAPTER_PATH = "activerecord-import/active_record/adapters".freeze

  def self.base_adapter(adapter)
    case adapter
    when 'mysql2_makara' then 'mysql2'
    when 'mysql2spatial' then 'mysql2'
    when 'spatialite' then 'sqlite3'
    when 'postgresql_makara' then 'postgresql'
    when 'postgis' then 'postgresql'
    when 'sqlserver' then ''
    when 'oracle' then ''
    else adapter
    end
  end

  # Loads the import functionality for a specific database adapter
  def self.require_adapter(adapter)
    base_adapter = base_adapter(adapter)
    unless base_adapter.blank?
      require File.join(AdapterPath,"/abstract_adapter")
    begin
      require File.join(ADAPTER_PATH, "/#{base_adapter(adapter)}_adapter")
    rescue LoadError
      # fallback
    end
  end

  # Loads the import functionality for the passed in ActiveRecord connection
  def self.load_from_connection_pool(connection_pool)
    require_adapter connection_pool.spec.config[:adapter]
  end
end

require 'activerecord-import/import'
require 'activerecord-import/active_record/adapters/abstract_adapter'
require 'activerecord-import/synchronize'
require 'activerecord-import/value_sets_parser'
