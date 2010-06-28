class ContractsController < ApplicationController
  def save
    @contract = Contract.new_from(params[:contract_json])
    @contract.save
  end
end
