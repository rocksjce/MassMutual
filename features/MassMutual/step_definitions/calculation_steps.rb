
Given(/^navigate to site$/) do
  @mass_mutual = UtilityPage.new(@browser)
  logger.info 'Navigating to Exercise1 site'
  @mass_mutual.visit
end

When(/^calculation check page available$/) do
  logger.info 'Now at Calculation Page'
end

Then(/^value count on the screen should be (.*)$/) do |val|
  total_val_count = @mass_mutual.check_for_val_count
  raise "value count on the screen #{total_val_count} didn't match with #{val}" unless total_val_count == val
  logger.info "value count on the screen #{total_val_count} validated" if total_val_count == val
end

Then(/^value on the screen should be greater than (\d+)$/) do |count|
  pending
end

Then(/^total balance should be correct based on the values listed on the screen$/) do
  pending
end

Then(/^values are formatted as currencies$/) do
  pending
end

Then(/^the total balance matches the sum of the values$/) do
  pending
end