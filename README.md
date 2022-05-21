# Docupilot

Ruby wrapper for Docupilot API.

## Installation

```ruby
# Gemfile
gem "docupilot"
```

### Configuration

For Rails:

```ruby
# config/initializers/docupilot.rb

Docupilot.configure do |config|
  config.api_key = Rails.application.credentials.docupilot[:api_key]
  config.secret_key = Rails.application.credentials.docupilot[:secret_key]
end
```


## Usage

### Template

**Index**

```ruby
Docupilot::Template.all
```

**Show**

```ruby
Docupilot::Template.find(42)
```

**Create / Update**

```ruby
Docupilot::Template.new(
  output_file_name: "Contract n°{{contract_number}}",
  folder: "Home",
  document_status: "test",
  description: "Contract template for client",
  type: "docx",
  title: "Contract template"
)
```
