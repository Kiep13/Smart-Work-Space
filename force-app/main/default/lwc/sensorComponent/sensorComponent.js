import {LightningElement,wire, track} from 'lwc';
import getSensors from '@salesforce/apex/SensorComponentController.getSensors';
import getEvents from '@salesforce/apex/SensorComponentController.getEvents';

export default class SensorComponent extends LightningElement {

  @wire(getSensors, {}) sensors;
  @track events;
  @track error;

  onValueSelection(event){
    getEvents({id: event.target.value})
    .then(result => {
        this.events = result;
    })
    .catch(error => {
      this.error = error;
    });
  }
}