import getApiKey from '@salesforce/apex/ConciergeLiveUtils.getApplicationApiKey';
import getSubdomain from '@salesforce/apex/ConciergeLiveUtils.getSubdomain';
import eventHistoryUrl from '@salesforce/apex/ConciergeLiveConstants.eventHistoryUrl';

export default async function fetchCustomerData({ customerId }) {
    const url = await eventHistoryUrl();
    const subdomain = await getSubdomain();
    const requestUrl = url.
        replace('[CONTACTID]', customerId).
        replace('[SUBDOMAIN]', subdomain);

    const apiKey = await getApiKey();

    return fetch(requestUrl + "?format=json", {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-ConciergeLive-ApiKey': apiKey,
        },
    }).then(response => response.json());
}