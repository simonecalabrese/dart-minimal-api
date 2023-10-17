A minimal **Dart** boilerplate HTTP api server with user authentication composed by 3 routes.

The users passwords are hashed and stored inside a **MongoDB** database using the [Bcrypt](https://it.wikipedia.org/wiki/Bcrypt) algorithm and the Dart package [bcrypt](https://pub.dev/documentation/bcrypt/latest/).

## Get started

```sh
# move inside the project folder
cd dart-minimal-api

# install all the required packages
dart pub get

# Start the server on port 8080
dart run src/server.dart

```

## Routes

There are 3 main routes:

- POST `/signup`
- POST `/login`
- GET `/profile`

### POST `/signup`

```json
{
  "name": "registered_name",
  "username": "registered_username",
  "password": "registered_password"
}
```

It stores a new user inside the database.

### POST `/login`

```json
{
  "username": "registered_username",
  "password": "registered_password"
}
```

It verifies the credentials and send back a JWT token that you can set in your future requests `Authorization` header like this:

```json
"Authorization": "Bearer <YOUR_TOKEN>"
```

Now you can perform all of the requests as authenticated user

### GET `/profile`

```json
"Authorization": "Bearer <YOUR_TOKEN>"
```

It requires a JWT token set in your `Authorization` header and send you back your user registered information.
