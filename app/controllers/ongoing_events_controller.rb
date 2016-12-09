require "ongoing_event/user_operation"
class OngoingEventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @operation =
      OngoingEventOperation::User::Index.present()
    @events = @operation.model.page(params[:page])
  end

  def show
    @event = OngoingEventOperation::User::Show.present(event_id: params[:id]).model
  end

  def opt_in
    @event = OngoingEventOperation::User::OptIn
      .(current_user: current_user, event_id: params[:id])
      .model
  end

  def opt_out
    @event = OngoingEventOperation::User::OptOut
      .(current_user: current_user, event_id: params[:id])
      .model
    redirect_to ongoing_event_path(@event)
  end
end

