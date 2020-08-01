@RestResource(urlMapping = '/SensorEvent')
global class SensorService {

    @HttpPut
    global static void putData(String data) {

        SensorServiceData sensorData = (SensorServiceData) JSON.deserialize(data, SensorServiceData.class);

        List<Sensor__c> foundedSensor = [SELECT Name FROM Sensor__c WHERE Name =: sensorData.sensorid LIMIT 1];
        Sensor__c sensor;

        if(foundedSensor.size() == 0) {
            sensor = new Sensor__c(Name = sensorData.sensorid);
            insert sensor;
        } else {
            sensor = foundedSensor[0];
        }

        List<Sensor_Event__c> events = new List<Sensor_Event__c>();

        Integer correctAmount;
        if(Math.mod(sensorData.line.size(), 3) != 0) {
            correctAmount = sensorData.line.size()  - (Math.mod(sensorData.line.size(), 3) + 3);
        } else {
            correctAmount = sensorData.line.size() - 3;
        }

        for(Integer i = 0; i <= correctAmount; i=i+3) {
            Sensor_Event__c newEvent = new Sensor_Event__c();
            newEvent.x__c = sensorData.line[i];
            newEvent.y__c = sensorData.line[i + 1];
            newEvent.z__c = sensorData.line[i + 2];
            newEvent.Sensor__c = sensor.Id;

            events.add(newEvent);
        }

        insert events;

        for(Integer i = 1; i < events.size(); i++) {
            events[i].Previous_Event__c = events[i - 1].Id;
        }

        upsert events;
    }

}
