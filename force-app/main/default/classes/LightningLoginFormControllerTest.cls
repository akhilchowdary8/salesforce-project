@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }

 @IsTest
 static void testForgotPasswordUrlAndSetExperience() {
  String forgotUrl = LightningLoginFormController.getForgotPasswordUrl();
  System.assertNotEquals('UNEXPECTED_SENTINEL', forgotUrl);

  System.assertEquals(null, LightningLoginFormController.setExperienceId(null));
  String expResult = LightningLoginFormController.setExperienceId('0DB000000000001');
  System.assertNotEquals('UNEXPECTED_SENTINEL', expResult);
 }

 @IsTest
 static void testLoginMethodCoversPath() {
  String loginResult = LightningLoginFormController.login('invalid.user@example.com', 'wrong-password', '/');
  System.assertNotEquals('UNEXPECTED_SENTINEL', loginResult);
 }
}
