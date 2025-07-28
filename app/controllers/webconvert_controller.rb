class WebconvertController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end

  def create
    svg_file = params.require(:svg_file)
    base_url = request.base_url # Получаем базовый URL здесь

    if svg_file.nil?
      # TODO: надо, чтобы ответ был в HTML (render :index + нужно ошибку пробрасывать во view)
      render json: {error: "SVG файл не предоставлен"}, status: :bad_request
      return
    end
    file_url = CreatePdfService.new(svg_file.tempfile, base_url).call
    # result_pdf = pdf_creator.call

    # send_data result_pdf, filename: "converted.pdf", type: "application/pdf", disposition: "attachment"

    render json: "PDF доступен по ссылке: #{file_url}"
  end
end
