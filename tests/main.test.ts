import { describe, expect, test } from '@jest/globals';
import { register, login, getProfile } from './users/users';
import { randomUser } from './config';

describe('User operations', () => {
    test('Register user', async () => {
        const res = await register(randomUser.name, randomUser.username, randomUser.password);
        if (res.error === true) console.log("🔴 Register user ERROR: ", getResponseError(res.res))
        expect(res.error).toBe(false);
    });
    test('User login', async () => {
        const res = await login(randomUser.name, randomUser.username, randomUser.password);
        if (res.error === true) console.log("🔴 User login ERROR: ", getResponseError(res.res))
        expect(res.error).toBe(false);
    });
    test('Get user profile info', async () => {
        const res = await getProfile();
        if (res.error === true) console.log("🔴 Get user profile ERROR: ", getResponseError(res.res))
        expect(res.error).toBe(false);
    });
});

function getResponseError(res) {
    if (res.response?.data?.message) return res.response?.data?.message
    else if (res?.message) return res.message
    else return res
}