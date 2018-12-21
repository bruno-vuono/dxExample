trigger LAT_Attachment on Attachment (after insert, after delete) {
    LAT_CTR_Attachment.runTriggers();
}