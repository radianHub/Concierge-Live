import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAttendeesForAccount from '@salesforce/apex/ConciergeLiveAttendeeSearch.findByAccount';

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
	{ label: 'Date', fieldName: 'date', type: 'date', hideDefaultActions: true },
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
	{ label: 'Requester', fieldName: 'user_name', hideDefaultActions: true },
	{ label: 'State', fieldName: 'state', hideDefaultActions: true },
];

export default class conciergeLiveAccountHistoryTable extends NavigationMixin(LightningElement) {
	@api recordId;
	@track data = [];
	columns = COLUMNS;

	// eslint-disable-next-line @lwc/lwc/no-async-await
	async connectedCallback() {
		const accountId = this.recordId;
		try {
			let result = await getAttendeesForAccount({ accountId: accountId });
			let formatted = result.map((attendee) => {
				return {
					event_name: attendee.ConciergeLive__Event_Name__c,
					venue_name: attendee.ConciergeLive__Venue_Name__c,
					date: attendee.ConciergeLive__Event_Date__c,
					ticket_count: attendee.ConciergeLive__Ticket_Count__c,
					value: attendee.ConciergeLive__Ticket_Value__c,
					ticket_request_id: attendee.ConciergeLive__Ticket_Request_ID__c,
					user_name: attendee.ConciergeLive__Requester_Name__c,
					state: attendee.ConciergeLive__State__c,
				};
			});
			this.data = formatted;
		} catch (err) {
			console.log(err);
		}
	}

	navigateToSearch() {
		this[NavigationMixin.Navigate](
			{
				type: 'standard__navItemPage',
				attributes: {
					apiName: 'ConciergeLive__Concierge_Live_Search_v2',
				},
				state: {
					c__accountId: this.recordId,
				},
			},
			true // Replaces the current page in your browser history with the URL
		);
	}
}
