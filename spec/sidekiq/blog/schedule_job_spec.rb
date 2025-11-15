require 'rails_helper'
RSpec.describe Blog::ScheduleJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:blog) { create(:blog, user: user, status: :draft) }

    it 'calls BlogService::Schedule with correct arguments' do
      service_instance = instance_double(BlogService::Schedule)
      allow(BlogService::Schedule).to receive(:new).with(user.id, blog.id).and_return(service_instance)
      allow(service_instance).to receive(:call)

      described_class.new.perform(user.id, blog.id)

      expect(BlogService::Schedule).to have_received(:new).with(user.id, blog.id)
      expect(service_instance).to have_received(:call)
    end
  end
end
