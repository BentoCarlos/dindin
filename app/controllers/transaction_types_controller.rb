class TransactionTypesController < ApplicationController
  def index
  end

  def new
    @transaction_type = TransactionType.new
  end

  def create
    @transaction_type = TransactionType.find_or_initialize_by(name: type_params[:name])

    if @transaction_type.persisted?
      @transaction_type = TransactionType.new
      @transaction_type.errors.add(type_params[:name], "já existe")
      render :new, status: :unprocessable_entity
    elsif @transaction_type.save
      redirect_to transactions_path, notice: "Categoria criada com sucesso"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def type_params
      params.require(:transaction_type).permit(:name)
    end
end
