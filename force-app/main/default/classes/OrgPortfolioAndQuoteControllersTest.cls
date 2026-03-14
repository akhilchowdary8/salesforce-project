@IsTest
private class OrgPortfolioAndQuoteControllersTest {
    @IsTest
    static void portfolioAndSimpleControllers_areCovered() {
        insert new Account(Name = 'Portfolio Account');

        Experience__c exp = new Experience__c(
            Name = 'Exp 1',
            Company__c = 'Acme',
            Role__c = 'Developer',
            Domain__c = 'CRM',
            Start_Date__c = Date.today()
        );
        Project__c project = new Project__c(
            Name = 'Project 1',
            Type__c = 'Internal',
            Technologies__c = 'Apex'
        );
        Certification__c cert = new Certification__c(
            Name = 'Cert 1',
            Issued_By__c = 'Salesforce',
            Category__c = 'Platform'
        );
        insert new List<SObject>{ exp, project, cert };

        System.assertEquals(1, PortfolioController.getExperiences().size());
        System.assertEquals(1, PortfolioController.getProjects().size());
        System.assertEquals(1, PortfolioController.getCertifications().size());
        System.assertEquals(1, PractiseOneController.fetchAccounts().size());
    }

    @IsTest
    static void fetchProductsAndQuoteClasses_areCovered() {
        Id standardPricebookId = Test.getStandardPricebookId();
        update new Pricebook2(Id = standardPricebookId, IsActive = true);

        Product2 product = new Product2(Name = 'Widget', IsActive = true, Family = 'Hardware');
        insert product;

        insert new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = product.Id,
            UnitPrice = 25,
            IsActive = true
        );

        List<Product2> products = FetchProductdetails.fetchProducts(10, 0);
        System.assertEquals(1, products.size());

        SBQQ__Quote__c quoteRecord = new SBQQ__Quote__c();
        insert quoteRecord;

        FetchProductdetails.QuoteLineWrapper wrapper = new FetchProductdetails.QuoteLineWrapper();
        wrapper.productId = product.Id;
        wrapper.quantity = 2;

        Test.startTest();
        FetchProductdetails.createQuoteLines(quoteRecord.Id, new List<FetchProductdetails.QuoteLineWrapper>{ wrapper });
        Test.stopTest();

        Integer quoteLineCount = [
            SELECT COUNT()
            FROM SBQQ__QuoteLine__c
            WHERE SBQQ__Quote__c = :quoteRecord.Id
        ];
        System.assertEquals(1, quoteLineCount);

        List<SBQQ__Quote__c> returnedQuotes = quoteDetails.doSomething(quoteRecord.Id);
        System.assertEquals(1, returnedQuotes.size());
        System.assertEquals(quoteRecord.Id, returnedQuotes[0].Id);
    }

    @IsTest
    static void fetchProductDetails_throwsForInvalidInputs() {
        Boolean nullQuoteThrown = false;
        try {
            FetchProductdetails.createQuoteLines(null, new List<FetchProductdetails.QuoteLineWrapper>());
        } catch (Exception ex) {
            nullQuoteThrown = true;
        }
        System.assertEquals(true, nullQuoteThrown);

        SBQQ__Quote__c quoteRecord = new SBQQ__Quote__c();
        insert quoteRecord;

        Boolean emptyProductsThrown = false;
        try {
            FetchProductdetails.createQuoteLines(quoteRecord.Id, new List<FetchProductdetails.QuoteLineWrapper>());
        } catch (Exception ex) {
            emptyProductsThrown = true;
        }
        System.assertEquals(true, emptyProductsThrown);
    }
}
