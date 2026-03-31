require "google/cloud/vision"
require "date"
require "json"
require "tempfile"

class OcrService
  def self.extract_expiration(image_path)
    Rails.logger.info "=== OCR START ==="

    if ENV["GOOGLE_CREDENTIALS_JSON"].present?
      Rails.logger.info "Using JSON credentials"

      raw = ENV["GOOGLE_CREDENTIALS_JSON"]
      credentials = JSON.parse(raw)

      file = Tempfile.new("gcp.json")
      file.write(credentials.to_json)
      file.rewind

      ENV["GOOGLE_APPLICATION_CREDENTIALS"] = file.path

    elsif ENV["GOOGLE_APPLICATION_CREDENTIALS"].present?
      Rails.logger.info "Using file credentials"

      # 何もしない（そのまま使う）

    else
      raise "No Google credentials found"
    end

    vision = Google::Cloud::Vision.image_annotator
    Rails.logger.info "Vision client created"

    response = vision.text_detection image: image_path
    Rails.logger.info "Vision API called"

    text = response.responses.first.text_annotations.first&.description
    Rails.logger.info "OCR TEXT: #{text}"

    extract_best_date(text)
  end


  private

   def self.extract_best_date(text)
    lines = text.split("\n")
  
    # 消費期限がある行を優先
    target_line = lines.find { |line| line.match?(/消費|賞味/) }
  
    # なければ全体
    target_line ||= text

    # 空白を削除
    target_line = target_line.gsub(/\s+/, "")
  
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