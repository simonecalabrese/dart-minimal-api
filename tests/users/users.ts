import axios from 'axios'
import { randomUser, apiUrl } from '../config'

export const register = async (name, username, password) => {
    try {
        if (!apiUrl) return { res: "api url has not been configured", error: true }
        const res = await axios.post(`${apiUrl}/signup`, {
            "name": name,
            "username": username,
            "password": password
        })
        return { res, error: false }
    } catch (e) {
        return { res: e, error: true }
    }
}

export const login = async (name, username, password) => {
    try {
        if (!apiUrl) return { res: "api url has not been configured", error: true }
        const res = await axios.post(`${apiUrl}/login`, {
            "name": name,
            "username": username,
            "password": password
        })
        randomUser.bearer_token = res.data.token
        return { res, error: false }
    } catch (e) {
        return { res: e, error: true }
    }
}

export const getProfile = async () => {
    try {
        if (!apiUrl) return { res: "api url has not been configured", error: true }
        const res = await axios.get(`${apiUrl}/profile`, {
            headers: {
                "Authorization": "Bearer " + randomUser.bearer_token
            }
        })
        return { res, error: false }
    } catch (e) {
        return { res: e, error: true }
    }
}