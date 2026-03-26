class OcrsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  
  def create
    image = params[:image]

    return render json: { error: "画像がありません" }, status: :bad_request if image.nil?

    expiration = OcrService.extract_expiration(image.tempfile.path)

    render json: {
      expiration: expiration&.strftime("%Y-%m-%d")
    }
  end
end