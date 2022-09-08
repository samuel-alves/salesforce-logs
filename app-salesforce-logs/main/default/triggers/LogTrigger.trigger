/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-09-08
 * @last modified by  : samuelalves@loba.pt
 **/
trigger LogTrigger on Log__e(after insert) {
    new LogTriggerHandler().run();
}
