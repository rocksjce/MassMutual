require 'date'

class UtilityPage

  attr_accessor :label_val1, :lbl_val2, :lbl_val3, :lbl_val4, :lbl_val5, :txt_val1,
                :txt_val2, :txt_val3, :txt_val4, :txt_val5, :lbl_val_ttl, :txt_val_ttl

  URL = $site_details['site_detail']['site_url']

  def initialize(browser)
    @browser = browser
    @lbl_val1 = @browser.label(:id, 'lbl_val_1')
    @lbl_val2 = @browser.label(:id, 'lbl_val_2')
    @lbl_val3 = @browser.label(:id, 'lbl_val_3')
    @lbl_val4 = @browser.label(:id, 'lbl_val_4')
    @lbl_val5 = @browser.label(:id, 'lbl_val_5')
    @lbl_val_ttl = @browser.label(:id, 'lbl_ttl_val')
    @txt_val1 = @browser.text_field(:id, 'txt_val_1')
    @txt_val2 = @browser.text_field(:id, 'txt_val_2')
    @txt_val3 = @browser.text_field(:id, 'txt_val_4')
    @txt_val4 = @browser.text_field(:id, 'txt_val_5')
    @txt_val5 = @browser.text_field(:id, 'txt_val_6')
    @txt_val_ttl = @browser.text_field(:id, 'txt_ttl_val')
  end

  # Purpose - Navigating to site URL
  def visit
    @browser.goto(URL)
  end

  # Purpose - get total count of the value field of amount balance
  def check_for_val_count
    @browser.elements(:class => "txt_val_.*").size
  end

  # Purpose - Verify whether values mentioned on the screen are greater than 0 (val: provided as input)
  def verify_val(val, tot_val_count)
    res = false
    case tot_val_count
    when 1
      res = @txt_val1.text.gsub(/[$]/, '$' => '').to_f > val
    when 2
      res = @txt_val2.text.gsub(/[$]/, '$' => '').to_f > val
    when 3
      res = @txt_val3.text.gsub(/[$]/, '$' => '').to_f > val
    when 4
      res = @txt_val4.text.gsub(/[$]/, '$' => '').to_f > val
    when 5
      res = @txt_val5.text.gsub(/[$]/, '$' => '').to_f > val
    end
    res
  end

  # Purpose - check whether total balance matches with the sum of values mentioned on the screen
  def check_for_tot_bal
    val1 = @txt_val1.text.gsub(/[$]/, '$' => '')
    val2 = @txt_val2.text.gsub(/[$]/, '$' => '')
    val3 = @txt_val3.text.gsub(/[$]/, '$' => '')
    val4 = @txt_val4.text.gsub(/[$]/, '$' => '')
    val5 = @txt_val5.text.gsub(/[$]/, '$' => '')
    total_val_expected = [val1, val2, val3, val4, val5].map(&:to_f).inject(:+)
    total_val_actual = @txt_val_ttltext.gsub(/[$]/, '$' => '').to_f
    total_val_expected == total_val_actual
  end

  # Purpose - Verify for the currency of values
  def check_for_curr
    res = false
    not_matched_currency = []
    val_arr = [@txt_val1, @txt_val2, @txt_val3, @txt_val4, @txt_val5, @txt_val_ttl]
    val_arr.each do |val|
      not_matched_currency = false unless val.text.to_s.chr == "$"
    end
    res = false unless not_matched_currency.empty?
    res
  end

end
