module Refinery
  module Events
    module Admin
      class EventsController < ::Refinery::AdminController

        crudify :'refinery/events/event',
                :order => "date DESC",
                :xhr_paging => true

        protected
        def event_params
          params.require(:event).permit(:title, :date, :photo, :blurb)
        end

      end
    end
  end
end
