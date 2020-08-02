public with sharing class SensorComponentController {

    @AuraEnabled(cacheable = true)
    public static List<Sensor__c> getSensors() {
        List<Sensor__c> sensors = [SELECT Name FROM Sensor__c];
        return sensors;
    }

    @AuraEnabled(cacheable = true)
    public static List<Sensor_Event__c> getEvents(String id) {
        List<Sensor_Event__c> events = [SELECT Name, x__c, y__c, z__c,	Modulus_difference_Vectors__c 
                                        FROM Sensor_Event__c WHERE Sensor__c = :id];
        return events;
    }
}
