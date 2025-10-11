class Month < ApplicationRecord
  # meses em português, armazenados em lowercase
  MONTHS = %w[
    janeiro fevereiro março abril maio junho
    julho agosto setembro outubro novembro dezembro
  ].freeze

  before_validation :normalize_month

  validates :month, presence: true,
                    inclusion: { in: MONTHS, message: "%{value} não é um mês válido" },
                    uniqueness: { case_sensitive: false }

  # Retorna o número do mês (1..12) ou nil se inválido
  def month_number
    idx = MONTHS.index(month)
    idx ? idx + 1 : nil
  end

  # Nome capitalizado para exibição ("Janeiro", "Fevereiro", ...)
  def month_name
    month.to_s.capitalize
  end

  # Converte para uma Date no primeiro dia do mês no ano fornecido
  # Ex.: to_date(2025) => 2025-01-01 (ou nil se inválido)
  def to_date(year = Date.current.year)
    return nil unless (m = month_number)
    Date.new(year, m, 1)
  end

  private

  def normalize_month
    self.month = month.to_s.strip.downcase if month.present?
  end
end
