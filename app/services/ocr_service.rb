require "google/cloud/vision"
require "date"
require "json"
require "tempfile"

class OcrService
  def self.extract_expiration(image_path)
    Rails.logger.info "=== OCR START ==="

    raw = ENV["GOOGLE_CREDENTIALS_JSON"]
    Rails.logger.info "ENV exists?: #{raw.present?}"

    begin
      credentials = JSON.parse(raw)
      Rails.logger.info "JSON parse OK"
    rescue => e
      Rails.logger.error "JSON parse ERROR: #{e.message}"
      raise
    end

    # 🔥 ここが重要
    file = Tempfile.new("gcp.json")
    file.write(credentials.to_json)
    file.rewind

    # 🔥 ここも重要（環境変数にセット）
    ENV["GOOGLE_APPLICATION_CREDENTIALS"] = file.path

    begin
      vision = Google::Cloud::Vision.image_annotator
      Rails.logger.info "Vision client created"
    rescue => e
      Rails.logger.error "Vision client ERROR: #{e.message}"
      raise
    end

    begin
      response = vision.text_detection image: image_path
      Rails.logger.info "Vision API called"
    rescue => e
      Rails.logger.error "Vision API ERROR: #{e.message}"
      raise
    end

    response
  end

  private

   def self.extract_best_date(text)
    lines = text.split("\n")
  
    # 消費期限がある行を優先
    target_line = lines.find { |line| line.match?(/消費|賞味/) }
  
    # なければ全体
    target_line ||= text
  
    dates = extract_dates(target_line)
    parsed_dates = dates.map { |d| normalize_date(d) }.compact
  
    return nil if parsed_dates.empty?
  
    # 念のため未来優先
    future_dates = parsed_dates.select { |d| d >= Date.today }
  
    return future_dates.min if future_dates.any?
  
    parsed_dates.min
  end

  def self.extract_dates(text)
    patterns = [
      /\d{2}\.\d{1,2}\.\d{1,2}/,   #2桁と1桁両方に対応できるよう修正
      /\d{4}[\/\.\-]\d{1,2}[\/\.\-]\d{1,2}/
    ]

    patterns.flat_map { |p| text.scan(p) }
  end

  def self.normalize_date(date_str)
    if date_str =~ /^\d{2}\.\d{2}\.\d{2}$/
      Date.strptime(date_str, "%y.%m.%d")
    else
      Date.parse(date_str)
    end
  rescue
    nil
  end
end