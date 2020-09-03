public with sharing class SensorComponentController {

    @AuraEnabled(cacheable = true)
    public static List<Sensor__c> getSensors() {
        if(!Schema.sObjectType.Sensor__c.isAccessible()) {
            throw new System.NoAccessException();
        }

        String [] expenseAccessFields = new String [] {'Id','Name'};

        Map<String,Schema.SObjectField> m = Schema.SObjectType.Sensor__c.fields.getMap();
 
        for (String fieldToCheck : expenseAccessFields) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        
        List<Sensor__c> sensors = [SELECT Name FROM Sensor__c];
        return sensors;
    }

    @AuraEnabled(cacheable = true)
    public static List<Sensor_Event__c> getEvents(String id) {
        if(!Schema.SObjectType.Sensor_Event__c.isAccessible()) {
            throw new System.NoAccessException();
        }

        String [] expenseAccessFields = new String [] {'Id','Name', 'x__c', 'y__c', 'z__c', 'Modulus_difference_Vectors__c'};

        Map<String,Schema.SObjectField> m = Schema.SObjectType.Sensor_Event__c.fields.getMap();
 
        for (String fieldToCheck : expenseAccessFields) {
            if (!m.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }
        
        List<Sensor_Event__c> events = [SELECT Name, x__c, y__c, z__c,	Modulus_difference_Vectors__c 
                                        FROM Sensor_Event__c WHERE Sensor__c = :id];
        return events;
    }
}
