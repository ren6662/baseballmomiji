class User::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    if message.save
      redirect_to user_room_path(message.room)
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = "メッセージの送信に失敗しました。"
    end
  end

  private

    def message_params
      params.require(:message).permit(:room_id, :body)
    end
end
