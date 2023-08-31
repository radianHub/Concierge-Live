import { LightningElement, api, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import { getRecord } from "lightning/uiRecordApi";
import fetchDataHelper from "./fetchDataHelper";

const columns = [
  { label: "Event", fieldName: "event_name", type: "text" },
  { label: "Venue", fieldName: "venue_name", type: "text" },
  { label: "Date", fieldName: "date", type: "date" },
  { label: "Number of Tickets", fieldName: "ticket_count", type: "text" },
  { label: "Value", fieldName: "value", type: "currency" },
  { label: "Ticket Request ID", fieldName: "ticket_request_id" },
  { label: "Requester", fieldName: "user_name" },
];

const FIELDS = ["Contact.ID"];

export default class contactEventTable extends NavigationMixin(
  LightningElement
) {
  @api recordId;

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  data = [];
  columns = columns;

  // eslint-disable-next-line @lwc/lwc/no-async-await
  async connectedCallback() {
    const contactId = this.recordId;
    const data = await fetchDataHelper({ contactId });
    this.data = data;
  }

  navigateToSearch() {
      
    this[NavigationMixin.Navigate](
        {
            type: "standard__navItemPage",
            attributes: {
                apiName: 'ConciergeLive__Concierge_Live_Search_v2',
                state: {
                    ContactId: recordId,
                }
            },
          },
      true // Replaces the current page in your browser history with the URL
    );
  }
}