class DocumentBlueprint < Blueprinter::Base
  field :id

  field :converted_pdf_url do |document, options|
    if document.converted_pdf.attached? && options[:view_context]
      options[:view_context].url_for(document.converted_pdf)
    end
  end
end
