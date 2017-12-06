defmodule Mix.Tasks.Plsm do
  use Mix.Task

  def run(_) do
    # ensure all dependencies are started manually.
    {:ok, _started} = Application.ensure_all_started(:postgrex)

    configs = Plsm.Common.Configs.load_configs()

    tableHeaders =
      configs
      |> Plsm.Database.Common.create()
      |> Plsm.Database.connect()
      |> Plsm.Database.get_tables()

    for header <- tableHeaders do
      columns = Plsm.Database.get_columns(header.database, header)
      table = %Plsm.Database.Table{header: header, columns: columns}

      Plsm.IO.Export.prepare(table, configs.project.name)
      |> Plsm.IO.Export.write(Inflex.singularize(header.name), configs.project.destination)
    end
  end
end

defmodule Mix.Tasks.Plsm.Config do
  use Mix.Task

  @doc "Generate the basic config file for a Plsm run"
  def run(params) do
    {opts, _, _} = OptionParser.parse(params, strict: [config_file: :string])
    file_name = Keyword.get(opts, :config_file, "config/config.exs")

    case config_exists?(file_name) do
      false ->
        case Plsm.Config.Config.write(file_name) do
          {:error, msg} -> IO.puts(msg)
          _ -> IO.puts("Configs written to #{file_name}\n")
        end

      true ->
        IO.puts("Configs have already been created, please change the current config.")
    end
  end

  defp config_exists?(filename) do
    case File.read(filename) do
      {:ok, content} -> String.contains?(content, ":plsm")
      _ -> false
    end
  end
end

defmodule Mix.Tasks.Plasm.Config do
  use Mix.Task

  def run(params) do
    Mix.Tasks.Plsm.Config.run(params)
  end
end

defmodule Mix.Tasks.Plasm do
  use Mix.Task

  def run(_) do
    Mix.Tasks.Plsm.run(nil)
  end
end
