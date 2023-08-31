import getApiKey from '@salesforce/apex/ConciergeLiveUtils.getApplicationApiKey';

export default async function fetchAccountData({ requestUrl, contactIds }) {
    let params = new URLSearchParams();
    params.append('format', 'json')
    params.append('contact_ids', contactIds.join(','))

    const apiKey = await getApiKey();

    return fetch(requestUrl + "?" + params.toString(), {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-ConciergeLive-ApiKey': apiKey,
        },
    }).
    then(response => response.json())
}