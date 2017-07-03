require "rails_helper"

require "chatbot/brain"
require "chatbot/facebook_user"

describe Chatbot::Brain do
  include ActiveJob::TestHelper

  let(:fbid) { "facebook_id" }

  def brain(msg)
    the_brain = described_class.new(msg)
    # I'm going to have to change the design
    the_brain.instance_variable_set("@fbid", fbid)
    the_brain
  end

  context "#handle_text_message hello" do
    it "handles english locale" do
      locale = "en"
      text   = I18n.t("chatbot.user.hello", locale: locale).sample
      user   = create(:user, locale: locale)
      user.create_facebook_account(facebook_id: fbid)
      sender = Struct.new(:id).new(fbid)
      msg    = Struct.new(:sender, :text).new(sender, text)
      expected_responses = I18n.t("chatbot.responses.hello", locale: locale)
      perform_enqueued_jobs do
        brain(msg).handle_text_message
      end
      response = BotMessage.where(from_bot: true).first.payload
      expect(expected_responses).to include(response)
    end

    it "handles german locale" do
      locale = "de"
      text   = I18n.t("chatbot.user.hello", locale: locale).sample
      user   = create(:user, locale: locale)
      user.create_facebook_account(facebook_id: fbid)
      sender = Struct.new(:id).new(fbid)
      msg    = Struct.new(:sender, :text).new(sender, text)
      expected_responses = I18n.t("chatbot.responses.hello", locale: locale)
      perform_enqueued_jobs do
        brain(msg).handle_text_message
      end
      response = BotMessage.where(from_bot: true).first.payload
      expect(expected_responses).to include(response)
    end
  end

  context "#handle_text_message fallback" do
    it "falls back to a do not understand response when it doesn't understand" do
      locale = "de"
      text   = "foobazboooooooo"
      user   = create(:user, locale: locale)
      user.create_facebook_account(facebook_id: fbid)
      sender = Struct.new(:id).new(fbid)
      msg    = Struct.new(:sender, :text).new(sender, text)
      expected_responses = I18n.t("chatbot.responses.dont_understand", locale: locale)
      perform_enqueued_jobs do
        brain(msg).handle_text_message
      end
      response = BotMessage.where(from_bot: true).first.payload
      expect(expected_responses).to include(response)
    end
  end
end
