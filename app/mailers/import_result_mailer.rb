class ImportResultMailer < ActionMailer::Base
  default from: "from@example.com"

  def result_email(products)
    @products = products
    mail to: 'products@productexam.ple', subject: 'New product import'
  end
end
