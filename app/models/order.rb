class Order < ApplicationRecord
  belongs_to :payment
  has_many :order_items, dependent: :destroy

  FORMAT_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: FORMAT_EMAIL},
      length: {maximum: Settings.size.of_email}
  validates :name, presence: true,
    length: {maximum: Settings.size.of_name}
  validates :phone, numericality: true
  validates :address, presence: true, length: {maximum: Settings.size.address}
  validates :payment_id, presence: true

  enum status_id: {place: 1, transport: 2, finish: 3}

  ORDER_PARAMS = %i(payment_id name email address phone).freeze

  scope :newest, ->{order "created_at DESC"}
  scope :by_user, ->(mail){where "email = ?", mail}
  scope :progress, ->{order "status_id"}

  def send_email_for_customer
    OrderMailer.notice_customer(self).deliver_now
  end

  def send_email_for_admin
    AdminMailer.notice_admin(self).deliver_now
  end

  def send_email_transporting
    OrderMailer.notice_transport(self).deliver_now
  end

  def send_email_finished
    OrderMailer.notice_finished(self).deliver_now
  end
end
