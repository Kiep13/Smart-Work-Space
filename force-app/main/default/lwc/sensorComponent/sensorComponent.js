import {LightningElement,wire, track} from 'lwc';
import getSensors from '@salesforce/apex/SensorComponentController.getSensors';
import getEvents from '@salesforce/apex/SensorComponentController.getEvents';

const EXCEPTION_NO_ACCESS = 'System.NoAccessException';
const MESSAGE_NO_ACCESS = 'You don\'t have access to this data';

export default class SensorComponent extends LightningElement {

  @track sensors;
  @track events;
  @track sensorsError;
  @track eventsError;

  @track eventsSize;

  onValueSelection(event){
    getEvents({id: event.target.value})
    .then(result => {
        this.events = result;
        this.eventsSize = result.length > 0;
    })
    .catch(error => {
      if(EXCEPTION_NO_ACCESS.localeCompare(error.body.exceptionType) == 0) {
        this.eventsError = MESSAGE_NO_ACCESS;
      }
    });
  }

  @wire(getSensors, {})
  getSensors({error, data}) {
    if(error) {
      if(EXCEPTION_NO_ACCESS.localeCompare(error.body.exceptionType) == 0) {
          this.sensorsError = MESSAGE_NO_ACCESS;
      }
    } else if(data) {
      this.sensors = data;
    }
  }
}