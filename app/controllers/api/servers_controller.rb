class Api::ServersController < ApplicationController

  before_action :require_logged_in!

  def index
    @servers = current_user.membered_servers + current_user.owned_servers # NEED to be membered servers of current user
    render :index
  end

  def show
    @server = Server.find_by(id: params[:id]) # NEED to be from @servers
    render :show
  end

  def create
    @server = Server.new(server_params)
    if @server.save
      render :show
    else
      render json: @server.errors.full_messages, status: 422
    end
  end

  def update
    @server = current_user.owned_servers.find_by(id: params[:id])
    if @server
      if @server.update(server_params)
        render :show
      else
        render json: @server.errors.full_messages, status: 422
      end
    else
      render json: ['Must be Server Owner to make changes'], status: 401
    end
  end

  def destroy
    @server = current_user.owned_servers.find_by(id: params[:id])
    if @server
      @server.destroy
      render :show
    else
      render json: ['Must be Server Owner to make changes'], status: 401
    end
  end

  private
  
  def server_params
    params.require(:server).permit(:server_name, :host_id)
  end
end
