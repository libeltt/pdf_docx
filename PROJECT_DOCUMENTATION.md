# PDF Converter - Rails 8 Application

## Overview

This is a Rails 8 web application with Tailwind CSS that allows users to convert PDF files to either DOCX (Microsoft Word) or TXT (plain text) format. The application features a modern, responsive user interface with drag-and-drop file upload functionality.

## What Was Built

### 1. Rails 8 Application Setup
- Created a new Rails 8.1.1 application
- Configured Tailwind CSS for modern UI styling
- Set up the application structure with MVC architecture

### 2. PDF Conversion Gems
- **pdf-reader**: Used to extract text from PDF files
- **rubyzip**: Used to create DOCX files (DOCX is essentially a ZIP file containing XML)
- **docx**: Additional DOCX support gem

### 3. Controller & Routes
- **PdfConverterController**: Handles file uploads and conversions
  - `index` action: Displays the main conversion interface
  - `convert` action: Processes PDF file and returns converted output
- **Routes**:
  - `GET /` → Main page with upload interface
  - `POST /pdf_converter/convert` → Conversion endpoint

### 4. User Interface Features
- **Drag-and-Drop Upload**: Users can drag PDF files onto the upload zone
- **File Browser**: Traditional file selection via button click
- **Format Selection**: Radio buttons to choose between TXT and DOCX output
- **File Preview**: Shows selected file name and size
- **Status Messages**: Real-time feedback during conversion process
- **Responsive Design**: Works on desktop and mobile devices
- **Modern Tailwind UI**: Clean, professional gradient design with smooth transitions

### 5. Conversion Logic

#### PDF to TXT Conversion
- Extracts text from each page of the PDF
- Preserves page breaks with double newlines
- Returns plain text file for download

#### PDF to DOCX Conversion
- Extracts text from PDF
- Creates a valid DOCX file structure using XML
- Formats text as paragraphs in the Word document
- Returns DOCX file for download

## Installation & Setup

### Prerequisites
- Ruby 3.3.6 or higher
- Bundler gem
- SQLite3 (for development database)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pdf_docx
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

   Or if you prefer to run services separately:
   ```bash
   rails server
   ```

5. **Access the application**
   Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

## How to Use

### Converting a PDF File

1. **Upload Your PDF**
   - **Option 1**: Drag and drop your PDF file onto the upload zone
   - **Option 2**: Click "Select PDF File" button to browse for a file

2. **Select Output Format**
   - Click on "Text File (.txt)" for plain text output
   - Click on "Word Document (.docx)" for Microsoft Word output

3. **Convert**
   - Click the "Convert PDF" button
   - The conversion will process and automatically download the converted file

4. **Save the File**
   - Your browser will prompt you to save the file
   - Choose your desired folder location
   - The file will be named after your original PDF with the new extension

### Supported Features
- **Input**: PDF files only
- **Output**: TXT or DOCX format
- **File Size**: No strict limit, but larger files may take longer to process
- **Text Extraction**: Extracts all readable text from PDF pages

## Technical Details

### File Structure
```
pdf_docx/
├── app/
│   ├── controllers/
│   │   └── pdf_converter_controller.rb  # Main conversion logic
│   ├── views/
│   │   └── pdf_converter/
│   │       └── index.html.erb            # Upload interface
│   └── assets/
│       └── tailwind/
│           └── application.css           # Tailwind styles
├── config/
│   └── routes.rb                         # Application routes
├── Gemfile                               # Ruby dependencies
└── PROJECT_DOCUMENTATION.md              # This file
```

### Key Technologies
- **Backend**: Ruby on Rails 8.1.1
- **Frontend**: Tailwind CSS 4.4.0
- **JavaScript**: Vanilla JS for drag-and-drop functionality
- **PDF Processing**: pdf-reader gem
- **DOCX Creation**: rubyzip gem with custom XML generation

### How It Works

1. **File Upload**: User uploads PDF through web form
2. **Text Extraction**: pdf-reader gem parses PDF and extracts text from all pages
3. **Format Conversion**:
   - **TXT**: Text is returned as-is
   - **DOCX**: Text is wrapped in valid OOXML (Office Open XML) format and packaged as ZIP
4. **Download**: Browser receives file with appropriate MIME type and filename

## Troubleshooting

### Common Issues

**Issue**: "No file uploaded" error
- **Solution**: Ensure you've selected a valid PDF file before clicking Convert

**Issue**: "Invalid output format" error
- **Solution**: Make sure you've selected either TXT or DOCX format option

**Issue**: Conversion fails for specific PDF
- **Solution**: Some PDFs may be scanned images without text layers. This app only extracts existing text, not OCR

**Issue**: Server won't start
- **Solution**: Make sure all gems are installed with `bundle install` and port 3000 is available

## Development

### Running Tests
```bash
rails test
```

### Code Style
The application follows Rails best practices and uses Rubocop for code styling.

### Adding Features
To add new conversion formats or features:
1. Add necessary gems to `Gemfile`
2. Update the controller conversion logic
3. Add format option to the view
4. Test thoroughly with various PDF files

## Production Deployment

### Environment Variables
Before deploying to production, ensure you set:
```bash
RAILS_ENV=production
SECRET_KEY_BASE=<your-secret-key>
```

### Asset Compilation
```bash
rails assets:precompile
RAILS_ENV=production rails tailwindcss:build
```

### Database
For production, configure PostgreSQL or MySQL in `config/database.yml`

## License

This project is open source and available for use and modification.

## Support

For issues or questions, please open an issue in the repository.

---

**Built with Rails 8 and Tailwind CSS**
**Created: November 2025**
