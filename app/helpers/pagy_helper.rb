module PagyHelper
  include Pagy::Frontend

  def pagy_daisy_nav(pagy)
    content_tag(:div, class: "join") do
      safe_join(
        [
          pagy_prev_button(pagy),
          *pagy.series.map { |item| pagy_page_button(pagy, item) },
          pagy_next_button(pagy)
        ]
      )
    end
  end

  def pagy_prev_button(pagy)
    disabled = pagy.prev.nil?
    link_to(
      "Prev",
      disabled ? "#" : url_for(page: pagy.prev),
      class: ["join-item btn", ("btn-disabled cursor-not-allowed" if disabled)].compact.join(" "),
      aria: { disabled: disabled }
    )
  end

  def pagy_next_button(pagy)
    disabled = pagy.next.nil?
    link_to(
      "Next",
      disabled ? "#" : url_for(page: pagy.next),
      class: ["join-item btn", ("btn-disabled cursor-not-allowed" if disabled)].compact.join(" "),
      aria: { disabled: disabled }
    )
  end

  def pagy_page_button(pagy, item)
    case item
    when Integer
      active = item == pagy.page
      link_to(
        item,
        active ? "#" : url_for(page: item),
        class: ["join-item btn", ("btn-active" if active)].compact.join(" "),
        aria: { current: ("page" if active) }
      )
    when String
      content_tag(:span, item, class: "join-item btn btn-disabled")
    end
  end
end
