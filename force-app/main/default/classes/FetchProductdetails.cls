public with sharing class FetchProductdetails {

    @AuraEnabled(cacheable=true)
public static List<Product2> fetchProducts(Integer pageSize, Integer offsetSize) {

    if (pageSize == null) pageSize = 10;
    if (offsetSize == null) offsetSize = 0;

    return [
        SELECT Id, Name, Family
        FROM Product2
        WHERE IsActive = true
        ORDER BY Name
        LIMIT :pageSize
        OFFSET :offsetSize
    ];
}

    @AuraEnabled
    public static void createQuoteLines(Id quoteId, List<QuoteLineWrapper> lines) {

        if (quoteId == null) {
            throw new AuraHandledException('Quote Id cannot be null.');
        }

        if (lines == null || lines.isEmpty()) {
            throw new AuraHandledException('No products selected.');
        }

        Set<Id> productIds = new Set<Id>();
        for (QuoteLineWrapper w : lines) {
            if (w != null && w.productId != null) {
                productIds.add(w.productId);
            }
        }

        if (productIds.isEmpty()) {
            throw new AuraHandledException('Invalid product selection.');
        }

        // Fetch PricebookEntries
        Map<Id, PricebookEntry> pbeMap = new Map<Id, PricebookEntry>();

        for (PricebookEntry pbe : [
            SELECT Id, Product2Id, UnitPrice
            FROM PricebookEntry
            WHERE Product2Id IN :productIds
            AND IsActive = true
        ]) {
            pbeMap.put(pbe.Product2Id, pbe);
        }

        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();

        for (QuoteLineWrapper w : lines) {

            if (w == null || w.productId == null) {
                continue; // skip invalid row
            }

            PricebookEntry pbe = pbeMap.get(w.productId);

            if (pbe == null) {
                throw new AuraHandledException(
                    'No active PricebookEntry found for product: ' + w.productId
                );
            }

            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
            ql.SBQQ__Quote__c = quoteId;
            ql.SBQQ__Product__c = w.productId;
            ql.SBQQ__PricebookEntryId__c = pbe.Id;
            ql.SBQQ__Quantity__c = (w.quantity != null && w.quantity > 0) ? w.quantity : 1;

            quoteLines.add(ql);
        }

        if (!quoteLines.isEmpty()) {
            insert quoteLines;
        }
    }
public class QuoteLineWrapper {
    @AuraEnabled public Id productId {get; set;}
    @AuraEnabled public Decimal quantity {get; set;}
}

}