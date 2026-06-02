class OcrsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user

  def create
    image = params[:image]

    return render json: { error: "画像がありません" }, status: :bad_request if image.nil?

    expiration = OcrService.extract_expiration(image.tempfile.path)

    render json: {
      expiration: expiration&.strftime("%Y-%m-%d")
    }
  end
end