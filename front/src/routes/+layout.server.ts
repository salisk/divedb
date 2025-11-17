import { client } from '$lib/graphql/client';

export async function load() {
	try {
		const { showBranding } = await client.loginInfo();
		return {
			showBranding
		};
	} catch (error) {
		// Default to true if there's an error
		return {
			showBranding: true
		};
	}
}
