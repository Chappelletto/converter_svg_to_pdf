class Api::PdfController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    svg_file = params[:svg_file]

    if svg_file.nil?
      render json: {error: "SVG файл не предоставлен"}, status: :bad_request
      return
    end

    result_pdf = CreatePdfService.new(svg_file.tempfile).call
    send_data result_pdf, filename: "converted.pdf", type: "application/pdf", disposition: "attachment"
  end
end