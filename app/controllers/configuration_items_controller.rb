class ConfigurationItemsController < ApplicationController
  unloadable

  model_object ConfigurationItem
  before_filter :require_admin
  before_filter :find_model_object, :only => [:show, :update, :destroy]

  accept_api_auth :index, :show, :create, :update, :destroy

  def index
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : nil
    @configuration_items = ConfigurationItem.search(params[:search])
                                            .with_status(params[:status])
                                            .notin(params[:not])
                                            .limit(limit)
    respond_to do |format|
      format.api
    end
  end

  def show
    respond_to do |format|
      format.api
    end
  end

  def create
    @configuration_item = ConfigurationItem.new(params[:configuration_item])
    if @configuration_item.save
      respond_to do |format|
        format.api { render :action => 'show', :status => :created, :location => configuration_item_url(@configuration_item) }
      end
    else
      respond_to do |format|
        format.api  { render_validation_errors(@configuration_item) }
      end
    end
  end

  def update
    if @configuration_item.update_attributes(params[:configuration_item])
      respond_to do |format|
        format.api  { head :ok }
      end
    else
      respond_to do |format|
        format.api  { render_validation_errors(@configuration_item) }
      end
    end
  end

  def destroy
    @configuration_item.destroy(params[:strategy])
    respond_to do |format|
      format.api { head :ok }
    end
  end
end
