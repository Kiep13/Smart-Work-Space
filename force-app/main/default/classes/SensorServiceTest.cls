@IsTest
public class SensorServiceTest {

    @TestSetup
    static void makeData(){
        Sensor__c sensor = new Sensor__c(Name = '200');
        insert sensor;
    }

    @isTest
    public static void postServiceData() {

        List<Integer> line = new List<Integer>();
        for(Integer i = 0; i < 24; i++) {
            line.add(i);
        }
        SensorServiceData sensorData = new SensorServiceData('100', line);

        SensorService.putData(JSON.serialize(sensorData));

        List<Sensor_Event__c> events = [SELECT Name FROM Sensor_Event__c];

        System.assertEquals(line.size() / 3, events.size(), 'Actual amount of sensor events does n\' equal to expected');

    }

    @isTest
    public static void postServiceDataWithExistsSensor() {

        List<Integer> line = new List<Integer>();
        for(Integer i = 0; i < 22; i++) {
            line.add(i);
        }
        SensorServiceData sensorData = new SensorServiceData('200', line);

        SensorService.putData(JSON.serialize(sensorData));

        List<Sensor_Event__c> events = [SELECT Name FROM Sensor_Event__c];

        System.assertEquals(line.size() / 3, events.size(), 'Actual amount of sensor events does n\' equal to expected');

    }
}
