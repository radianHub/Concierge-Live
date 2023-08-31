import { LightningElement, track, wire } from "lwc";
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getContacts from "@salesforce/apex/ConciergeLiveContactSearch.getContacts";
import getAccountContacts from "@salesforce/apex/ConciergeLiveContactSearch.getAccountContacts";
import buildSubmissionUrl from "./buildSubmissionUrl";
import getContactIdsForAccount from "@salesforce/apex/ConciergeLiveSearchV2.getContactIdsForAccount";
import disallowedMessage from '@salesforce/apex/ConciergeLiveConstants.disallowedMessage';
import manualSelectAccountContacts from "@salesforce/apex/ConciergeLiveConstants.manualSelectAccountContacts";
import LightningAlert from 'lightning/alert';

const SHARED_COLUMNS = [
  {
    label: "First Name",
    fieldName: "firstName",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Last Name",
    fieldName: "lastName",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Email",
    fieldName: "email",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Phone",
    fieldName: "phone",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Contact Owner",
    fieldName: "ownerName",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Account",
    fieldName: "accountName",
    type: "text",
    hideDefaultActions: true,
  },
  {
    label: "Account Number",
    fieldName: "accountNumber",
    type: "text",
    hideDefaultActions: true,
  },
];

// Columns shown for contacts that have been selected to send to CL.
const SELECTED_CONTACT_COLUMNS = [
  ...SHARED_COLUMNS,
  {
    type: "button",
    typeAttributes: {
      label: "Remove",
      name: "delete",
      title: "Remove from list",
      disabled: false,
      value: "delete"
    },
  }
];

// Columns shown for the "quick-add" table that shows all contacts for the
// selected account.
const ACCOUNT_CONTACT_COLUMNS = [
  ...SHARED_COLUMNS,
  {
    type: "button",
    typeAttributes: {
      label: "Add",
      name: "add",
      title: "Add to list",
      disabled: false,
      value: "add"
    },
  }
];

export default class ConciergeLiveSearch extends NavigationMixin(LightningElement) {
  selectedContactsColumns = SELECTED_CONTACT_COLUMNS;
  accountContactColumns = ACCOUNT_CONTACT_COLUMNS;
  baseSubmissionUrl = "";

  @track selectedContacts = [];
  @track selectedContactIds = [];
  @track selectedContactId;
  @track selectableAccountContacts = [];
  @track accountId;

  currentPageReference = null;
  // Injects the page reference that describes the current page
  @wire(CurrentPageReference)
  async getStateParameters(currentPageReference) {
    if (currentPageReference) {
      this.urlStateParameters = currentPageReference.state;

      if (this.urlStateParameters) {
        this.accountId = this.urlStateParameters.c__accountId;
        var recordId = this.urlStateParameters.c__recordId;

        if (recordId) {
          this.selectedContactIds = [recordId];
        } else if (this.accountId != null) {
          await this.preselectAllAccountContacts();
        }
      }
    }
  }

  async preselectAllAccountContacts() {
    // This is an app-level setting. For companies that have LOTS of contacts
    // per account, they may not want them automatically all pre-selected.
    var manual = await manualSelectAccountContacts();
    if (!manual) {
      this.selectedContactIds = await getContactIdsForAccount({accountId: this.accountId});
    }
  }

  async addSearchContactToSelected() {
    var success = await this.addSelectedContact(this.selectedContactId);
    if (success) {
      this.selectedContactId = null;
      this.template.querySelector(
        'lightning-input-field[data-name="contact"]'
      ).value = null;
    }
  }

  async addSelectedContact(id) {
    if (id == null) {
      return false;
    }

    if (this.selectedContactIds.find(x => x == id)) {
      await this.alertAlreadyAddedContact();
      return true;
    }

    this.selectedContactIds = [
      ...new Set([
        ...this.selectedContactIds,
        id,
      ])
    ];
    return true;
  }

  async handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    const id = event.detail.row.id;
    if (actionName === "delete") {
      this.deleteContact(row);
    } else if (actionName == "add") {
      await this.addSelectedContact(id);
    }
  }

  deleteContact({ id }) {
    let newIds = [];
    this.selectedContactIds.forEach(cid => {
      if (cid != id) {
        newIds.push(cid);
      }
    });
    this.selectedContactIds = newIds;

    let newContacts = [];
    this.selectedContacts.forEach(ctact => {
      if (ctact.id != id) {
        newContacts.push(ctact);
      }
    });
    this.selectedContacts = newContacts;
  }

  @wire(getContacts, { contactIds: "$selectedContactIds" })
  async contacts(result) {
    this.refreshTable = result;
    if (result.data) {
      this.selectedContacts = result.data.map((contact) => {
        return this.contactRecord(contact);
      });
      this.error = undefined;
      if (this.selectedContactIds.length != this.selectedContacts.length) {
        await this.alertDisallowedContact();
        this.selectedContactIds = this.selectedContacts.map(c => c.id);
      }
    } else if (result.error) {
      console.log(result.error);
      this.error = result.error;
      this.selectedContacts = [];
    }
  }

  contactRecord(contact) {
    return {
      id: contact.Id,
      firstName: contact.FirstName,
      lastName: contact.LastName,
      phone: contact.Phone,
      email: contact.Email,
      accountName: (contact.Account ?? { Name: "N/A" }).Name,
      ownerName: (contact.Owner ?? { Name: "N/A"}).Name,
      accountNumber: (contact.Account ?? { AccountNumber: "N/A" }).AccountNumber,
    }
  }

  @wire(getAccountContacts, { accountId: "$accountId" })
  async accountContacts(result) {
    this.refreshTable = result;
    if (result.data) {
      this.selectableAccountContacts = result.data.map((contact) => {
        return this.contactRecord(contact);
      });
    } else if (result.error) {
      console.log(result.error);
      this.error = result.error;
      this.selectableAccountContacts = [];
    }
  }

  // Alert users that the contact they've chosen is not allowed due to the
  // Contact_Filter__c custom setting. Companies can use our generic built-in
  // message or provide their own.
  async alertDisallowedContact() {
    var message = 'Due to company policy, the selected contact could not be added.';
    var customMessage = await disallowedMessage();
    if (customMessage != null) {
      message = customMessage;
    }

    await LightningAlert.open({
      message: message,
      theme: 'warning',
      label: 'Could not add selected contact',
    });
  }

  async alertAlreadyAddedContact() {
    await LightningAlert.open({
      message: 'That contact has already been added.',
      theme: 'warning',
      label: 'Could not add selected contact',
    });
  }

  async connectedCallback() {
    this.baseSubmissionUrl = await buildSubmissionUrl();
  }

  contactSelected(event) {
    this.selectedContactId = event.detail.value[0];
  }

  contactQueryString() {
    return "?ids[]=" + this.selectedContacts.map(c => c.id).join("&ids[]=");
  }

  sendToConciergeLive() {
    this[NavigationMixin.Navigate](
      {
        type: "standard__webPage",
        attributes: {
          url: this.baseSubmissionUrl + this.contactQueryString(),
        },
      },
      true // Replaces the current page in your browser history with the URL
    );
  }

  get disableAddButton() {
    return this.selectedContactId == null;
  }

  get disableSubmitButton() {
    return this.selectedContactIds.length == 0 || this.selectedContacts.length == 0;
  }
}