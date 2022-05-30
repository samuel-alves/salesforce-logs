/**
 * @description       :
 * @author            : samuel.f.alves
 * @group             :
 * @last modified on  : 2022-05-30
 * @last modified by  : samuelalves@loba.pt
 **/
trigger LogTrigger on Log__e(after insert) {
    new logTriggerHandler().run();
}
