# productive_cats

Demo: https://www.youtube.com/watch?v=mvqg0_AQmoc
<div align="center">
  <br />
  <p>
    <a href="https://www.youtube.com/watch?v=mvqg0_AQmoc"><img src="https://i.imgur.com/kbJxX9b.png" alt="Productive Cats Demo" /></a>
  </p>
</div>


GitHub: https://github.com/PotatoCider/productive_cats

An app designed to keep your productive with collectible cats.

## Getting Started
1. Install [Flutter](https://docs.flutter.dev/get-started/install) and Flutter/Dart Plugins in your IDE
2. Setup [Appwrite](https://appwrite.io/) server (v0.12.1) behind a public domain 
3. Create two databases, "Users" (role:all perms) and "Cats" (role:member) with collection r/w perms
4. Create user collection attributes:
 - email (type: email, required)
 - username (type: string, required)
 - coins (type: integer, required)
 - name (type: string)
 - user_id (type: string, required)
5. Create user collection indexes:
 - user_id (type: unique, attr: user_id ASC)
6. Create cat collection attributes:
 - file (type: string, required)
 - owner (type: string)
 - price (type: double, required)
 - name (type: string, required)
 - level (type: integer, required)
 - max_happiness (type: integer, required)
 - max_fitness (type: integer, required)
 - id (type: string, required)
 - preferences (type: string, required)
 - experience (type: double, required)
7. (Optional) Enable Google OAuth2
8. Add platform (com.example.productive_cats)

9. Setup .env file with appropriate data
10. Run app
