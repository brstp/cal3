class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    return true if value.blank?
    n_digits = value.scan(/[0-9]/).size
    valid_chars = (value =~ /^[+\- 0-9]+$/)
    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid_phone_number')) unless n_digits > 5 and valid_chars
  end
end
