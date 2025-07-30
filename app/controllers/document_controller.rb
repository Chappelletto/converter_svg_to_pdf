class DocumentController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end

  def create
    svg_file = params[:svg_file]
    @base_url = request.base_url # Получаем базовый URL здесь

    if svg_file.nil?
      render json: {error: "SVG файл не предоставлен"}, status: :bad_request
      return
    end
    filename = CreatePdfService.new(svg_file.tempfile, @base_url).call
    session[:generated_pdf] = filename
  end

  def download_pdf
    filename = session[:generated_pdf]
    file_path = Rails.root.join("public", "pdf_reports", filename)
    if File.exist?(file_path)
      send_file file_path, disposition: "attachment"
    else
      redirect_to root_path, alert: "Файл не найден"
    end
  end
end
