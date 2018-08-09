RSpec.describe Api::V1::PerformanceDataController, type: :request do 
    let(:user) { FactoryBot.create(:user) }
    let(:credentials) { user.create_new_auth_token }
    let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

    describe 'POST /api/v1/performance_data' do
        it 'creates a data entry' do
          post '/api/v1/performance_data', params: {
            performance_data: { data: { message: 'Average' } }
          }, headers: headers
    
          entry = PerformanceData.last
          expect(entry.data).to eq 'message' => 'Average'
        end
    end
    
    describe 'GET /api/v1/performance_data' do
      before do
        5.times { user.performance_data.create(data: { message: 'Average' }) }
      end
    

      it 'returns a collection of performance data' do
        get '/api/v1/performance_data', headers: headers
        expect(response_json['entries'].count).to eq 5
      end

      it 'returns a collection of performance data belonging to the current user' do
        get '/api/v1/performance_data', headers: headers
        current_user_entry = PerformanceData.last
        expected_response = {
            'id' => current_user_entry.id, 
            #'uid' => current_user_entry.email, 
            #'email' => current_user_entry.email, 
            'name' => nil, 
            'nickname' => nil, 
            'image' => nil
          }
      end
    end
end