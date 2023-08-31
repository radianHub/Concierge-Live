import getSubdomain from '@salesforce/apex/ConciergeLiveUtils.getSubdomain';
import submissionUrl from '@salesforce/apex/ConciergeLiveConstants.submissionUrl';

export default async function buildSubmissionUrl() {
    const url = await submissionUrl();
    const subdomain = await getSubdomain();
    return url.replace('[SUBDOMAIN]', subdomain);
}