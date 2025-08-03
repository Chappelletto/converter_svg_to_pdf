class Api::ConvertController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @document = Document.new
    svg_file = params[:document][:svg_file] if params[:document]

    if svg_file.nil?
      render json: {error: "SVG файл не предоставлен"}, status: :bad_request
      return
    end
    result_pdf = CreatePdfService.new(svg_file.tempfile).call
    pdf_io = StringIO.new(result_pdf)
    pdf_io.rewind

    @document.converted_pdf.attach(io: pdf_io,
      filename: "converted_#{Time.now.to_i}.pdf",
      content_type: "application/pdf")
    @document.save

    render json: url_for(@document.converted_pdf)
  end
end
