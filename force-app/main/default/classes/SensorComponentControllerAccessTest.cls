@isTest
public class SensorComponentControllerAccessTest {
    
    public static String TEST_USERNAME = 'assistantViceJenetor@testorg.com';

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

        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User user = new User(Alias = 'standt', Email='assistantViceJenetor@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles',
                            UserName=TEST_USERNAME);

        insert user;

    }

    @isTest
    public static void getSesnrosWithNoAccessTest() {

        User user = [SELECT Id FROM User WHERE Username = :TEST_USERNAME];

        System.runAs(user) {
            try {
                List<Sensor__c> sensors = SensorComponentController.getSensors();
            } catch (Exception e) {
                System.assertEquals('System.NoAccessException', e.getTypeName(),
                    'Expected exception with type NoAccessException, but got ' + e.getTypeName());
            }
    
        }

    }

    @isTest
    public static void getSesnrosWithAccessTest() {

        User user = [SELECT Id FROM User WHERE Username = :TEST_USERNAME];

        PermissionSet permission = [SELECT Name FROM PermissionSet WHERE Name = 'AllowReadSensor'];
        PermissionSetAssignment assignment = new PermissionSetAssignment (PermissionSetId = permission.Id, AssigneeId = user.Id);

        insert(assignment);

        System.runAs(user) {

            List<Sensor__c> sensors = SensorComponentController.getSensors();
            System.assertEquals(3, sensors.size(), 'Actual amount of sensors does n\'t equals to expected');

        }

    }

    @isTest
    public static void getSesnrosEventWithNoAccessTest() {

        User user = [SELECT Id FROM User WHERE Username = :TEST_USERNAME];

        PermissionSet permission = [SELECT Name FROM PermissionSet WHERE Name = 'AllowReadSensor'];
        PermissionSetAssignment assignment = new PermissionSetAssignment (PermissionSetId = permission.Id, AssigneeId = user.Id);

        insert(assignment);

        System.runAs(user) {
            try {
                List<Sensor__c> sensors = [SELECT Name FROM Sensor__c WHERE Name = '200'];
                List<Sensor_Event__c> events = SensorComponentController.getEvents(sensors[0].Id);
            } catch (Exception e) {
                System.assertEquals('System.NoAccessException', e.getTypeName(),
                    'Expected exception with type NoAccessException, but got ' + e.getTypeName());
            }
    
         }

    }

    @isTest
    public static void getSesnrosEventWithAccessTest() {

        User user = [SELECT Id FROM User WHERE Username = :TEST_USERNAME];

        PermissionSet psSensor = [SELECT Name FROM PermissionSet WHERE Name = 'AllowReadSensor'];
        PermissionSetAssignment asSensor = new PermissionSetAssignment (PermissionSetId = psSensor.Id, AssigneeId = user.Id);

        PermissionSet psSensorEvent = [SELECT Name FROM PermissionSet WHERE Name = 'AllowReadSensorEvents'];
        PermissionSetAssignment asSensorEvent = new PermissionSetAssignment (PermissionSetId = psSensorEvent.Id, AssigneeId = user.Id);

        insert(asSensor);
        insert(asSensorEvent);

        System.runAs(user) {
            List<Sensor__c> sensors = [SELECT Name FROM Sensor__c WHERE Name = '200'];
            
            List<Sensor_Event__c> events = SensorComponentController.getEvents(sensors[0].Id);

            System.assertEquals(2, events.size(), 'Actual amount of events does n\'t equals to expected');
        }

    }
}
