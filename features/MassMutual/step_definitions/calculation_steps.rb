
Given(/^navigate to site$/) do
  @mass_mutual = UtilityPage.new(@browser)
  logger.info 'Navigating to Exercise1 site'
  @mass_mutual.visit
end

When(/^calculation check page available$/) do
  logger.info 'Now at Calculation Page'
end

Then(/^value count on the screen should be (.*)$/) do |val|
  @total_val_count = @mass_mutual.check_for_val_count
  raise "value count on the screen #{@total_val_count} didn't match with #{val}" unless @total_val_count == val
  logger.info "value count on the screen #{@total_val_count} validated" if @total_val_count == val
end

Then(/^value on the screen should be greater than (\d+)$/) do |val|
  tot_val_count = @txt_val_count
  failed_arr = []
  while tot_val_count >= 1
    failed_arr << tot_val_count unless @mass_mutual.verify_val(val, tot_val_count)
    tot_val_count = tot_val_count - 1
  end
  raise "value on the screen are not greater than #{val} for #{failed_arr}" unless failed_arr.empty?
  logger.info "All values mentioned on screen are greater than #{val}"
end

Then(/^total balance should be correct based on the values listed on the screen$/) do
  tot_bal_res = @mass_mutual.check_for_tot_bal
  raise "Total balance are NOT correct based on the values listed on the screen " unless tot_bal_res
  logger.info "Total balance are correct based on the values listed on the screen"
end

Then(/^values are formatted as currencies$/) do
  res = @mass_mutual.check_for_curr
  raise "Values are NOT formatted as currencies listed on the screen" unless res
  logger.info "Values are formatted as currencies as listed on the screen"
end

Then(/^the total balance matches the sum of the values$/) do
  res = @mass_mutual.check_for_tot_bal
  raise "Total balance doesn't matches the sum of the values mentioned on the screen" unless res
  logger.info "Total balance matches the sum of the values mentioned on the screen"
end