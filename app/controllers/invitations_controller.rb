class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def show
    unless @invitation = Invitation.pending.find_by(token: params[:id])
      flash[:error] = "The invitation was not found."
      redirect_to leagues_path
    end
  end

  def accept
    op = Invitation::Accept.new(token: params[:token], user: current_user)
    op.call
    if op.succeeded?
      flash[:notice] = "You have joined #{op.output.league.name}."
      redirect_to league_path(op.output.league)
    else
      flash[:error] = "The invitation was not found."
      redirect_to leagues_path
    end
  rescue StandardError => e
    Rails.logger.error("InvitationsController#accept #{e.inspect}")
    flash[:error] = "There was a problem accepting the invitation."
    redirect_to leagues_path
  end

  def decline
    op = Invitation::Decline.new(token: params[:token], user: current_user)
    op.call
    if op.succeeded?
      flash[:notice] = "You have declined to join #{op.output.league.name}."
      redirect_to leagues_path
    else
      flash[:error] = "The invitation was not found."
      redirect_to leagues_path
    end
  rescue StandardError => e
    Rails.logger.error("InvitationsController#decline #{e.inspect}")
    flash[:error] = "There was a problem declining the invitation."
    redirect_to leagues_path
  end
end
