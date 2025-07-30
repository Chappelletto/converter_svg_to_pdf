class Api::ConvertController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    svg_file = params[:svg_file]
    base_url = request.base_url # Получаем базовый URL здесь

    if svg_file.nil?
      render json: {error: "SVG файл не предоставлен"}, status: :bad_request
      return
    end

    result_pdf = CreatePdfService.new(svg_file.tempfile, base_url).call
    send_data result_pdf, filename: "converted.pdf", type: "application/pdf", disposition: "attachment"
  end
end
