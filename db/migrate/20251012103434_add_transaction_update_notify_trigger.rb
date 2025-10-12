class AddTransactionUpdateNotifyTrigger < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION notify_transaction_update() RETURNS trigger AS $$
      DECLARE
        payload json;
      BEGIN
        payload = json_build_object('id', NEW.id, 'amount_cents', NEW.amount_cents);
        PERFORM pg_notify('transaction_updates', payload::text);
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      DROP TRIGGER IF EXISTS trigger_notify_transaction_update ON transactions;
      CREATE TRIGGER trigger_notify_transaction_update
        AFTER UPDATE ON transactions
        FOR EACH ROW
        WHEN (OLD.* IS DISTINCT FROM NEW.*)
        EXECUTE FUNCTION notify_transaction_update();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS trigger_notify_transaction_update ON transactions;
      DROP FUNCTION IF EXISTS notify_transaction_update();
    SQL
  end
end
