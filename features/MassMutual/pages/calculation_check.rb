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

  # Purpose - Navigating to Clear Trip site
  def visit
    @browser.goto(URL)
  end

  def check_for_val_count
    @browser.elements(:class => "txt_val_.*").size
  end

  def search_flight
    @trip_type.wait_until(timeout: 60, &:present?).click! unless @modal_popup.exists?
    @source_name.wait_until(timeout: 60, &:present?).set SOURCE_PLACE_NAME
    @destination_name.wait_until(timeout: 60, &:present?).set DESTINATION_PLACE_NAME
    @depart_date.wait_until(timeout: 60, &:present?).set DEPART_DATE
    @return_date.wait_until(timeout: 60, &:present?).set RETURN_DATE
    @no_of_adult.wait_until(timeout: 60, &:present?).select ADULT_COUNT.to_s
    @no_of_child.wait_until(timeout: 60, &:present?).select CHILD_COUNT.to_s
    @search_btn.wait_until(timeout: 60, &:present?).click!
    wait_until_true(150){@last_flight[2].lis[4].label.visible?}
    # Choosing the last flight on very next day
    @last_flight[2].lis[4].label.wait_until(timeout: 60, &:present?).click!
    p 'Click on the book button'
    @browser.buttons.each do |btn|
      btn.click! if btn.text == 'Book'
    end
  end

  # Purpose - Booking the flight ticket
  # Params - Passenger details - Hash value detail of person like name, dob, nationality
  def booking_of_flight(passenger_details)
    @modal_popup.a.click! if @modal_popup.exists? # if pop-up relating to "Try Again" comes, then close it
    @itinerary_btn.wait_until(timeout: 120, &:present?).click!
    sleep(10)

    @adult_iterator = 1
    @child_iterator = 1
    @iterator = 1
    passenger_details.each do |passgr|
      person_type = passgr['Person']
      title = passgr['Passenger_name'].split(' ')[0]
      first_name = passgr['Passenger_name'].split(' ')[1]
      second_name = passgr['Passenger_name'].split(' ')[2]
      dob_day = passgr['DateOfBirth'].split('/')[0]
      dob_month = passgr['DateOfBirth'].split('/')[1]
      dob_year = passgr['DateOfBirth'].split('/')[2]
      nationality = passgr['Nationality']
      val = person_type == 'Adult' ? @adult_iterator : @child_iterator
      @browser.select_list(:id, "#{person_type}Title#{val}").select title
      @browser.text_field(:id, "#{person_type}Fname#{val}").set first_name
      @browser.text_field(:id, "#{person_type}Lname#{val}").set second_name
      @browser.select_list(:id, "#{person_type}DobDay#{val}").select dob_day if @browser.select_list(:id, "#{person_type}DobDay#{val}").exists?
      @browser.select_list(:id, "#{person_type}DobMonth#{val}").select dob_month if @browser.select_list(:id, "#{person_type}DobMonth#{val}").exists?
      @browser.select_list(:id, "#{person_type}DobYear#{val}").select dob_year if @browser.select_list(:id, "#{person_type}DobYear#{val}").exists?
      @nationality[@iterator - 1].set nationality if @nationality.count > 0
      @adult_iterator += 1 if person_type == 'Adult'
      @child_iterator += 1 if person_type == 'Child'
      @iterator += 1
    end
    p 'Provide your contact details' if @mobile_number.set MOBILE_NUMBER
    @travel_continue_btn.wait_until(timeout: 60, &:present?).click!
    sleep(10)
    @modal_popup.a.click! if @modal_popup.exists?
  end

  # Purpose - Make payment for the flight ticket
  # Params - nil
  def flight_payment_gateway
    res = false
    begin
      res = true if @payment_submit_btn.wait_until(timeout: 60, &:present?).exists?
      p 'Payment for the flight ticket follows from HERE'
    rescue
      res = false
    end
    res
  end

  # Purpose - Method to make block wait until block returns TRUE
  def wait_until_true(seconds = 150)
    end_time = Time.now + seconds
    begin
      yield
    rescue StandardError => e
      raise e.message if Time.now >= end_time
      puts "Got #{e.message}, hence retrying...!"
      sleep 3
      retry
    end
  end
end
