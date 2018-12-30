module Silvio::ApiHelper
  macro json_get(url, method)
    get({{ url }}) do |context, params|
      context.response.content_type = "application/json"
      context.response.print({{ method }}(params).to_json)
      context
    end
  end

  macro json_post(url, method)
    post({{ url }}) do |context, params|
      context.response.content_type = "application/json"
      request_params = parse_json(context.request.body)
      # Merge the params from the HTTP body's JSON into the params variable
      request_params.as_h.each { |k, v| params[k] = v.to_s unless params.has_key?(k) }

      # Create and store the database object
      obj = {{ method }}(params)
      changeset = Database.insert(obj)

      context.response.print(changeset.instance.to_json)
      context
    end
  end

  macro json_put(url, method)
    put({{ url }}) do |context, params|
      context.response.content_type = "application/json"
      request_params = parse_json(context.request.body)
      # Merge the params from the HTTP body's JSON into the params variable
      request_params.as_h.each { |k, v| params[k] = v.to_s unless params.has_key?(k) }

      obj = {{ method }}(params)
      changeset = Database.update(obj)

      context.response.print(changeset.instance.to_json)
      context
    end
  end

  macro json_delete(url, method)
    delete({{ url }}) do |context, params|
      context.response.content_type = "application/json"
      {{ method }}(params)
      context.response.print({status: "ok"}.to_json)
      context
    end
  end

  private def parse_json(body : IO | Nil) : JSON::Any
    body ? JSON.parse(body) : JSON.parse("{}")
  end
end
