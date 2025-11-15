module Chatbots::PlaygroundHelper
  def playground_tour_steps_json
    playground_tour_steps.to_json
  end

  private

  def playground_tour_steps
    [
      tour_step(:instructions, "#prompt-input-container"),
      tour_step(:chat, "#chat"),
      tour_step(:share_link, "#public-url")
    ]
  end

  def tour_step(key, selector)
    {
      selector: selector,
      title: I18n.t("chatbots.playground.tour.#{key}.title"),
      description: I18n.t("chatbots.playground.tour.#{key}.description")
    }
  end
end
