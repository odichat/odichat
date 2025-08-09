# Project Overview
Odichat is web platform that help users build "custom GPTs" that are integrated into WhatsApp Business using the WhatsApp Business API to automate FAQs such as hours of operation, location, product details, and price.

1. Users create an account
2. Create a chatbot
3. Upload propietary documents (TXT, HTML, DOCX, DOC, PDF) to train their chatbot
4. Tweak their chatbot system instructions (prompt)
5. Integrate to WhatsApp Business using the WhatsApp Embedded Signup flow

## Non-negotiable golden rules
- Whenever unsure about something that's related to the project, ask the developer for clarification before making changes. DO NOT write changes or use tools when you are not sure about something project specific, or if you don't have context for a particular feature/decision.
- Add/update AIDEV-NOTE: anchor comments near non-trivial edited code. DO NOT delete or mangle existing AIDEV- comments.
- For changes >300 LOC or >3 files, ask for confirmation. DO NOT refactor large modules without human guidance.

## Project Structure
Odichat is a Ruby on Rails 8 full-stack application that uses the conventional Ruby on Rails MVC pattern and folder structure. Odichat uses the following underlying technologies:

- Frontend: `.html.erb` files, Hotwire for reactivity and StimulusJS for JavaScript
- Backend: Heavy usage of Ruby on Rails 8 as much as possible
- Database: PostgreSQL as primary database and SQLite3 for the Cache, Cable and Queue database in all environments
- Deployment: Kamal 2.0 in a Hetzner VPS

## Local Development

### Running the project
To run the project locally, use the following command:

```bash
./bin/dev
```

This will start the web server, a jobs server, the Tailwind CSS watcher, and a cloudflared tunnel.

### Running tests
To run the test suite, use the following command:

```bash
rails test
```

## Coding Standards & Framework Best Practices
- Adhere to Ruby on Rails MVC pattern and vanilla Rails folder structure
- Follow Rails conventions for naming and file organization
- Use Rails built-in testing tools (Minitest) for all test cases

### Rails Controllers
- Keep controllers thin, focused on HTTP concerns
- Use strong parameters for all user input
- Prefer redirect_to with notice/alert over render for form submissions
- Use before_action filters for authentication and shared setup
- Respond to appropriate formats (HTML, Turbo Stream, JSON)

### Rails Models
- Use Rails validations extensively to ensure data integrity
- Keep model callbacks minimal and consider service objects for complex logic
- Use scopes for common queries that return ActiveRecord::Relation
- Implement proper associations with dependent options
- Use ActiveRecord's `includes` method whenever possible to avoid N+1 queries

### Rails Views
- Use partials for reusable components
- Keep logic out of views, use view helpers or view objects when needed
- Follow Hotwire/Turbo conventions for dynamic page updates
- Use content_for to define regions of content in layouts
- Use Rails helpers appropriately (form_with, link_to, etc.)

## Key Gems
Odichat relies heavily on gems such as:

- `whatsapp_sdk` for interacting with the WhatsApp Business API
- `pay` and `stripe` for integrating Stripe payments and managing subscriptions
- `pundit` for authorization
- `devise` for authentication
- `ruby-openai` for interacting with the OpenAI API for consuming their AI models
- `aws-sdk-s3` and `image_processing` for ActiveStorage file uploads and file storage management

## Commit discipline
- Tag AI-generated commits: e.g., feat: optimise feed query [AI].
