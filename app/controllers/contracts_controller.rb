class ContractsController < ApplicationController
  def show
    @title = "Contract Calculator"
    @description = "A simple summarization calculator to help with creating contracts of multiple items in teh EVE Online MMORPG"
    @icon = "17_02"
    
    unless params[:key].blank?
      @contract = Contract.find_by_key(params[:key])
    end
  end
  
  def create
    @contract = Contract.new_from(params[:contract_json])
    unless @contract.save
      @contract = nil
    end
  rescue
    @contract = nil
  end
end
