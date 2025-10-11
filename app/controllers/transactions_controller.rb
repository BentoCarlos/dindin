class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update ]
  def index
    @transactions = Transaction.all
  end

  def show
  end

  def edit
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction
    else
        render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:amount)
    end
end
