require "pg"
require "json"

Rails.application.config.after_initialize do
  Thread.new do
    begin
      # usa uma conexão separada para LISTEN/NOTIFY
      pg_conf = ActiveRecord::Base.connection_db_config.configuration_hash.dup
      # PG.connect aceita keys como host, port, user, password, dbname
      pg_opts = {
        host:     pg_conf[:host],
        port:     pg_conf[:port],
        user:     pg_conf[:username],
        password: pg_conf[:password],
        dbname:   pg_conf[:database]
      }.compact

      conn = PG.connect(pg_opts)
      conn.exec("LISTEN transaction_updates")
      Rails.logger.info "[pg_notify_listener] listening on transaction_updates"

      loop do
        conn.wait_for_notify(10) do |channel, pid, payload|
          begin
            data = JSON.parse(payload) rescue nil
            next unless data && data["id"]

            id = data["id"]
            transaction = Transaction.find_by(id: id)
            next unless transaction

            Turbo::StreamsChannel.broadcast_replace_to(
              "transaction_#{id}",
              target: "transaction_amount_#{id}",
              partial: "transactions/amount",
              locals: { transaction: transaction }
            )
          rescue => e
            Rails.logger.error "[pg_notify_listener] error handling notification: #{e.class} #{e.message}"
          end
        end
      end
    rescue => e
      Rails.logger.error "[pg_notify_listener] listener crashed: #{e.class} #{e.message}"
      sleep 5
      retry
    end
  end
end
