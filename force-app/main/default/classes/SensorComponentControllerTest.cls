@isTest
public class SensorComponentControllerTest {

    @TestSetup
    static void makeData(){
        
        List<Sensor__c> sensors = new List<Sensor__c>();

        for(Integer i = 1; i <= 3; i++) {
            Sensor__c newSensor = new Sensor__c(Name = '' + (i * 100));
            sensors.add(newSensor);
        }

        insert sensors; 

        List<Sensor_Event__c> events = new List<Sensor_Event__c>();

        for(Integer i = 0; i < sensors.size(); i++) {

            for(Integer j = 0; j < (i*2); j++) {
                Sensor_Event__c newEvent = new Sensor_Event__c(x__c = 1, y__c = 2, z__c = 3);
                newEvent.Sensor__c = sensors[i].Id;
                events.add(newEvent);
            }

        }

        insert events;

    }

    @isTest
    public static void getSensorsTest() {

        List<Sensor__c> sensors = SensorComponentController.getSensors();

        System.assertEquals(3, sensors.size(), 'Actual amount of sensors does n\'t equals to expected');

    }

    @isTest
    public static void getEventsTest() {

        List<Sensor__c> sensors = [SELECT Name FROM Sensor__c WHERE Name = '200'];

        List<Sensor_Event__c> events = SensorComponentController.getEvents(sensors[0].Id);

        System.assertEquals(2, events.size(), 'Actual amount of events does n\'t equals to expected');

    }
}
