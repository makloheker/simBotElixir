defmodule SimsimiBot do

  def start do
    loop()
  end

  defp loop do
    IO.write("you>: ")
    input_text = IO.gets("") |> String.trim()

    if input_text == "exit" do
      IO.puts("byebye...")
    else
      case send_request(input_text) do
        {:ok, response} -> IO.puts("bot>: #{response}")
        {:error, reason} -> IO.puts("bot>: Error: #{reason}")
      end
      loop()
    end
  end

  defp send_request(input_text) do
    url = "https://api.simsimi.vn/v1/simtalk"
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    body = URI.encode_query(%{"text" => input_text, "lc" => "id"})

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"message" => message}} -> {:ok, message}
          _ -> {:error, "gagal parsing json"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "gagal req: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "gagal req: #{reason}"}
    end
  end
end
