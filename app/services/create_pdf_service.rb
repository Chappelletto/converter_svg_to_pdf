class CreatePdfService
  def initialize(svg_file, base_url)
    @svg_file = svg_file
    @base_url = base_url
  end

  def call
    # Путь к папке (если её нет, она будет создана)
    output_dir = Rails.root.join("public", "pdf_reports") # Пример: /ваш_проект/public/pdf_reports
    FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)

    # Имя файла (можно генерировать динамически)
    @filename = "report_#{Time.now.strftime("%Y-%m-%d_%H-%M")}.pdf"
    filepath = File.join(output_dir, @filename)

    Prawn::Document.generate(filepath) do |pdf|
      pdf.svg @svg_file, width: 500

      # Добавляем метки обрезки по углам (линии 10x10 мм)
      pdf.line_width(0.9)
      pdf.stroke_color "000000" # Чёрный цвет

      # Левый верхний угол
      pdf.dash(3, space: 2)
      pdf.stroke do
        pdf.horizontal_line(-100, 1000, at: pdf.bounds.height + 10) # Верхняя метка
        pdf.vertical_line(pdf.bounds.height, pdf.bounds.height + 10, at: -10) # Левая метка
      end

      # Правый верхний угол
      pdf.dash(3, space: 2)
      pdf.stroke do
        pdf.horizontal_line(pdf.bounds.width, pdf.bounds.width + 10, at: pdf.bounds.height + 10)
        pdf.vertical_line(pdf.bounds.height, pdf.bounds.height + 10, at: pdf.bounds.width + 10)
      end

      # Левый нижний угол
      pdf.dash(3, space: 2)
      pdf.stroke do
        pdf.horizontal_line(-100, 1000, at: -10)
        pdf.vertical_line(-100, 1000, at: -10)
      end

      # Правый нижний угол
      pdf.dash(3, space: 2)
      pdf.stroke do
        pdf.horizontal_line(pdf.bounds.width, pdf.bounds.width + 10, at: -10)
        pdf.vertical_line(-100, 1000, at: pdf.bounds.width + 10)
      end

      pdf.canvas do
        pdf.transparent(0.1) do
          pdf.fill_color "000000"
          0.step(500, 40) do |x|
            0.step(800, 80) do |y|
              pdf.text_box "Peter",
                at: [x + 30, y],
                rotate: 30,
                size: 14
            end
          end
        end
      end
    end
    @filename
  end
end
