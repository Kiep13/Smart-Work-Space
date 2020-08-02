import {LightningElement,wire, track} from 'lwc';
import getSensors from '@salesforce/apex/SensorComponentController.getSensors';
import getEvents from '@salesforce/apex/SensorComponentController.getEvents';

export default class SensorComponent extends LightningElement {

  @wire(getSensors, {}) sensors;
  @track events;
  @track error;

  @track eventsSize;

  onValueSelection(event){
    getEvents({id: event.target.value})
    .then(result => {
        this.events = result;
        this.eventsSize = result.length > 0;
    })
    .catch(error => {
      this.error = error;
    });
  }
}