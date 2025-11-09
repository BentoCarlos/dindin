class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update ]
  before_action :load_collections, only: %i[new create edit update]

  def index
    @transactions = Transaction.includes(:payment_type, :installments).all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      total_portions = params[:transaction][:total_portions].to_i
      payment_date = params[:transaction][:payment_date].to_date

      if payment_date.nil?
        payment_date = Date.today
      end

      if total_portions >= 1
        total_portions.times do |i|
          @transaction.installments.create!(portion: i + 1, total_portions: total_portions, payment_date: payment_date)

          payment_date += 1.months
        end
      end
      redirect_to @transaction
    else
      # load_collections is run by before_action, so @transaction_types and @payment_types are available
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      # Atualiza parcelas se necessário
      if params[:transaction][:total_portions].present?
        @transaction.update_installments(params[:transaction][:total_portions])
      end
      redirect_to @transaction
    else
      # load_collections is run by before_action for edit/update
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:amount, :name, :transaction_type_id, :payment_type_id)
    end

    def load_collections
      @transaction_types = TransactionType.all
      @payment_types = PaymentType.all
    end
end
