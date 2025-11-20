class PdfConverterController < ApplicationController
  require 'pdf-reader'
  require 'docx'

  def index
  end

  def convert
    unless params[:pdf_file].present?
      render json: { error: 'No file uploaded' }, status: :unprocessable_entity
      return
    end

    unless params[:output_format].in?(['txt', 'docx'])
      render json: { error: 'Invalid output format' }, status: :unprocessable_entity
      return
    end

    pdf_file = params[:pdf_file]
    output_format = params[:output_format]

    begin
      # Extract text from PDF
      text = extract_text_from_pdf(pdf_file.tempfile.path)

      if output_format == 'txt'
        # Convert to TXT
        send_data text, filename: "#{File.basename(pdf_file.original_filename, '.pdf')}.txt", type: 'text/plain'
      else
        # Convert to DOCX
        docx_content = create_docx(text)
        send_data docx_content, filename: "#{File.basename(pdf_file.original_filename, '.pdf')}.docx",
                  type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      end
    rescue => e
      render json: { error: "Conversion failed: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def extract_text_from_pdf(pdf_path)
    reader = PDF::Reader.new(pdf_path)
    text = ""

    reader.pages.each do |page|
      text += page.text + "\n\n"
    end

    text
  end

  def create_docx(text)
    require 'zip'

    # Create a temporary file for the DOCX
    temp_file = Tempfile.new(['output', '.docx'])

    begin
      # Create DOCX using rubyzip - DOCX is essentially a ZIP file with XML
      Zip::File.open(temp_file.path, create: true) do |zipfile|
        # Add required DOCX structure files
        zipfile.get_output_stream('[Content_Types].xml') do |f|
          f.puts '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
          f.puts '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
          f.puts '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
          f.puts '<Default Extension="xml" ContentType="application/xml"/>'
          f.puts '<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>'
          f.puts '</Types>'
        end

        zipfile.get_output_stream('_rels/.rels') do |f|
          f.puts '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
          f.puts '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
          f.puts '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>'
          f.puts '</Relationships>'
        end

        zipfile.get_output_stream('word/_rels/document.xml.rels') do |f|
          f.puts '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
          f.puts '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
          f.puts '</Relationships>'
        end

        # Create document.xml with the text content
        zipfile.get_output_stream('word/document.xml') do |f|
          f.puts '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
          f.puts '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
          f.puts '<w:body>'

          # Split text into paragraphs
          paragraphs = text.split("\n")
          paragraphs.each do |paragraph|
            unless paragraph.strip.empty?
              escaped_text = paragraph.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
              f.puts '<w:p><w:r><w:t xml:space="preserve">' + escaped_text + '</w:t></w:r></w:p>'
            end
          end

          f.puts '</w:body>'
          f.puts '</w:document>'
        end
      end

      # Read the file content
      content = File.binread(temp_file.path)
      content
    ensure
      temp_file.close
      temp_file.unlink
    end
  end
end
