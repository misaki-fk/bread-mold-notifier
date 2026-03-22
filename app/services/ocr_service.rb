require "google/cloud/vision"
require "date"

class OcrService
  def self.extract_expiration(image_path)
    vision = Google::Cloud::Vision.image_annotator

    response = vision.text_detection image: image_path
    text = response.responses.first.text_annotations.first.description

    extract_best_date(text)
  end

  private

  def self.extract_best_date(text)
    dates = extract_dates(text)

    parsed_dates = dates.map { |d| normalize_date(d) }.compact

    # 未来の日付を優先
    future_dates = parsed_dates.select { |d| d >= Date.today }

    return future_dates.min if future_dates.any?

    parsed_dates.min
  end

  def self.extract_dates(text)
    patterns = [
      /\d{2}\.\d{2}\.\d{2}/,
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