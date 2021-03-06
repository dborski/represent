class SinatraService

  def get_house_members
    get_json('/api/v1/representatives')
  end

  def get_senators
    get_json('/api/v1/senators')
  end

  def get_articles(favorite_names, sort, language_abbrev, num_results)
    params = { favorite_names: "\"#{favorite_names}\"", sort: sort,
               language: language_abbrev, num_results: num_results}

    get_json('/api/v1/articles', params)
  end

  def get_bills
    get_json('/api/v1/bills')
  end

  def get_image(congress_id)
    conn.get("/api/v1/images?congress_id=#{congress_id}").env[:response_body]
  end

  def get_member_votes(member_id, roll_call, chamber, session)
    params = { member_id: member_id, roll_call: roll_call, chamber: chamber, session: session}

    get_json_not_symbolized('/api/v1/member_votes', params)
  end

  private

  def conn
    Faraday.new(url: "http://represent-sinatra.herokuapp.com") do |f|
      f.adapter Faraday.default_adapter
    end
  end

  def get_json(url, params = nil)
    response = conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_json_not_symbolized(url, params = nil)
    response = conn.get(url, params)
    JSON.parse(response.body)
  end
end
