import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import fetchContactData from "./fetchContactData";

const COLUMNS = [
  {
    label: "Event",
    fieldName: "event_name",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Venue",
    fieldName: "venue_name",
    type: "text",
    hideDefaultActions: true,
  },
  { label: "Date", fieldName: "date", type: "date", hideDefaultActions: true },
  {
    label: "Number of Tickets",
    fieldName: "ticket_count",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Value",
    fieldName: "value",
    type: "currency",
    hideDefaultActions: true,
  },
  {
    label: "Ticket Request ID",
    fieldName: "ticket_request_id",
    hideDefaultActions: true,
  },
  { label: "Requester", fieldName: "user_name", hideDefaultActions: true },
];

export default class conciergeLiveContactHistoryTable extends NavigationMixin(
  LightningElement
) {
  @api recordId;
  columns = COLUMNS;

  data = [];

  // eslint-disable-next-line @lwc/lwc/no-async-await
  async connectedCallback() {
    const contactId = this.recordId;
    try {
      const data = await fetchContactData({ contactId: contactId });
      this.data = data;
    } catch (err) {
      console.log(err);
    }
  }

  navigateToSearch() {
    this[NavigationMixin.Navigate](
      {
        type: "standard__navItemPage",
        attributes: {
            apiName: 'ConciergeLive__Concierge_Live_Search_v2',
        },
        state: {
            c__recordId: this.recordId,
        }
      },
      true // Replaces the current page in your browser history with the URL
    );
  }
}