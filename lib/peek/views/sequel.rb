require 'concurrent/atomic/thread_local_var'

module Sequel
  class Database
    class << self
      attr_accessor :query_time, :query_count
    end
    self.query_time = Concurrent::ThreadLocalVar.new(0)
    self.query_count = Concurrent::ThreadLocalVar.new(0)

    def log_connection_yield(sql, conn, args=nil)
      unless @loggers.empty?
        sql = "#{connection_info(conn) if conn && log_connection_info}#{sql}#{"; #{args.inspect}" if args}"
      end
      start = Time.now
      begin
        yield
      rescue => e
        log_exception(e, sql)
        raise
      ensure
        log_duration(Time.now - start, sql) unless e
      end
    end

    alias_method :original_log_duration, :log_duration

    def log_duration(duration, message)
      Sequel::Database.query_time.value = Sequel::Database.query_time.value + duration
      Sequel::Database.query_count.value = Sequel::Database.query_count.value + 1
      original_log_duration duration, message
    end
  end
end

module Peek
  module Views
    class Sequel < View
      def duration
        ::Sequel::Database.query_time.value
      end

      def formatted_duration
        ms = duration * 1000
        if ms >= 1000
          "%.2fms" % ms
        else
          "%.0fms" % ms
        end
      end

      def query_count
        ::Sequel::Database.query_count.value
      end

      def results
        {
          duration: formatted_duration,
          calls: query_count
        }
      end

      private

        def setup_subscribers
          # Reset counters
          before_request do
            ::Sequel::Database.query_time.value = 0
            ::Sequel::Database.query_count.value = 0
          end
        end
    end
  end
end
