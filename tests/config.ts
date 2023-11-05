import 'dotenv/config'

const randomSeed = parseInt((Number(new Date().getTime().toString().slice(-5)) * Math.random() * 10000).toString());

export const randomUser = {
    name: "test_name_" + randomSeed,
    username: "test_username_" + randomSeed,
    password: "test_password_" + randomSeed,
    bearer_token: ""
}

// api running server instance url
export const apiUrl = process.env.API_URL
