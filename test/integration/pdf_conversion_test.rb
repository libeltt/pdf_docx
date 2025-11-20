require "test_helper"

class PdfConversionTest < ActionDispatch::IntegrationTest
  setup do
    # Create a simple test PDF file
    @test_pdf_path = Rails.root.join('tmp', 'test_sample.pdf')
    create_test_pdf(@test_pdf_path)
  end

  teardown do
    File.delete(@test_pdf_path) if File.exist?(@test_pdf_path)
  end

  test "should convert PDF to TXT" do
    pdf_file = fixture_file_upload(@test_pdf_path, 'application/pdf')

    post pdf_converter_convert_path, params: {
      pdf_file: pdf_file,
      output_format: 'txt'
    }

    assert_response :success
    assert_equal 'text/plain', response.content_type
    assert response.body.present?, "TXT output should not be empty"
    assert response.body.include?('Test'), "TXT should contain extracted text"
  end

  test "should convert PDF to DOCX" do
    pdf_file = fixture_file_upload(@test_pdf_path, 'application/pdf')

    post pdf_converter_convert_path, params: {
      pdf_file: pdf_file,
      output_format: 'docx'
    }

    assert_response :success
    assert_equal 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                 response.content_type
    assert response.body.present?, "DOCX output should not be empty"
    assert response.body.bytesize > 0, "DOCX file should have content"
  end

  test "should reject missing file" do
    post pdf_converter_convert_path, params: {
      output_format: 'txt'
    }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal 'No file uploaded', json_response['error']
  end

  test "should reject invalid format" do
    pdf_file = fixture_file_upload(@test_pdf_path, 'application/pdf')

    post pdf_converter_convert_path, params: {
      pdf_file: pdf_file,
      output_format: 'invalid'
    }

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal 'Invalid output format', json_response['error']
  end

  private

  def create_test_pdf(path)
    require 'prawn'

    Prawn::Document.generate(path) do |pdf|
      pdf.text "Test PDF Document", size: 24, style: :bold
      pdf.move_down 20
      pdf.text "This is a test PDF file created for integration testing."
      pdf.move_down 10
      pdf.text "It contains some sample text that should be extracted during conversion."
      pdf.move_down 10
      pdf.text "Line 1: Hello World"
      pdf.text "Line 2: PDF to TXT conversion"
      pdf.text "Line 3: PDF to DOCX conversion"
    end
  end
end
