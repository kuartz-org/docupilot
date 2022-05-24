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

#### Get list of templates

[reference](https://help.docupilot.app/developers/templates-api#get-list-of-templates)

```ruby
Docupilot::Template.all
# => [#<Docupilot::Template:0x0000..>, #<Docupilot::Template:0x0000..>]

# Optional `folder_id` attribute to get all templates from a specific folder.
Docupilot::Template.all(folder_id: 42)
```

> **Warning**
>
> Without `folder_id`, this returns only templates from root.

#### Get a template

[reference](https://help.docupilot.app/developers/templates-api#get-a-template)


```ruby
Docupilot::Template.find(42)
# => #<Docupilot::Template:0x0000..>
```

#### Create a new template

[reference](https://help.docupilot.app/developers/templates-api#create-a-new-template)


```ruby
template = Docupilot::Template.new(
  output_file_name: "Contract n°{{contract_number}}",
  folder: Docupilot::Folder.find(1),
  document_status: "test",
  description: "Contract template for client",
  type: "docx",
  title: "Contract template"
)

template.save
# => #<Docupilot::Template:0x0000..>

# or

Docupilot::Template.create(
  output_file_name: "Contract n°{{contract_number}}",
  folder: Docupilot::Folder.find(1),
  document_status: "test",
  description: "Contract template for client",
  type: "docx",
  title: "Contract template"
)
# => #<Docupilot::Template:0x0000..>
```

#### Update a template

[reference](https://help.docupilot.app/developers/templates-api#update-a-template)


```ruby
template = Docupilot::Template.find(42)

template.title = "New title"
template.save
# => #<Docupilot::Template:0x0000..>

# or

template.update(title: "New title")
# => #<Docupilot::Template:0x0000..>
```

#### Add/update template content

[reference](https://help.docupilot.app/developers/templates-api#add-update-template-content)

```ruby
file = File.open(Rails.root.join("tmp/sample_project_proposal.docx"))
template = Docupilot::Template.find(42)
template.upload_content(file)
# => nil
```

#### Get schema for a template

[reference](https://help.docupilot.app/developers/templates-api#get-schema-for-a-template)

```ruby
template = Docupilot::Template.find(42)
template.schema
# => [
# {:name=>"project_name", :type=>"string"},
# {:name=>"client", :type=>"object", :fields=>[{:name=>"name", :type=>"string"}, {:name=>"company", :type=>"string"}]},
# {:name=>"start_date", :type=>"string"},
# {:name=>"end_date", :type=>"string"}
# ]
```

#### Merge a document

[reference](https://help.docupilot.app/developers/templates-api#merge-a-document)

```ruby
attributes = {
  project_name: "test 1",
  client: { name: "michel", company: "acme" },
  start_date: "10 juin 2022",
  end_date: "12 juin 2022"
}

template = Docupilot::Template.find(42)
template.merge_document(attributes)
# => {
#   :file_url=> "https://docupilot-documents.s3.amazonaws.com/temp/...",
#   :file_name=>"Sample Project Proposal_2022-05-22 16_53_08.docx"
# }
```

### Folder

#### Get list of folders

[reference](https://help.docupilot.app/developers/folders-api#get-list-of-templates)

```ruby
Docupilot::Folder.all
# => [#<Docupilot::Folder:0x0000...>, #<Docupilot::Folder:0x0000...>]
```

#### Create a new folder

[reference](https://help.docupilot.app/developers/folders-api#create-a-new-folder)

```ruby
folder = Docupilot::Folder.new(name: "dev")

folder.save
# => #<Docupilot::Folder:0x0000..>

# or

Docupilot::Folder.create(name: "dev")
# => #<Docupilot::Folder:0x0000..>
```
