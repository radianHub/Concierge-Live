import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getSubdomain from '@salesforce/apex/ConciergeLiveUtils.getSubdomain';
import submissionUrl from '@salesforce/apex/ConciergeLiveConstants.submissionUrl';
import findAll from '@salesforce/apex/ConciergeLiveAttendeeSearch.findAll';

const COLUMNS = [
	{
		label: 'Event',
		fieldName: 'event_name',
		type: 'text',
		hideDefaultActions: true,
	},
	{
		label: 'Venue',
		fieldName: 'venue_name',
		type: 'text',
		hideDefaultActions: true,
	},
	{
		label: 'Date',
		fieldName: 'date',
		type: 'date-local',
		hideDefaultActions: true,
		typeAttributes: {
			day: 'numeric',
			month: 'short',
			year: 'numeric',
		},
	},
	{
		label: 'Number of Tickets',
		fieldName: 'ticket_count',
		type: 'text',
		hideDefaultActions: true,
	},
	{
		label: 'Value',
		fieldName: 'value',
		type: 'currency',
		hideDefaultActions: true,
	},
	{
		label: 'Ticket Request ID',
		fieldName: 'ticket_request_id',
		hideDefaultActions: true,
	},
	{
		label: 'Requester',
		fieldName: 'user_name',
		hideDefaultActions: true,
	},
	{
		label: 'State',
		fieldName: 'state',
		hideDefaultActions: true,
	},
];

function mapToTableEntry(arr) {
	try {
		return arr.map((att) => {
			return {
				event_name: att.ConciergeLive__Event_Name__c,
				venue_name: att.ConciergeLive__Venue_Name__c,
				ticket_count: att.ConciergeLive__Ticket_Count__c,
				value: att.ConciergeLive__Ticket_Value__c,
				ticket_request_id: att.ConciergeLive__Ticket_Request_ID__c,
				user_name: att.ConciergeLive__Requester_Name__c,
				date: att.ConciergeLive__Event_Date__c,
				state: att.ConciergeLive__State__c,
			};
		});
	} catch (e) {
		console.log('failed');
		console.log(e);
		return [];
	}
}

export default class conciergeLiveCustomerHistoryTable extends NavigationMixin(LightningElement) {
	@api recordId;
	columns = COLUMNS;

	data = [];

	// eslint-disable-next-line @lwc/lwc/no-async-await
	async connectedCallback() {
		const url = await submissionUrl();
		const subdomain = await getSubdomain();
		this.destinationUrl = url.replace('[SUBDOMAIN]', subdomain);
	}

	navigateToConciergeLive() {
		this[NavigationMixin.Navigate]({
			type: 'standard__webPage',
			attributes: {
				url: this.destinationUrl + '?ids[]=' + this.recordId,
			},
		});
	}

	@wire(findAll, { id: '$recordId' })
	getWireFindAll({ data, error }) {
		if (data) {
			this.data = mapToTableEntry(data);
		} else if (error) {
			console.log(error);
		}
	}
}
