require 'rails_helper'
require 'import/zendesk/base_factory_examples'

RSpec.describe Import::Zendesk::TicketFactory do
  it_behaves_like 'Import::Zendesk::BaseFactory'
end
