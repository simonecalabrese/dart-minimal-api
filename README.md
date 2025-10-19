A minimal **Dart** boilerplate HTTP api server with user authentication consisting of 3 routes.

The users passwords are hashed and stored inside a **MongoDB** database using the [Bcrypt](https://en.wikipedia.org/wiki/Bcrypt) algorithm and the Dart package [bcrypt](https://pub.dev/documentation/bcrypt/latest/).

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


## Testing
The test suite is written in Typescript and is located inside the `/tests` folder. Make sure to have an instance of MongoDB running as well as the API server.
#### Requirements
- [Node](https://nodejs.org/en)
- [yarn](https://yarnpkg.com/) or [npm](https://www.npmjs.com/)
#### Installation
```sh
cd tests
```
Install all the Node dependencies.
```sh
# or `npm install`
yarn
```

#### Run tests
```sh
# or `npm run test`
yarn test
```
This command will test all the implemented routes:
1. POST `/signup` -  Register a user
1. POST `/login` -  User login
1. GET `/profile` -  Get logged user data
