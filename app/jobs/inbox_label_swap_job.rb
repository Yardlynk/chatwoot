class InboxLabelSwapJob < ApplicationJob
  queue_as :high

  def perform
    # ADDED BY YARDLINK
    Conversation.where(status: 'open').each do |conv|
      inbox_labels = Label.where('title ilike ?', "%_inbox")

      inbox_labels.each do |il|
        inbox = Inbox.find_by(name: il.title.gsub('_inbox','').capitalize )
        convos =  il.conversations

        convos.each do |c|
          c.update(inbox_id: inbox.id)
          c.labels.where(name: il.title).destroy_all
        end
      end
    end
  end
end
