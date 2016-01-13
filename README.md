# Paginex

Paginex expose an struct that can be use to render the html of you
pagination.

## Installation

The package can be installed as:

  1. Add paginex to your list of dependencies in `mix.exs`:

        def deps do
          [{:paginex, "~> 0.0.1"}]
        end

  2. Ensure paginex is started before your application:

        def application do
          [applications: [:paginex]]
        end
