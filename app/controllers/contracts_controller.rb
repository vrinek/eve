class ContractsController < ApplicationController
  def save
    @contract = Contract.new_from(params[:contract_json])
    unless @contract.save
      @contract = nil
    end
  rescue
    @contract = nil
  end
end
